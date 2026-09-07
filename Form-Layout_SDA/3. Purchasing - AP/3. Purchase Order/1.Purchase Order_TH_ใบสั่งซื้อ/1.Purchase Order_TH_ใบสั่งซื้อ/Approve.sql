-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-09-01 18:40:48
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OPOR  
INNER JOIN OWDD ON OPOR."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '22'
INNER JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OPOR."DocEntry" = {?Dockey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
