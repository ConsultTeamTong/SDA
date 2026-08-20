-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-08-05 18:29:45
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPRQ
LEFT JOIN OHEM ON OPRQ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPRQ."DocEntry" = {?Dockey@}
