-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
Path:   3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
Extracted: 2026-08-05 14:18:16
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
