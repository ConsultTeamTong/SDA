-- ============================================================
-- Report: 1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต_(Batch_Serial).rpt
-- Path:   1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:18
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path",
    WDD1."UpdateDate" AS "ApproveDate"
FROM OIGE
LEFT JOIN OWDD ON OIGE."DocEntry" = OWDD."DocEntry"
             AND OWDD."ObjType" = '60'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode"
             AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OIGE."DocEntry" = {?DocKey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
