-- ============================================================
-- Report: 1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- Path:   1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- Extracted: 2026-09-24 10:20:26
-- Source: Main Report
-- Table:  AP_PQ
-- ============================================================

-- RPT: 3. Purchasing - AP\2. Purchase Quotation\1.Purchase Quotation_ใบเสนอราคาซื้อ\1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- SCOPE: main
-- ALIAS: AP_PQ
-- FIELDS: 64
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\2. Purchase Quotation\1.Purchase Quotation_ใบเสนอราคาซื้อ\1.Purchase Quotation_ใบเสนอราคาซื้อ.rpt
-- SCOPE: main
-- ALIAS: AP_PQ
-- FIELDS: 64
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

BRANCH.Code ,

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

CASE WHEN OPQT.DocCur = 'THB' THEN PQT1.LineTotal ELSE PQT1.TotalFrgn END AS 'LineTotal',

OPQT.DocCur,

OPQT.DocEntry,

OPQT.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
ISNULL(OCRD.Fax,'') AS 'Fax',
 
OCRD.LicTradNum,

ISNULL(pqt12.GlbLocNumB,'') AS 'GlbLocNumB',

ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
OPQT.DocNum,
 
OPQT.DocDate,
 
OPQT.DocDueDate,
 
(PQT1.VisOrder + 1) AS 'No.',
 
PQT1.LineNum as 'Line No.',
 
PQT1.ItemCode,
 
PQT1.Dscription as 'Dscription',
 
PQT1.Quantity,
 
PQT1.Price,
 
PQT1.TotalSumSy,

PQT1.UomCode,
 
CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.VatSum ELSE OPQT.VatSumFC END AS 'VatSum',

CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.DocTotal ELSE OPQT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPQT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PQT1 L WHERE L.DocEntry = OPQT.DocEntry) AS 'Sum_LineTotal_All',

pqt1.unitMsr,

PQT1.LineType,

OCPR.Name AS 'Coontact',

QPJ.Project,

ocrd.CntctPrsn,

ocrd.E_Mail,

ocrd.Phone2,

pqt1.DiscPrcnt,

pqt1.U_SLD_Dis_Amount,

CAST(CRD1.Street AS NVARCHAR(4000)) as StreetB,
 CAST(CRD1.StreetNo AS NVARCHAR(4000)) as StreetNoB,
CAST(CRD1.Block AS NVARCHAR(4000)) as BlockB,
 CAST(CRD1.Building AS NVARCHAR(4000)) as BuildingB,

CAST(CRD1.City AS NVARCHAR(4000)) as CityB,
 CRD1.ZipCode AS ZipCodeB,
 CAST(CRD1.County AS NVARCHAR(4000)) as CountyB,
 CRD1.State AS StateB,

opqt.cardcode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    PQT1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPQT
INNER JOIN PQT1 ON OPQT.DocEntry = PQT1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PQT1 P
    WHERE P.DocEntry = OPQT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
inner join PQT12 on OPQT.DocEntry = PQT12.DocEntry
LEFT JOIN OCRD ON OCRD.CardCode = OPQT.CardCode
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPQT.cntctcode = OCPR.cntctcode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPQT.PaytoCode = CRD1.[Address] AND  CRD1.AdresType ='B')
LEFT JOIN NNM1 ON OPQT.Series = NNM1.Series
LEFT JOIN OUSR ON OPQT.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPQT.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE OPQT.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '540000006'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

BRANCH.Code ,

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',
    NULL AS 'LineTotal',

OPQT.DocCur,

OPQT.DocEntry,

OPQT.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
ISNULL(OCRD.Fax,'') AS 'Fax',
 
OCRD.LicTradNum,

ISNULL(pqt12.GlbLocNumB,'') AS 'GlbLocNumB',

ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
OPQT.DocNum,
 
OPQT.DocDate,
 
OPQT.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    PQT1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PQT10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'Price',
    NULL AS 'TotalSumSy',
    NULL AS 'UomCode',
 
CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.VatSum ELSE OPQT.VatSumFC END AS 'VatSum',

CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.DocTotal ELSE OPQT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPQT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PQT1 L WHERE L.DocEntry = OPQT.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',
    'T' AS 'LineType',

OCPR.Name AS 'Coontact',

QPJ.Project,

ocrd.CntctPrsn,

ocrd.E_Mail,

ocrd.Phone2,
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',

CAST(CRD1.Street AS NVARCHAR(4000)) as StreetB,
 CAST(CRD1.StreetNo AS NVARCHAR(4000)) as StreetNoB,
CAST(CRD1.Block AS NVARCHAR(4000)) as BlockB,
 CAST(CRD1.Building AS NVARCHAR(4000)) as BuildingB,

CAST(CRD1.City AS NVARCHAR(4000)) as CityB,
 CRD1.ZipCode AS ZipCodeB,
 CAST(CRD1.County AS NVARCHAR(4000)) as CountyB,
 CRD1.State AS StateB,

opqt.cardcode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    PQT1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PQT10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPQT
INNER JOIN PQT10 ON OPQT.DocEntry = PQT10.DocEntry
LEFT JOIN PQT1 ON PQT10.DocEntry = PQT1.DocEntry AND PQT10.AftLineNum = PQT1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PQT1 P
    WHERE P.DocEntry = OPQT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
inner join PQT12 on OPQT.DocEntry = PQT12.DocEntry
LEFT JOIN OCRD ON OCRD.CardCode = OPQT.CardCode
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPQT.cntctcode = OCPR.cntctcode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPQT.PaytoCode = CRD1.[Address] AND  CRD1.AdresType ='B')
LEFT JOIN NNM1 ON OPQT.Series = NNM1.Series
LEFT JOIN OUSR ON OPQT.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPQT.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE OPQT.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '540000006'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

BRANCH.Code ,

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

CASE WHEN OPQT.DocCur = 'THB' THEN PQT1.LineTotal ELSE PQT1.TotalFrgn END AS 'LineTotal',

OPQT.DocCur,

OPQT.DocEntry,

OPQT.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
ISNULL(OCRD.Fax,'') AS 'Fax',
 
OCRD.LicTradNum,

ISNULL(pqt12.GlbLocNumB,'') AS 'GlbLocNumB',

ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
OPQT.DocNum,
 
OPQT.DocDate,
 
OPQT.DocDueDate,
 
(PQT1.VisOrder + 1) AS 'No.',
 
PQT1.LineNum as 'Line No.',
 
PQT1.ItemCode,
 
PQT1.Dscription as 'Dscription',
 
PQT1.Quantity,
 
PQT1.Price,
 
PQT1.TotalSumSy,

PQT1.UomCode,
 
CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.VatSum ELSE OPQT.VatSumFC END AS 'VatSum',

CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.DocTotal ELSE OPQT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPQT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPQT.DocEntry) AS 'Sum_LineTotal_All',

pqt1.unitMsr,

PQT1.LineType,

OCPR.Name AS 'Coontact',

QPJ.Project,

ocrd.CntctPrsn,

ocrd.E_Mail,

ocrd.Phone2,

pqt1.DiscPrcnt,

pqt1.U_SLD_Dis_Amount,

CAST(CRD1.Street AS NVARCHAR(4000)) as StreetB,
 CAST(CRD1.StreetNo AS NVARCHAR(4000)) as StreetNoB,
CAST(CRD1.Block AS NVARCHAR(4000)) as BlockB,
 CAST(CRD1.Building AS NVARCHAR(4000)) as BuildingB,

CAST(CRD1.City AS NVARCHAR(4000)) as CityB,
 CRD1.ZipCode AS ZipCodeB,
 CAST(CRD1.County AS NVARCHAR(4000)) as CountyB,
 CRD1.State AS StateB,

opqt.cardcode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    PQT1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPQT
INNER JOIN DRF1 PQT1 ON OPQT.DocEntry = PQT1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPQT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
inner JOIN DRF12 PQT12 ON OPQT.DocEntry = PQT12.DocEntry
LEFT JOIN OCRD ON OCRD.CardCode = OPQT.CardCode
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPQT.cntctcode = OCPR.cntctcode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPQT.PaytoCode = CRD1.[Address] AND  CRD1.AdresType ='B')
LEFT JOIN NNM1 ON OPQT.Series = NNM1.Series
LEFT JOIN OUSR ON OPQT.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPQT.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE OPQT.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPQT.ObjType = '540000006'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

BRANCH.Code ,

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN OPQT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',
    NULL AS 'LineTotal',

OPQT.DocCur,

OPQT.DocEntry,

OPQT.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
ISNULL(OCRD.Fax,'') AS 'Fax',
 
OCRD.LicTradNum,

ISNULL(pqt12.GlbLocNumB,'') AS 'GlbLocNumB',

ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
OPQT.DocNum,
 
OPQT.DocDate,
 
OPQT.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    PQT1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PQT10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'Price',
    NULL AS 'TotalSumSy',
    NULL AS 'UomCode',
 
CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.VatSum ELSE OPQT.VatSumFC END AS 'VatSum',

CASE WHEN OPQT.DocCur = 'THB' THEN OPQT.DocTotal ELSE OPQT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPQT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPQT.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',
    'T' AS 'LineType',

OCPR.Name AS 'Coontact',

QPJ.Project,

ocrd.CntctPrsn,

ocrd.E_Mail,

ocrd.Phone2,
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',

CAST(CRD1.Street AS NVARCHAR(4000)) as StreetB,
 CAST(CRD1.StreetNo AS NVARCHAR(4000)) as StreetNoB,
CAST(CRD1.Block AS NVARCHAR(4000)) as BlockB,
 CAST(CRD1.Building AS NVARCHAR(4000)) as BuildingB,

CAST(CRD1.City AS NVARCHAR(4000)) as CityB,
 CRD1.ZipCode AS ZipCodeB,
 CAST(CRD1.County AS NVARCHAR(4000)) as CountyB,
 CRD1.State AS StateB,

opqt.cardcode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    PQT1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PQT10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPQT
INNER JOIN DRF10 PQT10 ON OPQT.DocEntry = PQT10.DocEntry
LEFT JOIN DRF1 PQT1 ON PQT10.DocEntry = PQT1.DocEntry AND PQT10.AftLineNum = PQT1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPQT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
inner JOIN DRF12 PQT12 ON OPQT.DocEntry = PQT12.DocEntry
LEFT JOIN OCRD ON OCRD.CardCode = OPQT.CardCode
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPQT.cntctcode = OCPR.cntctcode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPQT.PaytoCode = CRD1.[Address] AND  CRD1.AdresType ='B')
LEFT JOIN NNM1 ON OPQT.Series = NNM1.Series
LEFT JOIN OUSR ON OPQT.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPQT.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE OPQT.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPQT.ObjType = '540000006'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

