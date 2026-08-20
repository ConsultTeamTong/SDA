-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-07-31 00:18:21
-- Source: Subreport [Hremark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM POR10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = -1
ORDER BY [LineSeq] ASC

