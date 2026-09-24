-- ============================================================
-- Report: 1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต_(Batch_Serial).rpt
-- Path:   1.Issue for Production_ใบเบิกวัตถุดิบเพื่อการผลิต_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:18
-- Source: Main Report
-- Table:  Issue_f_Prodution
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OIGE.docentry,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

NNM1.SeriesName,

OIGE.DocNum,

OIGE.DocDate,

(IGE1.VisOrder+1) AS 'No.',

IGE1.ItemCode,

IGE1.Dscription,

IGE1.Quantity,

IGE1.UomCode,

IGE1.WhsCode,

OWOR.PostDate as 'PostDate' ,

NNM1.BeginStr,

OIGE.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.[Name] As 'BranchName',

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
    IGE1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (OWOR.Project)) AS 'ProjectName'
FROM OIGE 
LEFT JOIN IGE1 ON OIGE.DocEntry = IGE1.DocEntry 
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series 
LEFT JOIN OWOR ON IGE1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OWHS ON OIGE.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGE.DocEntry  = {?DocKey@}
AND 
IGE1.BaseType = '202'
  AND {?ObjectId@} = '60'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OIGE.docentry,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

NNM1.SeriesName,

OIGE.DocNum,

OIGE.DocDate,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGE10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OWOR.PostDate as 'PostDate' ,

NNM1.BeginStr,

OIGE.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.[Name] As 'BranchName',

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
    IGE1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGE10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (OWOR.Project)) AS 'ProjectName'
FROM OIGE 
INNER JOIN IGE10 ON OIGE.DocEntry = IGE10.DocEntry
LEFT JOIN IGE1 ON IGE10.DocEntry = IGE1.DocEntry AND IGE10.AftLineNum = IGE1.VisOrder
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series 
LEFT JOIN OWOR ON IGE1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OWHS ON OIGE.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGE.DocEntry  = {?DocKey@}
AND 
IGE1.BaseType = '202'
  AND {?ObjectId@} = '60'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OIGE.docentry,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

NNM1.SeriesName,

OIGE.DocNum,

OIGE.DocDate,

(IGE1.VisOrder+1) AS 'No.',

IGE1.ItemCode,

IGE1.Dscription,

IGE1.Quantity,

IGE1.UomCode,

IGE1.WhsCode,

OWOR.PostDate as 'PostDate' ,

NNM1.BeginStr,

OIGE.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.[Name] As 'BranchName',

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
    IGE1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (OWOR.Project)) AS 'ProjectName'
FROM ODRF OIGE
LEFT JOIN DRF1 IGE1 ON OIGE.DocEntry = IGE1.DocEntry 
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series 
LEFT JOIN OWOR ON IGE1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OWHS ON OIGE.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGE.DocEntry  = {?DocKey@}
AND 
IGE1.BaseType = '202'
  AND {?ObjectId@} = '112' AND OIGE.ObjType = '60'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OIGE.docentry,

PNNM.BeginStr As 'OderBeginStr',

PNNM.SeriesName As 'OderSeries',

OWOR.DocNum As 'OderNo.',

OWOR.ItemCode AS 'Production_No',

OWOR.ProdName,

OWOR.PlannedQty,

OWOR.Warehouse,

NNM1.SeriesName,

OIGE.DocNum,

OIGE.DocDate,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGE10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OWOR.PostDate as 'PostDate' ,

NNM1.BeginStr,

OIGE.Comments,

BRANCH.Code as 'BranchCode' ,

BRANCH.[Name] As 'BranchName',

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
    IGE1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGE10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (OWOR.Project)) AS 'ProjectName'
FROM ODRF OIGE
INNER JOIN DRF10 IGE10 ON OIGE.DocEntry = IGE10.DocEntry
LEFT JOIN DRF1 IGE1 ON IGE10.DocEntry = IGE1.DocEntry AND IGE10.AftLineNum = IGE1.VisOrder
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series 
LEFT JOIN OWOR ON IGE1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OWHS ON OIGE.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGE.DocEntry  = {?DocKey@}
AND 
IGE1.BaseType = '202'
  AND {?ObjectId@} = '112' AND OIGE.ObjType = '60'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
