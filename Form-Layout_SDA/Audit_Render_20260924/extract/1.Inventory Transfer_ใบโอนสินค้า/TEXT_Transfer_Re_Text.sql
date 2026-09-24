-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:16
-- Source: Subreport [TEXT]
-- Table:  Transfer_Re_Text
-- ============================================================

SELECT [LineText]
FROM WTR10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = {?lineNum@}
ORDER BY [LineSeq] ASC

