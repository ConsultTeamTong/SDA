-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
-- Path:   1.Outgoing Payments_ใบจ่ายชำระ.rpt
-- Extracted: 2026-09-24 10:20:22
-- Source: Subreport [Report]
-- Table:  Command
-- ============================================================

SELECT 
    T2.InvType,
    T2.DocNum as DocNum,
    
    COALESCE(T3_PCH.DocDate, T3_DPO.DocDate, T3_RPC.DocDate, T3_JDT.RefDate) AS DocDate,
    COALESCE(T3_PCH.NumAtCard, T3_DPO.NumAtCard, T3_RPC.NumAtCard, T3_JDT.Ref2) AS NumAtCard,
    
    Project = CASE
        WHEN T2.InvType = 18 THEN (SELECT TOP 1 Project FROM PCH1 WHERE DocEntry = T2.DocEntry AND ISNULL(Project, '') <> '')
        WHEN T2.InvType = 204 THEN (SELECT TOP 1 Project FROM DPO1 WHERE DocEntry = T2.DocEntry AND ISNULL(Project, '') <> '')
        WHEN T2.InvType = 19 THEN (SELECT TOP 1 Project FROM RPC1 WHERE DocEntry = T2.DocEntry AND ISNULL(Project, '') <> '')
        WHEN T2.InvType IN (46, 30) THEN (SELECT TOP 1 Project FROM JDT1 WHERE TransId = T2.DocTransId AND ISNULL(Project, '') <> '')
        ELSE NULL
    END,

    Amount = CASE 
        WHEN T2.InvType = 19 THEN 
            CASE WHEN T2.[AppliedFC] = 0 THEN T2.[SumApplied] * -1 ELSE T2.[AppliedFC] * -1 END
        WHEN T2.InvType IN (46, 30) THEN 
            T2.AppliedSys
        ELSE 
            CASE WHEN T2.[AppliedFC] = 0 THEN T2.[SumApplied] ELSE T2.[AppliedFC] END
    END,

    AmountTax = CASE 
        WHEN T2.InvType = 19 THEN 
            CASE WHEN T2.[AppliedFC] = 0 THEN (T2.[SumApplied] + T2.[WtAppld]) * -1 ELSE (T2.[AppliedFC] + T2.[WtAppldFC]) * -1 END
        ELSE 
            CASE WHEN T2.[AppliedFC] = 0 THEN (T2.[SumApplied] + T2.[WtAppld]) ELSE (T2.[AppliedFC] + T2.[WtAppldFC]) END
    END,

    T2.DocTransId,
    COALESCE(T3_PCH.DocNum, T3_DPO.DocNum, T3_RPC.DocNum, T3_JDT.Number) as DocNumINV,
    T2.InvoiceId  

FROM VPM2 T2 
LEFT JOIN ODPO T3_DPO ON T2.InvType = 204 AND T2.DocEntry = T3_DPO.docEntry 
LEFT JOIN OPCH T3_PCH ON T2.InvType = 18 AND T2.DocEntry = T3_PCH.docEntry 
LEFT JOIN ORPC T3_RPC ON T2.InvType = 19 AND T2.DocEntry = T3_RPC.docEntry 
LEFT JOIN OJDT T3_JDT ON T2.InvType IN (46, 30) AND T2.DocTransId = T3_JDT.TransId 
LEFT JOIN OVPM T5 ON T2.InvType IN (46, 30) AND T5.TransId = T2.DocEntry

WHERE T2.InvType IN (18, 19, 204, 30, 46)

ORDER BY T2.InvoiceId
