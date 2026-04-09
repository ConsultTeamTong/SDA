-- ============================================================
-- Report: 2.Goods Return_EN_ใบส่งคืนสินค้า_(Batch_Serial).rpt
Path:   3. Purchasing - AP\5. Goods Return\2.Goods Return_EN_ใบส่งคืนสินค้า_(Batch_Serial).rpt
Extracted: 2026-04-09 15:22:44
-- Source: Subreport [TEXT]
-- Table:  Command
-- ============================================================

SELECT DISTINCT
ORPD.DocEntry,
(RPD1.VisOrder+1) AS 'No.',
CAST(RPD10.LineText AS NVARCHAR(200)) AS 'Text', 
RPD10.OrderNum


FROM ORPD  
LEFT JOIN RPD1 ON ORPD.DocEntry = RPD1.DocEntry 
LEFT JOIN RPD10 ON ORPD.Docentry = RPD10.DocEntry AND RPD1.VisOrder = RPD10.AftLineNum

ORDER BY RPD10.OrderNum
