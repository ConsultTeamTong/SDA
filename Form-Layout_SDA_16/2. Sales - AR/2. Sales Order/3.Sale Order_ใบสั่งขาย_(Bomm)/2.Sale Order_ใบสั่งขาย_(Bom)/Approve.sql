-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
Path:   3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
Extracted: 2026-08-05 14:18:16
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApprovalDate"
FROM ORDR  
INNER JOIN OWDD ON ORDR."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '17'
INNER JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE ORDR."DocEntry" = {?Dockey@}
