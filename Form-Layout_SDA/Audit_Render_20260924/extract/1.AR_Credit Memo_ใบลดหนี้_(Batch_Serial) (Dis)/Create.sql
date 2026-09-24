-- ============================================================
-- Report: 1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Path:   1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Extracted: 2026-09-24 10:20:03
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ORIN  
LEFT JOIN OHEM ON ORIN  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORIN  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '14'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF ORIN
LEFT JOIN OHEM ON ORIN  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORIN  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND ORIN.ObjType = '14'

) T0
