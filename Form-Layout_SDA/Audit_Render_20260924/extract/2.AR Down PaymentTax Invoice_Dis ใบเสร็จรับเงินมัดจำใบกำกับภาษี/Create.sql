-- ============================================================
-- Report: 2.AR Down PaymentTax Invoice_Dis ใบเสร็จรับเงินมัดจำใบกำกับภาษี.rpt
-- Path:   2.AR Down PaymentTax Invoice_Dis ใบเสร็จรับเงินมัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:36
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."picture") AS "Path"
FROM (
SELECT T0.*
FROM (

SELECT 
OHEM.picture,
CONCAT(OHEM.firstName,'  ' ,OHEM.lastName) AS Name
FROM ODPI  
LEFT JOIN OHEM ON ODPI.UserSign = OHEM.Code
INNER JOIN OUSR ON OUSR.USERID = OHEM.userId 
WHERE ODPI.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '203'


UNION ALL


SELECT 
OHEM.picture,
CONCAT(OHEM.firstName,'  ' ,OHEM.lastName) AS Name
FROM ODRF ODPI
LEFT JOIN OHEM ON ODPI.UserSign = OHEM.Code
INNER JOIN OUSR ON OUSR.USERID = OHEM.userId 
WHERE ODPI.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPI.ObjType = '203'

) T0
) SDAWRAP
CROSS JOIN OADP
