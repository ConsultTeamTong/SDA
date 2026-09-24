-- ============================================================
-- Report: 1.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
-- Path:   1.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:28
-- Source: Main Report
-- Table:  AR_Retrun_BS
-- ============================================================

-- RPT: 2. Sales - AR\4. Return\2.Retrun_ใบรับคืนสินค้า_(Batch_Serial)\1.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AR_Retrun_BS
-- FIELDS: 41
-- ---------------------------------------------------------------
-- RPT: 2. Sales - AR\4. Return\2.Retrun_ใบรับคืนสินค้า_(Batch_Serial)\1.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
-- SCOPE: main
-- ALIAS: AR_Retrun_BS
-- FIELDS: 41
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        RDN12.StreetS     AS '1Ship',

    RDN12.StreetNoS   AS '2Ship',

    RDN12.BlockS      AS '3Ship',

    RDN12.CityS       AS '4Ship',

    RDN12.CountyS     AS '5Ship',

    RDN12.ZipCodeS    AS '6Ship',

ORDN.[CardCode],

ORDN.[Comments],

RDN1.[ItemCode],

RDN1.[dscription] as 'Dscription',

RDN1.[Quantity],

ORDN.[DocDate],

ORDN.[DocNum],

ORDN.[DocEntry],

NNM1.[BeginStr],

ORDN.[CreateDate],

RDN1.[unitMsr],

(RDN1.[VisOrder]) As 'No.',

RDN1.LineNum as 'Line No.',
 
OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.LicTradNum ,

QPJ.Project,

ORDN.U_SLD_Returnreason ,

ORDN.U_SLD_ReturnTo ,

RDN1.LineType,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

RDN1.LineNum,

RDN10.AftLineNum
,
    RDN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORDN  
INNER JOIN RDN1 ON ORDN.[DocEntry] = RDN1.[DocEntry]
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RDN1 P
    WHERE P.DocEntry = ORDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN RDN10 ON RDN1.[DocEntry] = RDN10.[DocEntry] AND RDN1.VisOrder = RDN10.AftLineNum 
LEFT JOIN RDN12 ON ORDN.DocEntry = RDN12.DocEntry 
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ORDN.[DocEntry] = {?DocKey@}
  AND {?ObjectId@} = '16'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        RDN12.StreetS     AS '1Ship',

    RDN12.StreetNoS   AS '2Ship',

    RDN12.BlockS      AS '3Ship',

    RDN12.CityS       AS '4Ship',

    RDN12.CountyS     AS '5Ship',

    RDN12.ZipCodeS    AS '6Ship',

ORDN.[CardCode],

ORDN.[Comments],
    NULL AS 'ItemCode',
    CAST(RDN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',

ORDN.[DocDate],

ORDN.[DocNum],

ORDN.[DocEntry],

NNM1.[BeginStr],

ORDN.[CreateDate],
    NULL AS 'unitMsr',
    CAST(NULL AS INT) AS 'No.',
    RDN1.LineNum AS 'Line No.',
 
OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.LicTradNum ,

QPJ.Project,

ORDN.U_SLD_Returnreason ,

ORDN.U_SLD_ReturnTo ,
    'T' AS 'LineType',

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,
    NULL AS 'LineNum',

RDN10.AftLineNum
,
    RDN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RDN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORDN  
INNER JOIN RDN10 ON ORDN.DocEntry = RDN10.DocEntry
LEFT JOIN RDN1 ON RDN10.DocEntry = RDN1.DocEntry AND RDN10.AftLineNum = RDN1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM RDN1 P
    WHERE P.DocEntry = ORDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN RDN12 ON ORDN.DocEntry = RDN12.DocEntry 
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ORDN.[DocEntry] = {?DocKey@}
  AND {?ObjectId@} = '16'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        RDN12.StreetS     AS '1Ship',

    RDN12.StreetNoS   AS '2Ship',

    RDN12.BlockS      AS '3Ship',

    RDN12.CityS       AS '4Ship',

    RDN12.CountyS     AS '5Ship',

    RDN12.ZipCodeS    AS '6Ship',

ORDN.[CardCode],

ORDN.[Comments],

RDN1.[ItemCode],

RDN1.[dscription] as 'Dscription',

RDN1.[Quantity],

ORDN.[DocDate],

ORDN.[DocNum],

ORDN.[DocEntry],

NNM1.[BeginStr],

ORDN.[CreateDate],

RDN1.[unitMsr],

(RDN1.[VisOrder]) As 'No.',

RDN1.LineNum as 'Line No.',
 
OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.LicTradNum ,

QPJ.Project,

ORDN.U_SLD_Returnreason ,

ORDN.U_SLD_ReturnTo ,

RDN1.LineType,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

RDN1.LineNum,

RDN10.AftLineNum
,
    RDN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORDN
INNER JOIN DRF1 RDN1 ON ORDN.[DocEntry] = RDN1.[DocEntry]
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF10 RDN10 ON RDN1.[DocEntry] = RDN10.[DocEntry] AND RDN1.VisOrder = RDN10.AftLineNum 
LEFT JOIN DRF12 RDN12 ON ORDN.DocEntry = RDN12.DocEntry 
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ORDN.[DocEntry] = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORDN.ObjType = '16'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

CRD1.Street     AS '1Bill',
CRD1.State        AS StateB,

    CRD1.StreetNo   AS '2Bill',

    CRD1.Block      AS '3Bill',

    CRD1.City       AS '4Bill',

    CRD1.County     AS '5Bill',

    CRD1.ZipCode    AS '6Bill',

        RDN12.StreetS     AS '1Ship',

    RDN12.StreetNoS   AS '2Ship',

    RDN12.BlockS      AS '3Ship',

    RDN12.CityS       AS '4Ship',

    RDN12.CountyS     AS '5Ship',

    RDN12.ZipCodeS    AS '6Ship',

ORDN.[CardCode],

ORDN.[Comments],
    NULL AS 'ItemCode',
    CAST(RDN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',

ORDN.[DocDate],

ORDN.[DocNum],

ORDN.[DocEntry],

NNM1.[BeginStr],

ORDN.[CreateDate],
    NULL AS 'unitMsr',
    CAST(NULL AS INT) AS 'No.',
    RDN1.LineNum AS 'Line No.',
 
OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.LicTradNum ,

QPJ.Project,

ORDN.U_SLD_Returnreason ,

ORDN.U_SLD_ReturnTo ,
    'T' AS 'LineType',

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,
    NULL AS 'LineNum',

RDN10.AftLineNum
,
    RDN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RDN10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF ORDN
INNER JOIN DRF10 RDN10 ON ORDN.DocEntry = RDN10.DocEntry
LEFT JOIN DRF1 RDN1 ON RDN10.DocEntry = RDN1.DocEntry AND RDN10.AftLineNum = RDN1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ORDN.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 RDN12 ON ORDN.DocEntry = RDN12.DocEntry 
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE ORDN.[DocEntry] = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORDN.ObjType = '16'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

