# Get-AuditSamples.ps1 -- step 3 of the SBO_SDA_REAL render audit.
# Maps each .rpt (by English keyword in its file name) to an object type and
# picks a sample key from SBO_SDA_REAL with SELECT-only queries.
# Output: samples.csv (File, Group, ObjType, Table, DocKey, ObjectId, Source, Note)
# Source = real | draft | wht-acct | none   (none -> smoke run with a key that does not exist)

param(
    [string]$Audit = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924'
)
$ErrorActionPreference = 'Stop'
. (Join-Path $Audit 'SdaReadOnly.ps1')

# ordered: first match wins
$map = @(
    @{ re = 'Withholding Tax certificate|P\.N\.D\.|Withholding Income Tax'; kind = 'wht' }
    @{ re = 'P\.P\.30|PP30';               kind = 'pp30' }
    @{ re = '^Tax Report';                 kind = 'taxrpt' }
    @{ re = 'AP Down Payment';             t = 'ODPO'; o = '204' }
    @{ re = 'AR Down Payment';             t = 'ODPI'; o = '203' }
    @{ re = 'AP Credit';                   t = 'ORPC'; o = '19' }
    @{ re = 'AP Invoice';                  t = 'OPCH'; o = '18' }
    @{ re = 'AR_?\s?Credit';               t = 'ORIN'; o = '14' }
    @{ re = 'Billing|AR Invoice';          t = 'OINV'; o = '13' }
    @{ re = 'Delivery';                    t = 'ODLN'; o = '15' }
    @{ re = 'Issue for Production';        t = 'OIGE'; o = '60' }
    @{ re = 'Goods Issue';                 t = 'OIGE'; o = '60' }
    @{ re = 'Goods Rec(ie|ei)pt PO';       t = 'OPDN'; o = '20' }
    @{ re = 'Receipt from Production';     t = 'OIGN'; o = '59' }
    @{ re = 'Goods Rec(ie|ei)pt';          t = 'OIGN'; o = '59' }
    @{ re = 'Goods Return';                t = 'ORPD'; o = '21' }
    @{ re = 'Incoming Payment';            t = 'ORCT'; o = '24' }
    @{ re = 'Outgoing Payment';            t = 'OVPM'; o = '46' }
    @{ re = 'Inventory Counting';          t = 'OINC'; o = '1470000065' }
    @{ re = 'Transfer Request';            t = 'OWTQ'; o = '1250000001' }
    @{ re = 'Inventory Transfer';          t = 'OWTR'; o = '67' }
    @{ re = 'Journal Entry';               t = 'OJDT'; o = '30'; key = 'TransId' }
    @{ re = 'Landed Cost';                 t = 'OIPF'; o = '69' }
    @{ re = 'Production Order';            t = 'OWOR'; o = '202' }
    @{ re = 'Purchase Order';              t = 'OPOR'; o = '22' }
    @{ re = 'Purchase Quotation';          t = 'OPQT'; o = '540000006' }
    @{ re = 'Purchase Request';            t = 'OPRQ'; o = '1470000113' }
    @{ re = 'Retrun|Return';               t = 'ORDN'; o = '16' }
    @{ re = 'Sale Order';                  t = 'ORDR'; o = '17' }
    @{ re = 'Sale Quotation';              t = 'OQUT'; o = '23' }
)

$cache = @{}
function Get-Latest([string]$table, [string]$key) {
    $ck = "$table.$key"
    if (-not $cache.ContainsKey($ck)) {
        $dt = Invoke-SdaSelect "SELECT MAX($key) AS k FROM $table"
        $v = $dt.Rows[0].k
        $cache[$ck] = if ($v -is [DBNull]) { $null } else { [string]$v }
    }
    return $cache[$ck]
}
function Get-LatestDraft([string]$objType) {
    $ck = "ODRF.$objType"
    if (-not $cache.ContainsKey($ck)) {
        $dt = Invoke-SdaSelect "SELECT MAX(DocEntry) AS k FROM ODRF WHERE ObjType = '$objType'"
        $v = $dt.Rows[0].k
        $cache[$ck] = if ($v -is [DBNull]) { $null } else { [string]$v }
    }
    return $cache[$ck]
}

# WHT: latest JE TransId posted to a WHT account mapped in @SLDT_SET_ACCWH
$whtDt = Invoke-SdaSelect "SELECT MAX(j.TransId) AS k FROM JDT1 j JOIN OACT a ON a.AcctCode = j.Account JOIN [@SLDT_SET_ACCWH] w ON w.[Name] = a.FormatCode"
$whtKey = if ($whtDt.Rows[0].k -is [DBNull]) { $null } else { [string]$whtDt.Rows[0].k }
$ppDt = Invoke-SdaSelect "SELECT MAX(U_SubmitDate) AS k FROM [@SLDT_TS_TST]"
$ppKey = if ($ppDt.Rows[0].k -is [DBNull]) { $null } else { [string]$ppDt.Rows[0].k }
$rtDt = Invoke-SdaSelect "SELECT COUNT(*) AS c FROM [@SLDT_RT_TST]"
$rtCnt = [int]$rtDt.Rows[0].c
$lastMonth = (Get-Date).AddMonths(-1).ToString('yyyyMM')

$rows = foreach ($f in (Get-ChildItem -LiteralPath (Join-Path $Audit 'rpt') -Filter *.rpt | Sort-Object Name)) {
    $m = $null
    foreach ($e in $map) { if ($f.Name -match $e.re) { $m = $e; break } }
    $r = [ordered]@{ File = $f.Name; Group = 'Form'; ObjType = ''; Table = ''; DocKey = '-1'; ObjectId = ''; Source = 'none'; Note = '' }
    if (-not $m) { $r.Note = 'no keyword mapping'; [pscustomobject]$r; continue }
    switch ($m.kind) {
        'wht' {
            $r.Group = 'Tax'; $r.Table = 'JDT1+@SLDT_SET_ACCWH'; $r.ObjType = 'TransId'
            if ($whtKey) { $r.DocKey = $whtKey; $r.Source = 'wht-acct'; $r.Note = 'latest JE on WHT account (OVPM/OPCH/PCH5/VPM6 are empty)' }
            else { $r.Note = 'no WHT posting' }
        }
        'pp30' {
            $r.Group = 'Tax'; $r.Table = '@SLDT_TS_TST'; $r.ObjType = 'SubmitDate'
            if ($ppKey) { $r.DocKey = $ppKey; $r.Source = 'real' }
            else { $r.DocKey = $lastMonth; $r.Note = '@SLDT_TS_TST empty -- smoke with last month' }
        }
        'taxrpt' {
            $r.Group = 'Tax'; $r.Table = '@SLDT_RT_TST'; $r.ObjType = 'TaxType+DocNum'
            $r.DocKey = "''"
            $r.Note = if ($rtCnt -eq 0) { '@SLDT_RT_TST empty -- smoke with empty IN list' } else { 'DocKey is TaxType+DocNum list -- cannot derive' }
            if ($rtCnt -gt 0) { $r.Source = 'needs-param' }
        }
        default {
            $key = if ($m.key) { $m.key } else { 'DocEntry' }
            $r.Table = $m.t; $r.ObjType = $m.o; $r.ObjectId = $m.o
            $v = Get-Latest $m.t $key
            if ($v) { $r.DocKey = $v; $r.Source = 'real' }
            else {
                $d = Get-LatestDraft $m.o
                if ($d) { $r.DocKey = $d; $r.ObjectId = '112'; $r.Source = 'draft'; $r.Note = "$($m.t) empty -- using draft ODRF" }
                else { $r.Note = "$($m.t) empty, no draft" }
            }
        }
    }
    [pscustomobject]$r
}
$out = Join-Path $Audit 'samples.csv'
$rows | Export-Csv -LiteralPath $out -NoTypeInformation -Encoding UTF8
Write-Host ("samples.csv rows={0}" -f @($rows).Count)
