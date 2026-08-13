-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-08-05 18:29:45
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OPRQ  
INNER JOIN OWDD ON OPRQ."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '1470000113'
INNER JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OPRQ."DocEntry" = {?Dockey@}
