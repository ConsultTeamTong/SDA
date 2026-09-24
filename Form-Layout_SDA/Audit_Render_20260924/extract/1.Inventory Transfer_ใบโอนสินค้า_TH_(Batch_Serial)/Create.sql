-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial).rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:17
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OWTR  
LEFT JOIN OHEM ON OWTR  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OWTR  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '67'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF OWTR
LEFT JOIN OHEM ON OWTR  ."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OWTR  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND OWTR.ObjType = '67'

) T0
