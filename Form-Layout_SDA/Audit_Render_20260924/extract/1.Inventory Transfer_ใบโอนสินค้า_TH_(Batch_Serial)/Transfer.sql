-- ============================================================
-- Report: 1.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial).rpt
-- Path:   1.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:17
-- Source: Main Report
-- Table:  Transfer
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT
    CASE 
        WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
    END AS 'GLN_H',
    'From' AS WhsFrom,
    'To' AS WhsTo,
    OWTR.DocEntry,
    NNM1.BeginStr + CONVERT(VARCHAR(10), OWTR.DocNum) AS 'DocNum',
    OWTR.DocDate,
    OWTR.DocNum AS 'RawDocNum',
    OWTR.Comments AS 'Remark',
    WTR1.BaseRef AS 'TransRefNo',
    WTR1.LineNum + 1 AS 'LineNum',
    WTR1.ItemCode,
    WTR1.Dscription,
    WTR1.Quantity,
    WTR1.unitMsr,
    WTR1.FromWhsCod,
    WTR1.WhsCode,
    QPJ.Project,
    WTR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = QPJ.Project) AS 'ProjectName'
FROM OWTR
INNER JOIN WTR1 ON OWTR.DocEntry = WTR1.DocEntry 
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM WTR1 P
    WHERE P.DocEntry = OWTR.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
INNER JOIN NNM1 ON OWTR.Series = NNM1.Series
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OWTR.U_SLD_LVatBranch = BRANCH.Code
WHERE OWTR.DocEntry = {?dockey@}
  AND {?ObjectId@} = '67'

UNION ALL

-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT
    CASE 
        WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
    END AS 'GLN_H',
    'From' AS WhsFrom,
    'To' AS WhsTo,
    OWTR.DocEntry,
    NNM1.BeginStr + CONVERT(VARCHAR(10), OWTR.DocNum) AS 'DocNum',
    OWTR.DocDate,
    OWTR.DocNum AS 'RawDocNum',
    OWTR.Comments AS 'Remark',
    NULL AS 'TransRefNo',
    NULL AS 'LineNum',
    NULL AS 'ItemCode',
    CAST(WTR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'unitMsr',
    NULL AS 'FromWhsCod',
    NULL AS 'WhsCode',
    QPJ.Project,
    WTR1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    WTR10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = QPJ.Project) AS 'ProjectName'
FROM OWTR
INNER JOIN WTR10 ON OWTR.DocEntry = WTR10.DocEntry
LEFT JOIN WTR1 ON WTR10.DocEntry = WTR1.DocEntry AND WTR10.AftLineNum = WTR1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM WTR1 P
    WHERE P.DocEntry = OWTR.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
INNER JOIN NNM1 ON OWTR.Series = NNM1.Series
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OWTR.U_SLD_LVatBranch = BRANCH.Code
WHERE OWTR.DocEntry = {?dockey@}
  AND {?ObjectId@} = '67'

UNION ALL

-- 2.1 item rows of the draft document
SELECT DISTINCT
    CASE 
        WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
    END AS 'GLN_H',
    'From' AS WhsFrom,
    'To' AS WhsTo,
    OWTR.DocEntry,
    NNM1.BeginStr + CONVERT(VARCHAR(10), OWTR.DocNum) AS 'DocNum',
    OWTR.DocDate,
    OWTR.DocNum AS 'RawDocNum',
    OWTR.Comments AS 'Remark',
    WTR1.BaseRef AS 'TransRefNo',
    WTR1.LineNum + 1 AS 'LineNum',
    WTR1.ItemCode,
    WTR1.Dscription,
    WTR1.Quantity,
    WTR1.unitMsr,
    WTR1.FromWhsCod,
    WTR1.WhsCode,
    QPJ.Project,
    WTR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = QPJ.Project) AS 'ProjectName'
FROM ODRF OWTR
INNER JOIN DRF1 WTR1 ON OWTR.DocEntry = WTR1.DocEntry 
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OWTR.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
INNER JOIN NNM1 ON OWTR.Series = NNM1.Series
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OWTR.U_SLD_LVatBranch = BRANCH.Code
WHERE OWTR.DocEntry = {?dockey@}
  AND {?ObjectId@} = '112' AND OWTR.ObjType = '67'

UNION ALL

-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT
    CASE 
        WHEN BRANCH.Code = '00000' THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code <> '00000' THEN concat(N'สาขาที่', ' ', BRANCH.Code)
    END AS 'GLN_H',
    'From' AS WhsFrom,
    'To' AS WhsTo,
    OWTR.DocEntry,
    NNM1.BeginStr + CONVERT(VARCHAR(10), OWTR.DocNum) AS 'DocNum',
    OWTR.DocDate,
    OWTR.DocNum AS 'RawDocNum',
    OWTR.Comments AS 'Remark',
    NULL AS 'TransRefNo',
    NULL AS 'LineNum',
    NULL AS 'ItemCode',
    CAST(WTR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'unitMsr',
    NULL AS 'FromWhsCod',
    NULL AS 'WhsCode',
    QPJ.Project,
    WTR1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    WTR10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = QPJ.Project) AS 'ProjectName'
FROM ODRF OWTR
INNER JOIN DRF10 WTR10 ON OWTR.DocEntry = WTR10.DocEntry
LEFT JOIN DRF1 WTR1 ON WTR10.DocEntry = WTR1.DocEntry AND WTR10.AftLineNum = WTR1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OWTR.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
INNER JOIN NNM1 ON OWTR.Series = NNM1.Series
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OWTR.U_SLD_LVatBranch = BRANCH.Code
WHERE OWTR.DocEntry = {?dockey@}
  AND {?ObjectId@} = '112' AND OWTR.ObjType = '67'

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
