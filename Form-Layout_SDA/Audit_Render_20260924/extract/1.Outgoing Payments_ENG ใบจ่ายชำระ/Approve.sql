-- ============================================================
-- Report: 1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Path:   1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Extracted: 2026-09-24 10:20:21
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."ApproverPicture") AS "Path"
FROM (
SELECT TOP 1 
    OVPM.DocEntry,
    OVPM.DocNum,
    --OVPM.DocStatus          AS 'DocStatus',
    WDD1.UserID             AS 'ApproverUserID',
    OUSR.U_NAME             AS 'ApproverUserName',
    OHEM.empID,
    OHEM.middleName          AS 'ApproverFirstName',
    ''           AS 'ApproverLastName',
    OHEM.picture            AS 'ApproverPicture',
    CASE WDD1.Status
        WHEN 'Y' THEN 'Approved'
        WHEN 'N' THEN 'Rejected'
        WHEN 'W' THEN 'Waiting'
        ELSE 'No Workflow'
    END                     AS 'ApprovalStatus',
    WDD1.UpdateDate         AS 'ApprovalDate'
FROM OVPM
LEFT JOIN OWDD ON OVPM.DocEntry = OWDD.DocEntry 
             AND OWDD.ObjType   = '46'              -- Outgoing Payments
LEFT JOIN WDD1 ON OWDD.WddCode  = WDD1.WddCode 
             AND WDD1.Status    = 'Y'
LEFT JOIN OUSR ON WDD1.UserID   = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID   = OHEM.userId
WHERE OVPM.DocEntry = {?DocKey@}
ORDER BY
    WDD1.UpdateDate DESC,
    WDD1.UpdateTime DESC
) SDAWRAP
CROSS JOIN OADP
