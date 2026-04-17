SELECT
    TOP 1 WOR10.LineText
FROM WOR1
INNER JOIN WOR10 ON WOR1.[DocEntry] = WOR10.[DocEntry] AND WOR10.AftLineNum = {?lineNum@}
WHERE WOR1.[DocEntry] = {?DocKey@}
