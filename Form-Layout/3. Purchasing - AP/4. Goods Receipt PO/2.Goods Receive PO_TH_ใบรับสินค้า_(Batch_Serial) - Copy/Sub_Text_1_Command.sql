SELECT
    TOP 1 PDN10.LineText
FROM PDN1
INNER JOIN PDN10 ON PDN1.[DocEntry] = PDN10.[DocEntry] AND PDN10.AftLineNum = {?lineNum@}
WHERE PDN1.[DocEntry] = {?DocKey@}
