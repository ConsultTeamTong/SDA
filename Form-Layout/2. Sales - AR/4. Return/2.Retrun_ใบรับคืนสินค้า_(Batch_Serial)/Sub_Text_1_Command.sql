-- ============================================================
-- Report: 2.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
Path:   2. Sales - AR\4. Return\2.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
Extracted: 2026-04-09 15:22:35
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

SELECT DISTINCT 
ORDN.[DocEntry],
(RDN1.[VisOrder]+1) As 'No.',
CAST(RDN10.[LineText] As NVARCHAR(2000)) As 'Text',
RDN10.OrderNum

FROM ORDN
LEFT JOIN RDN1 ON ORDN.[DocEntry] = RDN1.[DocEntry]
LEFT JOIN RDN10 ON ORDN.[DocEntry] = RDN10.[DocEntry] AND RDN1.[VisOrder] = RDN10.AftLineNum

ORDER BY RDN10.OrderNum
