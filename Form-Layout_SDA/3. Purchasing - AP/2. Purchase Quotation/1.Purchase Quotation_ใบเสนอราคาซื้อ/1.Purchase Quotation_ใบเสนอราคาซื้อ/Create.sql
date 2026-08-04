-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-07-31 00:16:44
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
OHEM."picture",
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OPQT
LEFT JOIN OHEM ON OPQT."UserSign" = OHEM."userId"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OPQT."DocEntry" = {?Dockey@}
