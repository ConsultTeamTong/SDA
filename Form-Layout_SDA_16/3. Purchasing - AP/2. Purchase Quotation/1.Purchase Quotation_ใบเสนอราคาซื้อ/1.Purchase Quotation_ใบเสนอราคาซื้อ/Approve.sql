-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-08-05 18:27:23
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT 
    OPQT.DocEntry,
    OPQT.DocNum,
    OPQT.DocStatus          AS 'DocStatus',
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
FROM OPQT
LEFT JOIN OWDD ON OPQT.DocEntry = OWDD.DocEntry 
             AND OWDD.ObjType   = '540000006'       -- Purchase Quotation
LEFT JOIN WDD1 ON OWDD.WddCode  = WDD1.WddCode 
             AND WDD1.Status    = 'Y'
LEFT JOIN OUSR ON WDD1.UserID   = OUSR.USERID
LEFT JOIN OHEM ON WDD1.UserID   = OHEM.userId
WHERE OPQT.DocEntry = {?DocKey@}
