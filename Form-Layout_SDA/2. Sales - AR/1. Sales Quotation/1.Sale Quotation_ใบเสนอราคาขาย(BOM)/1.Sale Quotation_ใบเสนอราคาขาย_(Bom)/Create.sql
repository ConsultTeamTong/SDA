-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Path:   1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Extracted: 2026-08-05 14:09:13
-- Source: Main Report
-- Table:  Create
-- ============================================================

-- ========================================================
-- 🟢 ส่วนที่ 1: สำหรับใบเสนอราคาปกติ (OQUT) - ObjectId = '23'
-- ========================================================
SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM OQUT  
LEFT JOIN OHEM ON OQUT."SlpCode" = OHEM."salesPrson"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
WHERE OQUT."DocEntry" = '{?Dockey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ========================================================
-- 🟢 ส่วนที่ 2: สำหรับเอกสารร่าง Draft (ODRF) - ObjectId = '112'
-- ========================================================
SELECT 
    CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
    OHEM."picture",
    CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
FROM ODRF  
LEFT JOIN OHEM ON ODRF."SlpCode" = OHEM."salesPrson"
INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
CROSS JOIN OADP
-- เช็คว่าเป็น Draft (112) และเป็น Draft ของใบเสนอราคา (ObjType = 23)
WHERE ODRF."DocEntry" = '{?Dockey@}' AND '{?ObjectId@}' = '112' AND ODRF."ObjType" = '23'
