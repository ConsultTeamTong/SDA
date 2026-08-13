-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Extracted: 2026-08-05 14:09:14
-- Source: Subreport [Head_Remark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM (
    SELECT 
        [LineText], 
        [LineSeq]
    FROM QUT10
    WHERE [DocEntry] = '{?DocKey@}'
      AND [AftLineNum] = -1
      AND '{?ObjectId@}' = '23'

    UNION ALL

    SELECT 
        [LineText], 
        [LineSeq]
    FROM DRF10
    WHERE [DocEntry] = '{?DocKey@}'
      AND [AftLineNum] = -1
      AND '{?ObjectId@}' = '112'
) AS TextData
ORDER BY [LineSeq] ASC
