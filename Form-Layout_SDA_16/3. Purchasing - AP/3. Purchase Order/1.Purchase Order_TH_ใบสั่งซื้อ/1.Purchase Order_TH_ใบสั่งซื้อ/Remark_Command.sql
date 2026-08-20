-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-07-31 00:18:21
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT
    TOP 1 POR10.LineText
FROM POR1
INNER JOIN POR10 ON POR1.[DocEntry] = POR10.[DocEntry] AND POR10.AftLineNum = {?lineNum@}
WHERE POR1.[DocEntry] = {?DocKey@}

