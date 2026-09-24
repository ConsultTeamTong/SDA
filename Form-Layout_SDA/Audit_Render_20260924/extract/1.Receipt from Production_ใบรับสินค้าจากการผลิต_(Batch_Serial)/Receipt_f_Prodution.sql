-- ============================================================
-- Report: 1.Receipt from Production_ใบรับสินค้าจากการผลิต_(Batch_Serial).rpt
-- Path:   1.Receipt from Production_ใบรับสินค้าจากการผลิต_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:27
-- Source: Main Report
-- Table:  Receipt_f_Prodution
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OIGN.DocEntry,

NNM1.BeginStr,

NNM1.SeriesName,

OIGN.DocNum,

OIGN.DocDate,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

(IGN1.VisOrder+1) AS 'No.',

IGN1.ItemCode,

IGN1.Dscription,

IGN1.Quantity,

IGN1.UomCode,

IGN1.WhsCode,

OIGN.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.Name As 'BranchName',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_Building As 'Building',

BRANCH.U_SLD_Steet As 'Street',

BRANCH.U_SLD_Block As 'Block',

BRANCH.U_SLD_City As 'City',

BRANCH.U_SLD_County As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax'

,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (IGN1.Project)) AS 'ProjectName'
FROM OIGN 
LEFT JOIN IGN1 ON OIGN.DocEntry = IGN1.DocEntry --and IGN1.BaseRef =
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series 
LEFT JOIN OPRJ ON IGN1.Project = OPRJ.PrjCode
LEFT JOIN OWOR ON IGN1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OWHS ON OIGN.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGN.DocEntry = '{?DocKey@}'
AND IGN1.BaseType = '202'
  AND {?ObjectId@} = '59'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OIGN.DocEntry,

NNM1.BeginStr,

NNM1.SeriesName,

OIGN.DocNum,

OIGN.DocDate,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OIGN.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.Name As 'BranchName',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_Building As 'Building',

BRANCH.U_SLD_Steet As 'Street',

BRANCH.U_SLD_Block As 'Block',

BRANCH.U_SLD_City As 'City',

BRANCH.U_SLD_County As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax'

,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (IGN1.Project)) AS 'ProjectName'
FROM OIGN 
INNER JOIN IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series 
LEFT JOIN OPRJ ON IGN1.Project = OPRJ.PrjCode
LEFT JOIN OWOR ON IGN1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OWHS ON OIGN.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGN.DocEntry = '{?DocKey@}'
AND IGN1.BaseType = '202'
  AND {?ObjectId@} = '59'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OIGN.DocEntry,

NNM1.BeginStr,

NNM1.SeriesName,

OIGN.DocNum,

OIGN.DocDate,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

(IGN1.VisOrder+1) AS 'No.',

IGN1.ItemCode,

IGN1.Dscription,

IGN1.Quantity,

IGN1.UomCode,

IGN1.WhsCode,

OIGN.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.Name As 'BranchName',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_Building As 'Building',

BRANCH.U_SLD_Steet As 'Street',

BRANCH.U_SLD_Block As 'Block',

BRANCH.U_SLD_City As 'City',

BRANCH.U_SLD_County As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax'

,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (IGN1.Project)) AS 'ProjectName'
FROM ODRF OIGN
LEFT JOIN DRF1 IGN1 ON OIGN.DocEntry = IGN1.DocEntry --and IGN1.BaseRef =
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series 
LEFT JOIN OPRJ ON IGN1.Project = OPRJ.PrjCode
LEFT JOIN OWOR ON IGN1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OWHS ON OIGN.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGN.DocEntry = '{?DocKey@}'
AND IGN1.BaseType = '202'
  AND {?ObjectId@} = '112' AND OIGN.ObjType = '59'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OIGN.DocEntry,

NNM1.BeginStr,

NNM1.SeriesName,

OIGN.DocNum,

OIGN.DocDate,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OIGN.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.Name As 'BranchName',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_Building As 'Building',

BRANCH.U_SLD_Steet As 'Street',

BRANCH.U_SLD_Block As 'Block',

BRANCH.U_SLD_City As 'City',

BRANCH.U_SLD_County As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax'

,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (IGN1.Project)) AS 'ProjectName'
FROM ODRF OIGN
INNER JOIN DRF10 IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN DRF1 IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series 
LEFT JOIN OPRJ ON IGN1.Project = OPRJ.PrjCode
LEFT JOIN OWOR ON IGN1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OWHS ON OIGN.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGN.DocEntry = '{?DocKey@}'
AND IGN1.BaseType = '202'
  AND {?ObjectId@} = '112' AND OIGN.ObjType = '59'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
