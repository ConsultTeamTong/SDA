-- ============================================================
-- Report: 1.AP Credit Memo_ใบลดหนี้.rpt
Path:   3. Purchasing - AP\8. AP Credit Memo\1.AP Credit Memo_ใบลดหนี้.rpt
Extracted: 2026-04-09 15:22:46
-- Source: Subreport [TEXT]
-- Table:  คำสั่ง
-- ============================================================

SELECT DISTINCT
ORPC.DocEntry,
(RPC1.VisOrder+1) AS 'No.',
CAST(RPC10.LineText AS NVARCHAR(200)) AS 'Text',
RPC10.OrderNum

FROM ORPC 
LEFT JOIN RPC1 ON ORPC.DocEntry = RPC1.DocEntry 
LEFT JOIN RPC10 ON ORPC.Docentry = RPC10.DocEntry AND RPC1.VisOrder = RPC10.AftLineNum

ORDER BY RPC10.OrderNum
