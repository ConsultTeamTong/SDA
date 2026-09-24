-- ============================================================
-- Report: 1.Journal Entry_ใบบันทึกรายการบัญชี.rpt
-- Path:   1.Journal Entry_ใบบันทึกรายการบัญชี.rpt
-- Extracted: 2026-09-24 10:20:19
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path
FROM OJDT  
LEFT JOIN OHEM ON OJDT."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OJDT."TransId" = {?Dockey@}
