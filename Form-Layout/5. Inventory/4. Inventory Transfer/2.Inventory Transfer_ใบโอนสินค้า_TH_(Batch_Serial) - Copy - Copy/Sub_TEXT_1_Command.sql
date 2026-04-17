SELECT
    TOP 1 WTR10.LineText
FROM WTR1
INNER JOIN WTR10 ON WTR1.[DocEntry] = WTR10.[DocEntry] AND WTR10.AftLineNum = {?lineNum@}
WHERE WTR1.[DocEntry] = {?DocKey@}
