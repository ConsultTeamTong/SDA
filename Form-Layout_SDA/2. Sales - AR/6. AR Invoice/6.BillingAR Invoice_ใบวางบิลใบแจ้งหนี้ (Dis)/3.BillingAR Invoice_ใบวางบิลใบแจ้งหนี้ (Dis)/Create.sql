-- ============================================================
-- Report: 3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Path:   3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Extracted: 2026-09-01 17:12:17
-- Source: Main Report
-- Table:  Create
-- ============================================================

SELECT T0.*
FROM (

SELECT picture 
FROM OINV 
LEFT JOIN OHEM ON OINV.UserSign = OHEM.userId
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '13'


UNION ALL


SELECT picture 
FROM ODRF OINV
LEFT JOIN OHEM ON OINV.UserSign = OHEM.userId
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OINV.ObjType = '13'

) T0
