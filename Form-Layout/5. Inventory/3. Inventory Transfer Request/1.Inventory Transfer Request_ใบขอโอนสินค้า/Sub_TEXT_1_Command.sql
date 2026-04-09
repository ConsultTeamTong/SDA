-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Path:   5. Inventory\3. Inventory Transfer Request\1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Extracted: 2026-04-09 15:22:50
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT Distinct 
OWTQ.DocEntry,
(WTQ1.VisOrder+1) as 'No.',
cast(WTQ10.LineText as NVARCHAR(200)) as 'Text',
WTQ10.OrderNum,
WTQ1.ItemCode


FROM OWTQ  
LEFT JOIN WTQ1 ON OWTQ.DocEntry = WTQ1.DocEntry 
LEFT JOIN WTQ10 ON OWTQ.Docentry = WTQ10.DocEntry AND WTQ1.VisOrder = WTQ10.AftLineNum

Order By WTQ10.ordernum
