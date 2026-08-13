-- ============================================================
-- Report: 1.Sale Order_ใบสั่งขาย_(Dis).rpt
Path:   1.Sale Order_ใบสั่งขาย_(Dis)\1.Sale Order_ใบสั่งขาย_(Dis).rpt
Extracted: 2026-08-05 14:18:16
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT T0.[LineText] 
FROM (
    -- สำหรับใบสั่งขายปกติ (Sales Order - Object Type = 17)
    SELECT [LineText], [LineSeq]
    FROM RDR10
    WHERE [DocEntry] = {?DocKey@} 
      AND {?ObjectId@} = '17'
      AND [AftLineNum] = {?lineNum@}

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT [LineText], [LineSeq]
    FROM DRF10
    WHERE [DocEntry] = {?DocKey@} 
      AND {?ObjectId@} = '112'
      AND [AftLineNum] = {?lineNum@}
) T0
ORDER BY T0.[LineSeq] ASC
