-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Path:   5. Inventory\3. Inventory Transfer Request\1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Extracted: 2026-04-09 15:22:50
-- Source: Main Report
-- Table:  Command
-- ============================================================

SELECT 
OWTQ.Docentry,
OWTQ.DocNum, 
NNM1.BeginStr, 
OWTQ.DocDate, 
WTQ1.ItemCode, 
WTQ1.Dscription, 
WTQ1.FromWhsCod as 'L WH Fr', 
WTQ1.WhsCode as 'L WH To', 
WTQ1.Quantity, 
WTQ1.UomCode ,
OWTQ.Comments,
(WTQ1.VisOrder+1) as 'No',
WTQ1.Project

FROM OWTQ 
LEFT JOIN WTQ1 ON OWTQ.DocEntry = WTQ1.DocEntry 
LEFT JOIN OBPL ON OWTQ.BPLId = OBPL.BPLId 
LEFT JOIN NNM1 ON OWTQ.Series = NNM1.Series 

,OADM  , OADP

Where
OWTQ.DocEntry  = {?DocKey@}

ORDER BY WTQ1.VisOrder
