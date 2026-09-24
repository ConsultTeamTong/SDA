-- ============================================================
-- Report: 1.Landed Costs_ใบปรับราคาต้นทุนสินค้า.rpt
-- Path:   1.Landed Costs_ใบปรับราคาต้นทุนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:20
-- Source: Subreport [Landed_Cost]
-- Table:  Landed_Cost
-- ============================================================

SELECT DISTINCT
OIPF.DocEntry,
OIPF.DocNum,
NNM1.BeginStr,
OIPF.DocDate,
OIPF.DocCur,
OCRD.CardCode,
OCRD.CardName,
OALC.AlcCode,
OALC.AlcName,
IPF2.CostSum
FROM OIPF
INNER JOIN IPF1 ON OIPF.DocEntry = IPF1.DocEntry 
INNER JOIN IPF2 ON OIPF.DocEntry = IPF2.DocEntry
LEFT JOIN OALC ON IPF2.AlcCode = OALC.AlcCode
LEFT JOIN OCRD ON OIPF.CardCode = OCRD.CardCode
LEFT JOIN NNM1 ON OIPF.Series = NNM1.Series

ORDER BY OIPF.DocNum
