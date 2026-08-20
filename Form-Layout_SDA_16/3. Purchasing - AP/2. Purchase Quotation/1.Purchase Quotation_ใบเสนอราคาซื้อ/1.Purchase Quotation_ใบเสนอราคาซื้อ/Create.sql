-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
Extracted: 2026-08-05 18:27:23
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
