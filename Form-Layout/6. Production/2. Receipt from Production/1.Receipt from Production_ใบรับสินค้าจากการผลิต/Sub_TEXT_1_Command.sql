-- ============================================================
-- Report: 1.Receipt from Production_ใบรับสินค้าจากการผลิต.rpt
Path:   6. Production\2. Receipt from Production\1.Receipt from Production_ใบรับสินค้าจากการผลิต.rpt
Extracted: 2026-04-09 15:22:53
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT Distinct
OIGN.[DocEntry],
(IGN1.[VisOrder]+1) as 'No.'
,CAST(IGN10.[LineText] as NVARCHAR(2000)) as 'Text'
,IGN10.OrderNum

FROM OIGN 
LEFT JOIN IGN1 ON OIGN.[DocEntry] = IGN1.[DocEntry]
LEFT JOIN IGN10 ON OIGN.[DocEntry] = IGN10.[DocEntry] AND IGN1.[VisOrder] = IGN10.AftLineNum

Order By IGN10.OrderNum
