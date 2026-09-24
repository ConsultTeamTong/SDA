-- ============================================================
-- Report: 1.Goods Issue_ใบเบิกสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Issue_ใบเบิกสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:07
-- Source: Main Report
-- Table:  G_Issue_BS
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

OIGE.DocEntry,

OIGE.DocNum,

OIGE.DocDate,

NNM1.BeginStr,

(IGE1.VisOrder+1) AS 'No.',

IGE1.LineNum,

IGE1.ItemCode,

IGE1.Dscription,

IGE1.Quantity,

IGE1.WhsCode,

OIGE.Comments,

IGE1.unitmsr,

OIGE.U_GI_RE,

QPJ.Project
,
    IGE1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGE
INNER JOIN IGE1 IGE1 ON OIGE.DocEntry = IGE1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM IGE1 P
    WHERE P.DocEntry = OIGE.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGE.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGE.DocEntry  = {?DocKey@}
AND OIGE.BaseType <> '202'
  AND {?ObjectId@} = '60'



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

OIGE.DocEntry,

OIGE.DocNum,

OIGE.DocDate,

NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'LineNum',
    NULL AS 'ItemCode',
    CAST(IGE10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'WhsCode',

OIGE.Comments,
    NULL AS 'unitmsr',

OIGE.U_GI_RE,

QPJ.Project
,
    IGE1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGE10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGE
INNER JOIN IGE10 ON OIGE.DocEntry = IGE10.DocEntry
LEFT JOIN IGE1 ON IGE10.DocEntry = IGE1.DocEntry AND IGE10.AftLineNum = IGE1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM IGE1 P
    WHERE P.DocEntry = OIGE.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGE.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGE.DocEntry  = {?DocKey@}
AND OIGE.BaseType <> '202'
  AND {?ObjectId@} = '60'



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

OIGE.DocEntry,

OIGE.DocNum,

OIGE.DocDate,

NNM1.BeginStr,

(IGE1.VisOrder+1) AS 'No.',

IGE1.LineNum,

IGE1.ItemCode,

IGE1.Dscription,

IGE1.Quantity,

IGE1.WhsCode,

OIGE.Comments,

IGE1.unitmsr,

OIGE.U_GI_RE,

QPJ.Project
,
    IGE1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGE
INNER JOIN DRF1 IGE1 ON OIGE.DocEntry = IGE1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OIGE.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGE.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGE.DocEntry  = {?DocKey@}
AND OIGE.BaseType <> '202'
  AND {?ObjectId@} = '112' AND OIGE.ObjType = '60'


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

OIGE.DocEntry,

OIGE.DocNum,

OIGE.DocDate,

NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'LineNum',
    NULL AS 'ItemCode',
    CAST(IGE10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'WhsCode',

OIGE.Comments,
    NULL AS 'unitmsr',

OIGE.U_GI_RE,

QPJ.Project
,
    IGE1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGE10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGE
INNER JOIN DRF10 IGE10 ON OIGE.DocEntry = IGE10.DocEntry
LEFT JOIN DRF1 IGE1 ON IGE10.DocEntry = IGE1.DocEntry AND IGE10.AftLineNum = IGE1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OIGE.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGE.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGE.DocEntry  = {?DocKey@}
AND OIGE.BaseType <> '202'
  AND {?ObjectId@} = '112' AND OIGE.ObjType = '60'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
