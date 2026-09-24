-- ============================================================
-- Report: 2.BillingAR InvoiceTax Invoice_ใบวางบิลใบแจ้งหนี้ใบกำกับภาษี (Bom).rpt
-- Path:   2.BillingAR InvoiceTax Invoice_ใบวางบิลใบแจ้งหนี้ใบกำกับภาษี (Bom).rpt
-- Extracted: 2026-09-24 10:20:40
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP.BitmapPath, SDAWRAP.picture) AS "Path"
FROM (
    SELECT T0.*
    FROM (
        SELECT OHEM.picture,
               CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
        FROM OINV
        LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
        LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
        WHERE OINV.DocEntry = {?DocKey@} AND {?ObjectId@} = '13'
        UNION ALL
        SELECT OHEM.picture,
               CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
        FROM ODRF OINV
        LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
        LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
        WHERE OINV.DocEntry = {?DocKey@} AND {?ObjectId@} = '112' AND OINV.ObjType = '13'
    ) T0
) SDAWRAP
CROSS JOIN OADP
