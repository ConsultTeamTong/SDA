-- ============================================================
-- Report: 1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Path:   1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Extracted: 2026-09-03 10:51:40
-- Source: Subreport [batch&sserial]
-- Table:  AP_INV_BN
-- ============================================================

SELECT
    OPCH.DocEntry,
    PCH1.ItemCode,
    OITM.InvntryUom,
    Serial.SQTY,
    Serial.SerialNum,
    Batch_N.BQTY,
    Batch_N.BatchNum AS 'BATCH',
    Batch_N.ReceiveDate AS 'Bdate',
    Batch_N.ExpDate AS 'Bexp'
FROM OPCH
LEFT JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry
LEFT JOIN OITM ON PCH1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPCH.PayToCode = CRD1.Address AND CRD1.AdresType = 'B')
LEFT JOIN (
    SELECT
        SRI.BaseEntry,
        SRI.BaseLinNum,
        SRI.ItemCode,
        SUM(SN.Quantity) AS SQTY,
        STRING_AGG(SN.DistNumber, ', ') WITHIN GROUP (ORDER BY SN.DistNumber ASC) AS SerialNum
    FROM SRI1_LINK SRI
    INNER JOIN OSRN SN ON SRI.SysSerial = SN.SysNumber AND SN.ItemCode = SRI.ItemCode
    WHERE SRI.BaseType = '18'
    GROUP BY SRI.BaseEntry, SRI.BaseLinNum, SRI.ItemCode
) AS Serial
    ON PCH1.DocEntry = Serial.BaseEntry
    AND PCH1.LineNum = Serial.BaseLinNum
    AND PCH1.ItemCode = Serial.ItemCode
LEFT JOIN (
    SELECT
        IBT.BaseEntry,
        IBT.BaseLinNum,
        IBT.ItemCode,
        SUM(IBT.Quantity) AS BQTY,
        STRING_AGG(BN.DistNumber, ', ') WITHIN GROUP (ORDER BY BN.DistNumber ASC) AS BatchNum,
        MAX(COALESCE(BN.MnfDate, BN.InDate)) AS ReceiveDate,
        MAX(BN.ExpDate) AS ExpDate
    FROM IBT1_LINK IBT
    INNER JOIN OBTN BN ON IBT.BatchNum = BN.DistNumber AND IBT.ItemCode = BN.ItemCode
    WHERE IBT.BaseType = '18'
    GROUP BY IBT.BaseEntry, IBT.BaseLinNum, IBT.ItemCode
) AS Batch_N
    ON PCH1.DocEntry = Batch_N.BaseEntry
    AND PCH1.LineNum = Batch_N.BaseLinNum
    AND PCH1.ItemCode = Batch_N.ItemCode
WHERE
    OPCH.DocEntry = {?DocKey@}
    AND PCH1.ItemCode = '{?ItemCode@}'
ORDER BY OPCH.DocEntry, PCH1.VisOrder
