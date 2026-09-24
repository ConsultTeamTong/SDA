-- ============================================================
-- Report: 1.Retrun_ใบรับคืนสินค้า_ENG (Batch_Serial).rpt
-- Path:   1.Retrun_ใบรับคืนสินค้า_ENG (Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:29
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT 
    OHEM.middleName AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ORDN  
LEFT JOIN OHEM ON ORDN  ."U_SLD_Empname" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORDN  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '16'


UNION ALL


SELECT 
    OHEM.middleName  AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM ODRF ORDN
LEFT JOIN OHEM ON ORDN  ."U_SLD_Empname" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE ORDN  ."DocEntry" = {?Dockey@}
  AND {?ObjectId@} = '112' AND ORDN.ObjType = '16'

) T0
