-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-08-05 18:29:45
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT
    TOP 1 PRQ10.LineText
FROM PRQ1
INNER JOIN PRQ10 ON PRQ1.[DocEntry] = PRQ10.[DocEntry] AND PRQ10.AftLineNum = {?lineNum@}
WHERE PRQ1.[DocEntry] = {?DocKey@}
