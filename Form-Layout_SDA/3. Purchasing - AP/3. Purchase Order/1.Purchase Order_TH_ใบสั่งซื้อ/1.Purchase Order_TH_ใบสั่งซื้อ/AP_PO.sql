-- ============================================================
-- Report: 1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_TH_ใบสั่งซื้อ.rpt
Extracted: 2026-09-01 18:40:48
-- Source: Main Report
-- Table:  AP_PO
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT
 
        BRANCH.Code ,

         CASE 
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Original'
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Copy'  
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur = OADM.MainCurncy THEN N'สำเนา'
         END AS 'Print Status',

        BRANCH.[Name] As 'BranchName',

        BRANCH.U_SLD_VTAXID As 'TaxIdNum',

        CAST(BRANCH.U_SLD_VComName AS NVARCHAR(4000)) As 'PrintHeadr',

        CAST(BRANCH.U_SLD_F_VComName AS NVARCHAR(4000)) As 'PrintHdrF',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS NVARCHAR(4000)) AS 'Building',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS NVARCHAR(4000)) AS 'Street',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS NVARCHAR(4000)) AS 'Block',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END AS NVARCHAR(4000)) As 'City',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END AS NVARCHAR(4000)) As 'County',

        BRANCH.U_SLD_ZipCode As 'ZipCode',

        BRANCH.U_SLD_Tel As 'Tel',

        BRANCH.U_SLD_Fax As 'BFax',

        BRANCH.U_SLD_Email AS 'E-Mail',

        OPOR.DocEntry,

        CAST(OPOR.Address2 AS NVARCHAR(4000)) AS 'Address2',
 
        CAST(OPOR.[Address] AS NVARCHAR(4000)) AS 'Address',

        OCRD.U_SLD_Title,

        CAST(OCRD.U_SLD_FullName AS NVARCHAR(4000)) AS 'U_SLD_FullName',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',

        OCRD.LicTradNum,

        NNM1.BeginStr,
 
        OPOR.DocNum,

        OPOR.CardCode,
 
        OPOR.DocDate,
 
        OPOR.DocDueDate,
 
        OCTG.PymntGroup,
 
        CAST(POR1.VisOrder + 1 AS FLOAT) AS 'No.',
 
        POR1.LineNum as 'Line No.',
 
        POR1.ItemCode,
 
        CAST(POR1.Dscription AS NVARCHAR(4000)) AS 'Dscription',
 
        POR1.Quantity,

        POR1.PriceBefDi,
 
        POR1.DiscPrcnt,

        CASE WHEN OPOR.DocCur = 'THB' THEN POR1.LineTotal ELSE POR1.TotalFrgn END AS 'LineTotal',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DiscSum ELSE OPOR.DiscSumFC END AS 'DiscSum',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.VatSum ELSE OPOR.VatSumFC END AS 'VatSum',

        OPOR.DiscPrcnt AS 'OPOR_DiscPrcnt',
 -- แก้ไข Alias ไม่ให้ซ้ำ
        OPOR.DocCur,

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DocTotal ELSE OPOR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPOR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM POR1 L WHERE L.DocEntry = OPOR.DocEntry) AS 'Sum_LineTotal_All',

        POR1.unitmsr,

        CAST(OPOR.Comments AS NVARCHAR(4000)) AS 'Comments',

        POR1.LineType,

        CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

        OCRD.cntctPrsn,

        OCRD.E_mail,

        POR1.U_SLD_Dis_Amount,

        CAST(ocrd.MailAddres AS NVARCHAR(4000)) AS 'MailAddres',

        ocrd.Country,

        QPJ.Project,
 
        CAST(por12.StreetS AS NVARCHAR(4000)) as StreetS,
 
        CAST(por12.StreetNoS AS NVARCHAR(4000)) as StreetNoS,
 -- แก้ไข Alias ไม่ให้ซ้ำ
        CAST(por12.BlockS AS NVARCHAR(4000)) as BlockS,
 
        CAST(por12.BuildingS AS NVARCHAR(4000)) as BuildingS,
 
        CAST(por12.CityS AS NVARCHAR(4000)) as CityS,
 
        por12.ZipCodeS,
 
        CAST(por12.CountyS AS NVARCHAR(4000)) as CountyS,
 
        por12.StateS,

        CAST(por12.StreetB AS NVARCHAR(4000)) as StreetB,
 
        CAST(por12.StreetNoB AS NVARCHAR(4000)) as StreetNoB,

        CAST(por12.BlockB AS NVARCHAR(4000)) as BlockB,
 
        CAST(por12.BuildingB AS NVARCHAR(4000)) as BuildingB,
 
        CAST(por12.CityB AS NVARCHAR(4000)) as CityB,
 
        por12.ZipCodeB,
 
        CAST(por12.CountyB AS NVARCHAR(4000)) as CountyB,
 
        por12.StateB,

        OCPR.Name,

        OCPR.Tel1,

        OCPR.E_MailL,

        OPOR.comments AS 'Comments_2' -- แก้ไข Alias ไม่ให้ซ้ำ

,
    POR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPOR   
    INNER JOIN POR1 ON OPOR.DocEntry = POR1.DocEntry  
    -- OUTER APPLY keeps Project a header-level lookup; the old pj join
    -- multiplied every detail row. Do not turn it back into a JOIN.
    
OUTER APPLY (
        SELECT TOP 1 P.Project
        FROM POR1 P
        WHERE P.DocEntry = OPOR.DocEntry
          AND P.Project IS NOT NULL
          AND P.Project <> ''
    ) QPJ
    LEFT JOIN OITM ON POR1.ItemCode = OITM.ItemCode 
    LEFT JOIN OCRD ON OPOR.CardCode = OCRD.CardCode 
    LEFT JOIN CRD1 ON (OPOR.[PaytoCode] = CRD1.[Address] AND OPOR.CardCode = CRD1.CardCode and CRD1.AdresType = 'B')
    LEFT JOIN OCPR ON OPOR.CntctCode = OCPR.CntctCode 
    LEFT JOIN NNM1 ON OPOR.Series = NNM1.Series 
    LEFT JOIN OCTG ON OPOR.GroupNum = OCTG.GroupNum
    LEFT JOIN OHEM ON OPOR.OwnerCode = OHEM.empID
    LEFT JOIN OSLP ON OPOR.SlpCode = OSLP.SlpCode
    LEFT JOIN POR12 ON OPOR.DocEntry = POR12.DocEntry
    LEFT JOIN OUSR ON OPOR.UserSign = OUSR.USERID
    LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPOR.U_SLD_LVatBranch = BRANCH.Code, oadm
    WHERE OPOR.DocEntry = {?DocKey@}
      AND {?ObjectId@} = '22'

    
UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT
 
        BRANCH.Code ,

         CASE 
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Original'
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Copy'  
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur = OADM.MainCurncy THEN N'สำเนา'
         END AS 'Print Status',

        BRANCH.[Name] As 'BranchName',

        BRANCH.U_SLD_VTAXID As 'TaxIdNum',

        CAST(BRANCH.U_SLD_VComName AS NVARCHAR(4000)) As 'PrintHeadr',

        CAST(BRANCH.U_SLD_F_VComName AS NVARCHAR(4000)) As 'PrintHdrF',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS NVARCHAR(4000)) AS 'Building',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS NVARCHAR(4000)) AS 'Street',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS NVARCHAR(4000)) AS 'Block',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END AS NVARCHAR(4000)) As 'City',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END AS NVARCHAR(4000)) As 'County',

        BRANCH.U_SLD_ZipCode As 'ZipCode',

        BRANCH.U_SLD_Tel As 'Tel',

        BRANCH.U_SLD_Fax As 'BFax',

        BRANCH.U_SLD_Email AS 'E-Mail',

        OPOR.DocEntry,

        CAST(OPOR.Address2 AS NVARCHAR(4000)) AS 'Address2',
 
        CAST(OPOR.[Address] AS NVARCHAR(4000)) AS 'Address',

        OCRD.U_SLD_Title,

        CAST(OCRD.U_SLD_FullName AS NVARCHAR(4000)) AS 'U_SLD_FullName',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',

        OCRD.LicTradNum,

        NNM1.BeginStr,
 
        OPOR.DocNum,

        OPOR.CardCode,
 
        OPOR.DocDate,
 
        OPOR.DocDueDate,
 
        OCTG.PymntGroup,
    CAST(NULL AS INT) AS 'No.',
    POR1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(POR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'DiscPrcnt',
    NULL AS 'LineTotal',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DiscSum ELSE OPOR.DiscSumFC END AS 'DiscSum',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.VatSum ELSE OPOR.VatSumFC END AS 'VatSum',

        OPOR.DiscPrcnt AS 'OPOR_DiscPrcnt',
 -- แก้ไข Alias ไม่ให้ซ้ำ
        OPOR.DocCur,

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DocTotal ELSE OPOR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPOR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM POR1 L WHERE L.DocEntry = OPOR.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitmsr',

        CAST(OPOR.Comments AS NVARCHAR(4000)) AS 'Comments',
    'T' AS 'LineType',

        CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

        OCRD.cntctPrsn,

        OCRD.E_mail,
    NULL AS 'U_SLD_Dis_Amount',

        CAST(ocrd.MailAddres AS NVARCHAR(4000)) AS 'MailAddres',

        ocrd.Country,

        QPJ.Project,
 
        CAST(por12.StreetS AS NVARCHAR(4000)) as StreetS,
 
        CAST(por12.StreetNoS AS NVARCHAR(4000)) as StreetNoS,
 -- แก้ไข Alias ไม่ให้ซ้ำ
        CAST(por12.BlockS AS NVARCHAR(4000)) as BlockS,
 
        CAST(por12.BuildingS AS NVARCHAR(4000)) as BuildingS,
 
        CAST(por12.CityS AS NVARCHAR(4000)) as CityS,
 
        por12.ZipCodeS,
 
        CAST(por12.CountyS AS NVARCHAR(4000)) as CountyS,
 
        por12.StateS,

        CAST(por12.StreetB AS NVARCHAR(4000)) as StreetB,
 
        CAST(por12.StreetNoB AS NVARCHAR(4000)) as StreetNoB,

        CAST(por12.BlockB AS NVARCHAR(4000)) as BlockB,
 
        CAST(por12.BuildingB AS NVARCHAR(4000)) as BuildingB,
 
        CAST(por12.CityB AS NVARCHAR(4000)) as CityB,
 
        por12.ZipCodeB,
 
        CAST(por12.CountyB AS NVARCHAR(4000)) as CountyB,
 
        por12.StateB,

        OCPR.Name,

        OCPR.Tel1,

        OCPR.E_MailL,

        OPOR.comments AS 'Comments_2' -- แก้ไข Alias ไม่ให้ซ้ำ

,
    POR1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    POR10.LineSeq AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OPOR   
INNER JOIN POR10 ON OPOR.DocEntry = POR10.DocEntry
LEFT JOIN POR1 ON POR10.DocEntry = POR1.DocEntry AND POR10.AftLineNum = POR1.VisOrder
    -- OUTER APPLY keeps Project a header-level lookup; the old pj join
    -- multiplied every detail row. Do not turn it back into a JOIN.
    
OUTER APPLY (
        SELECT TOP 1 P.Project
        FROM POR1 P
        WHERE P.DocEntry = OPOR.DocEntry
          AND P.Project IS NOT NULL
          AND P.Project <> ''
    ) QPJ

    LEFT JOIN OCRD ON OPOR.CardCode = OCRD.CardCode 
    LEFT JOIN CRD1 ON (OPOR.[PaytoCode] = CRD1.[Address] AND OPOR.CardCode = CRD1.CardCode and CRD1.AdresType = 'B')
    LEFT JOIN OCPR ON OPOR.CntctCode = OCPR.CntctCode 
    LEFT JOIN NNM1 ON OPOR.Series = NNM1.Series 
    LEFT JOIN OCTG ON OPOR.GroupNum = OCTG.GroupNum
    LEFT JOIN OHEM ON OPOR.OwnerCode = OHEM.empID
    LEFT JOIN OSLP ON OPOR.SlpCode = OSLP.SlpCode
    LEFT JOIN POR12 ON OPOR.DocEntry = POR12.DocEntry
    LEFT JOIN OUSR ON OPOR.UserSign = OUSR.USERID
    LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPOR.U_SLD_LVatBranch = BRANCH.Code, oadm
    WHERE OPOR.DocEntry = {?DocKey@}
      AND {?ObjectId@} = '22'

    
UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT
 
        BRANCH.Code ,

         CASE 
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Original'
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Copy'  
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur = OADM.MainCurncy THEN N'สำเนา'
         END AS 'Print Status',

        BRANCH.[Name] As 'BranchName',

        BRANCH.U_SLD_VTAXID As 'TaxIdNum',

        CAST(BRANCH.U_SLD_VComName AS NVARCHAR(4000)) As 'PrintHeadr',

        CAST(BRANCH.U_SLD_F_VComName AS NVARCHAR(4000)) As 'PrintHdrF',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS NVARCHAR(4000)) AS 'Building',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS NVARCHAR(4000)) AS 'Street',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS NVARCHAR(4000)) AS 'Block',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END AS NVARCHAR(4000)) As 'City',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END AS NVARCHAR(4000)) As 'County',

        BRANCH.U_SLD_ZipCode As 'ZipCode',

        BRANCH.U_SLD_Tel As 'Tel',

        BRANCH.U_SLD_Fax As 'BFax',

        BRANCH.U_SLD_Email AS 'E-Mail',

        OPOR.DocEntry,

        CAST(OPOR.Address2 AS NVARCHAR(4000)) AS 'Address2',
 
        CAST(OPOR.[Address] AS NVARCHAR(4000)) AS 'Address',

        OCRD.U_SLD_Title,

        CAST(OCRD.U_SLD_FullName AS NVARCHAR(4000)) AS 'U_SLD_FullName',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',

        OCRD.LicTradNum,

        NNM1.BeginStr,
 
        OPOR.DocNum,

        OPOR.CardCode,
 
        OPOR.DocDate,
 
        OPOR.DocDueDate,
 
        OCTG.PymntGroup,
 
        CAST(POR1.VisOrder + 1 AS FLOAT) AS 'No.',
 
        POR1.LineNum as 'Line No.',
 
        POR1.ItemCode,
 
        CAST(POR1.Dscription AS NVARCHAR(4000)) AS 'Dscription',
 
        POR1.Quantity,

        POR1.PriceBefDi,
 
        POR1.DiscPrcnt,

        CASE WHEN OPOR.DocCur = 'THB' THEN POR1.LineTotal ELSE POR1.TotalFrgn END AS 'LineTotal',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DiscSum ELSE OPOR.DiscSumFC END AS 'DiscSum',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.VatSum ELSE OPOR.VatSumFC END AS 'VatSum',

        OPOR.DiscPrcnt AS 'OPOR_DiscPrcnt',

        OPOR.DocCur,

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DocTotal ELSE OPOR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPOR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPOR.DocEntry) AS 'Sum_LineTotal_All',

        POR1.unitmsr,

        CAST(OPOR.Comments AS NVARCHAR(4000)) AS 'Comments',

        POR1.LineType,

        CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

        OCRD.cntctPrsn,

        OCRD.E_mail,

        POR1.U_SLD_Dis_Amount,

        CAST(ocrd.MailAddres AS NVARCHAR(4000)) AS 'MailAddres',

        ocrd.Country,

        QPJ.Project,
 
        CAST(por12.StreetS AS NVARCHAR(4000)) as StreetS,
 
        CAST(por12.StreetNoS AS NVARCHAR(4000)) as StreetNoS,

        CAST(por12.BlockS AS NVARCHAR(4000)) as BlockS,
 
        CAST(por12.BuildingS AS NVARCHAR(4000)) as BuildingS,
 
        CAST(por12.CityS AS NVARCHAR(4000)) as CityS,
 
        por12.ZipCodeS,
 
        CAST(por12.CountyS AS NVARCHAR(4000)) as CountyS,
 
        por12.StateS,

        CAST(por12.StreetB AS NVARCHAR(4000)) as StreetB,
 
        CAST(por12.StreetNoB AS NVARCHAR(4000)) as StreetNoB,

        CAST(por12.BlockB AS NVARCHAR(4000)) as BlockB,
 
        CAST(por12.BuildingB AS NVARCHAR(4000)) as BuildingB,
 
        CAST(por12.CityB AS NVARCHAR(4000)) as CityB,
 
        por12.ZipCodeB,
 
        CAST(por12.CountyB AS NVARCHAR(4000)) as CountyB,
 
        por12.StateB,

        OCPR.Name,

        OCPR.Tel1,

        OCPR.E_MailL,

        OPOR.comments AS 'Comments_2'

    -- เรียกใช้ตาราง Draft เป็นหลัก
,
    POR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPOR   
    INNER JOIN DRF1 POR1 ON OPOR.DocEntry = POR1.DocEntry  
    -- OUTER APPLY keeps Project a header-level lookup; the old pj join
    -- multiplied every detail row. Do not turn it back into a JOIN.
    
OUTER APPLY (
        SELECT TOP 1 P.Project
        FROM DRF1 P
        WHERE P.DocEntry = OPOR.DocEntry
          AND P.Project IS NOT NULL
          AND P.Project <> ''
    ) QPJ
    LEFT JOIN OITM ON POR1.ItemCode = OITM.ItemCode 
    LEFT JOIN OCRD ON OPOR.CardCode = OCRD.CardCode 
    LEFT JOIN CRD1 ON (OPOR.[PaytoCode] = CRD1.[Address] AND OPOR.CardCode = CRD1.CardCode and CRD1.AdresType = 'B')
    LEFT JOIN OCPR ON OPOR.CntctCode = OCPR.CntctCode 
    LEFT JOIN NNM1 ON OPOR.Series = NNM1.Series 
    LEFT JOIN OCTG ON OPOR.GroupNum = OCTG.GroupNum
    LEFT JOIN OHEM ON OPOR.OwnerCode = OHEM.empID
    LEFT JOIN OSLP ON OPOR.SlpCode = OSLP.SlpCode
    LEFT JOIN DRF12 POR12 ON OPOR.DocEntry = POR12.DocEntry
    LEFT JOIN OUSR ON OPOR.UserSign = OUSR.USERID
    LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPOR.U_SLD_LVatBranch = BRANCH.Code, oadm
    WHERE OPOR.DocEntry = {?DocKey@}
      AND {?ObjectId@} = '112'
      AND OPOR.ObjType = '22'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT
 
        BRANCH.Code ,

         CASE 
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Original'
         WHEN OPOR.Printed = 'N' AND OPOR.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur <> OADM.MainCurncy THEN 'Copy'  
         WHEN OPOR.Printed = 'Y' AND OPOR.DocCur = OADM.MainCurncy THEN N'สำเนา'
         END AS 'Print Status',

        BRANCH.[Name] As 'BranchName',

        BRANCH.U_SLD_VTAXID As 'TaxIdNum',

        CAST(BRANCH.U_SLD_VComName AS NVARCHAR(4000)) As 'PrintHeadr',

        CAST(BRANCH.U_SLD_F_VComName AS NVARCHAR(4000)) As 'PrintHdrF',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS NVARCHAR(4000)) AS 'Building',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS NVARCHAR(4000)) AS 'Street',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS NVARCHAR(4000)) AS 'Block',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END AS NVARCHAR(4000)) As 'City',

        CAST(CASE WHEN OPOR.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END AS NVARCHAR(4000)) As 'County',

        BRANCH.U_SLD_ZipCode As 'ZipCode',

        BRANCH.U_SLD_Tel As 'Tel',

        BRANCH.U_SLD_Fax As 'BFax',

        BRANCH.U_SLD_Email AS 'E-Mail',

        OPOR.DocEntry,

        CAST(OPOR.Address2 AS NVARCHAR(4000)) AS 'Address2',
 
        CAST(OPOR.[Address] AS NVARCHAR(4000)) AS 'Address',

        OCRD.U_SLD_Title,

        CAST(OCRD.U_SLD_FullName AS NVARCHAR(4000)) AS 'U_SLD_FullName',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',

        OCRD.LicTradNum,

        NNM1.BeginStr,
 
        OPOR.DocNum,

        OPOR.CardCode,
 
        OPOR.DocDate,
 
        OPOR.DocDueDate,
 
        OCTG.PymntGroup,
    CAST(NULL AS INT) AS 'No.',
    POR1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(POR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'DiscPrcnt',
    NULL AS 'LineTotal',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DiscSum ELSE OPOR.DiscSumFC END AS 'DiscSum',

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.VatSum ELSE OPOR.VatSumFC END AS 'VatSum',

        OPOR.DiscPrcnt AS 'OPOR_DiscPrcnt',

        OPOR.DocCur,

        CASE WHEN OPOR.DocCur = 'THB' THEN OPOR.DocTotal ELSE OPOR.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPOR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPOR.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitmsr',

        CAST(OPOR.Comments AS NVARCHAR(4000)) AS 'Comments',
    'T' AS 'LineType',

        CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',

        OCRD.cntctPrsn,

        OCRD.E_mail,
    NULL AS 'U_SLD_Dis_Amount',

        CAST(ocrd.MailAddres AS NVARCHAR(4000)) AS 'MailAddres',

        ocrd.Country,

        QPJ.Project,
 
        CAST(por12.StreetS AS NVARCHAR(4000)) as StreetS,
 
        CAST(por12.StreetNoS AS NVARCHAR(4000)) as StreetNoS,

        CAST(por12.BlockS AS NVARCHAR(4000)) as BlockS,
 
        CAST(por12.BuildingS AS NVARCHAR(4000)) as BuildingS,
 
        CAST(por12.CityS AS NVARCHAR(4000)) as CityS,
 
        por12.ZipCodeS,
 
        CAST(por12.CountyS AS NVARCHAR(4000)) as CountyS,
 
        por12.StateS,

        CAST(por12.StreetB AS NVARCHAR(4000)) as StreetB,
 
        CAST(por12.StreetNoB AS NVARCHAR(4000)) as StreetNoB,

        CAST(por12.BlockB AS NVARCHAR(4000)) as BlockB,
 
        CAST(por12.BuildingB AS NVARCHAR(4000)) as BuildingB,
 
        CAST(por12.CityB AS NVARCHAR(4000)) as CityB,
 
        por12.ZipCodeB,
 
        CAST(por12.CountyB AS NVARCHAR(4000)) as CountyB,
 
        por12.StateB,

        OCPR.Name,

        OCPR.Tel1,

        OCPR.E_MailL,

        OPOR.comments AS 'Comments_2'

    -- เรียกใช้ตาราง Draft เป็นหลัก
,
    POR1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    POR10.LineSeq AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OPOR   
INNER JOIN DRF10 POR10 ON OPOR.DocEntry = POR10.DocEntry
LEFT JOIN DRF1 POR1 ON POR10.DocEntry = POR1.DocEntry AND POR10.AftLineNum = POR1.VisOrder
    -- OUTER APPLY keeps Project a header-level lookup; the old pj join
    -- multiplied every detail row. Do not turn it back into a JOIN.
    
OUTER APPLY (
        SELECT TOP 1 P.Project
        FROM DRF1 P
        WHERE P.DocEntry = OPOR.DocEntry
          AND P.Project IS NOT NULL
          AND P.Project <> ''
    ) QPJ

    LEFT JOIN OCRD ON OPOR.CardCode = OCRD.CardCode 
    LEFT JOIN CRD1 ON (OPOR.[PaytoCode] = CRD1.[Address] AND OPOR.CardCode = CRD1.CardCode and CRD1.AdresType = 'B')
    LEFT JOIN OCPR ON OPOR.CntctCode = OCPR.CntctCode 
    LEFT JOIN NNM1 ON OPOR.Series = NNM1.Series 
    LEFT JOIN OCTG ON OPOR.GroupNum = OCTG.GroupNum
    LEFT JOIN OHEM ON OPOR.OwnerCode = OHEM.empID
    LEFT JOIN OSLP ON OPOR.SlpCode = OSLP.SlpCode
    LEFT JOIN DRF12 POR12 ON OPOR.DocEntry = POR12.DocEntry
    LEFT JOIN OUSR ON OPOR.UserSign = OUSR.USERID
    LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPOR.U_SLD_LVatBranch = BRANCH.Code, oadm
    WHERE OPOR.DocEntry = {?DocKey@}
      AND {?ObjectId@} = '112'
      AND OPOR.ObjType = '22'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
