-- ============================================================
-- Report: 1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Path:   1.AP Invoice_ใบแจ้งหนี้_(Batch_Serial).rpt
Extracted: 2026-09-03 10:51:40
-- Source: Main Report
-- Table:  AP_INV_BN
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

PCH12.StreetB     AS '1Bill',

    PCH12.StreetNoB   AS '2Bill',

    PCH12.BlockB      AS '3Bill',

    PCH12.CityB       AS '4Bill',

    PCH12.CountyB     AS '5Bill',

    PCH12.ZipCodeB    AS '6Bill',

        PCH12.StreetS     AS '1Ship',

    PCH12.StreetNoS   AS '2Ship',

    PCH12.BlockS      AS '3Ship',

    PCH12.CityS       AS '4Ship',

    PCH12.CountyS     AS '5Ship',

    PCH12.ZipCodeS    AS '6Ship',

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OPCH.DocEntry,

OPCH.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,

OCRD.LicTradNum,
  
NNM1.BeginStr,
 
OPCH.DocNum,
 
OPCH.DocDate,
 
OPCH.DocDueDate,
 
OCTG.PymntGroup,
 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',

(PCH1.VisOrder + 1) AS 'No.',
 
PCH1.LineNum as 'Line No.',
 
PCH1.ItemCode,
 
PCH1.Dscription,
 
PCH1.Quantity,

PCH1.PriceBefDi,
 
PCH1.DiscPrcnt As 'LDiscPrcnt',

CASE WHEN OPCH.DocCur = 'THB' THEN PCH1.LineTotal ELSE PCH1.TotalFrgn END AS 'LineTotal',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.VatSum ELSE OPCH.VatSumFC END AS 'VatSum',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DiscSum ELSE OPCH.DiscSumFC END AS 'DiscSum',

OPCH.DiscPrcnt,

OPCH.DocCur,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DocTotal ELSE OPCH.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPCH.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PCH1 L WHERE L.DocEntry = OPCH.DocEntry) AS 'Sum_LineTotal_All',

PCH1.unitMsr,

OPCH.Comments,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DpmAmnt ELSE OPCH.DpmAmntFC END AS 'DpmAmnt',

PCH1.LineType,

QPJ.Project
,
    PCH1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPCH
INNER JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PCH1 P
    WHERE P.DocEntry = OPCH.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN PCH12 ON OPCH.DocEntry = PCH12.DocEntry
LEFT JOIN OITM ON PCH1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code, oadm
WHERE OPCH.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '18'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

PCH12.StreetB     AS '1Bill',

    PCH12.StreetNoB   AS '2Bill',

    PCH12.BlockB      AS '3Bill',

    PCH12.CityB       AS '4Bill',

    PCH12.CountyB     AS '5Bill',

    PCH12.ZipCodeB    AS '6Bill',

        PCH12.StreetS     AS '1Ship',

    PCH12.StreetNoS   AS '2Ship',

    PCH12.BlockS      AS '3Ship',

    PCH12.CityS       AS '4Ship',

    PCH12.CountyS     AS '5Ship',

    PCH12.ZipCodeS    AS '6Ship',

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OPCH.DocEntry,

OPCH.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,

OCRD.LicTradNum,
  
NNM1.BeginStr,
 
OPCH.DocNum,
 
OPCH.DocDate,
 
OPCH.DocDueDate,
 
OCTG.PymntGroup,
 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',
    CAST(NULL AS INT) AS 'No.',
    PCH1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PCH10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LDiscPrcnt',
    NULL AS 'LineTotal',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.VatSum ELSE OPCH.VatSumFC END AS 'VatSum',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DiscSum ELSE OPCH.DiscSumFC END AS 'DiscSum',

OPCH.DiscPrcnt,

OPCH.DocCur,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DocTotal ELSE OPCH.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPCH.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PCH1 L WHERE L.DocEntry = OPCH.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',

OPCH.Comments,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DpmAmnt ELSE OPCH.DpmAmntFC END AS 'DpmAmnt',
    'T' AS 'LineType',

QPJ.Project
,
    PCH1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PCH10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPCH
INNER JOIN PCH10 ON OPCH.DocEntry = PCH10.DocEntry
LEFT JOIN PCH1 ON PCH10.DocEntry = PCH1.DocEntry AND PCH10.AftLineNum = PCH1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM PCH1 P
    WHERE P.DocEntry = OPCH.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN PCH12 ON OPCH.DocEntry = PCH12.DocEntry

LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code, oadm
WHERE OPCH.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '18'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

PCH12.StreetB     AS '1Bill',

    PCH12.StreetNoB   AS '2Bill',

    PCH12.BlockB      AS '3Bill',

    PCH12.CityB       AS '4Bill',

    PCH12.CountyB     AS '5Bill',

    PCH12.ZipCodeB    AS '6Bill',

        PCH12.StreetS     AS '1Ship',

    PCH12.StreetNoS   AS '2Ship',

    PCH12.BlockS      AS '3Ship',

    PCH12.CityS       AS '4Ship',

    PCH12.CountyS     AS '5Ship',

    PCH12.ZipCodeS    AS '6Ship',

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OPCH.DocEntry,

OPCH.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,

OCRD.LicTradNum,
  
NNM1.BeginStr,
 
OPCH.DocNum,
 
OPCH.DocDate,
 
OPCH.DocDueDate,
 
OCTG.PymntGroup,
 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',

(PCH1.VisOrder + 1) AS 'No.',
 
PCH1.LineNum as 'Line No.',
 
PCH1.ItemCode,
 
PCH1.Dscription,
 
PCH1.Quantity,

PCH1.PriceBefDi,
 
PCH1.DiscPrcnt As 'LDiscPrcnt',

CASE WHEN OPCH.DocCur = 'THB' THEN PCH1.LineTotal ELSE PCH1.TotalFrgn END AS 'LineTotal',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.VatSum ELSE OPCH.VatSumFC END AS 'VatSum',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DiscSum ELSE OPCH.DiscSumFC END AS 'DiscSum',

OPCH.DiscPrcnt,

OPCH.DocCur,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DocTotal ELSE OPCH.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPCH.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPCH.DocEntry) AS 'Sum_LineTotal_All',

PCH1.unitMsr,

OPCH.Comments,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DpmAmnt ELSE OPCH.DpmAmntFC END AS 'DpmAmnt',

PCH1.LineType,

QPJ.Project
,
    PCH1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPCH
INNER JOIN DRF1 PCH1 ON OPCH.DocEntry = PCH1.DocEntry
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPCH.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 PCH12 ON OPCH.DocEntry = PCH12.DocEntry
LEFT JOIN OITM ON PCH1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code, oadm
WHERE OPCH.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPCH.ObjType = '18'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

PCH12.StreetB     AS '1Bill',

    PCH12.StreetNoB   AS '2Bill',

    PCH12.BlockB      AS '3Bill',

    PCH12.CityB       AS '4Bill',

    PCH12.CountyB     AS '5Bill',

    PCH12.ZipCodeB    AS '6Bill',

        PCH12.StreetS     AS '1Ship',

    PCH12.StreetNoS   AS '2Ship',

    PCH12.BlockS      AS '3Ship',

    PCH12.CityS       AS '4Ship',

    PCH12.CountyS     AS '5Ship',

    PCH12.ZipCodeS    AS '6Ship',

CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

 CASE
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',

OPCH.DocEntry,

OPCH.[Address],

OCRD.U_SLD_Title,

OCRD.U_SLD_FullName,

OCRD.Phone1,
 
OCRD.Fax,

OCRD.LicTradNum,
  
NNM1.BeginStr,
 
OPCH.DocNum,
 
OPCH.DocDate,
 
OPCH.DocDueDate,
 
OCTG.PymntGroup,
 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',
    CAST(NULL AS INT) AS 'No.',
    PCH1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PCH10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LDiscPrcnt',
    NULL AS 'LineTotal',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.VatSum ELSE OPCH.VatSumFC END AS 'VatSum',

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DiscSum ELSE OPCH.DiscSumFC END AS 'DiscSum',

OPCH.DiscPrcnt,

OPCH.DocCur,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DocTotal ELSE OPCH.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPCH.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPCH.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',

OPCH.Comments,

CASE WHEN OPCH.DocCur = 'THB' THEN OPCH.DpmAmnt ELSE OPCH.DpmAmntFC END AS 'DpmAmnt',
    'T' AS 'LineType',

QPJ.Project
,
    PCH1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PCH10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPCH
INNER JOIN DRF10 PCH10 ON OPCH.DocEntry = PCH10.DocEntry
LEFT JOIN DRF1 PCH1 ON PCH10.DocEntry = PCH1.DocEntry AND PCH10.AftLineNum = PCH1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OPCH.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 PCH12 ON OPCH.DocEntry = PCH12.DocEntry

LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B' ) 
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code, oadm
WHERE OPCH.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND OPCH.ObjType = '18'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
