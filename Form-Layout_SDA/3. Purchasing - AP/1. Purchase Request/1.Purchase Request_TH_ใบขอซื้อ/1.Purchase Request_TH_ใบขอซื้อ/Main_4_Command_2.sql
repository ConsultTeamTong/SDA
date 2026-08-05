-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   3. Purchasing - AP\1. Purchase Request\1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-04-09 15:22:43
-- Source: Main Report
-- Table:  Command_2
-- ============================================================

SELECT picture,
OPRQ.DocEntry
FROM OPRQ
LEFT JOIN OHEM ON OPRQ.UserSign = OHEM.userId
WHERE OPRQ.DocEntry  = {?DocEntry@}
