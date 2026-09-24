-- ============================================================
-- Report: 1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- Path:   1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:06
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path
FROM ODLN  
LEFT JOIN OHEM ON ODLN."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ODLN."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '15'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path
FROM ODRF ODLN
LEFT JOIN OHEM ON ODLN."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ODLN."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND ODLN.ObjType = '15'

) T0
