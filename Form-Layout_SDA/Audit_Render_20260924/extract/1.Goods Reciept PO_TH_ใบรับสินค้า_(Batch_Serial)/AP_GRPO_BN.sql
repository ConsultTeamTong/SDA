-- ============================================================
-- Report: 1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:11
-- Source: Main Report
-- Table:  AP_GRPO_BN
-- ============================================================

-- RPT: 3. Purchasing - AP\4. Goods Receipt PO\2.Goods Receive PO_TH_ใบรับสินค้า_(Batch_Serial) - Copy\1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AP_GRPO_BN
-- FIELDS: 67
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\4. Goods Receipt PO\2.Goods Receive PO_TH_ใบรับสินค้า_(Batch_Serial) - Copy\1.Goods Reciept PO_TH_ใบรับสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AP_GRPO_BN
-- FIELDS: 67
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
        PDN12.StreetS     AS '1Ship',
    PDN12.StreetNoS   AS '2Ship',
    PDN12.BlockS      AS '3Ship',
    PDN12.CityS       AS '4Ship',
    PDN12.CountyS     AS '5Ship',
    PDN12.ZipCodeS    AS '6Ship',

OCPR.Name AS 'Coontact',
BRANCH.Code ,

 CASE 
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',

-----------------------------------------------
OPDN.DocEntry,
OPDN.[Address],
OPDN.CardCode,
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OCRD.LicTradNum,
NNM1.BeginStr,
OPDN.DocNum,
OPDN.DocDate,
OPDN.DocDueDate,
OCTG.PymntGroup,
OPDN.NumAtCard,
(PDN1.VisOrder + 1) AS 'No.',
PDN1.LineNum as 'Line No.',
PDN1.ItemCode,
PDN1.Dscription as 'Dscription',
PDN1.Quantity,
PDN1.unitMsr,
QPJ.Project,
OPDN.Comments,
PDN1.LineType,

-- ALIAS ให้เหมือนใน Crystal Reports เดิม
CRD1.Street AS 'Street(1)',
CRD1.State        AS StateB,
CRD1.StreetNo AS 'StreetNo',
CRD1.Block AS 'Block(1)',
CRD1.City AS 'City(1)',
CRD1.ZipCode AS 'ZipCode(1)',
CRD1.County AS 'County(1)',
CRD1.GlblLocNum AS 'GLN_BP',

OCRD.E_Mail,
OCRD.CntctPrsn,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,
    PDN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPDN 
INNER JOIN PDN1 ON OPDN.DocEntry = PDN1.DocEntry 
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PDN1 P
    WHERE P.DocEntry = OPDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN PDN12 ON OPDN.DocEntry = PDN12.DocEntry
LEFT JOIN OITM ON PDN1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPDN.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPDN.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OPDN.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPDN.Series = NNM1.Series 
LEFT JOIN OCTG ON OPDN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPDN.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON OPDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OPDN.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '20'

UNION ALL

-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
        PDN12.StreetS     AS '1Ship',
    PDN12.StreetNoS   AS '2Ship',
    PDN12.BlockS      AS '3Ship',
    PDN12.CityS       AS '4Ship',
    PDN12.CountyS     AS '5Ship',
    PDN12.ZipCodeS    AS '6Ship',

OCPR.Name AS 'Coontact',
BRANCH.Code ,

 CASE 
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',

-----------------------------------------------
OPDN.DocEntry,
OPDN.[Address],
OPDN.CardCode,
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OCRD.LicTradNum,
NNM1.BeginStr,
OPDN.DocNum,
OPDN.DocDate,
OPDN.DocDueDate,
OCTG.PymntGroup,
OPDN.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    PDN1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PDN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'unitMsr',
QPJ.Project,
OPDN.Comments,
    'T' AS 'LineType',

-- ALIAS ให้เหมือนใน Crystal Reports เดิม
CRD1.Street AS 'Street(1)',
CRD1.State        AS StateB,
CRD1.StreetNo AS 'StreetNo',
CRD1.Block AS 'Block(1)',
CRD1.City AS 'City(1)',
CRD1.ZipCode AS 'ZipCode(1)',
CRD1.County AS 'County(1)',
CRD1.GlblLocNum AS 'GLN_BP',

OCRD.E_Mail,
OCRD.CntctPrsn,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,
    PDN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PDN10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPDN 
INNER JOIN PDN10 ON OPDN.DocEntry = PDN10.DocEntry
LEFT JOIN PDN1 ON PDN10.DocEntry = PDN1.DocEntry AND PDN10.AftLineNum = PDN1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PDN1 P
    WHERE P.DocEntry = OPDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN PDN12 ON OPDN.DocEntry = PDN12.DocEntry
LEFT JOIN OCRD ON OPDN.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPDN.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OPDN.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPDN.Series = NNM1.Series 
LEFT JOIN OCTG ON OPDN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPDN.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON OPDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OPDN.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '20'

UNION ALL

-- 2.1 item rows of the draft document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
        PDN12.StreetS     AS '1Ship',
    PDN12.StreetNoS   AS '2Ship',
    PDN12.BlockS      AS '3Ship',
    PDN12.CityS       AS '4Ship',
    PDN12.CountyS     AS '5Ship',
    PDN12.ZipCodeS    AS '6Ship',

OCPR.Name AS 'Coontact',
BRANCH.Code ,

 CASE 
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',

-----------------------------------------------
OPDN.DocEntry,
OPDN.[Address],
OPDN.CardCode,
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OCRD.LicTradNum,
NNM1.BeginStr,
OPDN.DocNum,
OPDN.DocDate,
OPDN.DocDueDate,
OCTG.PymntGroup,
OPDN.NumAtCard,
(PDN1.VisOrder + 1) AS 'No.',
PDN1.LineNum as 'Line No.',
PDN1.ItemCode,
PDN1.Dscription as 'Dscription',
PDN1.Quantity,
PDN1.unitMsr,
QPJ.Project,
OPDN.Comments,
PDN1.LineType,

-- ALIAS ให้เหมือนใน Crystal Reports เดิม
CRD1.Street AS 'Street(1)',
CRD1.State        AS StateB,
CRD1.StreetNo AS 'StreetNo',
CRD1.Block AS 'Block(1)',
CRD1.City AS 'City(1)',
CRD1.ZipCode AS 'ZipCode(1)',
CRD1.County AS 'County(1)',
CRD1.GlblLocNum AS 'GLN_BP',

OCRD.E_Mail,
OCRD.CntctPrsn,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,
    PDN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPDN
INNER JOIN DRF1 PDN1 ON OPDN.DocEntry = PDN1.DocEntry 
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 PDN12 ON OPDN.DocEntry = PDN12.DocEntry
LEFT JOIN OITM ON PDN1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPDN.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPDN.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OPDN.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPDN.Series = NNM1.Series 
LEFT JOIN OCTG ON OPDN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPDN.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON OPDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OPDN.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPDN.ObjType = '20'

UNION ALL

-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
        PDN12.StreetS     AS '1Ship',
    PDN12.StreetNoS   AS '2Ship',
    PDN12.BlockS      AS '3Ship',
    PDN12.CityS       AS '4Ship',
    PDN12.CountyS     AS '5Ship',
    PDN12.ZipCodeS    AS '6Ship',

OCPR.Name AS 'Coontact',
BRANCH.Code ,

 CASE 
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPDN.Printed = 'N' AND OPDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPDN.Printed = 'Y' AND OPDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',

-----------------------------------------------
OPDN.DocEntry,
OPDN.[Address],
OPDN.CardCode,
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OCRD.LicTradNum,
NNM1.BeginStr,
OPDN.DocNum,
OPDN.DocDate,
OPDN.DocDueDate,
OCTG.PymntGroup,
OPDN.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    PDN1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PDN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'unitMsr',
QPJ.Project,
OPDN.Comments,
    'T' AS 'LineType',

-- ALIAS ให้เหมือนใน Crystal Reports เดิม
CRD1.Street AS 'Street(1)',
CRD1.State        AS StateB,
CRD1.StreetNo AS 'StreetNo',
CRD1.Block AS 'Block(1)',
CRD1.City AS 'City(1)',
CRD1.ZipCode AS 'ZipCode(1)',
CRD1.County AS 'County(1)',
CRD1.GlblLocNum AS 'GLN_BP',

OCRD.E_Mail,
OCRD.CntctPrsn,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,
    PDN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PDN10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPDN
INNER JOIN DRF10 PDN10 ON OPDN.DocEntry = PDN10.DocEntry
LEFT JOIN DRF1 PDN1 ON PDN10.DocEntry = PDN1.DocEntry AND PDN10.AftLineNum = PDN1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 PDN12 ON OPDN.DocEntry = PDN12.DocEntry
LEFT JOIN OCRD ON OPDN.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPDN.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OPDN.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPDN.Series = NNM1.Series 
LEFT JOIN OCTG ON OPDN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPDN.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON OPDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OPDN.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPDN.ObjType = '20'

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

