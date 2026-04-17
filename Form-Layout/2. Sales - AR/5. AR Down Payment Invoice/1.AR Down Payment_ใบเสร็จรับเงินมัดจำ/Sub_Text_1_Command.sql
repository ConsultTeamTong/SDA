SELECT
    TOP 1 DPI10.LineText
FROM DPI1
INNER JOIN DPI10 ON DPI1.[DocEntry] = DPI10.[DocEntry] AND DPI10.AftLineNum = {?lineNum@}
WHERE DPI1.[DocEntry] = {?DocKey@}
