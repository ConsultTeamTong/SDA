-- ============================================================
-- Report: 1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- Path:   1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:06
-- Source: Main Report
-- Table:  AR_Delivery_BS
-- ============================================================

-- RPT: 2. Sales - AR\3. Delivery\2.Delivery_ใบส่งของ_(Batch_Serial)\1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AR_Delivery_BS
-- FIELDS: 54
-- ---------------------------------------------------------------
-- RPT: 2. Sales - AR\3. Delivery\2.Delivery_ใบส่งของ_(Batch_Serial)\1.Delivery_ใบส่งของ_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AR_Delivery_BS
-- FIELDS: 54
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OCPR.name AS 'Coontact',

 CASE 
 WHEN ODLN.Printed = 'N' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODLN.Printed = 'Y' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 END AS 'Print Status',

ODLN.DocEntry,
 
ODLN.CardCode,

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        DLN12.StreetS     AS '1Ship',

    DLN12.StreetNoS   AS '2Ship',

    DLN12.BlockS      AS '3Ship',

    DLN12.CityS       AS '4Ship',

    DLN12.CountyS     AS '5Ship',

    DLN12.ZipCodeS    AS '6Ship',

	DLN12.Address3S		AS 'NameShip',

ODLN.CreateDate,

ODLN.DocNum,

ODLN.DocDueDate,

ODLN.DocDate,

DLN1.unitmsr,

DLN1.Quantity,

DLN1.BaseDocNum,

(DLN1.VisOrder + 1) AS 'No.',

DLN1.LineNum as 'Line No.',
 
DLN1.Dscription,

DLN1.ItemCode,

NNM1.BeginStr,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

CRD1.GlblLocNum,

OCRD.Phone1,

ISNULL(OCPR.Cellolar,'') As 'Phone2',

OCRD.Fax,

OCRD.LicTradNum,

OCTG.pymntgroup,

OSLP.SlpName,

ODLN.Comments,

ODLN.NumAtCard,

DLN1.LineType,

OCPR.E_MailL AS ContactMail,

OSLP.SlpName as 'Sale Name contact',

OHEM.mobile as 'Mobile',

OHEM.Email as 'Email-Sale',

DLN1.Project ,

OUGP.UgpCode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    DLN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (DLN1.Project)) AS 'ProjectName'
FROM ODLN 
INNER JOIN DLN1 ON ODLN.DocEntry = DLN1.DocEntry 
LEFT JOIN OHEM ON ODLN.SlpCode = OHEM.salesPrson
LEFT JOIN DLN12 ON ODLN.DocEntry = DLN12.DocEntry 
LEFT JOIN NNM1 ON ODLN.Series = NNM1.Series 
LEFT JOIN OCRD ON ODLN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODLN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODLN.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCTG ON ODLN.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODLN.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON DLN1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON ODLN.UserSign = OUSR.USERID
LEFT JOIN OUGP ON DLN1.UomCode = OUGP.UgpCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODLN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ODLN.DocEntry  = '{?DocKey@}'
  AND {?ObjectId@} = '15'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OCPR.name AS 'Coontact',

 CASE 
 WHEN ODLN.Printed = 'N' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODLN.Printed = 'Y' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 END AS 'Print Status',

ODLN.DocEntry,
 
ODLN.CardCode,

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        DLN12.StreetS     AS '1Ship',

    DLN12.StreetNoS   AS '2Ship',

    DLN12.BlockS      AS '3Ship',

    DLN12.CityS       AS '4Ship',

    DLN12.CountyS     AS '5Ship',

    DLN12.ZipCodeS    AS '6Ship',

	DLN12.Address3S		AS 'NameShip',

ODLN.CreateDate,

ODLN.DocNum,

ODLN.DocDueDate,

ODLN.DocDate,
    NULL AS 'unitmsr',
    NULL AS 'Quantity',
    NULL AS 'BaseDocNum',
    CAST(NULL AS INT) AS 'No.',
    DLN1.LineNum AS 'Line No.',
    CAST(DLN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'ItemCode',

NNM1.BeginStr,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

CRD1.GlblLocNum,

OCRD.Phone1,

ISNULL(OCPR.Cellolar,'') As 'Phone2',

OCRD.Fax,

OCRD.LicTradNum,

OCTG.pymntgroup,

OSLP.SlpName,

ODLN.Comments,

ODLN.NumAtCard,
    'T' AS 'LineType',

OCPR.E_MailL AS ContactMail,

OSLP.SlpName as 'Sale Name contact',

OHEM.mobile as 'Mobile',

OHEM.Email as 'Email-Sale',

DLN1.Project ,

OUGP.UgpCode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    DLN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DLN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (DLN1.Project)) AS 'ProjectName'
FROM ODLN 
INNER JOIN DLN10 ON ODLN.DocEntry = DLN10.DocEntry
LEFT JOIN DLN1 ON DLN10.DocEntry = DLN1.DocEntry AND DLN10.AftLineNum = DLN1.VisOrder
LEFT JOIN OHEM ON ODLN.SlpCode = OHEM.salesPrson
LEFT JOIN DLN12 ON ODLN.DocEntry = DLN12.DocEntry 
LEFT JOIN NNM1 ON ODLN.Series = NNM1.Series 
LEFT JOIN OCRD ON ODLN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODLN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODLN.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCTG ON ODLN.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODLN.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON DLN1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON ODLN.UserSign = OUSR.USERID
LEFT JOIN OUGP ON DLN1.UomCode = OUGP.UgpCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODLN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ODLN.DocEntry  = '{?DocKey@}'
  AND {?ObjectId@} = '15'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OCPR.name AS 'Coontact',

 CASE 
 WHEN ODLN.Printed = 'N' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODLN.Printed = 'Y' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 END AS 'Print Status',

ODLN.DocEntry,
 
ODLN.CardCode,

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        DLN12.StreetS     AS '1Ship',

    DLN12.StreetNoS   AS '2Ship',

    DLN12.BlockS      AS '3Ship',

    DLN12.CityS       AS '4Ship',

    DLN12.CountyS     AS '5Ship',

    DLN12.ZipCodeS    AS '6Ship',

	DLN12.Address3S		AS 'NameShip',

ODLN.CreateDate,

ODLN.DocNum,

ODLN.DocDueDate,

ODLN.DocDate,

DLN1.unitmsr,

DLN1.Quantity,

DLN1.BaseDocNum,

(DLN1.VisOrder + 1) AS 'No.',

DLN1.LineNum as 'Line No.',
 
DLN1.Dscription,

DLN1.ItemCode,

NNM1.BeginStr,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

CRD1.GlblLocNum,

OCRD.Phone1,

ISNULL(OCPR.Cellolar,'') As 'Phone2',

OCRD.Fax,

OCRD.LicTradNum,

OCTG.pymntgroup,

OSLP.SlpName,

ODLN.Comments,

ODLN.NumAtCard,

DLN1.LineType,

OCPR.E_MailL AS ContactMail,

OSLP.SlpName as 'Sale Name contact',

OHEM.mobile as 'Mobile',

OHEM.Email as 'Email-Sale',

DLN1.Project ,

OUGP.UgpCode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    DLN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (DLN1.Project)) AS 'ProjectName'
FROM ODRF ODLN
INNER JOIN DRF1 DLN1 ON ODLN.DocEntry = DLN1.DocEntry 
LEFT JOIN OHEM ON ODLN.SlpCode = OHEM.salesPrson
LEFT JOIN DRF12 DLN12 ON ODLN.DocEntry = DLN12.DocEntry 
LEFT JOIN NNM1 ON ODLN.Series = NNM1.Series 
LEFT JOIN OCRD ON ODLN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODLN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODLN.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCTG ON ODLN.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODLN.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON DLN1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON ODLN.UserSign = OUSR.USERID
LEFT JOIN OUGP ON DLN1.UomCode = OUGP.UgpCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODLN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ODLN.DocEntry  = '{?DocKey@}'
  AND {?ObjectId@} = '112' AND ODLN.ObjType = '15'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OCPR.name AS 'Coontact',

 CASE 
 WHEN ODLN.Printed = 'N' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ODLN.Printed = 'Y' AND ODLN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 END AS 'Print Status',

ODLN.DocEntry,
 
ODLN.CardCode,

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        DLN12.StreetS     AS '1Ship',

    DLN12.StreetNoS   AS '2Ship',

    DLN12.BlockS      AS '3Ship',

    DLN12.CityS       AS '4Ship',

    DLN12.CountyS     AS '5Ship',

    DLN12.ZipCodeS    AS '6Ship',

	DLN12.Address3S		AS 'NameShip',

ODLN.CreateDate,

ODLN.DocNum,

ODLN.DocDueDate,

ODLN.DocDate,
    NULL AS 'unitmsr',
    NULL AS 'Quantity',
    NULL AS 'BaseDocNum',
    CAST(NULL AS INT) AS 'No.',
    DLN1.LineNum AS 'Line No.',
    CAST(DLN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'ItemCode',

NNM1.BeginStr,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

CRD1.GlblLocNum,

OCRD.Phone1,

ISNULL(OCPR.Cellolar,'') As 'Phone2',

OCRD.Fax,

OCRD.LicTradNum,

OCTG.pymntgroup,

OSLP.SlpName,

ODLN.Comments,

ODLN.NumAtCard,
    'T' AS 'LineType',

OCPR.E_MailL AS ContactMail,

OSLP.SlpName as 'Sale Name contact',

OHEM.mobile as 'Mobile',

OHEM.Email as 'Email-Sale',

DLN1.Project ,

OUGP.UgpCode,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL
,
    DLN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DLN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (DLN1.Project)) AS 'ProjectName'
FROM ODRF ODLN
INNER JOIN DRF10 DLN10 ON ODLN.DocEntry = DLN10.DocEntry
LEFT JOIN DRF1 DLN1 ON DLN10.DocEntry = DLN1.DocEntry AND DLN10.AftLineNum = DLN1.VisOrder
LEFT JOIN OHEM ON ODLN.SlpCode = OHEM.salesPrson
LEFT JOIN DRF12 DLN12 ON ODLN.DocEntry = DLN12.DocEntry 
LEFT JOIN NNM1 ON ODLN.Series = NNM1.Series 
LEFT JOIN OCRD ON ODLN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ODLN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODLN.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCTG ON ODLN.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODLN.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON DLN1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON ODLN.UserSign = OUSR.USERID
LEFT JOIN OUGP ON DLN1.UomCode = OUGP.UgpCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODLN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ODLN.DocEntry  = '{?DocKey@}'
  AND {?ObjectId@} = '112' AND ODLN.ObjType = '15'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

