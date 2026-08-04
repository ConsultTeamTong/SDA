-- ============================================================
-- Report: 1.Sale Order_ใบสั่งขาย_(Dis).rpt
Path:   1.Sale Order_ใบสั่งขาย_(Dis).rpt
Extracted: 2026-07-31 00:01:55
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ORDR  
LEFT JOIN OHEM ON ORDR  ."SlpCode" = OHEM."salesPrson"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORDR  ."DocEntry" = {?Dockey@}
