# ============================================================
# Mirror FMS from one FormID to another via direct SQL on CSHS.
# Bypasses DI API entirely because DI API v10 silently fails to
# persist QueryId/Refresh/FieldID on oFormattedSearches.Add()/Update().
#
# Logic:
#   1. DELETE existing rows on TargetFormID (limited by ItemID if given)
#   2. INSERT SELECT from SourceFormID, only changing FormID column
#   3. All other columns (ActionT, QueryId, Refresh, ByField, FieldID,
#      FrceRfrsh) copied verbatim from source.
# ============================================================
param(
    [string]$Server      = "SLD-C072",
    [string]$CompanyDB   = "SBO_SDA",
    [string]$DBUser      = "sa",
    [string]$DBPassword  = "1q2w3e4r",
    [Parameter(Mandatory=$true)]
    [string]$SourceFormID,
    [Parameter(Mandatory=$true)]
    [string]$TargetFormID,
    [string]$ItemID      = "",                                  # blank = mirror all items on the form
    [string]$LogFile     = "",
    [switch]$DryRun
)

# Defer log path resolution to script body (param defaults can lose
# $PSScriptRoot in some invocation contexts -> bad C:\..\ resolution)
if (-not $LogFile) {
    $LogFile = Join-Path $PSScriptRoot "..\Mirror_FMS_Log.txt"
}

function Write-Log {
    param([string]$Msg, [string]$Level = "INFO")
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Msg
    Write-Host $line
    Add-Content -Path $LogFile -Value $line -Encoding UTF8
}

Write-Log "=== Mirror FMS: source=$SourceFormID -> target=$TargetFormID (Item=$ItemID) DryRun=$DryRun ==="

$connStr = "Server=$Server;Database=$CompanyDB;User ID=$DBUser;Password=$DBPassword;Connection Timeout=10"
$conn = New-Object System.Data.SqlClient.SqlConnection $connStr
try {
    $conn.Open()
    Write-Log "Connected to SQL: $Server / $CompanyDB"

    # 1) Discover what's on source
    $itemFilter = ""
    if ($ItemID) { $itemFilter = " AND ItemID = @item" }
    $sel = $conn.CreateCommand()
    $sel.CommandText = "SELECT FormID, ItemID, ColID, ActionT, QueryId, Refresh, ByField, FieldID, FrceRfrsh FROM CSHS WHERE FormID = @src$itemFilter ORDER BY ItemID, ColID"
    [void]$sel.Parameters.AddWithValue("@src", $SourceFormID)
    if ($ItemID) { [void]$sel.Parameters.AddWithValue("@item", $ItemID) }
    $rdr = $sel.ExecuteReader()
    $srcRows = New-Object System.Collections.ArrayList
    while ($rdr.Read()) {
        [void]$srcRows.Add([pscustomobject]@{
            ItemID   = [string]$rdr["ItemID"]
            ColID    = [string]$rdr["ColID"]
            ActionT  = [string]$rdr["ActionT"]
            QueryId  = if ($rdr["QueryId"] -is [DBNull]) { $null } else { [int]$rdr["QueryId"] }
            Refresh  = [string]$rdr["Refresh"]
            ByField  = [string]$rdr["ByField"]
            FieldID  = [string]$rdr["FieldID"]
            FrceRfrsh= [string]$rdr["FrceRfrsh"]
        })
    }
    $rdr.Close()
    Write-Log "Source $SourceFormID has $($srcRows.Count) FMS row(s) to mirror"
    if ($srcRows.Count -eq 0) {
        Write-Log "Nothing to mirror — exiting." "WARN"
        exit 0
    }

    foreach ($r in $srcRows) {
        $q = if ($null -eq $r.QueryId) { "(null)" } else { $r.QueryId }
        Write-Log ("  Source  Item={0,-12} Col={1,-22} ActionT={2}  QueryId={3,-5}  Refresh={4}  ByField={5}  FieldID={6,-18}  FrceRfrsh={7}" -f $r.ItemID, $r.ColID, $r.ActionT, $q, $r.Refresh, $r.ByField, $r.FieldID, $r.FrceRfrsh)
    }

    if ($DryRun) {
        Write-Log "DryRun=ON. No DELETE / INSERT executed."
        exit 0
    }

    # 2) Execute DELETE + INSERT inside a transaction
    $tx = $conn.BeginTransaction()
    try {
        # DELETE existing rows on target (scoped to ItemID if given)
        $del = $conn.CreateCommand()
        $del.Transaction = $tx
        $del.CommandText = "DELETE FROM CSHS WHERE FormID = @tgt$itemFilter"
        [void]$del.Parameters.AddWithValue("@tgt", $TargetFormID)
        if ($ItemID) { [void]$del.Parameters.AddWithValue("@item", $ItemID) }
        $delCount = $del.ExecuteNonQuery()
        Write-Log "Deleted $delCount existing row(s) on target $TargetFormID"

        # IndexID is NOT NULL but NOT IDENTITY -> compute next manually
        $maxCmd = $conn.CreateCommand()
        $maxCmd.Transaction = $tx
        $maxCmd.CommandText = "SELECT ISNULL(MAX(IndexID), 0) FROM CSHS"
        $nextIdx = [int]$maxCmd.ExecuteScalar()
        Write-Log "Current MAX(IndexID) = $nextIdx -> new rows start at $($nextIdx + 1)"

        # INSERT each source row with FormID changed to target
        $insCount = 0
        foreach ($r in $srcRows) {
            $nextIdx++
            $ins = $conn.CreateCommand()
            $ins.Transaction = $tx
            $ins.CommandText = @"
INSERT INTO CSHS (IndexID, FormID, ItemID, ColID, ActionT, QueryId, Refresh, ByField, FieldID, FrceRfrsh)
VALUES (@idx, @fid, @iid, @cid, @act, @qid, @ref, @byf, @fld, @frc)
"@
            [void]$ins.Parameters.AddWithValue("@idx", $nextIdx)
            [void]$ins.Parameters.AddWithValue("@fid", $TargetFormID)
            [void]$ins.Parameters.AddWithValue("@iid", $r.ItemID)
            [void]$ins.Parameters.AddWithValue("@cid", $r.ColID)
            [void]$ins.Parameters.AddWithValue("@act", $r.ActionT)
            if ($null -eq $r.QueryId) {
                [void]$ins.Parameters.AddWithValue("@qid", [DBNull]::Value)
            } else {
                [void]$ins.Parameters.AddWithValue("@qid", $r.QueryId)
            }
            [void]$ins.Parameters.AddWithValue("@ref", $r.Refresh)
            [void]$ins.Parameters.AddWithValue("@byf", $r.ByField)
            [void]$ins.Parameters.AddWithValue("@fld", $r.FieldID)
            [void]$ins.Parameters.AddWithValue("@frc", $r.FrceRfrsh)
            $insCount += $ins.ExecuteNonQuery()
        }
        $tx.Commit()
        Write-Log "Inserted $insCount row(s) on target $TargetFormID — committed"
    } catch {
        $tx.Rollback()
        Write-Log "ROLLBACK: $($_.Exception.Message)" "ERROR"
        exit 3
    }

    # 3) Verify
    $ver = $conn.CreateCommand()
    $ver.CommandText = "SELECT ColID, ActionT, QueryId, Refresh, ByField, FieldID, FrceRfrsh FROM CSHS WHERE FormID = @tgt$itemFilter ORDER BY ColID"
    [void]$ver.Parameters.AddWithValue("@tgt", $TargetFormID)
    if ($ItemID) { [void]$ver.Parameters.AddWithValue("@item", $ItemID) }
    $rdr = $ver.ExecuteReader()
    Write-Log "Post-import state of $TargetFormID :"
    while ($rdr.Read()) {
        $q = if ($rdr["QueryId"] -is [DBNull]) { "(null)" } else { $rdr["QueryId"] }
        Write-Log ("  Result  Col={0,-22} ActionT={1}  QueryId={2,-5}  Refresh={3}  ByField={4}  FieldID={5,-18}  FrceRfrsh={6}" -f $rdr["ColID"], $rdr["ActionT"], $q, $rdr["Refresh"], $rdr["ByField"], $rdr["FieldID"], $rdr["FrceRfrsh"])
    }
    $rdr.Close()

    Write-Log "=== Done ==="
} finally {
    if ($conn.State -eq 'Open') { $conn.Close() }
}
exit 0
