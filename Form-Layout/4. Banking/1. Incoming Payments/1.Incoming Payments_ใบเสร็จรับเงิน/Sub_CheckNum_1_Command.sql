-- ============================================================
-- Report: 1.Incoming Payments_ใบเสร็จรับเงิน.rpt
Path:   4. Banking\1. Incoming Payments\1.Incoming Payments_ใบเสร็จรับเงิน.rpt
Extracted: 2026-04-09 15:22:47
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
