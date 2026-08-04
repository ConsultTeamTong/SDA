-- ============================================================
-- Report: 1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Extracted: 2026-07-31 00:18:20
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    OHEM.middleName AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPOR
LEFT JOIN OHEM ON OPOR."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPOR."DocEntry" = {?Dockey@}
