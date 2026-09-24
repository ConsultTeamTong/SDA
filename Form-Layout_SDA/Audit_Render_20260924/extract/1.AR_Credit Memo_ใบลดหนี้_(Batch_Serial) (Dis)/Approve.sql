-- ============================================================
-- Report: 1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Path:   1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Extracted: 2026-09-24 10:20:03
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."ApproverPicture") AS "Path"
FROM (
SELECT TOP 1 
    ORIN.DocEntry,
    ORIN.DocNum,
    ORIN.DocStatus          AS 'DocStatus',
    WDD1.UserID             AS 'ApproverUserID',
    OUSR.U_NAME             AS 'ApproverUserName',
    OHEM.empID,
    OHEM.firstName          AS 'ApproverFirstName',
    OHEM.lastName           AS 'ApproverLastName',
    OHEM.picture            AS 'ApproverPicture',
    CASE WDD1.Status
        WHEN 'Y' THEN 'Approved'
        WHEN 'N' THEN 'Rejected'
        WHEN 'W' THEN 'Waiting'
        ELSE 'No Workflow'
    END                     AS 'ApprovalStatus',
    WDD1.UpdateDate         AS 'ApprovalDate'
FROM ORIN
LEFT JOIN OWDD ON ORIN.DocEntry = OWDD.DocEntry 
             AND OWDD.ObjType   = '14'              -- A/R Credit Memo
LEFT JOIN WDD1 ON OWDD.WddCode  = WDD1.WddCode 
             AND WDD1.Status    = 'Y'
LEFT JOIN OUSR ON WDD1.UserID   = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID   = OHEM.userId
WHERE ORIN.DocEntry = {?DocKey@}
ORDER BY
    WDD1.UpdateDate DESC,
    WDD1.UpdateTime DESC
) SDAWRAP
CROSS JOIN OADP
