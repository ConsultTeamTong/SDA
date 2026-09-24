-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- Extracted: 2026-09-24 10:20:26
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
OHEM."picture",
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPQT
LEFT JOIN OHEM ON OPQT."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPQT."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '540000006'


UNION ALL


SELECT 
OHEM."picture",
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF OPQT
LEFT JOIN OHEM ON OPQT."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPQT."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND OPQT.ObjType = '540000006'

) T0
