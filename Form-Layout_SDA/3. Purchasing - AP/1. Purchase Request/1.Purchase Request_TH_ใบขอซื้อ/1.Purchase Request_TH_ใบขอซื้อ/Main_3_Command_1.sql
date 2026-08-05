-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   3. Purchasing - AP\1. Purchase Request\1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-04-09 15:22:43
-- Source: Main Report
-- Table:  Command_1
-- ============================================================

SELECT OHEM.picture,
OPRQ.docentry
FROM OPRQ
        INNER JOIN OHEM ON OPRQ."UserSign" = OHEM."userId"
        INNER JOIN 
            (select  OWDD."WddCode" , WDD1."Status" , OWDD.DocEntry , OWDD."ObjType" 
                from OWDD 
                    LEFT JOIN WDD1 ON OWDD."WddCode" = WDD1."WddCode" AND WDD1."Status" = 'Y') T6 ON OPRQ."DocEntry" = T6."DocEntry" AND T6."ObjType" = '1470000113'
                    WHERE OPRQ.DocEntry = {?DocKey@}
