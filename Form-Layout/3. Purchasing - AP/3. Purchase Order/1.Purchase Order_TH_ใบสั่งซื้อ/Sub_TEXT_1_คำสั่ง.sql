-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   3. Purchasing - AP\3. Purchase Order\1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-04-09 15:22:44
-- Source: Subreport [TEXT]
-- Table:  คำสั่ง
-- ============================================================

SELECT DISTINCT
OPOR.DocEntry,
(POR1.VisOrder+1) AS 'No.',
CAST(POR10.LineText AS NVARCHAR(200)) AS 'Text',
POR10.OrderNum

FROM OPOR  
LEFT JOIN POR1 ON OPOR.DocEntry = POR1.DocEntry 
LEFT JOIN POR10 ON OPOR.Docentry = POR10.DocEntry AND POR1.VisOrder = POR10.AftLineNum

ORDER BY POR10.OrderNum
