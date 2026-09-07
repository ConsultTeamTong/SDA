-- ============================================================
-- Report: 3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Path:   3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Extracted: 2026-09-01 17:12:17
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1 
    OINV.DocEntry,
    OINV.DocNum,
    OINV.DocStatus          AS 'DocStatus',
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
FROM OINV
LEFT JOIN OWDD ON OINV.DocEntry = OWDD.DocEntry 
             AND OWDD.ObjType   = '13'              -- A/R Invoice
LEFT JOIN WDD1 ON OWDD.WddCode  = WDD1.WddCode 
             AND WDD1.Status    = 'Y'
LEFT JOIN OUSR ON WDD1.UserID   = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID   = OHEM.userId
WHERE OINV.DocEntry = {?DocKey@}
ORDER BY
    WDD1.UpdateDate DESC,
    WDD1.UpdateTime DESC
