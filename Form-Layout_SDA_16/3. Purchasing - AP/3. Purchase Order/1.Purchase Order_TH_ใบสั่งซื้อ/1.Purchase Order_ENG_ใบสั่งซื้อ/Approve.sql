-- ============================================================
-- Report: 1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Extracted: 2026-07-31 00:18:20
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT 
    OHEM.middleName AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OPOR  
INNER JOIN OWDD ON OPOR."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '22'
INNER JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OPOR."DocEntry" = {?Dockey@}
