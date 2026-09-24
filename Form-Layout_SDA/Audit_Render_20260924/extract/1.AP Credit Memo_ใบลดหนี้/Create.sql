-- ============================================================
-- Report: 1.AP Credit Memo_ใบลดหนี้.rpt
-- Path:   1.AP Credit Memo_ใบลดหนี้.rpt
-- Extracted: 2026-09-24 10:19:50
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ORPC
LEFT JOIN OHEM ON ORPC."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORPC."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '19'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF ORPC
LEFT JOIN OHEM ON ORPC."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORPC."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND ORPC.ObjType = '19'

) T0
