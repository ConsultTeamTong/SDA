-- ============================================================
-- Report: 1.Production Order_ใบสั่งผลิต.rpt
-- Path:   1.Production Order_ใบสั่งผลิต.rpt
-- Extracted: 2026-09-24 10:20:24
-- Source: Main Report
-- Table:  Prodution_Order
-- ============================================================

SELECT DISTINCT
    WOR1.ItemType,
    WOR1.ItemName,
    OWOR.DocEntry,
    NNM1.SeriesName AS 'SeriesName',
    NNM1.BeginStr,
    OWOR.DocNum AS 'DocNum',
    OWOR.PostDate AS 'PostDate',
    OWOR.DueDate AS 'DueDate',
    OWOR.ItemCode AS 'Code FG',
    OWOR.ProdName AS 'ProdName',
    OWOR.PlannedQty AS 'PlannedQty',
    OWOR.Uom AS 'Uom',
    OWOR.Warehouse AS 'Warehouse',
    WOR1.ItemCode AS 'Code RM',
    OWOR.OriginNum As 'Sale No.',
    WOR1.UomCode As 'UomCode',
    WOR1.PlannedQty,
    WOR1.IssuedQty,
    WOR1.wareHouse AS 'WH',
    OWOR.Comments,
    WOR1.VisOrder AS 'Sort_VisOrder',
    CASE WHEN WOR1.ItemType = 4 THEN 1 ELSE 0 END AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = OWOR.Project) AS 'ProjectName'
FROM OWOR 
LEFT OUTER JOIN WOR1 ON OWOR.DocEntry = WOR1.DocEntry
LEFT JOIN OITM ON WOR1.ItemCode = OITM.ItemCode 
LEFT JOIN NNM1 ON OWOR.Series = NNM1.Series
LEFT JOIN ORSC ON WOR1.ItemCode = ORSC.VisResCode
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OWOR.UserSign = OUSR.USERID
LEFT JOIN OWHS ON OWOR.Warehouse = OWHS.WhsCode
WHERE OWOR.DocEntry = {?DocKey@}
ORDER BY 
    [Sort_VisOrder] ASC, 
    [Sort_IsText] ASC, 
    [Sort_Seq] ASC
