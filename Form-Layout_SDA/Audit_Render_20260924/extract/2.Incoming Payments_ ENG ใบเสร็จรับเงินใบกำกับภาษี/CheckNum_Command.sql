-- ============================================================
-- Report: 2.Incoming Payments_ ENG ใบเสร็จรับเงินใบกำกับภาษี.rpt
-- Path:   2.Incoming Payments_ ENG ใบเสร็จรับเงินใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:41
-- Source: Subreport [CheckNum]
-- Table:  Command
-- ============================================================

SELECT 
RCT1.DocNum,
RCT1.CheckNum,
ODSC.BankName,
RCT1.DueDate

FROM ORCT 
LEFT JOIN RCT1 ON ORCT.DocEntry = RCT1.DocNum
LEFT JOIN ODSC ON RCT1.BankCode = ODSC.BankCode
