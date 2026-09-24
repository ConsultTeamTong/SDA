-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
-- Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
-- Extracted: 2026-09-24 10:20:25
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OPOR  
LEFT JOIN OWDD ON OPOR."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '22'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OPOR."DocEntry" = {?Dockey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
