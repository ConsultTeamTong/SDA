-- ============================================================
-- Report: 1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Path:   1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Extracted: 2026-09-03 10:51:40
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPCH
LEFT JOIN OHEM ON OPCH."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPCH."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '18'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF OPCH
LEFT JOIN OHEM ON OPCH."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPCH."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND OPCH.ObjType = '18'

) T0
