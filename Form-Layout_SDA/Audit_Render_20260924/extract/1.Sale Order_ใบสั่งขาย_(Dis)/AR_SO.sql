-- ============================================================
-- Report: 1.Sale Order_ใบสั่งขาย_(Dis).rpt
-- Path:   1.Sale Order_ใบสั่งขาย_(Dis).rpt
-- Extracted: 2026-09-24 10:20:30
-- Source: Main Report
-- Table:  AR_SO
-- ============================================================

-- RPT: 2. Sales - AR\2. Sales Order\1.Sale Order_ใบสั่งขาย_(Dis)\1.Sale Order_ใบสั่งขาย_(Dis).rpt
-- SCOPE: main
-- ALIAS: AR_SO
-- FIELDS: 63
-- ---------------------------------------------------------------
-- RPT: 2. Sales - AR\2. Sales Order\1.Sale Order_ใบสั่งขาย_(Dis)\1.Sale Order_ใบสั่งขาย_(Dis).rpt
-- SCOPE: main
-- ALIAS: AR_SO
-- FIELDS: 63
-- ---------------------------------------------------------------
-- 1.1 item rows of the real document
SELECT DISTINCT

    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
 -- เปลี่ยนชื่อไม่ให้ซ้ำ
    OCPR.Name AS 'Coontact',

    ORDR.DocEntry,

    ORDR.CardCode,

    ORDR.Address2,

    ORDR.[Address],

    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CRD1.GlblLocNum,

    OCRD.Phone1,

    ISNULL(OCRD.Phone2, '') AS 'Phone2',

    OCRD.Fax,

    OCRD.LicTradNum,

    NNM1.BeginStr,

    ORDR.DocNum,

    ORDR.DocDate,

    ORDR.DocDueDate,

    OCTG.PymntGroup,

    ORDR.NumAtCard,

    RDR1.VisOrder + 1 AS 'No.',

    RDR1.LineNum AS 'Line No.',
 
    RDR1.ItemCode,

    RDR1.Dscription AS 'Dscription',

    RDR1.Quantity,

    RDR1.PriceBefDi,

    CASE WHEN ORDR.DocCur = 'THB' THEN RDR1.LineTotal ELSE RDR1.TotalFrgn END AS 'LineTotal',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DiscSum ELSE ORDR.DiscSumFC END AS 'DiscSum',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.VatSum ELSE ORDR.VatSumFC END AS 'VatSum',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DocTotal ELSE ORDR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORDR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM RDR1 L WHERE L.DocEntry = ORDR.DocEntry) AS 'Sum_LineTotal_All',

    ORDR.DiscPrcnt AS 'DiscP',

    ORDR.DocCur,

    RDR1.unitMsr,

    ORDR.Comments,

    RDR1.LineType,

    QPJ.Project,

    OCPR.E_MailL,

    OSLP.SlpName AS 'Sale Name contact',

    OHEM.Mobile AS 'Mobile',

    OHEM.Email AS 'Email-Sale',

    CRD1.Street     AS 'Street / PO Box12',

    CRD1.StreetNo   AS 'Street No.12',

    CRD1.Block      AS 'Block12',

    CRD1.City       AS 'City12',

    CRD1.ZipCode    AS 'Zip Code12',

    CRD1.County     AS 'County12',

    CRD1.State      AS 'State12',

    CRD1.Country    AS 'Country/Region12',

    RDR12.Streets     ,

    RDR12.StreetNos   ,

    RDR12.Blocks      ,

    RDR12.Citys       ,

    RDR12.ZipCodes    ,

    RDR12.Countys     ,

    RDR12.States      ,

    RDR12.Countrys    ,

    RDR1.U_SLD_Dis_Amount,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
    -- ลบ OCPR.E_MailL ตัวที่ซ้ำออก

,
    RDR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORDR   
INNER JOIN RDR1 ON ORDR.DocEntry = RDR1.DocEntry 
-- ใช้ OUTER APPLY ดึง Project เพื่อกันข้อมูลเบิ้ลแทนการ Join RDR1 แบบเก่า
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM RDR1 P 
    WHERE P.DocEntry = ORDR.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ORDR.SlpCode = OHEM.salesPrson
LEFT JOIN OITM ON RDR1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ORDR.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ORDR.CardCode = CRD1.CardCode AND ORDR.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B' ) 
LEFT JOIN OCPR ON ORDR.CardCode = OCPR.CardCode AND ORDR.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORDR.Series = NNM1.Series 
LEFT JOIN OCTG ON ORDR.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ORDR.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE 
LEFT JOIN RDR12 ON ORDR.DocEntry = RDR12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDR.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM

WHERE ORDR.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '17'


UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
 -- เปลี่ยนชื่อไม่ให้ซ้ำ
    OCPR.Name AS 'Coontact',

    ORDR.DocEntry,

    ORDR.CardCode,

    ORDR.Address2,

    ORDR.[Address],

    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CRD1.GlblLocNum,

    OCRD.Phone1,

    ISNULL(OCRD.Phone2, '') AS 'Phone2',

    OCRD.Fax,

    OCRD.LicTradNum,

    NNM1.BeginStr,

    ORDR.DocNum,

    ORDR.DocDate,

    ORDR.DocDueDate,

    OCTG.PymntGroup,

    ORDR.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    RDR1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RDR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DiscSum ELSE ORDR.DiscSumFC END AS 'DiscSum',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.VatSum ELSE ORDR.VatSumFC END AS 'VatSum',

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DocTotal ELSE ORDR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ORDR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM RDR1 L WHERE L.DocEntry = ORDR.DocEntry) AS 'Sum_LineTotal_All',

    ORDR.DiscPrcnt AS 'DiscP',

    ORDR.DocCur,
    NULL AS 'unitMsr',

    ORDR.Comments,
    'T' AS 'LineType',

    QPJ.Project,

    OCPR.E_MailL,

    OSLP.SlpName AS 'Sale Name contact',

    OHEM.Mobile AS 'Mobile',

    OHEM.Email AS 'Email-Sale',

    CRD1.Street     AS 'Street / PO Box12',

    CRD1.StreetNo   AS 'Street No.12',

    CRD1.Block      AS 'Block12',

    CRD1.City       AS 'City12',

    CRD1.ZipCode    AS 'Zip Code12',

    CRD1.County     AS 'County12',

    CRD1.State      AS 'State12',

    CRD1.Country    AS 'Country/Region12',

    RDR12.Streets     ,

    RDR12.StreetNos   ,

    RDR12.Blocks      ,

    RDR12.Citys       ,

    RDR12.ZipCodes    ,

    RDR12.Countys     ,

    RDR12.States      ,

    RDR12.Countrys    ,
    NULL AS 'U_SLD_Dis_Amount',

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'
    -- ลบ OCPR.E_MailL ตัวที่ซ้ำออก

,
    RDR1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RDR10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ORDR   
INNER JOIN RDR10 ON ORDR.DocEntry = RDR10.DocEntry
LEFT JOIN RDR1 ON RDR10.DocEntry = RDR1.DocEntry AND RDR10.AftLineNum = RDR1.VisOrder
-- ใช้ OUTER APPLY ดึง Project เพื่อกันข้อมูลเบิ้ลแทนการ Join RDR1 แบบเก่า
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM RDR1 P 
    WHERE P.DocEntry = ORDR.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ORDR.SlpCode = OHEM.salesPrson

LEFT JOIN OCRD ON ORDR.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ORDR.CardCode = CRD1.CardCode AND ORDR.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B' ) 
LEFT JOIN OCPR ON ORDR.CardCode = OCPR.CardCode AND ORDR.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ORDR.Series = NNM1.Series 
LEFT JOIN OCTG ON ORDR.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ORDR.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE 
LEFT JOIN RDR12 ON ORDR.DocEntry = RDR12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDR.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM

WHERE ORDR.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '17'


UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
 
    OCPR.Name AS 'Coontact',

    ODRF.DocEntry,

    ODRF.CardCode,

    ODRF.Address2,

    ODRF.[Address],

    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CRD1.GlblLocNum,

    OCRD.Phone1,

    ISNULL(OCRD.Phone2, '') AS 'Phone2',

    OCRD.Fax,

    OCRD.LicTradNum,

    NNM1.BeginStr,

    ODRF.DocNum,

    ODRF.DocDate,

    ODRF.DocDueDate,

    OCTG.PymntGroup,

    ODRF.NumAtCard,

    DRF1.VisOrder + 1 AS 'No.',

    DRF1.LineNum AS 'Line No.',
 
    DRF1.ItemCode,

    DRF1.Dscription AS 'Dscription',

    DRF1.Quantity,

    DRF1.PriceBefDi,

    CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END AS 'LineTotal',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',

    ODRF.DocCur,

    DRF1.unitMsr,

    ODRF.Comments,

    DRF1.LineType,

    QPJ.Project,

    OCPR.E_MailL,

    OSLP.SlpName AS 'Sale Name contact',

    OHEM.Mobile AS 'Mobile',

    OHEM.Email AS 'Email-Sale',

    CRD1.Street     AS 'Street / PO Box12',

    CRD1.StreetNo   AS 'Street No.12',

    CRD1.Block      AS 'Block12',

    CRD1.City       AS 'City12',

    CRD1.ZipCode    AS 'Zip Code12',

    CRD1.County     AS 'County12',

    CRD1.State      AS 'State12',

    CRD1.Country    AS 'Country/Region12',

    DRF12.Streets     ,

    DRF12.StreetNos   ,

    DRF12.Blocks      ,

    DRF12.Citys       ,

    DRF12.ZipCodes    ,

    DRF12.Countys     ,

    DRF12.States      ,

    DRF12.Countrys    ,

    DRF1.U_SLD_Dis_Amount,

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'

,
    DRF1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF   
INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry 
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DRF1 P 
    WHERE P.DocEntry = ODRF.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OITM ON DRF1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B' ) 
LEFT JOIN OCPR ON ODRF.CardCode = OCPR.CardCode AND ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series 
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODRF.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE 
LEFT JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM

-- เช็ค Draft ของ Sales Order (ObjType = 17)
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '17'

-- ========================================================
-- การเรียงลำดับ (ORDER BY ต้องอยู่ล่างสุดของการทำ UNION)
-- ========================================================

UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
 
    OCPR.Name AS 'Coontact',

    ODRF.DocEntry,

    ODRF.CardCode,

    ODRF.Address2,

    ODRF.[Address],

    OCRD.U_SLD_Title,

    OCRD.U_SLD_FullName,

    CRD1.GlblLocNum,

    OCRD.Phone1,

    ISNULL(OCRD.Phone2, '') AS 'Phone2',

    OCRD.Fax,

    OCRD.LicTradNum,

    NNM1.BeginStr,

    ODRF.DocNum,

    ODRF.DocDate,

    ODRF.DocDueDate,

    OCTG.PymntGroup,

    ODRF.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    DRF1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(DRF10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',

    ODRF.DocCur,
    NULL AS 'unitMsr',

    ODRF.Comments,
    'T' AS 'LineType',

    QPJ.Project,

    OCPR.E_MailL,

    OSLP.SlpName AS 'Sale Name contact',

    OHEM.Mobile AS 'Mobile',

    OHEM.Email AS 'Email-Sale',

    CRD1.Street     AS 'Street / PO Box12',

    CRD1.StreetNo   AS 'Street No.12',

    CRD1.Block      AS 'Block12',

    CRD1.City       AS 'City12',

    CRD1.ZipCode    AS 'Zip Code12',

    CRD1.County     AS 'County12',

    CRD1.State      AS 'State12',

    CRD1.Country    AS 'Country/Region12',

    DRF12.Streets     ,

    DRF12.StreetNos   ,

    DRF12.Blocks      ,

    DRF12.Citys       ,

    DRF12.ZipCodes    ,

    DRF12.Countys     ,

    DRF12.States      ,

    DRF12.Countrys    ,
    NULL AS 'U_SLD_Dis_Amount',

    OCPR.Name,

    OCPR.Cellolar AS 'Tel1'

,
    DRF1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DRF10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF   
INNER JOIN DRF10 ON ODRF.DocEntry = DRF10.DocEntry
LEFT JOIN DRF1 ON DRF10.DocEntry = DRF1.DocEntry AND DRF10.AftLineNum = DRF1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DRF1 P 
    WHERE P.DocEntry = ODRF.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson

LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B' ) 
LEFT JOIN OCPR ON ODRF.CardCode = OCPR.CardCode AND ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series 
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OSLP ON ODRF.SlpCode = OSLP.SlpCode
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE 
LEFT JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM

-- เช็ค Draft ของ Sales Order (ObjType = 17)
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '17'

-- ========================================================
-- การเรียงลำดับ (ORDER BY ต้องอยู่ล่างสุดของการทำ UNION)
-- ========================================================


ORDER BY
    [Sort_VisOrder] ASC,
    [Sort_IsText] ASC,
    [Sort_Seq] ASC

