-- ============================================================
-- Report: 1.AP Credit Memo_ใบลดหนี้.rpt
-- Path:   1.AP Credit Memo_ใบลดหนี้.rpt
-- Extracted: 2026-09-24 10:19:50
-- Source: Main Report
-- Table:  AP_CN
-- ============================================================

-- RPT: 3. Purchasing - AP\8. AP Credit Memo\1.AP Credit Memo_ใบลดหนี้\1.AP Credit Memo_ใบลดหนี้.rpt
-- SCOPE: main
-- ALIAS: AP_CN
-- FIELDS: 63
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\8. AP Credit Memo\1.AP Credit Memo_ใบลดหนี้\1.AP Credit Memo_ใบลดหนี้.rpt
-- SCOPE: main
-- ALIAS: AP_CN
-- FIELDS: 63
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
ORPC.[Address],

ORPC.VatSumFC,
 
ORPC.DocTotalFC,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,
 
OSLP.SlpName,

NNM1.BeginStr,
 
ORPC.DocEntry,
 
ORPC.DocNum,
 
ORPC.DocDate,

(RPC1.VisOrder + 1) AS 'No.',
 
RPC1.LineNum as 'Line No.',
 
RPC1.ItemCode,
 
RPC1.Dscription as 'Dscription',
 
RPC1.LineType as 'LineType',

RPC1.Quantity,
 
RPC1.UomCode,

RPC1.unitMsr,
  
RPC1.Price,
 
RPC1.LineTotal,

RPC1.TotalFrgn,
 
ORPC.VatSum,

ORPC.DocCur,
 
ORPC.DocTotal,

OCRD.LicTradNum,

ORPC.Printed
,
ORPC.Comments,

QPJ.Project,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

OPCH.DocNum   AS 'Ref_DocNum',

OPCH.DocDate  AS 'Ref_DocDate',

OPCH.DocTotal AS 'Ref_DocTotal'
,
    RPC1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORPC 
INNER JOIN RPC1 ON ORPC.DocEntry = RPC1.DocEntry 
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RPC1 P
    WHERE P.DocEntry = ORPC.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN RPC12 ON ORPC.DocEntry = RPC12.DocEntry 
LEFT JOIN OITM ON RPC1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ORPC.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORPC.PayToCode
LEFT JOIN OCPR ON ORPC.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ORPC.Series = NNM1.Series 
LEFT JOIN OCTG ON ORPC.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORPC.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORPC.SlpCode = OSLP.SlpCode
--LEFT JOIN [dbo].[@SLD_REASON_RD] T10 ON ORPC.U_CN_04 = T10.code
LEFT JOIN CRD1 CRD ON (ORPC.PaytoCode = CRD.[Address] AND ORPC.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OUSR ON ORPC.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPC.U_SLD_LVatBranch = BRANCH.Code 
LEFT JOIN OPCH ON RPC1.BaseEntry = OPCH.DocEntry 
              AND RPC1.BaseType  = 18
, oadm
WHERE ORPC.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '19'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
ORPC.[Address],

ORPC.VatSumFC,
 
ORPC.DocTotalFC,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,
 
OSLP.SlpName,

NNM1.BeginStr,
 
ORPC.DocEntry,
 
ORPC.DocNum,
 
ORPC.DocDate,
    CAST(NULL AS INT) AS 'No.',
    RPC1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RPC10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    'T' AS 'LineType',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'unitMsr',
    NULL AS 'Price',
    NULL AS 'LineTotal',
    NULL AS 'TotalFrgn',
 
ORPC.VatSum,

ORPC.DocCur,
 
ORPC.DocTotal,

OCRD.LicTradNum,

ORPC.Printed
,
ORPC.Comments,

QPJ.Project,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

OPCH.DocNum   AS 'Ref_DocNum',

OPCH.DocDate  AS 'Ref_DocDate',

OPCH.DocTotal AS 'Ref_DocTotal'
,
    RPC1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RPC10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORPC 
INNER JOIN RPC10 ON ORPC.DocEntry = RPC10.DocEntry
LEFT JOIN RPC1 ON RPC10.DocEntry = RPC1.DocEntry AND RPC10.AftLineNum = RPC1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RPC1 P
    WHERE P.DocEntry = ORPC.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN RPC12 ON ORPC.DocEntry = RPC12.DocEntry 

LEFT JOIN OCRD ON ORPC.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORPC.PayToCode
LEFT JOIN OCPR ON ORPC.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ORPC.Series = NNM1.Series 
LEFT JOIN OCTG ON ORPC.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORPC.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORPC.SlpCode = OSLP.SlpCode
--LEFT JOIN [dbo].[@SLD_REASON_RD] T10 ON ORPC.U_CN_04 = T10.code
LEFT JOIN CRD1 CRD ON (ORPC.PaytoCode = CRD.[Address] AND ORPC.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OUSR ON ORPC.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPC.U_SLD_LVatBranch = BRANCH.Code 
LEFT JOIN OPCH ON RPC1.BaseEntry = OPCH.DocEntry 
              AND RPC1.BaseType  = 18
, oadm
WHERE ORPC.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '19'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
ORPC.[Address],

ORPC.VatSumFC,
 
ORPC.DocTotalFC,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,
 
OSLP.SlpName,

NNM1.BeginStr,
 
ORPC.DocEntry,
 
ORPC.DocNum,
 
ORPC.DocDate,

(RPC1.VisOrder + 1) AS 'No.',
 
RPC1.LineNum as 'Line No.',
 
RPC1.ItemCode,
 
RPC1.Dscription as 'Dscription',
 
RPC1.LineType as 'LineType',

RPC1.Quantity,
 
RPC1.UomCode,

RPC1.unitMsr,
  
RPC1.Price,
 
RPC1.LineTotal,

RPC1.TotalFrgn,
 
ORPC.VatSum,

ORPC.DocCur,
 
ORPC.DocTotal,

OCRD.LicTradNum,

ORPC.Printed
,
ORPC.Comments,

QPJ.Project,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

OPCH.DocNum   AS 'Ref_DocNum',

OPCH.DocDate  AS 'Ref_DocDate',

OPCH.DocTotal AS 'Ref_DocTotal'
,
    RPC1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORPC
INNER JOIN DRF1 RPC1 ON ORPC.DocEntry = RPC1.DocEntry 
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORPC.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 RPC12 ON ORPC.DocEntry = RPC12.DocEntry 
LEFT JOIN OITM ON RPC1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ORPC.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORPC.PayToCode
LEFT JOIN OCPR ON ORPC.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ORPC.Series = NNM1.Series 
LEFT JOIN OCTG ON ORPC.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORPC.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORPC.SlpCode = OSLP.SlpCode
--LEFT JOIN [dbo].[@SLD_REASON_RD] T10 ON ORPC.U_CN_04 = T10.code
LEFT JOIN CRD1 CRD ON (ORPC.PaytoCode = CRD.[Address] AND ORPC.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OUSR ON ORPC.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPC.U_SLD_LVatBranch = BRANCH.Code 
LEFT JOIN OPCH ON RPC1.BaseEntry = OPCH.DocEntry 
              AND RPC1.BaseType  = 18
, oadm
WHERE ORPC.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORPC.ObjType = '19'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORPC.Printed = 'N' AND ORPC.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORPC.Printed = 'Y' AND ORPC.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ORPC.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
ORPC.[Address],

ORPC.VatSumFC,
 
ORPC.DocTotalFC,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,
 
OSLP.SlpName,

NNM1.BeginStr,
 
ORPC.DocEntry,
 
ORPC.DocNum,
 
ORPC.DocDate,
    CAST(NULL AS INT) AS 'No.',
    RPC1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RPC10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    'T' AS 'LineType',
    NULL AS 'Quantity',
    NULL AS 'UomCode',
    NULL AS 'unitMsr',
    NULL AS 'Price',
    NULL AS 'LineTotal',
    NULL AS 'TotalFrgn',
 
ORPC.VatSum,

ORPC.DocCur,
 
ORPC.DocTotal,

OCRD.LicTradNum,

ORPC.Printed
,
ORPC.Comments,

QPJ.Project,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

OPCH.DocNum   AS 'Ref_DocNum',

OPCH.DocDate  AS 'Ref_DocDate',

OPCH.DocTotal AS 'Ref_DocTotal'
,
    RPC1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RPC10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORPC
INNER JOIN DRF10 RPC10 ON ORPC.DocEntry = RPC10.DocEntry
LEFT JOIN DRF1 RPC1 ON RPC10.DocEntry = RPC1.DocEntry AND RPC10.AftLineNum = RPC1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORPC.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 RPC12 ON ORPC.DocEntry = RPC12.DocEntry 

LEFT JOIN OCRD ON ORPC.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORPC.PayToCode
LEFT JOIN OCPR ON ORPC.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ORPC.Series = NNM1.Series 
LEFT JOIN OCTG ON ORPC.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORPC.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORPC.SlpCode = OSLP.SlpCode
--LEFT JOIN [dbo].[@SLD_REASON_RD] T10 ON ORPC.U_CN_04 = T10.code
LEFT JOIN CRD1 CRD ON (ORPC.PaytoCode = CRD.[Address] AND ORPC.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OUSR ON ORPC.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPC.U_SLD_LVatBranch = BRANCH.Code 
LEFT JOIN OPCH ON RPC1.BaseEntry = OPCH.DocEntry 
              AND RPC1.BaseType  = 18
, oadm
WHERE ORPC.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORPC.ObjType = '19'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

