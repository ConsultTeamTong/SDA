-- ============================================================
-- Report: 1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:11
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPDN
LEFT JOIN OHEM ON OPDN."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPDN."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '20'


UNION ALL


SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF OPDN
LEFT JOIN OHEM ON OPDN."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPDN."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND OPDN.ObjType = '20'

) T0
