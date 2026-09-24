# Build-AuditHtml.ps1 -- step 6: inject results.csv into audit-template.html.
# Only non-customer columns are exported (file, group, object type, key, status,
# short error, pages, time, original datasource).
param(
    [string]$Audit = 'C:\GitHub\SDA\Form-Layout_SDA\Audit_Render_20260924',
    [string]$Out   = 'C:\Users\User\AppData\Local\Temp\claude\C--Users-User\3e269b4f-0dd2-4b5e-878f-9d24e5044a68\scratchpad\crystal-audit-sbo-sda-real.html'
)
$ErrorActionPreference = 'Stop'
$rows = Import-Csv -LiteralPath (Join-Path $Audit 'results.csv') -Encoding UTF8
$data = foreach ($r in $rows) {
    $err = [string]$r.Error
    $err = $err -replace 'Exception calling "ExportToDisk" with "2" argument\(s\):\s*', ''
    $err = $err -replace 'Error in File [^:]*\.rpt:\s*', ''
    $err = ($err -split '\s\|\s')[0].Trim('"', ' ')
    if ($err.Length -gt 180) { $err = $err.Substring(0, 177) + '...' }
    [ordered]@{
        File = $r.File; Group = $r.Group; ObjType = $r.ObjType; DocKey = $r.DocKey; ObjectId = $r.ObjectId
        SampleSource = $r.SampleSource; Status = $r.Status; Error = $err
        Pages = [int]$r.Pages; Ms = [int]$r.Ms; OrigServer = $r.OrigServer; OrigDb = $r.OrigDb
    }
}
$json = ConvertTo-Json -InputObject @($data) -Depth 3 -Compress
$json = $json -replace '</', '<\/'
$tpl = [IO.File]::ReadAllText((Join-Path $Audit 'audit-template.html'), [Text.Encoding]::UTF8)
$stamp = (Get-Item -LiteralPath (Join-Path $Audit 'results.csv')).LastWriteTime.ToString('yyyy-MM-dd HH:mm')
$html = $tpl.Replace('__DATA__', $json).Replace('__RUNDATE__', $stamp)
[IO.File]::WriteAllText($Out, $html, (New-Object Text.UTF8Encoding($false)))
Write-Host ("html rows={0} -> {1}" -f @($data).Count, $Out)
