SELECT
    TOP 1 RPC10.LineText
FROM RPC1
INNER JOIN RPC10 ON RPC1.[DocEntry] = RPC10.[DocEntry] AND RPC10.AftLineNum = {?lineNum@}
WHERE RPC1.[DocEntry] = {?DocKey@}
