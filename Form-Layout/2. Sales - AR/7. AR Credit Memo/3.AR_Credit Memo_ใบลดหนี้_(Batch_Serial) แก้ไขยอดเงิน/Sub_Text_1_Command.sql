-- ============================================================
-- Report: 3.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) แก้ไขยอดเงิน.rpt
Path:   2. Sales - AR\7. AR Credit Memo\3.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) แก้ไขยอดเงิน.rpt
Extracted: 2026-04-09 15:22:41
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT Distinct
ORIN.DocEntry,
(RIN1.VisOrder+1) AS 'No.',
CAST(RIN10.LineText AS NVARCHAR(2000)) AS'Text',
RIN10.OrderNum

FROM ORIN 
LEFT JOIN RIN1 ON ORIN.DocEntry = RIN1.DocEntry
LEFT JOIN RIN10 ON ORIN.DocEntry = RIN10.DocEntry AND RIN1.VisOrder = RIN10.AftLineNum

ORDER BY RIN10.OrderNum
