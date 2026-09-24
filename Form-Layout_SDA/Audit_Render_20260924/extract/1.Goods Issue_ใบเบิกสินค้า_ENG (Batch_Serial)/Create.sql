-- ============================================================
-- Report: 1.Goods Issue_ใบเบิกสินค้า_ENG (Batch_Serial).rpt
-- Path:   1.Goods Issue_ใบเบิกสินค้า_ENG (Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:08
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM OIGE
LEFT JOIN OHEM ON OIGE."UserSign" = OHEM."userId"
CROSS JOIN OADP
WHERE OIGE."DocEntry" = {?DocKey@}
