-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   3. Purchasing - AP\2. Purchase Quotation\1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-04-09 15:22:43
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT DISTINCT
OPQT.DocEntry,
(PQT1.VisOrder+1) AS 'No.',
CAST(PQT10.LineText AS NVARCHAR(2000)) AS 'Text',
PQT10.OrderNum

FROM OPQT
LEFT JOIN PQT1 ON OPQT.DocEntry = PQT1.DocEntry
LEFT JOIN PQT10 ON OPQT.DocEntry = PQT10.DocEntry AND PQT1.VisOrder = PQT10.AftLineNum

ORDER BY PQT10.OrderNum

