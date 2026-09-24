-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
-- Path:   1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:15
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP.BitmapPath, SDAWRAP.picture) AS "Path"
FROM (
    SELECT T0.*
    FROM (
        SELECT OHEM.picture,
               CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
        FROM OWTQ
        LEFT JOIN OUSR ON OWTQ.UserSign = OUSR.USERID
        LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
        WHERE OWTQ.DocEntry = {?dockey@} AND {?ObjectId@} = '1250000001'
        UNION ALL
        SELECT OHEM.picture,
               CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
        FROM ODRF OWTQ
        LEFT JOIN OUSR ON OWTQ.UserSign = OUSR.USERID
        LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
        WHERE OWTQ.DocEntry = {?dockey@} AND {?ObjectId@} = '112' AND OWTQ.ObjType = '1250000001'
    ) T0
) SDAWRAP
CROSS JOIN OADP
