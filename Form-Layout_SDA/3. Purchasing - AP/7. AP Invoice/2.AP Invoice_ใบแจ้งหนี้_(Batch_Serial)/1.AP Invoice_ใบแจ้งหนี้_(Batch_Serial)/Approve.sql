-- ============================================================
-- Report: 1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Path:   1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Extracted: 2026-09-03 10:51:40
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1 
    OPCH.DocEntry,
    OPCH.DocNum,
    OPCH.DocStatus          AS 'DocStatus',
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
FROM OPCH
LEFT JOIN OWDD ON OPCH.DocEntry = OWDD.DocEntry 
             AND OWDD.ObjType   = '18'              -- A/P Invoice
LEFT JOIN WDD1 ON OWDD.WddCode  = WDD1.WddCode 
             AND WDD1.Status    = 'Y'
LEFT JOIN OUSR ON WDD1.UserID   = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID   = OHEM.userId
WHERE OPCH.DocEntry = {?DocKey@}
ORDER BY
    WDD1.UpdateDate DESC,
    WDD1.UpdateTime DESC
