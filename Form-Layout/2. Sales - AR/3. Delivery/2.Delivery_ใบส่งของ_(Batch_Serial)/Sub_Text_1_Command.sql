-- ============================================================
-- Report: 2.Delivery_ใบส่งของ_(Batch_Serial).rpt
Path:   2. Sales - AR\3. Delivery\2.Delivery_ใบส่งของ_(Batch_Serial).rpt
Extracted: 2026-04-09 15:22:34
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT DISTINCT
ODLN.DocEntry,
(DLN1.VisOrder+1) AS 'No.',
CAST(DLN10.LineText AS NVARCHAR(2000)) AS 'Text',
DLN10.OrderNum

FROM ODLN
LEFT JOIN DLN1 ON ODLN.DocEntry = DLN1.DocEntry
LEFT JOIN DLN10 ON ODLN.DocEntry = DLN10.DocEntry AND DLN1.VisOrder = DLN10.AftLineNum

ORDER BY DLN10.OrderNum
