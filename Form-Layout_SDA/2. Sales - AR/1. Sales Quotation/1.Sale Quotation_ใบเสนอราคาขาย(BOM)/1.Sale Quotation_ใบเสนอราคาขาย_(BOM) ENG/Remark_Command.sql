-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
Path:   1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
Extracted: 2026-08-05 14:09:12
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT TOP 1 T0.[LineText]
FROM (
    -- สำหรับใบเสนอราคาปกติ (Object Type = 23)
    SELECT QUT10.[LineText]
    FROM QUT1
    INNER JOIN QUT10 ON QUT1.[DocEntry] = QUT10.[DocEntry] 
                    AND QUT10.[AftLineNum] = {?lineNum@}
    WHERE QUT1.[DocEntry] = {?DocKey@}
      AND {?ObjectId@} = '23'

    UNION ALL

    -- สำหรับเอกสาร Draft (Object Type = 112)
    SELECT DRF10.[LineText]
    FROM DRF1
    INNER JOIN DRF10 ON DRF1.[DocEntry] = DRF10.[DocEntry] 
                    AND DRF10.[AftLineNum] = {?lineNum@}
    WHERE DRF1.[DocEntry] = {?DocKey@}
      AND {?ObjectId@} = '112'
) T0
