-- ============================================================
-- Report: 1.Goods Receipt_ENG ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Receipt_ENG ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:09
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM OIGN
LEFT JOIN OHEM ON OIGN."UserSign" = OHEM."userId"
CROSS JOIN OADP
WHERE OIGN."DocEntry" = {?Dockey@}
