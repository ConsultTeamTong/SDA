SELECT
    TOP 1 IGE10.LineText
FROM IGE1
INNER JOIN IGE10 ON IGE1.[DocEntry] = IGE10.[DocEntry] AND IGE10.AftLineNum = {?lineNum@}
WHERE IGE1.[DocEntry] = {?DocKey@}
