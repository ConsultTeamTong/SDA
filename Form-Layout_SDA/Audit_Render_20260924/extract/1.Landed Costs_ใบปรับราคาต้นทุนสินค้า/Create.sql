-- ============================================================
-- Report: 1.Landed Costs_ใบปรับราคาต้นทุนสินค้า.rpt
-- Path:   1.Landed Costs_ใบปรับราคาต้นทุนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:20
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM OIPF
LEFT JOIN OHEM ON OIPF."UserSign" = OHEM."userId"
CROSS JOIN OADP
WHERE OIPF."DocEntry" = {?DocKey@}
