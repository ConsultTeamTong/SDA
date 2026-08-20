-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Extracted: 2026-08-17 11:43:03
-- Source: Subreport [Remark]
-- Table:  Command
-- ============================================================

SELECT [LineText]
FROM (
    SELECT 
        [LineText], 
        [LineSeq]
    FROM QUT10
    WHERE [DocEntry] = '{?DocKey@}'
      AND [AftLineNum] = '{?lineNum@}'
      AND '{?ObjectId@}' = '23'

    UNION ALL

    SELECT 
        [LineText], 
        [LineSeq]
    FROM DRF10
    WHERE [DocEntry] = '{?DocKey@}'
      AND [AftLineNum] = '{?lineNum@}'
      AND '{?ObjectId@}' = '112'
) AS TextData
ORDER BY [LineSeq] ASC
