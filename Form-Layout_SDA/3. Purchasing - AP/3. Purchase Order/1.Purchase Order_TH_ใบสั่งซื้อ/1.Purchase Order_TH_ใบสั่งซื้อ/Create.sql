-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-09-01 18:40:48
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0."Name", T0."picture", T0."Path"
FROM (
    -- สำหรับใบสั่งซื้อปกติ (Purchase Order - Object Type = 22)
    SELECT 
        CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM OPOR
    LEFT JOIN OHEM ON OPOR."UserSign" = OHEM."userId"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE OPOR."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '22'

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT 
        CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM ODRF
    LEFT JOIN OHEM ON ODRF."UserSign" = OHEM."userId"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE ODRF."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '112'
      AND ODRF."ObjType" = '22' -- เช็คเพิ่มเติมว่าเป็น Draft ของใบสั่งซื้อ
) T0
