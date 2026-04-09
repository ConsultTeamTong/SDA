-- ============================================================
-- Report: 1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต.rpt
Path:   6. Production\3. Issue for Production\1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต.rpt
Extracted: 2026-04-09 15:22:54
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT Distinct
OIGE.[DocEntry],
(IGE1.[VisOrder]+1) as 'No.'
,CAST(IGE10.[LineText] as NVARCHAR(2000)) as 'Text'
,IGE10.OrderNum

FROM OIGE 
LEFT JOIN IGE1 ON OIGE.[DocEntry] = IGE1.[DocEntry]
LEFT JOIN IGE10 ON OIGE.[DocEntry] = IGE10.[DocEntry] AND IGE1.[VisOrder] = IGE10.AftLineNum

Order By IGE10.OrderNum
