# ============================================================
# Render-CrystalFolder.ps1
# Render every .rpt in a folder to PDF against a live SQL Server DB
# (read-only: the report runs its own SELECT; nothing is saved back
# into the .rpt -- logon and parameters are set in memory only).
#
# Driver mode (default): loops the .rpt files, runs each one in its own
# 64-bit child process (-WorkerFile) with a timeout, and writes results.csv.
# A native crash or hang in one report cannot take the batch down.
#
# Credential: read at runtime from ImportLayouts\_settings.bat
# (SERVER / COMPANYDB / DBUSER / DBPASSWORD). The password is never
# printed, logged or written to any output; error text is scrubbed.
#
# Status per file:
#   OK          sample key given, PDF exported, main report has records
#   EMPTY       sample key given, PDF exported, 0 records
#   NO-SAMPLE   no sample document in DB; smoke-run with a key that does
#               not exist succeeded (SQL compiles and runs)
#   NEEDS-PARAM parameter value cannot be derived / missing parameter
#   LOAD-FAIL   ReportDocument.Load failed
#   DB-FAIL     logon / SQL / database error while running the report
#   RENDER-FAIL any other export error, crash or timeout
#
# BITNESS: CR runtime here is 64-bit only (RAS in GAC_64) -> re-exec in
# 64-bit PowerShell, same pattern as Extract-CrystalReport.ps1.
# ============================================================

param(
    [string]$RptFolder  = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924\rpt',
    [string]$PdfFolder  = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924\pdf',
    [string]$SampleCsv  = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924\samples.csv',
    [string]$ResultCsv  = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924\results.csv',
    [string]$LogFolder  = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924\log',
    [string]$Settings   = 'C:\GitHub\SDA\Form-Layout_SDA\ImportLayouts\_settings.bat',
    [string[]]$Only     = @('*'),
    [int]$TimeoutSec    = 300,
    [string]$WorkerFile = '',
    [string]$WorkerOut  = ''
)

# --- Force a 64-bit PowerShell host ---
if ([IntPtr]::Size -ne 8 -and -not $env:CR_EXTRACT_NO_REEXEC) {
    $ps64 = Join-Path $env:WINDIR 'Sysnative\WindowsPowerShell\v1.0\powershell.exe'
    if (-not (Test-Path $ps64)) { Write-Host '[ERROR] need 64-bit PowerShell' -ForegroundColor Red; exit 1 }
    $env:CR_EXTRACT_NO_REEXEC = '1'
    $argv = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $PSCommandPath,
              '-RptFolder', $RptFolder, '-PdfFolder', $PdfFolder, '-SampleCsv', $SampleCsv,
              '-ResultCsv', $ResultCsv, '-LogFolder', $LogFolder, '-Settings', $Settings,
              '-TimeoutSec', $TimeoutSec, '-Only', ($Only -join ';'))
    & $ps64 @argv
    exit $LASTEXITCODE
}

function Get-DbSettings {
    $h = @{}
    foreach ($l in (Get-Content -LiteralPath $Settings)) {
        if ($l -match '^\s*set\s+"?(\w+)=(.*?)"?\s*$') { $h[$matches[1]] = $matches[2] }
    }
    foreach ($k in 'SERVER', 'COMPANYDB', 'DBUSER', 'DBPASSWORD') {
        if (-not $h[$k]) { throw "_settings.bat has no $k" }
    }
    if ($h['SERVER'] -ne '10.0.70.61' -or $h['COMPANYDB'] -ne 'SBO_SDA_REAL' -or $h['DBUSER'] -ne 'sa') {
        throw '_settings.bat does not point to 10.0.70.61 / SBO_SDA_REAL / sa -- stop'
    }
    return $h
}

function Get-Scrubbed([string]$text, [string]$secret) {
    if (-not $text) { return '' }
    if ($secret) { $text = $text.Replace($secret, '***') }
    $text = $text -replace '(?i)(password|pwd)\s*=\s*[^;\s]+', '$1=***'
    return (($text -replace '\s+', ' ').Trim())
}

# ============================================================
# WORKER: render one file, write one JSON result
# ============================================================
if ($WorkerFile) {
    $res = [ordered]@{
        Status = ''; Error = ''; Pages = 0; Records = -1; Ms = 0
        OrigServer = ''; OrigDb = ''; Subreports = 0; Tables = 0; ParamsSet = ''
    }
    $secret = $null
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $doc = $null
    try {
        $db = Get-DbSettings
        $secret = $db['DBPASSWORD']

        # --- assemblies (same resolution rule as Extract-CrystalReport.ps1) ---
        $tok = '692fbea5521e1304'
        foreach ($n in 'CrystalDecisions.Shared', 'CrystalDecisions.CrystalReports.Engine') {
            $ok = $false
            foreach ($v in '13.0.4000.0', '13.0.3500.0', '13.0.2000.0', '13.0.1000.0') {
                try { [void][Reflection.Assembly]::Load("$n, Version=$v, Culture=neutral, PublicKeyToken=$tok"); $ok = $true; break } catch { }
            }
            if (-not $ok) { throw "cannot load $n (host $([IntPtr]::Size * 8)-bit)" }
        }

        $sample = Import-Csv -LiteralPath $SampleCsv -Encoding UTF8 |
                  Where-Object { $_.File -eq [IO.Path]::GetFileName($WorkerFile) } | Select-Object -First 1
        if (-not $sample) { throw 'file not in samples.csv' }

        $doc = New-Object CrystalDecisions.CrystalReports.Engine.ReportDocument
        try { $doc.Load($WorkerFile, [CrystalDecisions.Shared.OpenReportMethod]::OpenReportByTempCopy) }
        catch {
            $res.Status = 'LOAD-FAIL'
            $e = $_.Exception; $msg = $e.Message; while ($e.InnerException) { $e = $e.InnerException; $msg += ' | ' + $e.Message }
            $res.Error = Get-Scrubbed $msg $secret
            throw 'handled'
        }

        # --- original datasource + logon (memory only) ---
        $servers = @{}; $dbs = @{}; $tcount = 0
        $apply = {
            param($tables)
            foreach ($t in $tables) {
                $li = $t.LogOnInfo
                $ci = $li.ConnectionInfo
                if ($ci.ServerName) { $servers[$ci.ServerName] = 1 }
                if ($ci.DatabaseName) { $dbs[$ci.DatabaseName] = 1 }
                $ci.ServerName = $db['SERVER']; $ci.DatabaseName = $db['COMPANYDB']
                $ci.UserID = $db['DBUSER']; $ci.Password = $db['DBPASSWORD']
                $ci.IntegratedSecurity = $false
                $t.ApplyLogOnInfo($li)
                $script:tcount++
            }
        }
        # record every original server/db first -- subreport tables can share the
        # main report's connection, so reading after ApplyLogOnInfo shows the new value
        $subs = @($doc.Subreports)
        $allTables = @($doc.Database.Tables)
        foreach ($s in $subs) { $allTables += @($s.Database.Tables) }
        foreach ($t in $allTables) {
            $ci0 = $t.LogOnInfo.ConnectionInfo
            if ($ci0.ServerName) { $servers[$ci0.ServerName] = 1 }
            if ($ci0.DatabaseName) { $dbs[$ci0.DatabaseName] = 1 }
        }
        $origServers = ($servers.Keys | Sort-Object) -join '|'
        $origDbs = ($dbs.Keys | Sort-Object) -join '|'
        $script:tcount = 0
        & $apply $doc.Database.Tables
        foreach ($s in $subs) { & $apply $s.Database.Tables }
        $res.Subreports = $subs.Count
        $res.Tables = $script:tcount
        $res.OrigServer = $origServers
        $res.OrigDb = $origDbs

        # --- parameters: every non-linked field, main and subreport ---
        $set = @()
        $missing = @()
        $skipped = @()
        foreach ($pf in $doc.ParameterFields) {
            $name = $pf.Name; $rep = $pf.ReportName
            if ($name -like 'Pm-*') { continue }   # linked subreport params get value from the main report
            # a parameter the engine marks NotInUse is never prompted for at print time
            $usage = [int]$pf.ParameterFieldUsage2
            if (($usage -band [int][CrystalDecisions.Shared.ParameterFieldUsage2]::NotInUse) -ne 0) { $skipped += if ($rep) { "$rep/$name" } else { $name }; continue }
            $lname = $name.ToLowerInvariant()
            $val = $null
            if ($lname -eq 'dockey@') { $val = $sample.DocKey }
            elseif ($lname -eq 'objectid@') { $val = if ($sample.ObjectId) { $sample.ObjectId } else { $sample.ObjType } }
            if ($null -eq $val -or $val -eq '') { $missing += $name; continue }
            $typed = $val
            if ($pf.ParameterValueType -eq [CrystalDecisions.Shared.ParameterValueKind]::NumberParameter -or
                $pf.ParameterValueType -eq [CrystalDecisions.Shared.ParameterValueKind]::CurrencyParameter) {
                $typed = [decimal]$val
            }
            if ($rep) { $doc.SetParameterValue($name, $typed, $rep) } else { $doc.SetParameterValue($name, $typed) }
            $set += if ($rep) { "$rep/$name" } else { $name }
        }
        $res.ParamsSet = ($set -join ',')
        if ($skipped.Count -gt 0) { $res.ParamsSet += ' [notinuse: ' + ($skipped -join ',') + ']' }
        if ($missing.Count -gt 0) {
            $res.Status = 'NEEDS-PARAM'
            $res.Error = 'no value for: ' + ($missing -join ', ')
            throw 'handled'
        }
        if ($sample.Source -eq 'needs-param') {
            $res.Status = 'NEEDS-PARAM'; $res.Error = $sample.Note; throw 'handled'
        }

        # --- export ---
        $pdf = Join-Path $PdfFolder ([IO.Path]::ChangeExtension([IO.Path]::GetFileName($WorkerFile), '.pdf'))
        if (Test-Path -LiteralPath $pdf) { Remove-Item -LiteralPath $pdf -Force }
        try {
            $doc.ExportToDisk([CrystalDecisions.Shared.ExportFormatType]::PortableDocFormat, $pdf)
        }
        catch {
            $e = $_.Exception; $msg = $e.Message; while ($e.InnerException) { $e = $e.InnerException; $msg += ' | ' + $e.Message }
            $msg = Get-Scrubbed $msg $secret
            if ($msg -match '(?i)missing parameter') { $res.Status = 'NEEDS-PARAM' }
            elseif ($msg -match '(?i)logon|log on|login|connect|database|sql|invalid (object|column)|syntax|failed to (retrieve|open)|table|query|provider|ole db|odbc|timeout expired') { $res.Status = 'DB-FAIL' }
            else { $res.Status = 'RENDER-FAIL' }
            $res.Error = $msg
            throw 'handled'
        }

        # --- page count from the PDF, record count from the engine ---
        $bytes = [IO.File]::ReadAllBytes($pdf)
        $txt = [Text.Encoding]::GetEncoding(28591).GetString($bytes)
        $res.Pages = ([regex]::Matches($txt, '/Type\s*/Page(?![a-zA-Z])')).Count
        try { $res.Records = [int]$doc.Rows.Count } catch { $res.Records = -1 }

        if ($sample.Source -eq 'none') { $res.Status = 'NO-SAMPLE'; $res.Error = 'smoke run OK (key ' + $sample.DocKey + '); ' + $sample.Note }
        elseif ($res.Records -gt 0) { $res.Status = 'OK' }
        elseif ($res.Records -eq 0) { $res.Status = 'EMPTY'; $res.Error = '0 records for key ' + $sample.DocKey }
        else { $res.Status = 'OK'; $res.Error = 'record count unavailable' }
    }
    catch {
        if (-not $res.Status) {
            $res.Status = 'RENDER-FAIL'
            $e = $_.Exception; $msg = $e.Message; while ($e.InnerException) { $e = $e.InnerException; $msg += ' | ' + $e.Message }
            $res.Error = Get-Scrubbed $msg $secret
            if ($res.Error -match '_settings\.bat') { $res.Status = 'DB-FAIL' }
        }
    }
    finally {
        if ($doc) { try { $doc.Close() } catch { }; try { $doc.Dispose() } catch { } }
        $sw.Stop(); $res.Ms = [int]$sw.ElapsedMilliseconds
        $json = ([pscustomobject]$res | ConvertTo-Json -Compress)
        [IO.File]::WriteAllText($WorkerOut, $json, (New-Object Text.UTF8Encoding($false)))
    }
    exit 0
}

# ============================================================
# DRIVER
# ============================================================
$null = Get-DbSettings    # fail fast on bad settings (value not kept)
foreach ($d in $PdfFolder, $LogFolder) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Force $d | Out-Null } }
$samples = Import-Csv -LiteralPath $SampleCsv -Encoding UTF8
# powershell.exe -File passes a list as one string -> accept ';' separated patterns
$Only = @($Only | ForEach-Object { $_ -split ';' } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$files = Get-ChildItem -LiteralPath $RptFolder -Filter *.rpt | Sort-Object Name | Where-Object {
    $n = $_.Name; @($Only | Where-Object { $n -like $_ }).Count -gt 0 }
$ps64 = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
$log = Join-Path $LogFolder 'render.log'
$tmp = Join-Path $LogFolder 'worker'
if (-not (Test-Path $tmp)) { New-Item -ItemType Directory -Force $tmp | Out-Null }
Add-Content -LiteralPath $log -Encoding UTF8 -Value ("==== run {0} files={1} only={2}" -f (Get-Date -Format s), $files.Count, ($Only -join ';'))

# keep rows of files not in this run (so partial reruns merge)
$prev = @{}
if (Test-Path -LiteralPath $ResultCsv) { foreach ($r in (Import-Csv -LiteralPath $ResultCsv -Encoding UTF8)) { $prev[$r.File] = $r } }

$i = 0
foreach ($f in $files) {
    $i++
    $s = $samples | Where-Object { $_.File -eq $f.Name } | Select-Object -First 1
    $out = Join-Path $tmp ("{0:D3}.json" -f $i)
    if (Test-Path $out) { Remove-Item $out -Force }
    $argList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', "`"$PSCommandPath`"",
                 '-WorkerFile', "`"$($f.FullName)`"", '-WorkerOut', "`"$out`"",
                 '-PdfFolder', "`"$PdfFolder`"", '-SampleCsv', "`"$SampleCsv`"", '-Settings', "`"$Settings`"")
    $p = Start-Process -FilePath $ps64 -ArgumentList $argList -PassThru -WindowStyle Hidden
    $sw = [Diagnostics.Stopwatch]::StartNew()
    $done = $p.WaitForExit($TimeoutSec * 1000)
    if (-not $done) { try { $p.Kill() } catch { } }
    $sw.Stop()
    $r = $null
    if ($done -and (Test-Path $out)) { $r = Get-Content -LiteralPath $out -Raw -Encoding UTF8 | ConvertFrom-Json }
    if (-not $r) {
        $r = [pscustomobject]@{ Status = 'RENDER-FAIL'; Error = $(if ($done) { "worker exited $($p.ExitCode) without result (native crash?)" } else { "timeout ${TimeoutSec}s" })
                                Pages = 0; Records = -1; Ms = [int]$sw.ElapsedMilliseconds; OrigServer = ''; OrigDb = ''; Subreports = 0; Tables = 0; ParamsSet = '' }
    }
    $row = [pscustomobject][ordered]@{
        File = $f.Name; Group = $s.Group; ObjType = $s.ObjType; SourceTable = $s.Table
        DocKey = $s.DocKey; ObjectId = $s.ObjectId; SampleSource = $s.Source
        Status = $r.Status; Error = $r.Error; Pages = $r.Pages; Records = $r.Records; Ms = $r.Ms
        OrigServer = $r.OrigServer; OrigDb = $r.OrigDb
        OrigDbFlag = $(if ($r.OrigDb -and $r.OrigDb -ne 'SBO_SDA_REAL') { 'NOT-SBO_SDA_REAL' } else { '' })
        Subreports = $r.Subreports; Tables = $r.Tables; ParamsSet = $r.ParamsSet
        Pdf = $(if ($r.Pages -gt 0) { [IO.Path]::ChangeExtension($f.Name, '.pdf') } else { '' })
    }
    $prev[$f.Name] = $row
    $line = "{0:D3} {1,-11} p={2,-3} rec={3,-5} {4,6}ms  {5}  {6}" -f $i, $row.Status, $row.Pages, $row.Records, $row.Ms, $f.Name, $row.Error
    Add-Content -LiteralPath $log -Encoding UTF8 -Value $line
    Write-Host ("[{0}%] {1}" -f [int](100 * $i / $files.Count), $line)
}

$all = $prev.Values | Sort-Object File
$all | Export-Csv -LiteralPath $ResultCsv -NoTypeInformation -Encoding UTF8
Write-Host ("results.csv rows={0}" -f @($all).Count)
