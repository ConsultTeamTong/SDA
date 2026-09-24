-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Extracted: 2026-09-24 10:20:27
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OPRQ  
LEFT JOIN OWDD ON OPRQ."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '1470000113'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OPRQ."DocEntry" = {?Dockey@}
ORDER BY ApproveDate DESC
