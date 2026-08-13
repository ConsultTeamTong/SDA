-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-08-05 18:27:23
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT
    TOP 1 PQT10.LineText
FROM PQT1
INNER JOIN PQT10 ON PQT1.[DocEntry] = PQT10.[DocEntry] AND PQT10.AftLineNum = {?lineNum@}
WHERE PQT1.[DocEntry] = {?DocKey@}

