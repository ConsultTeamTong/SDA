-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
-- Path:   1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
-- Extracted: 2026-09-24 10:20:31
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT TOP 1 
   OHEM.middleName AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OQUT  
LEFT JOIN OWDD ON OQUT."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '23'
LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OQUT."DocEntry" = {?Dockey@}
ORDER BY
    WDD1."UpdateDate" DESC,
    WDD1."UpdateTime" DESC
