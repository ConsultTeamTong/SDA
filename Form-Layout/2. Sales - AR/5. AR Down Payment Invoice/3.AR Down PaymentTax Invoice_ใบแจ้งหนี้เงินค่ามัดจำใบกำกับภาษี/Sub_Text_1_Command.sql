-- ============================================================
-- Report: 3.AR Down PaymentTax Invoice_ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
Path:   2. Sales - AR\5. AR Down Payment Invoice\3.AR Down PaymentTax Invoice_ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
Extracted: 2026-04-09 15:22:37
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT DISTINCT
ODPI.DocEntry,
(DPI1.VisOrder+1) AS 'No.',
CAST(DPI10.LineText as NVARCHAR(2000)) AS 'Text',
DPI10.OrderNum

FROM ODPI 
LEFT JOIN DPI1 ON ODPI.DocEntry = DPI1.DocEntry
LEFT JOIN DPI10 ON ODPI.DocEntry = DPI10.DocEntry AND DPI1.VisOrder = DPI10.AftLineNum

ORDER BY DPI10.OrderNum
