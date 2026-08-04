-- ============================================================
-- Report: 1.Sale Order_ใบสั่งขาย_(Dis).rpt
Path:   1.Sale Order_ใบสั่งขาย_(Dis).rpt
Extracted: 2026-07-31 00:01:55
-- Source: Subreport [Hremark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM RDR10
WHERE [DocEntry] = {?DocKey@} 
  AND [AftLineNum] = -1
ORDER BY [LineSeq] ASC
