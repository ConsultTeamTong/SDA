SELECT 
    TOP 1 RDN10.LineText
FROM RDN1 
INNER JOIN RDN10 ON RDN1.[DocEntry] = RDN10.[DocEntry] AND RDN10.AftLineNum = 0
WHERE RDN1.[DocEntry] = {?DocKey@}