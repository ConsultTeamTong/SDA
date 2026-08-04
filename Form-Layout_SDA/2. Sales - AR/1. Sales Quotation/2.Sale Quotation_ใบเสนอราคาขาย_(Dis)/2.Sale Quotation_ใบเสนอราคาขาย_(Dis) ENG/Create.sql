-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Extracted: 2026-07-30 23:56:38
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT 
    OHEM.middleName AS "Name",
	OHEM."picture",
    CONCAT(OADP."BitmapPath",OHEM."picture") As Path
FROM OQUT  
LEFT JOIN OHEM ON OQUT  ."SlpCode" = OHEM."salesPrson"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OQUT  ."DocEntry" = {?Dockey@}

