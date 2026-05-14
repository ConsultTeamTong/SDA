SELECT DISTINCT
    CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Contact',
    CASE WHEN BRANCH.Code = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่'
         WHEN BRANCH.Code = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN 'Head office'
         WHEN BRANCH.Code <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN CONCAT(N'สาขาที่' ,' ',BRANCH.Code)
         WHEN BRANCH.Code <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN CONCAT('Branch' ,' ',BRANCH.Code)
    END AS 'GLN_H',
    CASE WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)'
         WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN '(Head office)'
         WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN CONCAT(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')')
         WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN CONCAT('(Branch' ,' ',CRD1.GlblLocNum,')')
         WHEN CRD1.GlblLocNum = '' OR CRD1.GlblLocNum IS NULL THEN ''
    END AS 'GLN_BP',
    CASE WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
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
    CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
         WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
    END AS 'GLN',
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCRD.Phone1,
    OCRD.Fax,
    OINV.LicTradNum,
    OINV.NumAtCard,
    OCTG.PymntGroup,
    OINV.DocDueDate,
    (INV1.VisOrder) AS 'No.',
    INV1.LineNum AS 'Line No.',
    INV1.ItemCode,
    INV1.Dscription,
    INV1.Quantity,
    OINV.Comments,
    OINV.DocCur,
    INV1.PriceBefDi,
    CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END AS 'LineTotal',
    CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum  ELSE OINV.DiscSumFC END AS 'DiscSum',
    CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum   ELSE OINV.VatSumFC  END AS 'VatSum',
    CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',
    CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt  ELSE OINV.DpmAmntFC  END AS 'DpmAmnt',
    SUM(CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
    OINV.Printed,
    INV1.LineType,
    INV1.TreeType, 
    INV1.Project,
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
FROM OINV
INNER JOIN INV1 ON OINV.DocEntry = INV1.DocEntry
LEFT JOIN  INV12 ON OINV.DocEntry = INV12.DocEntry
LEFT JOIN  NNM1 ON OINV.Series = NNM1.Series
LEFT JOIN  OCRD ON OINV.CardCode = OCRD.CardCode
LEFT JOIN  OCPR ON OINV.CntctCode = OCPR.CntctCode
LEFT JOIN  CRD1 ON (OCRD.CardCode = CRD1.CardCode 
                AND OINV.PayToCode = CRD1.Address 
                AND CRD1.AdresType = 'B')
LEFT JOIN  OSLP ON OINV.SlpCode = OSLP.SlpCode
LEFT JOIN  OCTG ON OINV.GroupNum = OCTG.GroupNum
LEFT JOIN  OHEM ON OINV.OwnerCode = OHEM.empID
LEFT JOIN  INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
LEFT JOIN  ODPI ON INV11.BASEABS = ODPI.DocEntry
LEFT JOIN  NNM1 NNM ON ODPI.Series = NNM.Series
LEFT JOIN  OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN  OPRJ ON INV1.Project = OPRJ.PrjCode
LEFT JOIN  OITT ON INV1.ItemCode = OITT.Code AND OITT.TreeType = 'S'
LEFT JOIN  [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE OINV.DocEntry = {?DocKey@}
  AND INV1.TreeType <> 'I'
ORDER BY 'No.', 'Line No.'