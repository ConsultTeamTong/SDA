-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:16
-- Source: Subreport [HRemark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM WTR10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = -1
ORDER BY [LineSeq] ASC

