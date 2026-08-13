-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-08-05 18:27:23
-- Source: Subreport [Hremark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM PQT10
WHERE [DocEntry] = {?DocKey@}
  AND [AftLineNum] = -1
ORDER BY [LineSeq] ASC
