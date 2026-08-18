-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Extracted: 2026-08-17 11:43:03
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0."Name", T0."picture", T0."Path"
FROM (
    -- สำหรับใบเสนอราคาปกติ (Object Type = 23)
    SELECT 
        OHEM.middleName AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM OQUT  
    LEFT JOIN OHEM ON OQUT."SlpCode" = OHEM."salesPrson"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE OQUT."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '23'

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT 
        OHEM.middleName AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM ODRF  
    LEFT JOIN OHEM ON ODRF."SlpCode" = OHEM."salesPrson"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE ODRF."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '112'
      AND ODRF."ObjType" = '23' -- เช็คเพิ่มเติมว่าเป็น Draft ของใบเสนอราคา
) T0
