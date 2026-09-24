-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:16
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP.BitmapPath, SDAWRAP.picture) AS "Path"
FROM (
    SELECT OHEM.picture,
           CONCAT(OHEM.firstName, '  ', OHEM.lastName) AS Name
    FROM OWTR
    LEFT JOIN OUSR ON OWTR.UserSign = OUSR.USERID
    LEFT JOIN OHEM ON OUSR.USERID = OHEM.userId
    WHERE OWTR.DocEntry = {?dockey@}
) SDAWRAP
CROSS JOIN OADP
