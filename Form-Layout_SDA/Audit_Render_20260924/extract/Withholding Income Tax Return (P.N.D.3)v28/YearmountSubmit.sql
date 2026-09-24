-- ============================================================
-- Report: Withholding Income Tax Return (P.N.D.3)v28.rpt
-- Path:   Withholding Income Tax Return (P.N.D.3)v28.rpt
-- Extracted: 2026-09-24 10:21:03
-- Source: Main Report
-- Table:  YearmountSubmit
-- ============================================================

SELECT DISTINCT ROW_NUMBER() OVER ( ORDER BY Name) AS Row, * 
FROM 
(SELECT DISTINCT
CAST((Left([U_Date], 4)) AS INT) + 543 AS Year, 
RIGHT(LEFT([U_Date], 6),2) AS Mount, 
[U_CardName],
[Name]
FROM [@SLDT_RT_TST] 
where [U_DocNum] IS NOT NULL AND [U_TaxType] = '5'
) AS YearMount;
