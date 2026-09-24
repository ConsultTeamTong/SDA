-- ============================================================
-- Report: 1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:12
-- Source: Subreport [batch&serial]
-- Table:  AP_GR_BN
-- ============================================================

SELECT
    ORPD.DocEntry,
    RPD1.ItemCode,
    OITM.InvntryUom,
    Serial.SQTY,
    Serial.SerialNum,
    Batch_N.BQTY,
    Batch_N.BatchNum AS 'BATCH',
    Batch_N.ReceiveDate AS 'Bdate',
    Batch_N.ExpDate AS 'Bexp'
FROM ORPD
LEFT JOIN RPD1 ON ORPD.DocEntry = RPD1.DocEntry
LEFT JOIN OITM ON RPD1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN (
    SELECT
        SRI.BaseEntry,
        SRI.BaseLinNum,
        SRI.ItemCode,
        SUM(SN.Quantity) AS SQTY,
        STRING_AGG(SN.DistNumber, ', ') WITHIN GROUP (ORDER BY SN.DistNumber ASC) AS SerialNum
    FROM SRI1_LINK SRI
    INNER JOIN OSRN SN ON SRI.SysSerial = SN.SysNumber AND SN.ItemCode = SRI.ItemCode
    WHERE SRI.BaseType = '21'
    GROUP BY SRI.BaseEntry, SRI.BaseLinNum, SRI.ItemCode
) AS Serial
    ON RPD1.DocEntry = Serial.BaseEntry
    AND RPD1.LineNum = Serial.BaseLinNum
    AND RPD1.ItemCode = Serial.ItemCode
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
    WHERE IBT.BaseType = '21'
    GROUP BY IBT.BaseEntry, IBT.BaseLinNum, IBT.ItemCode
) AS Batch_N
    ON RPD1.DocEntry = Batch_N.BaseEntry
    AND RPD1.LineNum = Batch_N.BaseLinNum
    AND RPD1.ItemCode = Batch_N.ItemCode
WHERE
    ORPD.DocEntry = {?DocKey@}
    AND RPD1.ItemCode = '{?ItemCode@}'
ORDER BY ORPD.DocEntry, RPD1.VisOrder

