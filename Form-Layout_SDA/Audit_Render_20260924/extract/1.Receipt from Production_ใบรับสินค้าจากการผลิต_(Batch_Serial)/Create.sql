-- ============================================================
-- Report: 1.Receipt from Production_ใบรับสินค้าจากการผลิต_(Batch_Serial).rpt
-- Path:   1.Receipt from Production_ใบรับสินค้าจากการผลิต_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:27
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
