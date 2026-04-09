-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   3. Purchasing - AP\1. Purchase Request\1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-04-09 15:22:43
-- Source: Subreport [TEXT]
-- Table:  คำสั่ง
-- ============================================================

SELECT 
OPRQ.DocEntry,
(PRQ1.VisOrder+1) AS 'No.',
CAST(PRQ10.LineText AS NVARCHAR(200)) AS 'Text', 
PRQ10.OrderNum

FROM OPRQ  
LEFT JOIN PRQ1 ON OPRQ.DocEntry = PRQ1.DocEntry 
LEFT JOIN NNM1 ON OPRQ.Series = NNM1.Series 
LEFT JOIN OUDP ON OPRQ.Department = OUDP.Code 
LEFT JOIN OHEM ON OPRQ.Requester = OHEM.empID 
LEFT JOIN OHPS ON OHEM.position = OHPS.posID
LEFT JOIN OBPL ON OPRQ.BPLId = OBPL.BPLId
LEFT JOIN OITM ON PRQ1.ItemCode = OITM.ItemCode
LEFT JOIN OWHS ON PRQ1.WhsCode = OWHS.WhsCode
LEFT JOIN OITW ON PRQ1.ItemCode = OITW.ItemCode AND (OITW.WhsCode = 'AM-A' OR OITW.WhsCode = 'AM-B' 
		  OR OITW.WhsCode = 'AM-OV' OR OITW.WhsCode = 'Main OF'OR OITW.WhsCode = 'P5-A' OR OITW.WhsCode = 'P5-AO' 
		  OR OITW.WhsCode = 'P5-BM' OR OITW.WhsCode = 'P5-BO' OR OITW.WhsCode = 'P5-RD')
LEFT JOIN PRQ10 ON OPRQ.DocEntry = PRQ10.DocEntry AND PRQ1.VisOrder = PRQ10.AftLineNum

ORDER BY PRQ10.ordernum

