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
    OPRQ.DocDueDate, 
    PRQ1.VisOrder AS 'No.', 
    PRQ1.LineNum AS 'Line No.', 
    PRQ1.ItemCode, 
    PRQ1.Dscription AS 'Dscription', 
    PRQ1.Quantity, 
    PRQ1.Price, 
    PRQ1.TotalSumSy,
    PRQ1.UomCode, 
    CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.VatSum ELSE OPRQ.VatSumFC END AS 'VatSum',
    CASE WHEN OPRQ.DocCur = 'THB' THEN OPRQ.DocTotal ELSE OPRQ.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN OPRQ.DocCur = 'THB' THEN PRQ1.LineTotal ELSE PRQ1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
    PRQ1.unitMsr,
    PRQ1.LineType,
    CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
    PRQ1.Project,
    OCRD.CntctPrsn,
    OCRD.E_Mail,
    OCRD.Phone1 AS 'BP_Phone1', -- Note: duplicate Phone1 alias renamed for safety
    OCRD.Phone2 AS 'BP_Phone2', -- Note: duplicate Phone2 alias renamed for safety
    PRQ1.DiscPrcnt,
    PRQ1.U_SLD_Dis_Amount,
    CAST(PRQ12.StreetB AS NVARCHAR(MAX)) AS StreetB, 
    CAST(PRQ12.StreetNoB AS NVARCHAR(MAX)) AS StreetNoB,
    CAST(PRQ12.BlockB AS NVARCHAR(MAX)) AS BlockB, 
    CAST(PRQ12.BuildingB AS NVARCHAR(MAX)) AS BuildingB, 
    CAST(PRQ12.CityB AS NVARCHAR(MAX)) AS CityB, 
    PRQ12.ZipCodeB, 
    CAST(PRQ12.CountyB AS NVARCHAR(MAX)) AS CountyB, 
    PRQ12.StateB,
    OPRQ.CardCode,
    OUDP.Name 
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
ORDER BY PRQ1.VisOrder, PRQ1.LineNum