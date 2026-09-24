# SdaReadOnly.ps1 -- dot-source helper: read-only SQL access to SBO_SDA_REAL.
# Credential is read from ImportLayouts\_settings.bat at runtime and never printed.
# Only statements starting with SELECT / WITH are allowed.

$script:SdaSettings = 'C:\GitHub\SDA\Form-Layout_SDA\ImportLayouts\_settings.bat'

function Get-SdaSettings {
    $h = @{}
    foreach ($l in (Get-Content -LiteralPath $script:SdaSettings)) {
        if ($l -match '^\s*set\s+"?(\w+)=(.*?)"?\s*$') { $h[$matches[1]] = $matches[2] }
    }
    if (-not $h['DBPASSWORD']) { throw 'DBPASSWORD missing in _settings.bat' }
    if ($h['SERVER'] -ne '10.0.70.61' -or $h['COMPANYDB'] -ne 'SBO_SDA_REAL' -or $h['DBUSER'] -ne 'sa') {
        throw 'settings do not point to 10.0.70.61 / SBO_SDA_REAL / sa -- stop'
    }
    return $h
}

function Invoke-SdaSelect {
    param([Parameter(Mandatory)][string]$Sql)
    $trim = $Sql.TrimStart()
    if ($trim -notmatch '^(?i)(SELECT|WITH)\b') { throw 'read-only helper: only SELECT/WITH allowed' }
    if ($Sql -match '(?i)\b(INSERT|UPDATE|DELETE|MERGE|DROP|ALTER|CREATE|TRUNCATE|EXEC|EXECUTE|GRANT|REVOKE)\b\s') {
        throw 'read-only helper: write keyword detected'
    }
    $s = Get-SdaSettings
    $b = New-Object System.Data.SqlClient.SqlConnectionStringBuilder
    $b['Data Source'] = $s['SERVER']; $b['Initial Catalog'] = $s['COMPANYDB']
    $b['User ID'] = $s['DBUSER']; $b['Password'] = $s['DBPASSWORD']
    $b['ApplicationIntent'] = 'ReadOnly'; $b['Connect Timeout'] = 15
    $cn = New-Object System.Data.SqlClient.SqlConnection $b.ConnectionString
    try {
        $cn.Open()
        $cmd = $cn.CreateCommand(); $cmd.CommandText = $Sql; $cmd.CommandTimeout = 120
        $dt = New-Object System.Data.DataTable
        (New-Object System.Data.SqlClient.SqlDataAdapter $cmd).Fill($dt) | Out-Null
        return ,$dt
    }
    finally { $cn.Close(); $cn.Dispose() }
}
