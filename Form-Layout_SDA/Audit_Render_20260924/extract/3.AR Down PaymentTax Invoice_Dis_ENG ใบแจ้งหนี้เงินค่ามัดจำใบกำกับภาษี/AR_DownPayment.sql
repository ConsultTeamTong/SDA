-- ============================================================
-- Report: 3.AR Down PaymentTax Invoice_Dis_ENG ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
-- Path:   3.AR Down PaymentTax Invoice_Dis_ENG ใบแจ้งหนี้เงินค่ามัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:51
-- Source: Main Report
-- Table:  AR_DownPayment
-- ============================================================

-- RPT: 2. Sales - AR\5. AR Down Payment Invoice\1.AR Down Payment_ใบเสร็จรับเงินมัดจำ\1.AR Down Payment_ENG_ปกติ ใบเสร็จรับเงินมัดจำ.rpt
-- SCOPE: main
-- ALIAS: AR_DownPayment
-- FIELDS: 63
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- ========================================================
-- 1.1 item rows of the real document (ODPI)
-- ========================================================
SELECT DISTINCT
    CRD1.Street     AS '1Bill',
    CRD1.State        AS StateB,
    OCRY.Name         AS 'CountryName',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
    DPI12.StreetS     AS '1Ship',
    DPI12.StreetNoS   AS '2Ship',
    DPI12.BlockS      AS '3Ship',
    DPI12.CityS       AS '4Ship',
    DPI12.CountyS     AS '5Ship',
    DPI12.ZipCodeS    AS '6Ship',
    
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
    
    CASE 
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Head office'
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
    END AS 'GLN_H',
    
    CASE 
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN '(Head office)'
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
    END AS 'GLN_BP',
    
    CASE
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Original'
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Copy'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำเนา'
    END AS 'Print Status',
    
    NNM1.BeginStr,
    ODPI.DocEntry,
    ODPI.DocNum,
    ODPI.DocDate,
    ODPI.CardCode,
    DPI1.unitmsr,
    ODPI.NumAtCard,
    
    (DPI1.VisOrder + 1) AS 'No.',
    DPI1.LineNum AS 'Line No.',
    
    ODPI.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2_2',
    OCRD.Fax,
    ODPI.LicTradNum,
    
    CASE 
         WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
         WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
         WHEN OCTG.PymntGroup = N'90 วัน' THEN '90 Days'
         WHEN OCTG.PymntGroup = N'60 วัน' THEN '60 Days'
         WHEN OCTG.PymntGroup = N'45 วัน' THEN '45 Days'
         WHEN OCTG.PymntGroup = N'30 วัน' THEN '30 Days'
         WHEN OCTG.PymntGroup = N'15 วัน' THEN '15 Days'
         WHEN OCTG.PymntGroup = N'7 วัน' THEN '7 Days'
         WHEN OCTG.PymntGroup = N'3 วัน' THEN '3 Days'
    END AS 'PaymentEng',
    
    ODPI.DocDueDate,
    DPI1.ItemCode,
    DPI1.Dscription AS 'Dscription',
    DPI1.Quantity,
    ODPI.Comments,
    ODPI.DocCur,

    DPI1.PriceBefDi AS 'PriceBefDi',
    
    CASE 
        WHEN ODPI.DocCur = 'THB' THEN DPI1.LineTotal 
        ELSE DPI1.TotalFrgn 
    END AS 'LineTotal',
    
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.VatSum ELSE ODPI.VatSumFC END AS 'VatSum',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DocTotal ELSE ODPI.DocTotalFC END AS 'DocTotal',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DpmAmnt ELSE ODPI.DpmAmntFC END AS 'DpmAmnt',
    
    (SELECT CASE WHEN ODPI.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DPI1 L WHERE L.DocEntry = ODPI.DocEntry
    ) AS 'Sum_LineTotal_All',
    
    ODPI.dpmprcnt,
    RCT1.CheckNum,
    RCT1.[CheckSum],
    RCT1.DueDate AS 'Check Date',
    (SELECT CASE WHEN ODPI.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END FROM DPI1 L WHERE L.DocEntry = ODPI.DocEntry) AS 'CashSum',
    SUM(ORCT.TrsfrSum) OVER(PARTITION BY ODPI.DocEntry) AS 'TrsfrSum',
    ODSC.BankName,
    DPI1.LineType,
    OSLP.U_Name_Foreign AS 'Name',
    OCPR.Cellolar AS 'Tel1',
    OCPR.E_MailL,
    QPJ.Project,
    ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), DPI1.UomCode) AS UgpCode,
    DPI1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

FROM ODPI
INNER JOIN DPI1 ON ODPI.DocEntry = DPI1.DocEntry
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DPI1 P 
    WHERE P.DocEntry = ODPI.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN DPI12 ON ODPI.DocEntry = DPI12.DocEntry
LEFT JOIN NNM1 ON ODPI.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPI.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON ODPI.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPI.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OSLP ON ODPI.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPI.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPI.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPI.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode 
LEFT JOIN ORCT ON ODPI.ReceiptNum = ORCT.DocEntry
LEFT JOIN RCT1 ON ORCT.DocEntry = RCT1.DocNum
LEFT JOIN RCT2 ON ORCT.DocNum = RCT2.DocEntry
LEFT JOIN ODSC ON RCT1.BankCode = ODSC.BankCode
LEFT JOIN OITM ON DPI1.ItemCode = OITM.ItemCode
LEFT JOIN OUOM ON DPI1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPI.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM

WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '203'

UNION ALL
-- ========================================================
-- 1.2 text rows (remarks) of the real document
-- ========================================================
SELECT DISTINCT
    CRD1.Street     AS '1Bill',
    CRD1.State        AS StateB,
    OCRY.Name         AS 'CountryName',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
    DPI12.StreetS     AS '1Ship',
    DPI12.StreetNoS   AS '2Ship',
    DPI12.BlockS      AS '3Ship',
    DPI12.CityS       AS '4Ship',
    DPI12.CountyS     AS '5Ship',
    DPI12.ZipCodeS    AS '6Ship',
    
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
    
    CASE 
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Head office'
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
    END AS 'GLN_H',
    
    CASE 
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN '(Head office)'
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
    END AS 'GLN_BP',
    
    CASE
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Original'
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Copy'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำเนา'
    END AS 'Print Status',
    
    NNM1.BeginStr,
    ODPI.DocEntry,
    ODPI.DocNum,
    ODPI.DocDate,
    ODPI.CardCode,
    NULL AS 'unitmsr',
    ODPI.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    DPI1.LineNum AS 'Line No.',
    ODPI.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2_2',
    OCRD.Fax,
    ODPI.LicTradNum,
    
    CASE 
         WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
         WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
         WHEN OCTG.PymntGroup = N'90 วัน' THEN '90 Days'
         WHEN OCTG.PymntGroup = N'60 วัน' THEN '60 Days'
         WHEN OCTG.PymntGroup = N'45 วัน' THEN '45 Days'
         WHEN OCTG.PymntGroup = N'30 วัน' THEN '30 Days'
         WHEN OCTG.PymntGroup = N'15 วัน' THEN '15 Days'
         WHEN OCTG.PymntGroup = N'7 วัน' THEN '7 Days'
         WHEN OCTG.PymntGroup = N'3 วัน' THEN '3 Days'
    END AS 'PaymentEng',
    
    ODPI.DocDueDate,
    NULL AS 'ItemCode',
    CAST(DPI10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    ODPI.Comments,
    ODPI.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.VatSum ELSE ODPI.VatSumFC END AS 'VatSum',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DocTotal ELSE ODPI.DocTotalFC END AS 'DocTotal',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DpmAmnt ELSE ODPI.DpmAmntFC END AS 'DpmAmnt',
    
    (SELECT CASE WHEN ODPI.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DPI1 L WHERE L.DocEntry = ODPI.DocEntry
    ) AS 'Sum_LineTotal_All',
    
    ODPI.dpmprcnt,
    RCT1.CheckNum,
    RCT1.[CheckSum],
    RCT1.DueDate AS 'Check Date',
    SUM(ORCT.CashSum) OVER(PARTITION BY ODPI.DocEntry) AS 'CashSum',
    SUM(ORCT.TrsfrSum) OVER(PARTITION BY ODPI.DocEntry) AS 'TrsfrSum',
    ODSC.BankName,
    'T' AS 'LineType',
    OSLP.U_Name_Foreign AS 'Name',
    OCPR.Cellolar AS 'Tel1',
    OCPR.E_MailL,
    QPJ.Project,
    NULL AS UgpCode,
    COALESCE(DPI1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DPI10.LineSeq AS 'Sort_Seq'

FROM ODPI
INNER JOIN DPI10 ON ODPI.DocEntry = DPI10.DocEntry
LEFT JOIN DPI1 ON DPI10.DocEntry = DPI1.DocEntry AND DPI10.AftLineNum = DPI1.LineNum
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DPI1 P 
    WHERE P.DocEntry = ODPI.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN DPI12 ON ODPI.DocEntry = DPI12.DocEntry
LEFT JOIN NNM1 ON ODPI.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPI.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON ODPI.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPI.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OSLP ON ODPI.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPI.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPI.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPI.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode 
LEFT JOIN ORCT ON ODPI.ReceiptNum = ORCT.DocEntry
LEFT JOIN RCT1 ON ORCT.DocEntry = RCT1.DocNum
LEFT JOIN RCT2 ON ORCT.DocNum = RCT2.DocEntry
LEFT JOIN ODSC ON RCT1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPI.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM

WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '203'

UNION ALL
-- ========================================================
-- 2.1 item rows of the draft document (ODRF)
-- ========================================================
SELECT DISTINCT
    CRD1.Street     AS '1Bill',
    CRD1.State        AS StateB,
    OCRY.Name         AS 'CountryName',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
    DPI12.StreetS     AS '1Ship',
    DPI12.StreetNoS   AS '2Ship',
    DPI12.BlockS      AS '3Ship',
    DPI12.CityS       AS '4Ship',
    DPI12.CountyS     AS '5Ship',
    DPI12.ZipCodeS    AS '6Ship',
    
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
    
    CASE 
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Head office'
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
    END AS 'GLN_H',
    
    CASE 
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN '(Head office)'
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
    END AS 'GLN_BP',
    
    CASE
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Original'
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Copy'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำเนา'
    END AS 'Print Status',
    
    NNM1.BeginStr,
    ODPI.DocEntry,
    ODPI.DocNum,
    ODPI.DocDate,
    ODPI.CardCode,
    DPI1.unitmsr,
    ODPI.NumAtCard,
    
    (DPI1.VisOrder + 1) AS 'No.',
    DPI1.LineNum AS 'Line No.',
    
    ODPI.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2_2',
    OCRD.Fax,
    ODPI.LicTradNum,
    
    CASE 
         WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
         WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
         WHEN OCTG.PymntGroup = N'90 วัน' THEN '90 Days'
         WHEN OCTG.PymntGroup = N'60 วัน' THEN '60 Days'
         WHEN OCTG.PymntGroup = N'45 วัน' THEN '45 Days'
         WHEN OCTG.PymntGroup = N'30 วัน' THEN '30 Days'
         WHEN OCTG.PymntGroup = N'15 วัน' THEN '15 Days'
         WHEN OCTG.PymntGroup = N'7 วัน' THEN '7 Days'
         WHEN OCTG.PymntGroup = N'3 วัน' THEN '3 Days'
    END AS 'PaymentEng',
    
    ODPI.DocDueDate,
    DPI1.ItemCode,
    DPI1.Dscription AS 'Dscription',
    DPI1.Quantity,
    ODPI.Comments,
    ODPI.DocCur,
    
    DPI1.PriceBefDi AS 'PriceBefDi',
    CASE 
        WHEN ODPI.DocCur = 'THB' THEN DPI1.LineTotal 
        ELSE DPI1.TotalFrgn 
    END AS 'LineTotal',
    
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.VatSum ELSE ODPI.VatSumFC END AS 'VatSum',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DocTotal ELSE ODPI.DocTotalFC END AS 'DocTotal',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DpmAmnt ELSE ODPI.DpmAmntFC END AS 'DpmAmnt',
    
    (SELECT CASE WHEN ODPI.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODPI.DocEntry
    ) AS 'Sum_LineTotal_All',
    
    ODPI.dpmprcnt,
    RCT1.CheckNum,
    RCT1.[CheckSum],
    RCT1.DueDate AS 'Check Date',
    CAST(NULL AS NUMERIC(19,6)) AS 'CashSum',
    CAST(NULL AS NUMERIC(19,6)) AS 'TrsfrSum',
    ODSC.BankName,
    DPI1.LineType,
    OSLP.U_Name_Foreign AS 'Name',
    OCPR.Cellolar AS 'Tel1',
    OCPR.E_MailL,
    QPJ.Project,
    ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), DPI1.UomCode) AS UgpCode,
    DPI1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

FROM ODRF ODPI
INNER JOIN DRF1 DPI1 ON ODPI.DocEntry = DPI1.DocEntry
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DRF1 P 
    WHERE P.DocEntry = ODPI.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 DPI12 ON ODPI.DocEntry = DPI12.DocEntry
LEFT JOIN NNM1 ON ODPI.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPI.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON ODPI.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPI.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OSLP ON ODPI.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPI.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPI.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPI.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode 
LEFT JOIN ORCT ON ODPI.ReceiptNum = ORCT.DocEntry
LEFT JOIN RCT1 ON ORCT.DocEntry = RCT1.DocNum
LEFT JOIN RCT2 ON ORCT.DocNum = RCT2.DocEntry
LEFT JOIN ODSC ON RCT1.BankCode = ODSC.BankCode
LEFT JOIN OITM ON DPI1.ItemCode = OITM.ItemCode
LEFT JOIN OUOM ON DPI1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPI.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM

WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPI.ObjType = '203'

UNION ALL
-- ========================================================
-- 2.2 text rows (remarks) of the draft document
-- ========================================================
SELECT DISTINCT
    CRD1.Street     AS '1Bill',
    CRD1.State        AS StateB,
    OCRY.Name         AS 'CountryName',
    CRD1.StreetNo   AS '2Bill',
    CRD1.Block      AS '3Bill',
    CRD1.City       AS '4Bill',
    CRD1.County     AS '5Bill',
    CRD1.ZipCode    AS '6Bill',
    DPI12.StreetS     AS '1Ship',
    DPI12.StreetNoS   AS '2Ship',
    DPI12.BlockS      AS '3Ship',
    DPI12.CityS       AS '4Ship',
    DPI12.CountyS     AS '5Ship',
    DPI12.ZipCodeS    AS '6Ship',
    
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
    
    CASE 
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
        WHEN BRANCH.Code = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Head office'
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
        WHEN BRANCH.Code <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
    END AS 'GLN_H',
    
    CASE 
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
        WHEN CRD1.GlblLocNum = '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN '(Head office)'
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum <> '00000' AND ODPI.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
        WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
    END AS 'GLN_BP',
    
    CASE
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Original'
        WHEN ODPI.Printed = 'N' AND ODPI.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur <> OADM.MainCurncy THEN 'Copy'
        WHEN ODPI.Printed = 'Y' AND ODPI.DocCur = OADM.MainCurncy THEN N'สำเนา'
    END AS 'Print Status',
    
    NNM1.BeginStr,
    ODPI.DocEntry,
    ODPI.DocNum,
    ODPI.DocDate,
    ODPI.CardCode,
    NULL AS 'unitmsr',
    ODPI.NumAtCard,
    CAST(NULL AS INT) AS 'No.',
    DPI1.LineNum AS 'Line No.',
    ODPI.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2_2',
    OCRD.Fax,
    ODPI.LicTradNum,
    
    CASE 
         WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
         WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
         WHEN OCTG.PymntGroup = N'90 วัน' THEN '90 Days'
         WHEN OCTG.PymntGroup = N'60 วัน' THEN '60 Days'
         WHEN OCTG.PymntGroup = N'45 วัน' THEN '45 Days'
         WHEN OCTG.PymntGroup = N'30 วัน' THEN '30 Days'
         WHEN OCTG.PymntGroup = N'15 วัน' THEN '15 Days'
         WHEN OCTG.PymntGroup = N'7 วัน' THEN '7 Days'
         WHEN OCTG.PymntGroup = N'3 วัน' THEN '3 Days'
    END AS 'PaymentEng',
    
    ODPI.DocDueDate,
    NULL AS 'ItemCode',
    CAST(DPI10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    ODPI.Comments,
    ODPI.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.VatSum ELSE ODPI.VatSumFC END AS 'VatSum',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DocTotal ELSE ODPI.DocTotalFC END AS 'DocTotal',
    CASE WHEN ODPI.DocCur = 'THB' THEN ODPI.DpmAmnt ELSE ODPI.DpmAmntFC END AS 'DpmAmnt',
    
    (SELECT CASE WHEN ODPI.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODPI.DocEntry
    ) AS 'Sum_LineTotal_All',
    
    ODPI.dpmprcnt,
    RCT1.CheckNum,
    RCT1.[CheckSum],
    RCT1.DueDate AS 'Check Date',
    CAST(NULL AS NUMERIC(19,6)) AS 'CashSum',
    CAST(NULL AS NUMERIC(19,6)) AS 'TrsfrSum',
    ODSC.BankName,
    'T' AS 'LineType',
    OSLP.U_Name_Foreign AS 'Name',
    OCPR.Cellolar AS 'Tel1',
    OCPR.E_MailL,
    QPJ.Project,
    NULL AS UgpCode,
    COALESCE(DPI1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DPI10.LineSeq AS 'Sort_Seq'

FROM ODRF ODPI
INNER JOIN DRF10 DPI10 ON ODPI.DocEntry = DPI10.DocEntry
LEFT JOIN DRF1 DPI1 ON DPI10.DocEntry = DPI1.DocEntry AND DPI10.AftLineNum = DPI1.LineNum
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DRF1 P 
    WHERE P.DocEntry = ODPI.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN DRF12 DPI12 ON ODPI.DocEntry = DPI12.DocEntry
LEFT JOIN NNM1 ON ODPI.Series = NNM1.Series 
LEFT JOIN OCRD ON ODPI.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON ODPI.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ODPI.PayToCode = CRD1.[Address] AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OSLP ON ODPI.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON ODPI.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON ODPI.OwnerCode = OHEM.empID
LEFT JOIN OUSR ON ODPI.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode 
LEFT JOIN ORCT ON ODPI.ReceiptNum = ORCT.DocEntry
LEFT JOIN RCT1 ON ORCT.DocEntry = RCT1.DocNum
LEFT JOIN RCT2 ON ORCT.DocNum = RCT2.DocEntry
LEFT JOIN ODSC ON RCT1.BankCode = ODSC.BankCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODPI.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM

WHERE ODPI.DocEntry = {?DocKey@}
  AND {?ObjectId@} = '112' AND ODPI.ObjType = '203'

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
