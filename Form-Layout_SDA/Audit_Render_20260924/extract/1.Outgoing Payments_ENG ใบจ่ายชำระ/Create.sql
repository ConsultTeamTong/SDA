-- ============================================================
-- Report: 1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Path:   1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Extracted: 2026-09-24 10:20:21
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    OHEM."middleName" AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OVPM  
LEFT JOIN OHEM ON OVPM  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OVPM  ."DocEntry" = {?Dockey@}

