-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Path:   1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Extracted: 2026-08-17 11:43:02
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
