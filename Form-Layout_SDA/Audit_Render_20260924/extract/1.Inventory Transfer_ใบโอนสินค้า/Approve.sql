-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:16
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path",
    WDD1."UpdateDate" AS "ApproveDate"
FROM OIGN
LEFT JOIN OWDD ON OIGN."DocEntry" = OWDD."DocEntry"
             AND OWDD."ObjType" = '59'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode"
             AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OIGN."DocEntry" = {?Dockey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
