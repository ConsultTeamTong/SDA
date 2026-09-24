-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
-- Extracted: 2026-09-24 10:20:27
-- Source: Main Report
-- Table:  AP_PR
-- ============================================================

-- RPT: 3. Purchasing - AP\1. Purchase Request\1.Purchase Request_TH_ใบขอซื้อ\1.Purchase Request_TH_ใบขอซื้อ.rpt
-- SCOPE: main
-- ALIAS: AP_PR
-- FIELDS: 57
-- ---------------------------------------------------------------
SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT

        CASE WHEN BRANCH.Code = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
             WHEN BRANCH.Code = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Head office'
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
        END AS 'GLN_H',

        CASE WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
             WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN '(Head office)'
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
        END AS 'GLN_BP',

        CASE WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Original'
             WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Copy'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำเนา'
        END AS 'Print Status',

        CASE WHEN OPRQ.DocCur = 'THB' THEN PRQ1.LineTotal ELSE PRQ1.TotalFrgn END AS 'LineTotal',

        OHEM.firstName,

        OHEM.lastName,

        OHEM.UserSign,
 
        OPRQ.DocCur,

        OPRQ.DocEntry,

        OPRQ.[Address],

        OCRD.U_SLD_Title,

        OCRD.U_SLD_FullName,

        CASE WHEN OCRD.Phone2 IS NULL THEN ''
             WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
        END AS 'Phone2',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',
 
        OCRD.LicTradNum,

        ISNULL(PRQ12.GlbLocNumB,'') AS 'GlbLocNumB',

        ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
        OPRQ.DocNum,
 
        OPRQ.DocDate,
 
        OPRQ.ReqDate AS DocDueDate,
 
        PRQ1.VisOrder + 1 AS 'No.',
 
        PRQ1.LineNum AS 'Line No.',
 
        PRQ1.ItemCode,
 
        PRQ1.Dscription AS 'Dscription',
 
        PRQ1.Quantity,
 
        PRQ1.Price,
 
        PRQ1.TotalSumSy,

        PRQ1.UomCode,
 
        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.VatSum ELSE OPRQ.VatSumFC END AS 'VatSum',

        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.DocTotal ELSE OPRQ.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPRQ.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PRQ1 L WHERE L.DocEntry = OPRQ.DocEntry) AS 'Sum_LineTotal_All',

        PRQ1.unitMsr,

        PRQ1.LineType,

        OCPR.Name AS 'Coontact',

        PRQ1.Project,

        OCRD.CntctPrsn,

        OCRD.E_Mail,

        OCRD.Phone1 AS 'BP_Phone1',

        OCRD.Phone2 AS 'BP_Phone2',

        PRQ1.DiscPrcnt,

        PRQ1.U_SLD_Dis_Amount,

        CAST(PRQ12.StreetB AS NVARCHAR(4000)) AS StreetB,
 
        CAST(PRQ12.StreetNoB AS NVARCHAR(4000)) AS StreetNoB,

        CAST(PRQ12.BlockB AS NVARCHAR(4000)) AS BlockB,
 
        CAST(PRQ12.BuildingB AS NVARCHAR(4000)) AS BuildingB,
 
        CAST(PRQ12.CityB AS NVARCHAR(4000)) AS CityB,
 
        PRQ12.ZipCodeB,
 
        CAST(PRQ12.CountyB AS NVARCHAR(4000)) AS CountyB,
 
        PRQ12.StateB,

        OPRQ.CardCode,

        OUDP.Name ,

        OPRQ.Comments
,
    PRQ1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (PRQ1.Project)) AS 'ProjectName'
FROM OPRQ 
    INNER JOIN PRQ1 ON OPRQ.DocEntry = PRQ1.DocEntry
    LEFT JOIN PRQ12 ON OPRQ.DocEntry = PRQ12.DocEntry
    LEFT JOIN OCRD ON OCRD.CardCode = OPRQ.CardCode 
    LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPRQ.cntctcode = OCPR.cntctcode
    LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPRQ.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B')
    LEFT JOIN NNM1 ON OPRQ.Series = NNM1.Series
    LEFT JOIN OPRJ ON PRQ1.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPRQ.U_SLD_LVatBranch = BRANCH.Code
    left join OUDP ON OPRQ.Department = OUDP.Code 
    CROSS JOIN OADM 
    LEFT JOIN OHEM ON 
        (OPRQ.ReqType = '171' AND OPRQ.Requester = CAST(OHEM.empID AS NVARCHAR(20)))
        OR 
        (OPRQ.ReqType = '12' AND OHEM.userId = (SELECT USERID FROM OUSR WHERE USER_CODE = OPRQ.Requester))
    WHERE OPRQ.DocEntry = {?Dockey@}
      AND {?ObjectId@} = '1470000113'

    
UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT

        CASE WHEN BRANCH.Code = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
             WHEN BRANCH.Code = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Head office'
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
        END AS 'GLN_H',

        CASE WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
             WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN '(Head office)'
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
        END AS 'GLN_BP',

        CASE WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Original'
             WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Copy'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำเนา'
        END AS 'Print Status',
    NULL AS 'LineTotal',

        OHEM.firstName,

        OHEM.lastName,

        OHEM.UserSign,
 
        OPRQ.DocCur,

        OPRQ.DocEntry,

        OPRQ.[Address],

        OCRD.U_SLD_Title,

        OCRD.U_SLD_FullName,

        CASE WHEN OCRD.Phone2 IS NULL THEN ''
             WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
        END AS 'Phone2',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',
 
        OCRD.LicTradNum,

        ISNULL(PRQ12.GlbLocNumB,'') AS 'GlbLocNumB',

        ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
        OPRQ.DocNum,
 
        OPRQ.DocDate,
 
        OPRQ.ReqDate AS DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    PRQ1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PRQ10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'Price',
    NULL AS 'TotalSumSy',
    NULL AS 'UomCode',
 
        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.VatSum ELSE OPRQ.VatSumFC END AS 'VatSum',

        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.DocTotal ELSE OPRQ.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPRQ.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM PRQ1 L WHERE L.DocEntry = OPRQ.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',
    'T' AS 'LineType',

        OCPR.Name AS 'Coontact',
    NULL AS 'Project',

        OCRD.CntctPrsn,

        OCRD.E_Mail,

        OCRD.Phone1 AS 'BP_Phone1',

        OCRD.Phone2 AS 'BP_Phone2',
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',

        CAST(PRQ12.StreetB AS NVARCHAR(4000)) AS StreetB,
 
        CAST(PRQ12.StreetNoB AS NVARCHAR(4000)) AS StreetNoB,

        CAST(PRQ12.BlockB AS NVARCHAR(4000)) AS BlockB,
 
        CAST(PRQ12.BuildingB AS NVARCHAR(4000)) AS BuildingB,
 
        CAST(PRQ12.CityB AS NVARCHAR(4000)) AS CityB,
 
        PRQ12.ZipCodeB,
 
        CAST(PRQ12.CountyB AS NVARCHAR(4000)) AS CountyB,
 
        PRQ12.StateB,

        OPRQ.CardCode,

        OUDP.Name ,

        OPRQ.Comments
,
    PRQ1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PRQ10.LineSeq AS 'Sort_Seq'

    ,
    NULL AS 'ProjectName'
FROM OPRQ 
INNER JOIN PRQ10 ON OPRQ.DocEntry = PRQ10.DocEntry
LEFT JOIN PRQ1 ON PRQ10.DocEntry = PRQ1.DocEntry AND PRQ10.AftLineNum = PRQ1.VisOrder
    LEFT JOIN PRQ12 ON OPRQ.DocEntry = PRQ12.DocEntry
    LEFT JOIN OCRD ON OCRD.CardCode = OPRQ.CardCode 
    LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPRQ.cntctcode = OCPR.cntctcode
    LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPRQ.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B')
    LEFT JOIN NNM1 ON OPRQ.Series = NNM1.Series
    LEFT JOIN OPRJ ON PRQ1.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPRQ.U_SLD_LVatBranch = BRANCH.Code
    left join OUDP ON OPRQ.Department = OUDP.Code 
    CROSS JOIN OADM 
    LEFT JOIN OHEM ON 
        (OPRQ.ReqType = '171' AND OPRQ.Requester = CAST(OHEM.empID AS NVARCHAR(20)))
        OR 
        (OPRQ.ReqType = '12' AND OHEM.userId = (SELECT USERID FROM OUSR WHERE USER_CODE = OPRQ.Requester))
    WHERE OPRQ.DocEntry = {?Dockey@}
      AND {?ObjectId@} = '1470000113'

    
UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT

        CASE WHEN BRANCH.Code = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
             WHEN BRANCH.Code = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Head office'
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
        END AS 'GLN_H',

        CASE WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
             WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN '(Head office)'
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
        END AS 'GLN_BP',

        CASE WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Original'
             WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Copy'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำเนา'
        END AS 'Print Status',

        CASE WHEN OPRQ.DocCur = 'THB' THEN PRQ1.LineTotal ELSE PRQ1.TotalFrgn END AS 'LineTotal',

        OHEM.firstName,

        OHEM.lastName,

        OHEM.UserSign,
 
        OPRQ.DocCur,

        OPRQ.DocEntry,

        OPRQ.[Address],

        OCRD.U_SLD_Title,

        OCRD.U_SLD_FullName,

        CASE WHEN OCRD.Phone2 IS NULL THEN ''
             WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
        END AS 'Phone2',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',
 
        OCRD.LicTradNum,

        ISNULL(PRQ12.GlbLocNumB,'') AS 'GlbLocNumB',

        ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
        OPRQ.DocNum,
 
        OPRQ.DocDate,
 
        OPRQ.ReqDate AS DocDueDate,
 
        PRQ1.VisOrder + 1 AS 'No.',
 
        PRQ1.LineNum AS 'Line No.',
 
        PRQ1.ItemCode,
 
        PRQ1.Dscription AS 'Dscription',
 
        PRQ1.Quantity,
 
        PRQ1.Price,
 
        PRQ1.TotalSumSy,

        PRQ1.UomCode,
 
        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.VatSum ELSE OPRQ.VatSumFC END AS 'VatSum',

        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.DocTotal ELSE OPRQ.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPRQ.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPRQ.DocEntry) AS 'Sum_LineTotal_All',

        PRQ1.unitMsr,

        PRQ1.LineType,

        OCPR.Name AS 'Coontact',

        PRQ1.Project,

        OCRD.CntctPrsn,

        OCRD.E_Mail,

        OCRD.Phone1 AS 'BP_Phone1',

        OCRD.Phone2 AS 'BP_Phone2',

        PRQ1.DiscPrcnt,

        PRQ1.U_SLD_Dis_Amount,

        CAST(PRQ12.StreetB AS NVARCHAR(4000)) AS StreetB,
 
        CAST(PRQ12.StreetNoB AS NVARCHAR(4000)) AS StreetNoB,

        CAST(PRQ12.BlockB AS NVARCHAR(4000)) AS BlockB,
 
        CAST(PRQ12.BuildingB AS NVARCHAR(4000)) AS BuildingB,
 
        CAST(PRQ12.CityB AS NVARCHAR(4000)) AS CityB,
 
        PRQ12.ZipCodeB,
 
        CAST(PRQ12.CountyB AS NVARCHAR(4000)) AS CountyB,
 
        PRQ12.StateB,

        OPRQ.CardCode,

        OUDP.Name ,

        OPRQ.Comments
    
    -- เปลี่ยนการ JOIN ตรงนี้ให้ชี้ไปที่ตาราง Draft
,
    PRQ1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

    ,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (PRQ1.Project)) AS 'ProjectName'
FROM ODRF OPRQ 
    INNER JOIN DRF1 PRQ1 ON OPRQ.DocEntry = PRQ1.DocEntry
    LEFT JOIN DRF12 PRQ12 ON OPRQ.DocEntry = PRQ12.DocEntry
    LEFT JOIN OCRD ON OCRD.CardCode = OPRQ.CardCode 
    LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPRQ.cntctcode = OCPR.cntctcode
    LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPRQ.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B')
    LEFT JOIN NNM1 ON OPRQ.Series = NNM1.Series
    LEFT JOIN OPRJ ON PRQ1.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPRQ.U_SLD_LVatBranch = BRANCH.Code
    left join OUDP ON OPRQ.Department = OUDP.Code 
    CROSS JOIN OADM 
    LEFT JOIN OHEM ON 
        (OPRQ.ReqType = '171' AND OPRQ.Requester = CAST(OHEM.empID AS NVARCHAR(20)))
        OR 
        (OPRQ.ReqType = '12' AND OHEM.userId = (SELECT USERID FROM OUSR WHERE USER_CODE = OPRQ.Requester))
    WHERE OPRQ.DocEntry = {?Dockey@}
      AND {?ObjectId@} = '112'
      AND OPRQ.ObjType = '1470000113' -- เช็คเพิ่มเติมว่าเป็น Draft ของฝั่ง PR เท่านั้น


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT

        CASE WHEN BRANCH.Code = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
             WHEN BRANCH.Code = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Head office'
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code)
             WHEN BRANCH.Code <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code)
        END AS 'GLN_H',

        CASE WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
             WHEN CRD1.GlblLocNum = '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN '(Head office)'
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum <> '00000' AND OPRQ.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')')
             WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
        END AS 'GLN_BP',

        CASE WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Original'
             WHEN OPRQ.Printed = 'N' AND OPRQ.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur <> OADM.MainCurncy THEN 'Copy'
             WHEN OPRQ.Printed = 'Y' AND OPRQ.DocCur = OADM.MainCurncy THEN N'สำเนา'
        END AS 'Print Status',
    NULL AS 'LineTotal',

        OHEM.firstName,

        OHEM.lastName,

        OHEM.UserSign,
 
        OPRQ.DocCur,

        OPRQ.DocEntry,

        OPRQ.[Address],

        OCRD.U_SLD_Title,

        OCRD.U_SLD_FullName,

        CASE WHEN OCRD.Phone2 IS NULL THEN ''
             WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
        END AS 'Phone2',

        OCRD.Phone1,
 
        ISNULL(OCRD.Fax,'') AS 'Fax',
 
        OCRD.LicTradNum,

        ISNULL(PRQ12.GlbLocNumB,'') AS 'GlbLocNumB',

        ISNULL(NNM1.BeginStr,'') AS 'BeginStr',
 
        OPRQ.DocNum,
 
        OPRQ.DocDate,
 
        OPRQ.ReqDate AS DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    PRQ1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(PRQ10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'Price',
    NULL AS 'TotalSumSy',
    NULL AS 'UomCode',
 
        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.VatSum ELSE OPRQ.VatSumFC END AS 'VatSum',

        CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.DocTotal ELSE OPRQ.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OPRQ.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = OPRQ.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'unitMsr',
    'T' AS 'LineType',

        OCPR.Name AS 'Coontact',
    NULL AS 'Project',

        OCRD.CntctPrsn,

        OCRD.E_Mail,

        OCRD.Phone1 AS 'BP_Phone1',

        OCRD.Phone2 AS 'BP_Phone2',
    NULL AS 'DiscPrcnt',
    NULL AS 'U_SLD_Dis_Amount',

        CAST(PRQ12.StreetB AS NVARCHAR(4000)) AS StreetB,
 
        CAST(PRQ12.StreetNoB AS NVARCHAR(4000)) AS StreetNoB,

        CAST(PRQ12.BlockB AS NVARCHAR(4000)) AS BlockB,
 
        CAST(PRQ12.BuildingB AS NVARCHAR(4000)) AS BuildingB,
 
        CAST(PRQ12.CityB AS NVARCHAR(4000)) AS CityB,
 
        PRQ12.ZipCodeB,
 
        CAST(PRQ12.CountyB AS NVARCHAR(4000)) AS CountyB,
 
        PRQ12.StateB,

        OPRQ.CardCode,

        OUDP.Name ,

        OPRQ.Comments
    
    -- เปลี่ยนการ JOIN ตรงนี้ให้ชี้ไปที่ตาราง Draft
,
    PRQ1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    PRQ10.LineSeq AS 'Sort_Seq'

    ,
    NULL AS 'ProjectName'
FROM ODRF OPRQ 
INNER JOIN DRF10 PRQ10 ON OPRQ.DocEntry = PRQ10.DocEntry
LEFT JOIN DRF1 PRQ1 ON PRQ10.DocEntry = PRQ1.DocEntry AND PRQ10.AftLineNum = PRQ1.VisOrder
    LEFT JOIN DRF12 PRQ12 ON OPRQ.DocEntry = PRQ12.DocEntry
    LEFT JOIN OCRD ON OCRD.CardCode = OPRQ.CardCode 
    LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode AND OPRQ.cntctcode = OCPR.cntctcode
    LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OPRQ.PaytoCode = CRD1.[Address] AND CRD1.AdresType ='B')
    LEFT JOIN NNM1 ON OPRQ.Series = NNM1.Series
    LEFT JOIN OPRJ ON PRQ1.Project = OPRJ.PrjCode
    LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPRQ.U_SLD_LVatBranch = BRANCH.Code
    left join OUDP ON OPRQ.Department = OUDP.Code 
    CROSS JOIN OADM 
    LEFT JOIN OHEM ON 
        (OPRQ.ReqType = '171' AND OPRQ.Requester = CAST(OHEM.empID AS NVARCHAR(20)))
        OR 
        (OPRQ.ReqType = '12' AND OHEM.userId = (SELECT USERID FROM OUSR WHERE USER_CODE = OPRQ.Requester))
    WHERE OPRQ.DocEntry = {?Dockey@}
      AND {?ObjectId@} = '112'
      AND OPRQ.ObjType = '1470000113' -- เช็คเพิ่มเติมว่าเป็น Draft ของฝั่ง PR เท่านั้น


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC

