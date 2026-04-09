-- ============================================================
-- Report: 5.DeliveryTax Invoice_ใบส่งของใบกำกับภาษี_(Batch_Serial).rpt
Path:   2. Sales - AR\6. AR Invoice\5.DeliveryTax Invoice_ใบส่งของใบกำกับภาษี_(Batch_Serial).rpt
Extracted: 2026-04-09 15:22:39
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT Distinct
T0.[DocEntry],
(T1.[VisOrder]+1) as 'No.'
,cast(T9.[LineText] as NVARCHAR(2000)) as 'Text'
,T9.OrderNum

FROM OINV T0
LEFT JOIN INV1 T1 ON T0.[DocEntry] = T1.[DocEntry]
LEFT JOIN INV10 T9 ON T0.[DocEntry] = T9.[DocEntry] AND T1.[VisOrder] = T9.AftLineNum

Order By T9.OrderNum

