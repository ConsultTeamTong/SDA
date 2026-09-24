-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Extracted: 2026-09-24 10:20:27
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0."Name", T0."picture", T0."Path"
FROM (
    -- สำหรับใบขอซื้อปกติ (Purchase Request - Object Type = 1470000113)
    SELECT 
        CONCAT(OHEM."firstName", CONCAT(' ', OHEM."lastName")) AS "Name",
        OHEM."picture",
        CONCAT(OADP."BitmapPath", OHEM."picture") AS "Path"
    FROM OPRQ  
    LEFT JOIN OHEM ON OPRQ."UserSign" = OHEM."userId"
    INNER JOIN OUSR ON OUSR."USERID" = OHEM."userId" 
    CROSS JOIN OADP
    WHERE OPRQ."DocEntry" = {?Dockey@}
      AND {?ObjectId@} = '1470000113'

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
      AND ODRF."ObjType" = '1470000113' -- เช็คเพิ่มเติมว่าเป็น Draft ของใบขอซื้อ
) T0
