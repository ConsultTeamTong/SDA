-- ============================================================
-- Report: 1.AP Down Payment_ใบจ่ายเงินมัดจำ.rpt
-- Path:   1.AP Down Payment_ใบจ่ายเงินมัดจำ.rpt
-- Extracted: 2026-09-24 10:19:53
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODPO
LEFT JOIN OHEM ON ODPO."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ODPO."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '204'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF ODPO
LEFT JOIN OHEM ON ODPO."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ODPO."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND ODPO.ObjType = '204'

) T0
