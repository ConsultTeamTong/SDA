-- ============================================================
-- Report: 1.AR Invoice_ใบแจ้งหนี้_(Dis).rpt
-- Path:   1.AR Invoice_ใบแจ้งหนี้_(Dis).rpt
-- Extracted: 2026-09-24 10:20:02
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT SDAWRAP.*, CONCAT(OADP."BitmapPath", SDAWRAP."ApproverPicture") AS "Path"
FROM (
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
) SDAWRAP
CROSS JOIN OADP
