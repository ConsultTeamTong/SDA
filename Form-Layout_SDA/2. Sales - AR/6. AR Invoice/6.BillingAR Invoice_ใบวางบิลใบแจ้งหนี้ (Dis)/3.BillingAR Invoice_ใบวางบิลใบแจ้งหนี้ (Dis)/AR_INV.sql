-- ============================================================
-- Report: 3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Path:   3.BillingAR Invoice_ใบวางบิลใบแจ้งหนี้ (Dis).rpt
Extracted: 2026-09-01 17:12:17
-- Source: Main Report
-- Table:  AR_INV
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OINV.DocEntry,

NNM1.BeginStr,

OINV.DocNum,

OINV.DocDate,

OINV.CardCode,

INV1.UnitMsr,

OINV.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OINV.LicTradNum,

OINV.NumAtCard,

OCTG.PymntGroup,

OINV.DocDueDate,

(INV1.VisOrder + 1) As 'No.',

INV1.LineNum as 'Line No.',
 
INV1.ItemCode,

INV1.U_SLD_Dis_Amount,

INV1.Dscription as 'Dscription',

INV1.Quantity,

INV1.DiscPrcnt,

OINV.Comments,

OINV.DocCur,

INV1.PriceBefDi,

CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',
    (SELECT CASE WHEN OINV.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM INV1 L WHERE L.DocEntry = OINV.DocEntry) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',

INV1.LineType,

QPJ.Project,

OCPR.Name,

OCPR.Tel1,

OCPR.E_MailL,

INV12.StreetB,

INV12.StreetNoB,

INV12.BlockB,

INV12.CityB,

INV12.ZipCodeB,

INV12.CountyB,

INV12.CountryB
,
    INV1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OINV
Left JOIN INV1 ON OINV.DocEntry = INV1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM INV1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '13'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OINV.DocEntry,

NNM1.BeginStr,

OINV.DocNum,

OINV.DocDate,

OINV.CardCode,
    NULL AS 'UnitMsr',

OINV.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OINV.LicTradNum,

OINV.NumAtCard,

OCTG.PymntGroup,

OINV.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    INV1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    NULL AS 'U_SLD_Dis_Amount',
    CAST(INV10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'DiscPrcnt',

OINV.Comments,

OINV.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',
    (SELECT CASE WHEN OINV.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM INV1 L WHERE L.DocEntry = OINV.DocEntry) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
    'T' AS 'LineType',

QPJ.Project,

OCPR.Name,

OCPR.Tel1,

OCPR.E_MailL,

INV12.StreetB,

INV12.StreetNoB,

INV12.BlockB,

INV12.CityB,

INV12.ZipCodeB,

INV12.CountyB,

INV12.CountryB
,
    INV1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    INV10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OINV
INNER JOIN INV10 ON OINV.DocEntry = INV10.DocEntry
LEFT JOIN INV1 ON INV10.DocEntry = INV1.DocEntry AND INV10.AftLineNum = INV1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM INV1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '13'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OINV.DocEntry,

NNM1.BeginStr,

OINV.DocNum,

OINV.DocDate,

OINV.CardCode,

INV1.UnitMsr,

OINV.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OINV.LicTradNum,

OINV.NumAtCard,

OCTG.PymntGroup,

OINV.DocDueDate,

(INV1.VisOrder + 1) As 'No.',

INV1.LineNum as 'Line No.',
 
INV1.ItemCode,

INV1.U_SLD_Dis_Amount,

INV1.Dscription as 'Dscription',

INV1.Quantity,

INV1.DiscPrcnt,

OINV.Comments,

OINV.DocCur,

INV1.PriceBefDi,

CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',
    (SELECT CASE WHEN OINV.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OINV.DocEntry) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',

INV1.LineType,

QPJ.Project,

OCPR.Name,

OCPR.Tel1,

OCPR.E_MailL,

INV12.StreetB,

INV12.StreetNoB,

INV12.BlockB,

INV12.CityB,

INV12.ZipCodeB,

INV12.CountyB,

INV12.CountryB
,
    INV1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OINV
Left JOIN DRF1 INV1 ON OINV.DocEntry = INV1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN DRF12 INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN DRF11 INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OINV.ObjType = '13'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OINV.DocEntry,

NNM1.BeginStr,

OINV.DocNum,

OINV.DocDate,

OINV.CardCode,
    NULL AS 'UnitMsr',

OINV.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,

OCRD.Fax,

OINV.LicTradNum,

OINV.NumAtCard,

OCTG.PymntGroup,

OINV.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    INV1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    NULL AS 'U_SLD_Dis_Amount',
    CAST(INV10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'DiscPrcnt',

OINV.Comments,

OINV.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',
    (SELECT CASE WHEN OINV.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OINV.DocEntry) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
    'T' AS 'LineType',

QPJ.Project,

OCPR.Name,

OCPR.Tel1,

OCPR.E_MailL,

INV12.StreetB,

INV12.StreetNoB,

INV12.BlockB,

INV12.CityB,

INV12.ZipCodeB,

INV12.CountyB,

INV12.CountryB
,
    INV1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    INV10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OINV
INNER JOIN DRF10 INV10 ON OINV.DocEntry = INV10.DocEntry
LEFT JOIN DRF1 INV1 ON INV10.DocEntry = INV1.DocEntry AND INV10.AftLineNum = INV1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN DRF12 INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN DRF11 INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OINV.ObjType = '13'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
