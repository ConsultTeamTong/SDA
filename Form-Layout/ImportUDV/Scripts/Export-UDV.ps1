# ============================================================
# Export current FMS (UDV) to CSV in UDV_Map.csv format
# Reads CSHS + OUQR via SQL (DI API Recordset). Discovers
# CSHS columns at runtime so it works across B1 versions.
# Output is round-trip safe: re-import with Action=UPSERT.
# ============================================================
param(
    [string]$Server      = "SLD-C072",
    [string]$CompanyDB   = "SBO_SDA",
    [string]$DBUser      = "sa",
    [string]$DBPassword  = "1q2w3e4r",
    [string]$SapUser     = "manager",
    [string]$SapPassword = "1q2w3e4r",
    [ValidateSet("MSSQL","HANA")]
    [string]$DBType      = "MSSQL",
    [string]$OutFile     = "",
    [string]$LogFile     = "$PSScriptRoot\..\Export_UDV_Log.txt",
    [string]$ExportAction = "UPSERT"
)

if (-not $OutFile) {
    $OutFile = Join-Path "$PSScriptRoot\..\Config" ("UDV_Export_{0}.csv" -f (Get-Date -Format 'yyyyMMdd_HHmmss'))
}

# ------------------------------------------------------------
# Logging
# ------------------------------------------------------------
function Write-Log {
    param([string]$Msg, [string]$Level = "INFO")
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Msg
    Write-Host $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

# ------------------------------------------------------------
# Locate DI API interop assembly
# ------------------------------------------------------------
function Find-DIAPIAssembly {
    $is64 = [Environment]::Is64BitProcess
    $roots = if ($is64) {
        @("${env:ProgramFiles}\SAP", "${env:ProgramW6432}\SAP")
    } else {
        @("${env:ProgramFiles(x86)}\SAP")
    }
    $roots = $roots | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique
    foreach ($r in $roots) {
        $hit = Get-ChildItem -Path $r -Recurse -Filter "Interop.SAPbobsCOM.dll" -ErrorAction SilentlyContinue |
            Sort-Object -Property @{Expression = { $_.FullName -match "DI API" }; Descending = $true} |
            Select-Object -First 1 -ExpandProperty FullName
        if ($hit) { return $hit }
    }
    return $null
}

$diDll = Find-DIAPIAssembly
if (-not $diDll) {
    Write-Log "DI API interop (Interop.SAPbobsCOM.dll) not found." "ERROR"
    exit 2
}
try {
    Add-Type -Path $diDll -ErrorAction Stop
} catch {
    Write-Log "Failed to load $diDll : $($_.Exception.Message)" "ERROR"
    exit 2
}

Write-Log "=== Start UDV/FMS Export (SQL via DI API Recordset) ==="
Write-Log "Loaded DI API: $diDll"
Write-Log "Server   : $Server"
Write-Log "CompanyDB: $CompanyDB"
Write-Log "OutFile  : $OutFile"

# ------------------------------------------------------------
# Connect
# ------------------------------------------------------------
$company = New-Object -ComObject SAPbobsCOM.Company
$company.Server     = $Server
$company.CompanyDB  = $CompanyDB
$company.UserName   = $SapUser
$company.Password   = $SapPassword
$company.DbUserName = $DBUser
$company.DbPassword = $DBPassword
$company.UseTrusted = $false
$company.language   = [SAPbobsCOM.BoSuppLangs]::ln_English

$connected = $false
if ($DBType -eq "HANA") {
    $company.DbServerType = [SAPbobsCOM.BoDataServerTypes]::dst_HANADB
    if ($company.Connect() -eq 0) { $connected = $true }
} else {
    $tries = @(
        [SAPbobsCOM.BoDataServerTypes]::dst_MSSQL2019,
        [SAPbobsCOM.BoDataServerTypes]::dst_MSSQL2017,
        [SAPbobsCOM.BoDataServerTypes]::dst_MSSQL2016,
        [SAPbobsCOM.BoDataServerTypes]::dst_MSSQL2014,
        [SAPbobsCOM.BoDataServerTypes]::dst_MSSQL2012
    )
    foreach ($t in $tries) {
        $company.DbServerType = $t
        if ($company.Connect() -eq 0) { $connected = $true; Write-Log "Connected (DbServerType=$t)"; break }
    }
}
if (-not $connected) {
    Write-Log "Connect failed: $($company.GetLastErrorDescription())" "ERROR"
    exit 3
}

# ------------------------------------------------------------
# Helper: get field value by trying multiple column names
# ------------------------------------------------------------
function Read-FieldByNames {
    param($Fields, $NameToIndex, [string[]]$Names)
    foreach ($n in $Names) {
        if ($NameToIndex.ContainsKey($n)) {
            try {
                $v = $Fields.Item($NameToIndex[$n]).Value
                if ($null -ne $v) { return $v }
            } catch {}
        }
    }
    return $null
}

function To-YN {
    param($Val)
    $s = ([string]$Val).Trim().ToUpper()
    if ($s -in @("Y","YES","TRUE","1")) { "Y" } else { "N" }
}

try {
    $rs = $company.GetBusinessObject([SAPbobsCOM.BoObjectTypes]::BoRecordset)

    # ------------------------------------------------------------
    # 1) Discover CSHS columns
    # ------------------------------------------------------------
    $rs.DoQuery("SELECT TOP 1 * FROM CSHS")
    $cshsIdx = @{}
    for ($i = 0; $i -lt $rs.Fields.Count; $i++) {
        $cshsIdx[$rs.Fields.Item($i).Name] = $i
    }
    $cshsColList = ($cshsIdx.Keys | Sort-Object) -join ", "
    Write-Log "CSHS columns ($($cshsIdx.Count)): $cshsColList"

    # ------------------------------------------------------------
    # 2) Load OUQR queries into hashtable[IntrnalKey]
    # ------------------------------------------------------------
    $queries = @{}
    $rs.DoQuery("SELECT IntrnalKey, QCategory, QName, QString FROM OUQR")
    while (-not $rs.EoF) {
        $key = [int]$rs.Fields.Item("IntrnalKey").Value
        $queries[$key] = @{
            Category = [int]$rs.Fields.Item("QCategory").Value
            Name     = [string]$rs.Fields.Item("QName").Value
            Body     = [string]$rs.Fields.Item("QString").Value
        }
        $rs.MoveNext()
    }
    Write-Log "Loaded $($queries.Count) saved queries from OUQR"

    # ------------------------------------------------------------
    # 3) Read all CSHS rows, map heuristically
    # ------------------------------------------------------------
    $rs.DoQuery("SELECT * FROM CSHS ORDER BY FormID, ItemID, ColID")
    $output = New-Object System.Collections.ArrayList
    $rowNo = 0
    while (-not $rs.EoF) {
        $rowNo++
        $f = $rs.Fields

        $formId  = [string](Read-FieldByNames $f $cshsIdx @("FormID"))
        $itemId  = [string](Read-FieldByNames $f $cshsIdx @("ItemID"))
        $colId   = [string](Read-FieldByNames $f $cshsIdx @("ColID","ColumnID"))
        $action  = ([string](Read-FieldByNames $f $cshsIdx @("Action","ActionType"))).Trim().ToUpper()
        $queryId = Read-FieldByNames $f $cshsIdx @("QueryID","QueryId")
        $fixedVal = [string](Read-FieldByNames $f $cshsIdx @("StringVal","StringValue","FixedValue","DefaultValue","Value"))
        $refresh  = To-YN (Read-FieldByNames $f $cshsIdx @("Refresh","AutoRefresh"))
        $trigId   = [string](Read-FieldByNames $f $cshsIdx @("TriggerID","TrigID","TrigerID"))
        $trigCol  = [string](Read-FieldByNames $f $cshsIdx @("TriggerCol","TrigCol","TriggerColumn","TrigerCol"))
        $forceRf  = To-YN (Read-FieldByNames $f $cshsIdx @("ForceRfsh","ForceRefresh","ForceRefr","DisplaySaved"))

        # Decide FMSAction: prefer explicit Action column, else infer from QueryID
        $fmsAction = if ($action -eq "F") { "F" }
                     elseif ($action -eq "Q") { "Q" }
                     elseif ($queryId -and [int]$queryId -gt 0) { "Q" }
                     else { "F" }

        $qInfo = $null
        if ($fmsAction -eq "Q" -and $queryId) {
            $qi = [int]$queryId
            if ($queries.ContainsKey($qi)) { $qInfo = $queries[$qi] }
        }

        [void]$output.Add([pscustomobject]@{
            Action        = $ExportAction
            FormID        = $formId
            ItemID        = $itemId
            ColumnID      = $colId
            FMSAction     = $fmsAction
            QueryName     = if ($qInfo) { $qInfo.Name }     else { "" }
            QueryCategory = if ($qInfo) { $qInfo.Category } else { "" }
            QueryBody     = if ($qInfo) { $qInfo.Body }     else { "" }
            FixedValue    = if ($fmsAction -eq "F") { $fixedVal } else { "" }
            Refresh       = $refresh
            TriggerID     = $trigId
            TriggerColumn = $trigCol
            ForceRefresh  = $forceRf
        })

        $rs.MoveNext()
    }
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($rs)

    Write-Log "Read $($output.Count) FMS rows from CSHS"

    # ------------------------------------------------------------
    # 4) Write CSV (UTF-8 with BOM for Excel + Thai)
    # ------------------------------------------------------------
    $dir = Split-Path $OutFile -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    if ($output.Count -eq 0) {
        $csvLines = @('"Action","FormID","ItemID","ColumnID","FMSAction","QueryName","QueryCategory","QueryBody","FixedValue","Refresh","TriggerID","TriggerColumn","ForceRefresh"')
    } else {
        $csvLines = @($output | ConvertTo-Csv -NoTypeInformation)
    }
    [System.IO.File]::WriteAllLines($OutFile, [string[]]$csvLines, (New-Object System.Text.UTF8Encoding $true))

    Write-Log "=== Done. Exported $($output.Count) records ==="
    Write-Log "Output: $OutFile"
} finally {
    if ($company.Connected) { $company.Disconnect() | Out-Null }
    [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($company)
}
exit 0
