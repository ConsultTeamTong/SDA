-- ============================================================
-- Report: 2.Goods Receive PO_TH_ใบรับสินค้า_(Batch_Serial) - Copy.rpt
Path:   3. Purchasing - AP\4. Goods Receipt PO\2.Goods Receive PO_TH_ใบรับสินค้า_(Batch_Serial) - Copy.rpt
Extracted: 2026-04-09 15:22:44
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT DISTINCT 
OPDN.DocEntry,
(PDN1.VisOrder+1) AS 'No.',
CAST(PDN10.LineText AS NVARCHAR(200)) AS 'Text',
PDN10.OrderNum

FROM OPDN 
LEFT JOIN PDN1 ON OPDN.DocEntry = PDN1.DocEntry 
LEFT JOIN PDN10 ON OPDN.Docentry = PDN10.DocEntry AND PDN1.VisOrder = PDN10.AftLineNum

ORDER BY PDN10.OrderNum
