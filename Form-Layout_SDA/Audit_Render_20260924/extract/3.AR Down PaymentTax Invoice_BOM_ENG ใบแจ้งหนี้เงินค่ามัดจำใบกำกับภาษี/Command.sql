-- ============================================================
-- Report: 3.AR Down PaymentTax Invoice_BOM_ENG ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
-- Path:   3.AR Down PaymentTax Invoice_BOM_ENG ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:50
-- Source: Main Report
-- Table:  Command
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."ApproverPicture") AS "ApproverPath"
FROM (
SELECT TOP 1 T0.*
FROM (

SELECT 
    ODPI.DocEntry,
    ODPI.DocNum,
    WDD1.UserID            AS 'ApproverUserID',
    OUSR.U_NAME            AS 'ApproverUserName',
    OHEM.empID,
    OHEM.middleName AS 'ApproverName',
    OHEM.picture           AS 'ApproverPicture',
    WDD1.Status            AS 'ApprovalStatus',
    WDD1.UpdateDate        AS 'ApprovalDate',
    WDD1.UpdateTime        AS 'ApprovalTime'
FROM ODPI
INNER JOIN OWDD ON ODPI.DocEntry = OWDD.DocEntry 
              AND OWDD.ObjType  = '203'
INNER JOIN WDD1 ON OWDD.WddCode = WDD1.WddCode 
              AND WDD1.Status   = 'Y'
LEFT JOIN OUSR ON WDD1.UserID = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID = OHEM.userId 
WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '203'


UNION ALL


SELECT 
    ODPI.DocEntry,
    ODPI.DocNum,
    WDD1.UserID            AS 'ApproverUserID',
    OUSR.U_NAME            AS 'ApproverUserName',
    OHEM.empID,
    OHEM.middleName AS 'ApproverName',
    OHEM.picture           AS 'ApproverPicture',
    WDD1.Status            AS 'ApprovalStatus',
    WDD1.UpdateDate        AS 'ApprovalDate',
    WDD1.UpdateTime        AS 'ApprovalTime'
FROM ODRF ODPI
INNER JOIN OWDD ON ODPI.DocEntry = OWDD.DocEntry 
              AND OWDD.ObjType  = '203'
INNER JOIN WDD1 ON OWDD.WddCode = WDD1.WddCode 
              AND WDD1.Status   = 'Y'
LEFT JOIN OUSR ON WDD1.UserID = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID = OHEM.userId 
WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPI.ObjType = '203'

) T0
ORDER BY T0.ApprovalDate DESC, T0.ApprovalTime DESC
) SDAWRAP
CROSS JOIN OADP
