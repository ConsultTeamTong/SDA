-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
Path:   3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
Extracted: 2026-08-05 14:18:16
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM RDR10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = {?lineNum@}
ORDER BY [LineSeq] ASC

