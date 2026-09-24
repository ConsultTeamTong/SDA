-- ============================================================
-- Report: 1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:12
-- Source: Main Report
-- Table:  AP_GR_BN
-- ============================================================

-- RPT: 3. Purchasing - AP\5. Goods Return\2.Goods Return_EN_ใบส่งคืนสินค้า_(Batch_Serial)\1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AP_GR_BN
-- FIELDS: 42
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\5. Goods Return\2.Goods Return_EN_ใบส่งคืนสินค้า_(Batch_Serial)\1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AP_GR_BN
-- FIELDS: 42
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\5. Goods Return\2.Goods Return_EN_ใบส่งคืนสินค้า_(Batch_Serial)\1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AP_GR_BN
-- FIELDS: 42
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

    ORPD.DocEntry,

    (RPD1.VisOrder + 1) AS 'No.',

    RPD1.LineNum AS 'Line No.',
 
    ORPD.[Address],
  
    OCRD.LicTradNum,
 
    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',

    OCRD.Phone1,
 
    OCRD.Fax,
  
    ORPD.NumAtCard,
 
    ORPD.Comments,

    RPD1.ItemCode,

    RPD1.dscription AS 'Dscription',
 
    RPD1.Quantity,
 
    ORPD.DocDate,
 
    NNM1.BeginStr,

    ORPD.DocNum,

-----------------------------------------------------
    ISNULL(
        (
            SELECT STRING_AGG(BaseDoc, ', ')
            FROM (
                SELECT DISTINCT 
                    CASE 
                        WHEN Sub_RPD1.BaseType = 20 THEN ISNULL(Sub_N1.BeginStr, '') + CAST(Sub_OPDN.DocNum AS VARCHAR(20))
                        WHEN Sub_RPD1.BaseType = 22 THEN ISNULL(Sub_N2.BeginStr, '') + CAST(Sub_OPOR.DocNum AS VARCHAR(20))
                    END AS BaseDoc
                FROM RPD1 Sub_RPD1
                LEFT JOIN OPDN Sub_OPDN ON Sub_RPD1.BaseEntry = Sub_OPDN.DocEntry
                LEFT JOIN NNM1 Sub_N1 ON Sub_OPDN.Series = Sub_N1.Series
                LEFT JOIN OPOR Sub_OPOR ON Sub_RPD1.BaseEntry = Sub_OPOR.DocEntry
                LEFT JOIN NNM1 Sub_N2 ON Sub_OPOR.Series = Sub_N2.Series
                WHERE Sub_RPD1.DocEntry = ORPD.DocEntry 
                  AND Sub_RPD1.BaseType IN (20, 22)
            ) AS TempDistinct
        ), 
        ISNULL(NNM1.BeginStr, '') + CAST(ORPD.DocNum AS VARCHAR(20))
    ) AS 'FullDocNum',

-----------------------------------------------------
    ORPD.CreateDate,

    ORPD.CardCode,

    ORPD.U_SLD_Returnreason,

    RPD1.unitMsr,

    RPD1.LineType,

    QPJ.Project,

    OCRD.CntctPrsn,

    OCPR.E_MailL,

    OCPR.Cellolar,

    CAST(CRD1.Street AS NVARCHAR(4000)) AS StreetB,
 
    CAST(CRD1.StreetNo AS NVARCHAR(4000)) AS StreetNoB,

    CAST(CRD1.Block AS NVARCHAR(4000)) AS BlockB,
 
    CAST(CRD1.Building AS NVARCHAR(4000)) AS BuildingB,
 
    CAST(CRD1.City AS NVARCHAR(4000)) AS CityB,
 
    CRD1.ZipCode AS ZipCodeB,
 
    CAST(CRD1.County AS NVARCHAR(4000)) AS CountyB,
 
    CRD1.State AS StateB,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
,
    RPD1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORPD 
INNER JOIN RPD1 ON ORPD.DocEntry = RPD1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RPD1 P
    WHERE P.DocEntry = ORPD.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN RPD12 ON ORPD.DocEntry = RPD12.DocEntry
LEFT JOIN NNM1 ON ORPD.Series = NNM1.Series
LEFT JOIN OUSR ON ORPD.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND ORPD.CntctCode = OCPR.CntctCode
LEFT JOIN OITM ON RPD1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPD.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE ORPD.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '21'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

    ORPD.DocEntry,
    CAST(NULL AS INT) AS 'No.',
    RPD1.LineNum AS 'Line No.',
 
    ORPD.[Address],
  
    OCRD.LicTradNum,
 
    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',

    OCRD.Phone1,
 
    OCRD.Fax,
  
    ORPD.NumAtCard,
 
    ORPD.Comments,
    NULL AS 'ItemCode',
    CAST(RPD10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
 
    ORPD.DocDate,
 
    NNM1.BeginStr,

    ORPD.DocNum,

-----------------------------------------------------
    ISNULL(
        (
            SELECT STRING_AGG(BaseDoc, ', ')
            FROM (
                SELECT DISTINCT 
                    CASE 
                        WHEN Sub_RPD1.BaseType = 20 THEN ISNULL(Sub_N1.BeginStr, '') + CAST(Sub_OPDN.DocNum AS VARCHAR(20))
                        WHEN Sub_RPD1.BaseType = 22 THEN ISNULL(Sub_N2.BeginStr, '') + CAST(Sub_OPOR.DocNum AS VARCHAR(20))
                    END AS BaseDoc
                FROM RPD1 Sub_RPD1
                LEFT JOIN OPDN Sub_OPDN ON Sub_RPD1.BaseEntry = Sub_OPDN.DocEntry
                LEFT JOIN NNM1 Sub_N1 ON Sub_OPDN.Series = Sub_N1.Series
                LEFT JOIN OPOR Sub_OPOR ON Sub_RPD1.BaseEntry = Sub_OPOR.DocEntry
                LEFT JOIN NNM1 Sub_N2 ON Sub_OPOR.Series = Sub_N2.Series
                WHERE Sub_RPD1.DocEntry = ORPD.DocEntry 
                  AND Sub_RPD1.BaseType IN (20, 22)
            ) AS TempDistinct
        ), 
        ISNULL(NNM1.BeginStr, '') + CAST(ORPD.DocNum AS VARCHAR(20))
    ) AS 'FullDocNum',

-----------------------------------------------------
    ORPD.CreateDate,

    ORPD.CardCode,

    ORPD.U_SLD_Returnreason,
    NULL AS 'unitMsr',
    'T' AS 'LineType',

    QPJ.Project,

    OCRD.CntctPrsn,

    OCPR.E_MailL,

    OCPR.Cellolar,

    CAST(CRD1.Street AS NVARCHAR(4000)) AS StreetB,
 
    CAST(CRD1.StreetNo AS NVARCHAR(4000)) AS StreetNoB,

    CAST(CRD1.Block AS NVARCHAR(4000)) AS BlockB,
 
    CAST(CRD1.Building AS NVARCHAR(4000)) AS BuildingB,
 
    CAST(CRD1.City AS NVARCHAR(4000)) AS CityB,
 
    CRD1.ZipCode AS ZipCodeB,
 
    CAST(CRD1.County AS NVARCHAR(4000)) AS CountyB,
 
    CRD1.State AS StateB,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
,
    RPD1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RPD10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORPD 
INNER JOIN RPD10 ON ORPD.DocEntry = RPD10.DocEntry
LEFT JOIN RPD1 ON RPD10.DocEntry = RPD1.DocEntry AND RPD10.AftLineNum = RPD1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RPD1 P
    WHERE P.DocEntry = ORPD.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN RPD12 ON ORPD.DocEntry = RPD12.DocEntry
LEFT JOIN NNM1 ON ORPD.Series = NNM1.Series
LEFT JOIN OUSR ON ORPD.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND ORPD.CntctCode = OCPR.CntctCode

LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPD.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE ORPD.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '21'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

    ORPD.DocEntry,

    (RPD1.VisOrder + 1) AS 'No.',

    RPD1.LineNum AS 'Line No.',
 
    ORPD.[Address],
  
    OCRD.LicTradNum,
 
    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',

    OCRD.Phone1,
 
    OCRD.Fax,
  
    ORPD.NumAtCard,
 
    ORPD.Comments,

    RPD1.ItemCode,

    RPD1.dscription AS 'Dscription',
 
    RPD1.Quantity,
 
    ORPD.DocDate,
 
    NNM1.BeginStr,

    ORPD.DocNum,

-----------------------------------------------------
    ISNULL(
        (
            SELECT STRING_AGG(BaseDoc, ', ')
            FROM (
                SELECT DISTINCT 
                    CASE 
                        WHEN Sub_RPD1.BaseType = 20 THEN ISNULL(Sub_N1.BeginStr, '') + CAST(Sub_OPDN.DocNum AS VARCHAR(20))
                        WHEN Sub_RPD1.BaseType = 22 THEN ISNULL(Sub_N2.BeginStr, '') + CAST(Sub_OPOR.DocNum AS VARCHAR(20))
                    END AS BaseDoc
                FROM DRF1 Sub_RPD1
                LEFT JOIN OPDN Sub_OPDN ON Sub_RPD1.BaseEntry = Sub_OPDN.DocEntry
                LEFT JOIN NNM1 Sub_N1 ON Sub_OPDN.Series = Sub_N1.Series
                LEFT JOIN OPOR Sub_OPOR ON Sub_RPD1.BaseEntry = Sub_OPOR.DocEntry
                LEFT JOIN NNM1 Sub_N2 ON Sub_OPOR.Series = Sub_N2.Series
                WHERE Sub_RPD1.DocEntry = ORPD.DocEntry 
                  AND Sub_RPD1.BaseType IN (20, 22)
            ) AS TempDistinct
        ), 
        ISNULL(NNM1.BeginStr, '') + CAST(ORPD.DocNum AS VARCHAR(20))
    ) AS 'FullDocNum',

-----------------------------------------------------
    ORPD.CreateDate,

    ORPD.CardCode,

    ORPD.U_SLD_Returnreason,

    RPD1.unitMsr,

    RPD1.LineType,

    QPJ.Project,

    OCRD.CntctPrsn,

    OCPR.E_MailL,

    OCPR.Cellolar,

    CAST(CRD1.Street AS NVARCHAR(4000)) AS StreetB,
 
    CAST(CRD1.StreetNo AS NVARCHAR(4000)) AS StreetNoB,

    CAST(CRD1.Block AS NVARCHAR(4000)) AS BlockB,
 
    CAST(CRD1.Building AS NVARCHAR(4000)) AS BuildingB,
 
    CAST(CRD1.City AS NVARCHAR(4000)) AS CityB,
 
    CRD1.ZipCode AS ZipCodeB,
 
    CAST(CRD1.County AS NVARCHAR(4000)) AS CountyB,
 
    CRD1.State AS StateB,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
,
    RPD1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORPD
INNER JOIN DRF1 RPD1 ON ORPD.DocEntry = RPD1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORPD.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 RPD12 ON ORPD.DocEntry = RPD12.DocEntry
LEFT JOIN NNM1 ON ORPD.Series = NNM1.Series
LEFT JOIN OUSR ON ORPD.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND ORPD.CntctCode = OCPR.CntctCode
LEFT JOIN OITM ON RPD1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPD.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE ORPD.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORPD.ObjType = '21'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

    ORPD.DocEntry,
    CAST(NULL AS INT) AS 'No.',
    RPD1.LineNum AS 'Line No.',
 
    ORPD.[Address],
  
    OCRD.LicTradNum,
 
    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',

    OCRD.Phone1,
 
    OCRD.Fax,
  
    ORPD.NumAtCard,
 
    ORPD.Comments,
    NULL AS 'ItemCode',
    CAST(RPD10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
 
    ORPD.DocDate,
 
    NNM1.BeginStr,

    ORPD.DocNum,

-----------------------------------------------------
    ISNULL(
        (
            SELECT STRING_AGG(BaseDoc, ', ')
            FROM (
                SELECT DISTINCT 
                    CASE 
                        WHEN Sub_RPD1.BaseType = 20 THEN ISNULL(Sub_N1.BeginStr, '') + CAST(Sub_OPDN.DocNum AS VARCHAR(20))
                        WHEN Sub_RPD1.BaseType = 22 THEN ISNULL(Sub_N2.BeginStr, '') + CAST(Sub_OPOR.DocNum AS VARCHAR(20))
                    END AS BaseDoc
                FROM DRF1 Sub_RPD1
                LEFT JOIN OPDN Sub_OPDN ON Sub_RPD1.BaseEntry = Sub_OPDN.DocEntry
                LEFT JOIN NNM1 Sub_N1 ON Sub_OPDN.Series = Sub_N1.Series
                LEFT JOIN OPOR Sub_OPOR ON Sub_RPD1.BaseEntry = Sub_OPOR.DocEntry
                LEFT JOIN NNM1 Sub_N2 ON Sub_OPOR.Series = Sub_N2.Series
                WHERE Sub_RPD1.DocEntry = ORPD.DocEntry 
                  AND Sub_RPD1.BaseType IN (20, 22)
            ) AS TempDistinct
        ), 
        ISNULL(NNM1.BeginStr, '') + CAST(ORPD.DocNum AS VARCHAR(20))
    ) AS 'FullDocNum',

-----------------------------------------------------
    ORPD.CreateDate,

    ORPD.CardCode,

    ORPD.U_SLD_Returnreason,
    NULL AS 'unitMsr',
    'T' AS 'LineType',

    QPJ.Project,

    OCRD.CntctPrsn,

    OCPR.E_MailL,

    OCPR.Cellolar,

    CAST(CRD1.Street AS NVARCHAR(4000)) AS StreetB,
 
    CAST(CRD1.StreetNo AS NVARCHAR(4000)) AS StreetNoB,

    CAST(CRD1.Block AS NVARCHAR(4000)) AS BlockB,
 
    CAST(CRD1.Building AS NVARCHAR(4000)) AS BuildingB,
 
    CAST(CRD1.City AS NVARCHAR(4000)) AS CityB,
 
    CRD1.ZipCode AS ZipCodeB,
 
    CAST(CRD1.County AS NVARCHAR(4000)) AS CountyB,
 
    CRD1.State AS StateB,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
,
    RPD1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RPD10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORPD
INNER JOIN DRF10 RPD10 ON ORPD.DocEntry = RPD10.DocEntry
LEFT JOIN DRF1 RPD1 ON RPD10.DocEntry = RPD1.DocEntry AND RPD10.AftLineNum = RPD1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORPD.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 RPD12 ON ORPD.DocEntry = RPD12.DocEntry
LEFT JOIN NNM1 ON ORPD.Series = NNM1.Series
LEFT JOIN OUSR ON ORPD.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND ORPD.CntctCode = OCPR.CntctCode

LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPD.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE ORPD.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORPD.ObjType = '21'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

