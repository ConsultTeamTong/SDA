# ============================================================
# Delete ALL layouts in RDOC EXCEPT system defaults
# "System" = rows where Author = '-System-'
# All other authors (manager, SDA, custom users, etc.) will be deleted.
# ============================================================
param(
    [Parameter(Mandatory=$true)][string]$Server,
    [Parameter(Mandatory=$true)][string]$CompanyDB,
    [string]$DBUser     = "sa",
    [Parameter(Mandatory=$true)][string]$DBPassword,
    [string]$SystemAuthor = "-System-",
    [switch]$DryRun,
    [switch]$Force
)

Write-Host "=== Delete non-system layouts from RDOC ===" -ForegroundColor Cyan
Write-Host "Server      : $Server"
Write-Host "CompanyDB   : $CompanyDB"
Write-Host "Keep Author : '$SystemAuthor'"
Write-Host ""

$cs = "Server=$Server;Database=$CompanyDB;User ID=$DBUser;Password=$DBPassword;Connection Timeout=10;"
$conn = New-Object System.Data.SqlClient.SqlConnection $cs
try {
    $conn.Open()
} catch {
    Write-Host "ERROR connecting: $($_.Exception.Message)" -ForegroundColor Red
    return
}

$total = ($conn.CreateCommand() | ForEach-Object { $_.CommandText = "SELECT COUNT(*) FROM RDOC"; $_.ExecuteScalar() })
Write-Host ("RDOC total rows           : {0}" -f $total) -ForegroundColor Gray

$sysCmd = $conn.CreateCommand()
$sysCmd.CommandText = "SELECT COUNT(*) FROM RDOC WHERE Author=@a"
[void]$sysCmd.Parameters.AddWithValue("@a", $SystemAuthor)
$sysCount = $sysCmd.ExecuteScalar()
Write-Host ("Rows with Author='$SystemAuthor' (KEEP) : {0}" -f $sysCount) -ForegroundColor Green

$delCmd = $conn.CreateCommand()
$delCmd.CommandText = "SELECT COUNT(*) FROM RDOC WHERE Author<>@a OR Author IS NULL"
[void]$delCmd.Parameters.AddWithValue("@a", $SystemAuthor)
$delCount = $delCmd.ExecuteScalar()
Write-Host ("Rows to DELETE            : {0}" -f $delCount) -ForegroundColor Yellow
Write-Host ""

if ($delCount -eq 0) {
    Write-Host "Nothing to delete." -ForegroundColor Green
    $conn.Close()
    return
}

# Preview: group by Author + TypeCode
$prev = $conn.CreateCommand()
$prev.CommandText = @"
SELECT Author, TypeCode, COUNT(*) AS Cnt
FROM RDOC
WHERE Author<>@a OR Author IS NULL
GROUP BY Author, TypeCode
ORDER BY Author, TypeCode
"@
[void]$prev.Parameters.AddWithValue("@a", $SystemAuthor)
$da = New-Object System.Data.SqlClient.SqlDataAdapter $prev
$dt = New-Object System.Data.DataTable
[void]$da.Fill($dt)
Write-Host "=== Preview (grouped by Author + TypeCode) ===" -ForegroundColor Yellow
$dt | Format-Table Author,TypeCode,Cnt -AutoSize

if ($DryRun) {
    Write-Host "DryRun mode - no changes made." -ForegroundColor Cyan
    $conn.Close()
    return
}

if (-not $Force) {
    Write-Host "WARNING: This will permanently delete $delCount rows from RDOC." -ForegroundColor Red
    $ans = Read-Host "Type 'yes' to confirm"
    if ($ans -ne "yes") {
        Write-Host "Cancelled." -ForegroundColor Yellow
        $conn.Close()
        return
    }
}

$exec = $conn.CreateCommand()
$exec.CommandText = "DELETE FROM RDOC WHERE Author<>@a OR Author IS NULL"
[void]$exec.Parameters.AddWithValue("@a", $SystemAuthor)
$exec.CommandTimeout = 300
$n = $exec.ExecuteNonQuery()
$conn.Close()

Write-Host ""
Write-Host "=== Summary: Deleted=$n / Kept(system)=$sysCount ===" -ForegroundColor Cyan
