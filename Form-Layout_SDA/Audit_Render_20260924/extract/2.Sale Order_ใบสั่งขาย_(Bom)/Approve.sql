-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Path:   2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Extracted: 2026-09-24 10:20:44
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1

    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM ORDR  
LEFT JOIN OWDD ON ORDR."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '17'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE ORDR."DocEntry" = {?Dockey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
