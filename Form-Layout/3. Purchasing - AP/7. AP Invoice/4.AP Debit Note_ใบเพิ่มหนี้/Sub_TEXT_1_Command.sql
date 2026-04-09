-- ============================================================
-- Report: 4.AP Debit Note_ใบเพิ่มหนี้.rpt
Path:   3. Purchasing - AP\7. AP Invoice\4.AP Debit Note_ใบเพิ่มหนี้.rpt
Extracted: 2026-04-09 15:22:46
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT DISTINCT 
OPCH.DocEntry,
(PCH1.VisOrder+1) AS 'No.',
CAST(PCH10.LineText AS NVARCHAR(200)) AS 'Text',
PCH10.OrderNum


FROM OPCH  
LEFT JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry 
LEFT JOIN PCH10 ON OPCH.Docentry = PCH10.DocEntry AND PCH1.VisOrder = PCH10.AftLineNum

ORDER BY PCH10.OrderNum
