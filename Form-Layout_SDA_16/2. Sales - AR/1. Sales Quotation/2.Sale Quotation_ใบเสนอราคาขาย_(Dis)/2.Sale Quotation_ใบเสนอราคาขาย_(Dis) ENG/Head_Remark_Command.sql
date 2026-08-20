-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Extracted: 2026-08-17 11:43:03
-- Source: Subreport [Head_Remark]
-- Table:  Command
-- ============================================================

SELECT T0.[LineText] 
FROM (
    -- สำหรับใบเสนอราคาปกติ (Object Type = 23)
    SELECT [LineText], [LineSeq]
    FROM QUT10
    WHERE [DocEntry] = {?DocKey@} 
      AND {?ObjectId@} = '23'
      AND [AftLineNum] = -1

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT [LineText], [LineSeq]
    FROM DRF10
    WHERE [DocEntry] = {?DocKey@} 
      AND {?ObjectId@} = '112'
      AND [AftLineNum] = -1
) T0
ORDER BY T0.[LineSeq] ASC
