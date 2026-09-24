-- ============================================================
-- Report: 1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:12
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM ORPD
LEFT JOIN OHEM ON ORPD."UserSign" = OHEM."userId"
CROSS JOIN OADP
WHERE ORPD."DocEntry" = {?DocKey@}
