SELECT
    TOP 1 RIN10.LineText
FROM RIN1
INNER JOIN RIN10 ON RIN1.[DocEntry] = RIN10.[DocEntry] AND RIN10.AftLineNum = {?lineNum@}
WHERE RIN1.[DocEntry] = {?DocKey@}
