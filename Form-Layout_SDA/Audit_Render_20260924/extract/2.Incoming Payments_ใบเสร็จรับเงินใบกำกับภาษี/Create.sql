-- ============================================================
-- Report: 2.Incoming Payments_ใบเสร็จรับเงินใบกำกับภาษี.rpt
-- Path:   2.Incoming Payments_ใบเสร็จรับเงินใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:42
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ORCT  
LEFT JOIN OHEM ON ORCT  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORCT  ."DocEntry" = {?Dockey@}


