-- ============================================================
-- Report: 1.Goods Receipt_ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Receipt_ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:10
-- Source: Main Report
-- Table:  G_Receipt
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

CASE WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
     WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
END AS 'GLN_H',

OIGN.DocEntry,

OIGN.DocNum,

OIGN.DocDate,

NNM1.BeginStr,

(IGN1.VisOrder+1) As 'No.',

IGN1.ItemCode,

IGN1.Dscription,

IGN1.Quantity,

IGN1.UomCode,

IGN1.WhsCode,

OIGN.comments,

OIGN.U_GR_RE,

QPJ.Project
,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGN
LEFT JOIN IGN1 ON OIGN.DocEntry = IGN1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

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
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

CASE WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
     WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
END AS 'GLN_H',

OIGN.DocEntry,

OIGN.DocNum,

OIGN.DocDate,

NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OIGN.comments,

OIGN.U_GR_RE,

QPJ.Project
,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OIGN
INNER JOIN IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

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

CASE WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
     WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
END AS 'GLN_H',

OIGN.DocEntry,

OIGN.DocNum,

OIGN.DocDate,

NNM1.BeginStr,

(IGN1.VisOrder+1) As 'No.',

IGN1.ItemCode,

IGN1.Dscription,

IGN1.Quantity,

IGN1.UomCode,

IGN1.WhsCode,

OIGN.comments,

OIGN.U_GR_RE,

QPJ.Project
,
    IGN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGN
LEFT JOIN DRF1 IGN1 ON OIGN.DocEntry = IGN1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

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


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

CASE WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
     WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
END AS 'GLN_H',

OIGN.DocEntry,

OIGN.DocNum,

OIGN.DocDate,

NNM1.BeginStr,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'ItemCode',
    CAST(IGN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'WhsCode',

OIGN.comments,

OIGN.U_GR_RE,

QPJ.Project
,
    IGN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    IGN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OIGN
INNER JOIN DRF10 IGN10 ON OIGN.DocEntry = IGN10.DocEntry
LEFT JOIN DRF1 IGN1 ON IGN10.DocEntry = IGN1.DocEntry AND IGN10.AftLineNum = IGN1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

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
