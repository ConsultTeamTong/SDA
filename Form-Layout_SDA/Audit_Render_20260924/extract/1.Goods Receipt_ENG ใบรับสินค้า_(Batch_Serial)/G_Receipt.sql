-- ============================================================
-- Report: 1.Goods Receipt_ENG ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Receipt_ENG ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:09
-- Source: Main Report
-- Table:  G_Receipt
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT
    BRANCH.[Code] As 'BranchCode',
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
    BRANCH.U_SLD_Fax As 'BFax',
    OIGN.DocEntry,
    OIGN.DocNum,
    OIGN.DocDate,
    NNM1.BeginStr,
    (IGN1.VisOrder+1) As 'No.',
    IGN1.ItemCode,
    IGN1.Dscription,
    OITM.FrgnName,
    IGN1.Quantity,
    ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), IGN1.UomCode) AS 'UomCode',
    IGN1.WhsCode,
    OIGN.comments,
    CAST(IGN10.LineText As NVARCHAR(200)) As 'Text',
    OIGN.U_GR_RE,
    QPJ.Project,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGN
LEFT JOIN IGN1 ON OIGN.DocEntry = IGN1.DocEntry
LEFT JOIN OUOM ON IGN1.UomCode = OUOM.UomCode
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM IGN1 P
    WHERE P.DocEntry = OIGN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN IGN10 ON OIGN.Docentry = IGN10.DocEntry AND IGN1.VisOrder = IGN10.AftLineNum
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGN.UserSign = OUSR.USERID
LEFT JOIN OITM ON IGN1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGN.DocEntry = {?Dockey@}
  AND IGN1.basetype <> '202'
  AND {?ObjectId@} = '59'

UNION ALL

-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT
    BRANCH.[Code] As 'BranchCode',
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
    BRANCH.U_SLD_Fax As 'BFax',
    OIGN.DocEntry,
    OIGN.DocNum,
    OIGN.DocDate,
    NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'FrgnName',  -- FIX: Changed OITM.FrgnName to NULL
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',
    OIGN.comments,
    CAST(IGN10.LineText As NVARCHAR(200)) As 'Text',
    OIGN.U_GR_RE,
    QPJ.Project,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGN
INNER JOIN IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM IGN1 P
    WHERE P.DocEntry = OIGN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGN.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGN.DocEntry = {?Dockey@}
  AND IGN1.basetype <> '202'
  AND {?ObjectId@} = '59'

UNION ALL

-- 2.1 item rows of the draft document
SELECT DISTINCT
    BRANCH.[Code] As 'BranchCode',
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
    BRANCH.U_SLD_Fax As 'BFax',
    OIGN.DocEntry,
    OIGN.DocNum,
    OIGN.DocDate,
    NNM1.BeginStr,
    (IGN1.VisOrder+1) As 'No.',
    IGN1.ItemCode,
    IGN1.Dscription,
    OITM.FrgnName,
    IGN1.Quantity,
    ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), IGN1.UomCode) AS 'UomCode',
    IGN1.WhsCode,
    OIGN.comments,
    CAST(IGN10.LineText As NVARCHAR(200)) As 'Text',
    OIGN.U_GR_RE,
    QPJ.Project,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGN
LEFT JOIN DRF1 IGN1 ON OIGN.DocEntry = IGN1.DocEntry
LEFT JOIN OUOM ON IGN1.UomCode = OUOM.UomCode
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OIGN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF10 IGN10 ON OIGN.Docentry = IGN10.DocEntry AND IGN1.VisOrder = IGN10.AftLineNum
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGN.UserSign = OUSR.USERID
LEFT JOIN OITM ON IGN1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGN.DocEntry = {?Dockey@}
  AND IGN1.basetype <> '202'
  AND {?ObjectId@} = '112' AND OIGN.ObjType = '59'

UNION ALL

-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT
    BRANCH.[Code] As 'BranchCode',
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
    BRANCH.U_SLD_Fax As 'BFax',
    OIGN.DocEntry,
    OIGN.DocNum,
    OIGN.DocDate,
    NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'FrgnName', -- FIX: Changed OITM.FrgnName to NULL
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',
    OIGN.comments,
    CAST(IGN10.LineText As NVARCHAR(200)) As 'Text',
    OIGN.U_GR_RE,
    QPJ.Project,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGN
INNER JOIN DRF10 IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN DRF1 IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OIGN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGN.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGN.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGN.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGN.DocEntry = {?Dockey@}
  AND IGN1.basetype <> '202'
  AND {?ObjectId@} = '112' AND OIGN.ObjType = '59'

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
