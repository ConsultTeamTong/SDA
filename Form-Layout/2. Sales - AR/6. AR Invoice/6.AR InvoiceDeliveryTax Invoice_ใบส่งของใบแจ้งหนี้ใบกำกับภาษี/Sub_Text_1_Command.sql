SELECT
    TOP 1 INV10.LineText
FROM INV1
INNER JOIN INV10 ON INV1.[DocEntry] = INV10.[DocEntry] AND INV10.AftLineNum = {?lineNum@}
WHERE INV1.[DocEntry] = {?DocKey@}
