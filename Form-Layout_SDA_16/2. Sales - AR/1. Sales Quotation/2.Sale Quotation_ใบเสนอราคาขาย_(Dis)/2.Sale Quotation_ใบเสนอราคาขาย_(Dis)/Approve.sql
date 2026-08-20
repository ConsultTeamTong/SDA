-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Extracted: 2026-08-17 11:43:03
-- Source: Main Report
-- Table:  Approve
-- ============================================================

SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") As Path,
    WDD1."UpdateDate" AS "ApproveDate"
FROM OQUT  
INNER JOIN OWDD ON OQUT."DocEntry" = OWDD."DocEntry" AND OWDD."ObjType" = '23'
INNER JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y'
LEFT JOIN OHEM ON WDD1."UserID" = OHEM."userId"
CROSS JOIN OADP
WHERE OQUT."DocEntry" = {?Dockey@}
