-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
-- Path:   1.Outgoing Payments_ใบจ่ายชำระ.rpt
-- Extracted: 2026-09-24 10:20:22
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP.BitmapPath, SDAWRAP.picture) AS "Path"
FROM (
    SELECT OHEM.picture,
           CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
    FROM OVPM
    LEFT JOIN OUSR ON OVPM.UserSign = OUSR.USERID
    LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
    WHERE OVPM.DocEntry = {?DocKey@}
) SDAWRAP
CROSS JOIN OADP
