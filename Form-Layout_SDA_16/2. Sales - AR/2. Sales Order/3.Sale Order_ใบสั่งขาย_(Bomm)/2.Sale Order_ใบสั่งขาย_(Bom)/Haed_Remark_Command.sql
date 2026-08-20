-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
Path:   3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
Extracted: 2026-08-05 14:18:16
-- Source: Subreport [Haed_Remark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM RDR10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = -1
ORDER BY [LineSeq] ASC

