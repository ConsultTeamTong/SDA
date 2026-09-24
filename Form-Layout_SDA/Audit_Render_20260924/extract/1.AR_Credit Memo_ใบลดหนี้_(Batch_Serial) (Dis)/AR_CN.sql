-- ============================================================
-- Report: 1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Path:   1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- Extracted: 2026-09-24 10:20:03
-- Source: Main Report
-- Table:  AR_CN
-- ============================================================

-- RPT: 2. Sales - AR\7. AR Credit Memo\4.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis)\1.AR_Credit Memo_ใบลดหนี้_(Batch_Serial) (Dis).rpt
-- SCOPE: main
-- ALIAS: AR_CN
-- FIELDS: 54
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',

 CASE
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

ORIN.CardCode,

ORIN.[Address],

ORIN.LicTradNum,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OSLP.SlpName,

NNM1.BeginStr,

ORIN.DocNum,

ORIN.DocDate,

(RIN1.VisOrder + 1) As 'No.',

RIN1.LineNum as 'Line No.',

RIN1.ItemCode,

RIN1.Dscription as 'Dscription',

RIN1.LineType as 'LineType',

RIN1.Quantity,

RIN1.PriceBefDi,

CASE WHEN ORIN.DocCur = 'THB' THEN RIN1.LineTotal ELSE RIN1.TotalFrgn END AS 'LineTotal',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.VatSum ELSE ORIN.VatSumFC END AS 'VatSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DiscSum ELSE ORIN.DiscSumFC END AS 'DiscSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DocTotal ELSE ORIN.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORIN.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM RIN1 L WHERE L.DocEntry = ORIN.DocEntry) AS 'Sum_LineTotal_All',

ORIN.DocCur,

ORIN.DocEntry,

ORIN.CreateDate,

RIN1.unitmsr,

orin.Printed,

COALESCE(T10.[Name], ORIN.U_CN_05) AS 'Reason_CN',

ORIN.comments
,
OINV.VatSum as 'InvVat'
,
OINV.VatSumFC as 'InvVatFC',

Ref_NNM.BeginStr                                  AS 'Ref_BeginStr',

Ref_OINV.DocNum                                   AS 'Ref_DocNum',

Ref_OINV.DocDate                                  AS 'Ref_DocDate',

CASE WHEN OINV.DocCur = 'THB'
     THEN Ref_OINV.DocTotal
     ELSE Ref_OINV.DocTotalFC
END                                        AS 'Ref_DocTotal',

RIN1.Project,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

Rin1.DiscPrcnt,

RIN1.U_SLD_Dis_Amount

,
    RIN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (RIN1.Project)) AS 'ProjectName'
FROM ORIN
INNER JOIN RIN1 ON ORIN.DocEntry = RIN1.DocEntry
INNER JOIN RIN12 ON ORIN.DocEntry = RIN12.DocEntry
left join INV1 on RIN1.BaseEntry = INV1.DocEntry and RIN1.BaseLine = INV1.LineNum and RIN1.BaseType = 13
Left join OINV on OINV.DocEntry = inv1.DocEntry

LEFT JOIN OITM ON RIN1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON ORIN.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORIN.PayToCode
LEFT JOIN OCPR ON ORIN.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORIN.Series = NNM1.Series
LEFT JOIN OCTG ON ORIN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORIN.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORIN.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_RD] T10 on ORIN.U_CN_04 = T10.code
LEFT JOIN OUSR ON ORIN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RIN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORIN.U_SLD_LVatBranch = BRANCH.Code
LEFT JOIN OINV Ref_OINV ON RIN1.BaseEntry = Ref_OINV.DocEntry AND RIN1.BaseType = 13  
LEFT JOIN NNM1 Ref_NNM  ON Ref_OINV.Series = Ref_NNM.Series
CROSS JOIN oadm

WHERE ORIN.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '14'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

OCPR.Name AS 'Coontact',


 CASE
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

ORIN.CardCode,

ORIN.[Address],

ORIN.LicTradNum,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OSLP.SlpName,

NNM1.BeginStr,

ORIN.DocNum,

ORIN.DocDate,
    CAST(NULL AS INT) AS 'No.',
    RIN1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RIN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    'T' AS 'LineType',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.VatSum ELSE ORIN.VatSumFC END AS 'VatSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DiscSum ELSE ORIN.DiscSumFC END AS 'DiscSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DocTotal ELSE ORIN.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORIN.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM RIN1 L WHERE L.DocEntry = ORIN.DocEntry) AS 'Sum_LineTotal_All',

ORIN.DocCur,

ORIN.DocEntry,

ORIN.CreateDate,
    NULL AS 'unitmsr',

orin.Printed,

COALESCE(T10.[Name], ORIN.U_CN_05) AS 'Reason_CN',

ORIN.comments
,
OINV.VatSum as 'InvVat'
,
OINV.VatSumFC as 'InvVatFC',

Ref_NNM.BeginStr                                  AS 'Ref_BeginStr',

Ref_OINV.DocNum                                   AS 'Ref_DocNum',

Ref_OINV.DocDate                                  AS 'Ref_DocDate',

CASE WHEN OINV.DocCur = 'THB'
     THEN Ref_OINV.DocTotal
     ELSE Ref_OINV.DocTotalFC
END                                        AS 'Ref_DocTotal',
    NULL AS 'Project',

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',
    RIN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RIN10.LineSeq AS 'Sort_Seq'

,
    NULL AS 'ProjectName'
FROM ORIN
INNER JOIN RIN10 ON ORIN.DocEntry = RIN10.DocEntry
LEFT JOIN RIN1 ON RIN10.DocEntry = RIN1.DocEntry AND RIN10.AftLineNum = RIN1.VisOrder
INNER JOIN RIN12 ON ORIN.DocEntry = RIN12.DocEntry
left join INV1 on RIN1.BaseEntry = INV1.DocEntry and RIN1.BaseLine = INV1.LineNum and RIN1.BaseType = 13
Left join OINV on OINV.DocEntry = inv1.DocEntry


LEFT JOIN OCRD ON ORIN.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORIN.PayToCode
LEFT JOIN OCPR ON ORIN.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORIN.Series = NNM1.Series
LEFT JOIN OCTG ON ORIN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORIN.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORIN.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_RD] T10 on ORIN.U_CN_04 = T10.code
LEFT JOIN OUSR ON ORIN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RIN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORIN.U_SLD_LVatBranch = BRANCH.Code
LEFT JOIN OINV Ref_OINV ON RIN1.BaseEntry = Ref_OINV.DocEntry AND RIN1.BaseType = 13  
LEFT JOIN NNM1 Ref_NNM  ON Ref_OINV.Series = Ref_NNM.Series
CROSS JOIN oadm

WHERE ORIN.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '14'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',


 CASE
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

ORIN.CardCode,

ORIN.[Address],

ORIN.LicTradNum,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OSLP.SlpName,

NNM1.BeginStr,

ORIN.DocNum,

ORIN.DocDate,

(RIN1.VisOrder + 1) As 'No.',

RIN1.LineNum as 'Line No.',

RIN1.ItemCode,

RIN1.Dscription as 'Dscription',

RIN1.LineType as 'LineType',

RIN1.Quantity,

RIN1.PriceBefDi,

CASE WHEN ORIN.DocCur = 'THB' THEN RIN1.LineTotal ELSE RIN1.TotalFrgn END AS 'LineTotal',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.VatSum ELSE ORIN.VatSumFC END AS 'VatSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DiscSum ELSE ORIN.DiscSumFC END AS 'DiscSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DocTotal ELSE ORIN.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORIN.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ORIN.DocEntry) AS 'Sum_LineTotal_All',

ORIN.DocCur,

ORIN.DocEntry,

ORIN.CreateDate,

RIN1.unitmsr,

orin.Printed,

COALESCE(T10.[Name], ORIN.U_CN_05) AS 'Reason_CN',

ORIN.comments
,
OINV.VatSum as 'InvVat'
,
OINV.VatSumFC as 'InvVatFC',

Ref_NNM.BeginStr                                  AS 'Ref_BeginStr',

Ref_OINV.DocNum                                   AS 'Ref_DocNum',

Ref_OINV.DocDate                                  AS 'Ref_DocDate',

CASE WHEN OINV.DocCur = 'THB'
     THEN Ref_OINV.DocTotal
     ELSE Ref_OINV.DocTotalFC
END                                        AS 'Ref_DocTotal',

RIN1.Project,

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,

Rin1.DiscPrcnt,

RIN1.U_SLD_Dis_Amount

,
    RIN1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (RIN1.Project)) AS 'ProjectName'
FROM ODRF ORIN
INNER JOIN DRF1 RIN1 ON ORIN.DocEntry = RIN1.DocEntry
INNER JOIN DRF12 RIN12 ON ORIN.DocEntry = RIN12.DocEntry
left join INV1 on RIN1.BaseEntry = INV1.DocEntry and RIN1.BaseLine = INV1.LineNum and RIN1.BaseType = 13
Left join OINV on OINV.DocEntry = inv1.DocEntry

LEFT JOIN OITM ON RIN1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON ORIN.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORIN.PayToCode
LEFT JOIN OCPR ON ORIN.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORIN.Series = NNM1.Series
LEFT JOIN OCTG ON ORIN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORIN.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORIN.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_RD] T10 on ORIN.U_CN_04 = T10.code
LEFT JOIN OUSR ON ORIN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RIN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORIN.U_SLD_LVatBranch = BRANCH.Code
LEFT JOIN OINV Ref_OINV ON RIN1.BaseEntry = Ref_OINV.DocEntry AND RIN1.BaseType = 13  
LEFT JOIN NNM1 Ref_NNM  ON Ref_OINV.Series = Ref_NNM.Series
CROSS JOIN oadm

WHERE ORIN.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORIN.ObjType = '14'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

OCPR.Name AS 'Coontact',


 CASE
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORIN.Printed = 'N' AND ORIN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN ORIN.Printed = 'Y' AND ORIN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

ORIN.CardCode,

ORIN.[Address],

ORIN.LicTradNum,

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OSLP.SlpName,

NNM1.BeginStr,

ORIN.DocNum,

ORIN.DocDate,
    CAST(NULL AS INT) AS 'No.',
    RIN1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RIN10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    'T' AS 'LineType',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.VatSum ELSE ORIN.VatSumFC END AS 'VatSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DiscSum ELSE ORIN.DiscSumFC END AS 'DiscSum',

CASE WHEN ORIN.DocCur = 'THB' THEN ORIN.DocTotal ELSE ORIN.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORIN.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ORIN.DocEntry) AS 'Sum_LineTotal_All',

ORIN.DocCur,

ORIN.DocEntry,

ORIN.CreateDate,
    NULL AS 'unitmsr',

orin.Printed,

COALESCE(T10.[Name], ORIN.U_CN_05) AS 'Reason_CN',

ORIN.comments
,
OINV.VatSum as 'InvVat'
,
OINV.VatSumFC as 'InvVatFC',

Ref_NNM.BeginStr                                  AS 'Ref_BeginStr',

Ref_OINV.DocNum                                   AS 'Ref_DocNum',

Ref_OINV.DocDate                                  AS 'Ref_DocDate',

CASE WHEN OINV.DocCur = 'THB'
     THEN Ref_OINV.DocTotal
     ELSE Ref_OINV.DocTotalFC
END                                        AS 'Ref_DocTotal',
    NULL AS 'Project',

OCPR.Name,

OCPR.Cellolar AS 'Tel1',

OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,

CRD1.StreetNo AS StreetNoB,

CRD1.Block AS BlockB,

CRD1.City AS CityB,

CRD1.ZipCode AS ZipCodeB,

CRD1.County AS CountyB,

CRD1.Country AS CountryB,
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',
    RIN1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RIN10.LineSeq AS 'Sort_Seq'

,
    NULL AS 'ProjectName'
FROM ODRF ORIN
INNER JOIN DRF10 RIN10 ON ORIN.DocEntry = RIN10.DocEntry
LEFT JOIN DRF1 RIN1 ON RIN10.DocEntry = RIN1.DocEntry AND RIN10.AftLineNum = RIN1.VisOrder
INNER JOIN DRF12 RIN12 ON ORIN.DocEntry = RIN12.DocEntry
left join INV1 on RIN1.BaseEntry = INV1.DocEntry and RIN1.BaseLine = INV1.LineNum and RIN1.BaseType = 13
Left join OINV on OINV.DocEntry = inv1.DocEntry


LEFT JOIN OCRD ON ORIN.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode AND CRD1.AdresType = 'B' AND CRD1.[Address] = ORIN.PayToCode
LEFT JOIN OCPR ON ORIN.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORIN.Series = NNM1.Series
LEFT JOIN OCTG ON ORIN.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ORIN.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ORIN.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_RD] T10 on ORIN.U_CN_04 = T10.code
LEFT JOIN OUSR ON ORIN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RIN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORIN.U_SLD_LVatBranch = BRANCH.Code
LEFT JOIN OINV Ref_OINV ON RIN1.BaseEntry = Ref_OINV.DocEntry AND RIN1.BaseType = 13  
LEFT JOIN NNM1 Ref_NNM  ON Ref_OINV.Series = Ref_NNM.Series
CROSS JOIN oadm

WHERE ORIN.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ORIN.ObjType = '14'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
