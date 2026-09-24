-- ============================================================
-- Report: 1.Production Order_ใบสั่งผลิต.rpt
-- Path:   1.Production Order_ใบสั่งผลิต.rpt
-- Extracted: 2026-09-24 10:20:24
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM OWOR
LEFT JOIN OHEM ON OWOR."UserSign" = OHEM."userId"
CROSS JOIN OADP
WHERE OWOR."DocEntry" = {?DocKey@}
