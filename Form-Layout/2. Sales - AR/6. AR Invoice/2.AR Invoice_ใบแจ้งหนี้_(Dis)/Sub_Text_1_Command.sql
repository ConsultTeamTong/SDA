-- ============================================================
-- Report: 2.AR Invoice_ใบแจ้งหนี้_(Dis).rpt
Path:   2. Sales - AR\6. AR Invoice\2.AR Invoice_ใบแจ้งหนี้_(Dis).rpt
Extracted: 2026-04-09 15:22:37
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT Distinct
OINV.DocEntry,
(INV1.VisOrder+1) AS 'No.',
CAST(INV10.LineText as NVARCHAR(2000)) AS 'Text',
INV10.OrderNum

FROM OINV
LEFT JOIN INV1 ON OINV.DocEntry = INV1.DocEntry
LEFT JOIN INV10 ON OINV.DocEntry = INV10.DocEntry AND INV1.VisOrder = INV10.AftLineNum

ORDER BY INV10.OrderNum

