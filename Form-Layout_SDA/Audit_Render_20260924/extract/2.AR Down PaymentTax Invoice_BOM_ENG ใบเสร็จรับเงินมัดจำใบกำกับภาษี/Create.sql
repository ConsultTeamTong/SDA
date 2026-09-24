-- ============================================================
-- Report: 2.AR Down PaymentTax Invoice_BOM_ENG ใบเสร็จรับเงินมัดจำใบกำกับภาษี.rpt
-- Path:   2.AR Down PaymentTax Invoice_BOM_ENG ใบเสร็จรับเงินมัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:35
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."picture") AS "Path"
FROM (
SELECT T0.*
FROM (

SELECT 
OHEM.picture,
OHEM.middleName AS Name
FROM ODPI  
LEFT JOIN OHEM ON ODPI.UserSign = OHEM.userId
INNER JOIN OUSR ON OUSR.USERID = OHEM.userId 
WHERE ODPI.DocEntry  = {?Dockey@}
  AND {?ObjectId@} = '203'


UNION ALL


SELECT 
OHEM.picture,
OHEM.middleName AS Name
FROM ODRF ODPI
LEFT JOIN OHEM ON ODPI.UserSign = OHEM.userId
INNER JOIN OUSR ON OUSR.USERID = OHEM.userId 
WHERE ODPI.DocEntry  = {?Dockey@}
  AND {?ObjectId@} = '112' AND ODPI.ObjType = '203'

) T0
) SDAWRAP
CROSS JOIN OADP
