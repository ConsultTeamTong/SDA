-- ============================================================
-- Report: 2.AP Down Payment Invoice_ใบจ่ายเงินมัดจำใบกำกับภาษี.rpt
-- Path:   2.AP Down Payment Invoice_ใบจ่ายเงินมัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:34
-- Source: Main Report
-- Table:  AP_DownPayment
-- ============================================================

-- RPT: 3. Purchasing - AP\6. AP Down Payment Invoice\1.AP Down Payment ใบจ่ายเงินมัดจำ\1.AP Down Payment_ใบจ่ายเงินมัดจำ.rpt
-- SCOPE: main
-- ALIAS: AP_DownPayment
-- FIELDS: 70
-- ---------------------------------------------------------------
-- RPT: 3. Purchasing - AP\6. AP Down Payment Invoice\1.AP Down Payment ใบจ่ายเงินมัดจำ\1.AP Down Payment_ใบจ่ายเงินมัดจำ.rpt
-- SCOPE: main
-- ALIAS: AP_DownPayment
-- FIELDS: 70
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
NNM1.BeginStr,

ODPO.DocEntry,

ODPO.DocNum,

ODPO.DocDate,

ODPO.CardCode,

DPO1.unitmsr,

ODPO.NumAtCard,

(DPO1.VisOrder + 1) As 'No.',

DPO1.LineNum as 'Line Num',

DPO1.LineType as 'LineType',

ODPO.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

ODPO.LicTradNum,

OCTG.PymntGroup,

ODPO.DocDueDate,

DPO1.ItemCode,

DPO1.Dscription as 'Dscription' ,

DPO1.Quantity,

ODPO.Comments,

ODPO.DocCur,

DPO1.PriceBefDi,

DPO1.LineTotal,

ODPO.VatSum,

ODPO.DocTotal,

ODPO.DpmAmnt,

DPO1.TotalFrgn,

ODPO.DocTotalFC,

ODPO.DpmAmntFC,

ODPO.dpmprcnt,

VPM1.CheckNum,

VPM1.[CheckSum] ,

VPM1.DueDate As 'Check Date',

SUM(OVPM.CashSum) As 'CashSum',

SUM(OVPM.TrsfrSum) As 'TrsfrSum',

ODSC.BankName,

ODPO.Printed,

QPJ.Project,

OCPR.E_MailL,

OCPR.Cellolar AS 'Tel1',

OCPR.Name,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB
,
    DPO1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODPO 
INNER JOIN DPO1 ON ODPO.DocEntry = DPO1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DPO1 P
    WHERE P.DocEntry = ODPO.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DPO12 ON ODPO.DocEntry = DPO12.DocEntry
LEFT JOIN NNM1 ON ODPO.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPO.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODPO.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPO.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON ODPO.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPO.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPO.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPO.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OVPM ON odpo.ReceiptNum = OVPM.docentry
LEFT JOIN VPM1 ON OVPM.docentry = VPM1.DocNum
LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocEntry
LEFT JOIN ODSC ON VPM1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPO.U_SLD_LVatBranch = BRANCH.Code,oadm
WHERE ODPO.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '204'
GROUP BY
OCPR.Name ,
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END  ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END  ,
 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END ,
BRANCH.[Name] ,
BRANCH.U_SLD_VTAXID ,
BRANCH.U_SLD_VComName ,
BRANCH.U_SLD_F_VComName ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END,
BRANCH.U_SLD_ZipCode ,
BRANCH.U_SLD_Tel ,
BRANCH.U_SLD_Fax ,
BRANCH.U_SLD_Email ,
NNM1.BeginStr,
ODPO.DocEntry,
ODPO.DocNum,
ODPO.DocDate,
ODPO.CardCode,
DPO1.unitmsr,
ODPO.NumAtCard,
(DPO1.VisOrder),
DPO1.LineNum,
DPO1.LineType,
ODPO.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END ,
OCRD.Phone1,
OCRD.Fax,
ODPO.LicTradNum,
OCTG.PymntGroup,
ODPO.DocDueDate,
DPO1.ItemCode,
DPO1.Dscription,
DPO1.Quantity,
ODPO.Comments,
ODPO.DocCur,
DPO1.PriceBefDi,
DPO1.LineTotal,
ODPO.VatSum,
ODPO.DocTotal,
ODPO.DpmAmnt,
DPO1.TotalFrgn,
ODPO.DocTotalFC,
ODPO.DpmAmntFC,
ODPO.dpmprcnt,
VPM1.CheckNum,
VPM1.[CheckSum],
VPM1.DueDate,
ODSC.BankName,
ODPO.Printed,
QPJ.Project,
OCPR.E_MailL,
OCPR.Cellolar,
OCPR.Name,
CRD1.Street,
CRD1.State,
CRD1.StreetNo,
CRD1.Block,
CRD1.City,
CRD1.ZipCode,
CRD1.County,
CRD1.Country,
OCPR.FirstName,
OCPR.LastName


UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
NNM1.BeginStr,

ODPO.DocEntry,

ODPO.DocNum,

ODPO.DocDate,

ODPO.CardCode,
    NULL AS 'unitmsr',

ODPO.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'Line Num',
    'T' AS 'LineType',

ODPO.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

ODPO.LicTradNum,

OCTG.PymntGroup,

ODPO.DocDueDate,
    NULL AS 'ItemCode',
    CAST(DPO10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',

ODPO.Comments,

ODPO.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

ODPO.VatSum,

ODPO.DocTotal,

ODPO.DpmAmnt,
    NULL AS 'TotalFrgn',

ODPO.DocTotalFC,

ODPO.DpmAmntFC,

ODPO.dpmprcnt,

VPM1.CheckNum,

VPM1.[CheckSum] ,

VPM1.DueDate As 'Check Date',

SUM(OVPM.CashSum) As 'CashSum',

SUM(OVPM.TrsfrSum) As 'TrsfrSum',

ODSC.BankName,

ODPO.Printed,

QPJ.Project,

OCPR.E_MailL,

OCPR.Cellolar AS 'Tel1',

OCPR.Name,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB
,
    DPO1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DPO10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODPO 
INNER JOIN DPO10 ON ODPO.DocEntry = DPO10.DocEntry
LEFT JOIN DPO1 ON DPO10.DocEntry = DPO1.DocEntry AND DPO10.AftLineNum = DPO1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DPO1 P
    WHERE P.DocEntry = ODPO.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DPO12 ON ODPO.DocEntry = DPO12.DocEntry
LEFT JOIN NNM1 ON ODPO.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPO.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODPO.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPO.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON ODPO.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPO.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPO.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPO.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OVPM ON odpo.ReceiptNum = OVPM.docentry
LEFT JOIN VPM1 ON OVPM.docentry = VPM1.DocNum
LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocEntry
LEFT JOIN ODSC ON VPM1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPO.U_SLD_LVatBranch = BRANCH.Code,oadm
WHERE ODPO.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '204'
GROUP BY
OCPR.Name ,
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END  ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END  ,
 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END ,
BRANCH.[Name] ,
BRANCH.U_SLD_VTAXID ,
BRANCH.U_SLD_VComName ,
BRANCH.U_SLD_F_VComName ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END,
BRANCH.U_SLD_ZipCode ,
BRANCH.U_SLD_Tel ,
BRANCH.U_SLD_Fax ,
BRANCH.U_SLD_Email ,
NNM1.BeginStr,
ODPO.DocEntry,
ODPO.DocNum,
ODPO.DocDate,
ODPO.CardCode,
DPO1.unitmsr,
ODPO.NumAtCard,
(DPO1.VisOrder),
DPO1.LineNum,
DPO1.LineType,
ODPO.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END ,
OCRD.Phone1,
OCRD.Fax,
ODPO.LicTradNum,
OCTG.PymntGroup,
ODPO.DocDueDate,
DPO1.ItemCode,
DPO1.Dscription,
DPO1.Quantity,
ODPO.Comments,
ODPO.DocCur,
DPO1.PriceBefDi,
DPO1.LineTotal,
ODPO.VatSum,
ODPO.DocTotal,
ODPO.DpmAmnt,
DPO1.TotalFrgn,
ODPO.DocTotalFC,
ODPO.DpmAmntFC,
ODPO.dpmprcnt,
VPM1.CheckNum,
VPM1.[CheckSum],
VPM1.DueDate,
ODSC.BankName,
ODPO.Printed,
QPJ.Project,
OCPR.E_MailL,
OCPR.Cellolar,
OCPR.Name,
CRD1.Street,
CRD1.State,
CRD1.StreetNo,
CRD1.Block,
CRD1.City,
CRD1.ZipCode,
CRD1.County,
CRD1.Country,
OCPR.FirstName,
OCPR.LastName,
CAST(DPO10.LineText AS NVARCHAR(4000)),
DPO10.LineSeq


UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
NNM1.BeginStr,

ODPO.DocEntry,

ODPO.DocNum,

ODPO.DocDate,

ODPO.CardCode,

DPO1.unitmsr,

ODPO.NumAtCard,

(DPO1.VisOrder + 1) As 'No.',

DPO1.LineNum as 'Line Num',

DPO1.LineType as 'LineType',

ODPO.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

ODPO.LicTradNum,

OCTG.PymntGroup,

ODPO.DocDueDate,

DPO1.ItemCode,

DPO1.Dscription as 'Dscription' ,

DPO1.Quantity,

ODPO.Comments,

ODPO.DocCur,

DPO1.PriceBefDi,

DPO1.LineTotal,

ODPO.VatSum,

ODPO.DocTotal,

ODPO.DpmAmnt,

DPO1.TotalFrgn,

ODPO.DocTotalFC,

ODPO.DpmAmntFC,

ODPO.dpmprcnt,

VPM1.CheckNum,

VPM1.[CheckSum] ,

VPM1.DueDate As 'Check Date',

SUM(OVPM.CashSum) As 'CashSum',

SUM(OVPM.TrsfrSum) As 'TrsfrSum',

ODSC.BankName,

ODPO.Printed,

QPJ.Project,

OCPR.E_MailL,

OCPR.Cellolar AS 'Tel1',

OCPR.Name,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB
,
    DPO1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ODPO
INNER JOIN DRF1 DPO1 ON ODPO.DocEntry = DPO1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ODPO.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 DPO12 ON ODPO.DocEntry = DPO12.DocEntry
LEFT JOIN NNM1 ON ODPO.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPO.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODPO.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPO.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON ODPO.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPO.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPO.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPO.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OVPM ON odpo.ReceiptNum = OVPM.docentry
LEFT JOIN VPM1 ON OVPM.docentry = VPM1.DocNum
LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocEntry
LEFT JOIN ODSC ON VPM1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPO.U_SLD_LVatBranch = BRANCH.Code,oadm
WHERE ODPO.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPO.ObjType = '204'
GROUP BY
OCPR.Name ,
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END  ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END  ,
 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END ,
BRANCH.[Name] ,
BRANCH.U_SLD_VTAXID ,
BRANCH.U_SLD_VComName ,
BRANCH.U_SLD_F_VComName ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END,
BRANCH.U_SLD_ZipCode ,
BRANCH.U_SLD_Tel ,
BRANCH.U_SLD_Fax ,
BRANCH.U_SLD_Email ,
NNM1.BeginStr,
ODPO.DocEntry,
ODPO.DocNum,
ODPO.DocDate,
ODPO.CardCode,
DPO1.unitmsr,
ODPO.NumAtCard,
(DPO1.VisOrder),
DPO1.LineNum,
DPO1.LineType,
ODPO.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END ,
OCRD.Phone1,
OCRD.Fax,
ODPO.LicTradNum,
OCTG.PymntGroup,
ODPO.DocDueDate,
DPO1.ItemCode,
DPO1.Dscription,
DPO1.Quantity,
ODPO.Comments,
ODPO.DocCur,
DPO1.PriceBefDi,
DPO1.LineTotal,
ODPO.VatSum,
ODPO.DocTotal,
ODPO.DpmAmnt,
DPO1.TotalFrgn,
ODPO.DocTotalFC,
ODPO.DpmAmntFC,
ODPO.dpmprcnt,
VPM1.CheckNum,
VPM1.[CheckSum],
VPM1.DueDate,
ODSC.BankName,
ODPO.Printed,
QPJ.Project,
OCPR.E_MailL,
OCPR.Cellolar,
OCPR.Name,
CRD1.Street,
CRD1.State,
CRD1.StreetNo,
CRD1.Block,
CRD1.City,
CRD1.ZipCode,
CRD1.County,
CRD1.Country,
OCPR.FirstName,
OCPR.LastName

UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

BRANCH.Code ,

 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

BRANCH.[Name] As 'BranchName',

BRANCH.U_SLD_VTAXID As 'TaxIdNum',

BRANCH.U_SLD_VComName As 'PrintHeadr',

BRANCH.U_SLD_F_VComName As 'PrintHdrF',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',

CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',

BRANCH.U_SLD_ZipCode As 'ZipCode',

BRANCH.U_SLD_Tel As 'Tel',

BRANCH.U_SLD_Fax As 'BFax',

BRANCH.U_SLD_Email AS 'E-Mail',

--------------------------------------------------------------------------------------------------------
NNM1.BeginStr,

ODPO.DocEntry,

ODPO.DocNum,

ODPO.DocDate,

ODPO.CardCode,
    NULL AS 'unitmsr',

ODPO.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    NULL AS 'Line Num',
    'T' AS 'LineType',

ODPO.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

ODPO.LicTradNum,

OCTG.PymntGroup,

ODPO.DocDueDate,
    NULL AS 'ItemCode',
    CAST(DPO10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',

ODPO.Comments,

ODPO.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

ODPO.VatSum,

ODPO.DocTotal,

ODPO.DpmAmnt,
    NULL AS 'TotalFrgn',

ODPO.DocTotalFC,

ODPO.DpmAmntFC,

ODPO.dpmprcnt,

VPM1.CheckNum,

VPM1.[CheckSum] ,

VPM1.DueDate As 'Check Date',

SUM(OVPM.CashSum) As 'CashSum',

SUM(OVPM.TrsfrSum) As 'TrsfrSum',

ODSC.BankName,

ODPO.Printed,

QPJ.Project,

OCPR.E_MailL,

OCPR.Cellolar AS 'Tel1',

OCPR.Name,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB
,
    DPO1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DPO10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ODPO
INNER JOIN DRF10 DPO10 ON ODPO.DocEntry = DPO10.DocEntry
LEFT JOIN DRF1 DPO1 ON DPO10.DocEntry = DPO1.DocEntry AND DPO10.AftLineNum = DPO1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ODPO.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
INNER JOIN DRF12 DPO12 ON ODPO.DocEntry = DPO12.DocEntry
LEFT JOIN NNM1 ON ODPO.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPO.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODPO.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPO.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON ODPO.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPO.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPO.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPO.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OVPM ON odpo.ReceiptNum = OVPM.docentry
LEFT JOIN VPM1 ON OVPM.docentry = VPM1.DocNum
LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocEntry
LEFT JOIN ODSC ON VPM1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPO.U_SLD_LVatBranch = BRANCH.Code,oadm
WHERE ODPO.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPO.ObjType = '204'
GROUP BY
OCPR.Name ,
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END  ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ODPO.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END  ,
 CASE 
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODPO.Printed = 'N' AND ODPO.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ODPO.Printed = 'Y' AND ODPO.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END ,
BRANCH.[Name] ,
BRANCH.U_SLD_VTAXID ,
BRANCH.U_SLD_VComName ,
BRANCH.U_SLD_F_VComName ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END ,
CASE WHEN ODPO.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END,
BRANCH.U_SLD_ZipCode ,
BRANCH.U_SLD_Tel ,
BRANCH.U_SLD_Fax ,
BRANCH.U_SLD_Email ,
NNM1.BeginStr,
ODPO.DocEntry,
ODPO.DocNum,
ODPO.DocDate,
ODPO.CardCode,
DPO1.unitmsr,
ODPO.NumAtCard,
(DPO1.VisOrder),
DPO1.LineNum,
DPO1.LineType,
ODPO.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END ,
OCRD.Phone1,
OCRD.Fax,
ODPO.LicTradNum,
OCTG.PymntGroup,
ODPO.DocDueDate,
DPO1.ItemCode,
DPO1.Dscription,
DPO1.Quantity,
ODPO.Comments,
ODPO.DocCur,
DPO1.PriceBefDi,
DPO1.LineTotal,
ODPO.VatSum,
ODPO.DocTotal,
ODPO.DpmAmnt,
DPO1.TotalFrgn,
ODPO.DocTotalFC,
ODPO.DpmAmntFC,
ODPO.dpmprcnt,
VPM1.CheckNum,
VPM1.[CheckSum],
VPM1.DueDate,
ODSC.BankName,
ODPO.Printed,
QPJ.Project,
OCPR.E_MailL,
OCPR.Cellolar,
OCPR.Name,
CRD1.Street,
CRD1.State,
CRD1.StreetNo,
CRD1.Block,
CRD1.City,
CRD1.ZipCode,
CRD1.County,
CRD1.Country,
OCPR.FirstName,
OCPR.LastName,
CAST(DPO10.LineText AS NVARCHAR(4000)),
DPO10.LineSeq

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

