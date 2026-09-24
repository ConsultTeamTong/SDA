-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Path:   2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Extracted: 2026-09-24 10:20:44
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0."Name", T0."picture", T0."Path"
FROM (
    -- สำหรับใบสั่งขายปกติ (Sales Order - Object Type = 17)
    SELECT 
        CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM ORDR  
    LEFT JOIN OHEM ON ORDR."SlpCode" = OHEM."salesPrson"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE ORDR."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '17'

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT 
        CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM ODRF  
    LEFT JOIN OHEM ON ODRF."SlpCode" = OHEM."salesPrson"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE ODRF."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '112'
      AND ODRF."ObjType" = '17' -- เช็คเพิ่มเติมว่าเป็น Draft ของใบสั่งขาย
) T0
