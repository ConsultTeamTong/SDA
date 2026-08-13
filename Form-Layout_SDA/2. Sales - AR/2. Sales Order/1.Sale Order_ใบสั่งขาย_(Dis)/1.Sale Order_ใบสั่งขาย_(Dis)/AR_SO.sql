-- ============================================================
-- Report: 1.Sale Order_ใบสั่งขาย_(Dis).rpt
Path:   1.Sale Order_ใบสั่งขาย_(Dis)\1.Sale Order_ใบสั่งขาย_(Dis).rpt
Extracted: 2026-08-05 14:18:16
-- Source: Main Report
-- Table:  AR_SO
-- ============================================================

-- ========================================================
-- 🟢 ส่วนที่ 1: ดึงข้อมูลจากใบสั่งขายปกติ (ORDR) - ObjectId = '17'
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format', -- เปลี่ยนชื่อไม่ให้ซ้ำ
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Coontact',
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
    RDR1.VisOrder AS 'No.',
    RDR1.LineNum AS 'Line No.', 
    RDR1.ItemCode,
    RDR1.Dscription AS 'Dscription',
    RDR1.Quantity,
    RDR1.PriceBefDi,
    CASE WHEN ORDR.DocCur = 'THB' THEN RDR1.LineTotal ELSE RDR1.TotalFrgn END AS 'LineTotal',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DiscSum ELSE ORDR.DiscSumFC END AS 'DiscSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.VatSum ELSE ORDR.VatSumFC END AS 'VatSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DocTotal ELSE ORDR.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN ORDR.DocCur = 'THB' THEN RDR1.LineTotal ELSE RDR1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
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
    RDR12.StreetB     AS 'Street / PO Box12',
    RDR12.StreetNoB   AS 'Street No.12',
    RDR12.BlockB      AS 'Block12',
    RDR12.CityB       AS 'City12',
    RDR12.ZipCodeB    AS 'Zip Code12',
    RDR12.CountyB     AS 'County12',
    RDR12.StateB      AS 'State12',
    RDR12.CountryB    AS 'Country/Region12',
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
    OCPR.Tel1
    -- ลบ OCPR.E_MailL ตัวที่ซ้ำออก

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

-- ========================================================
-- 🟢 ส่วนที่ 2: ดึงข้อมูลจากเอกสารร่าง Draft (ODRF) - ObjectId = '112'
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format', 
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Coontact',
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
    DRF1.VisOrder AS 'No.',
    DRF1.LineNum AS 'Line No.', 
    DRF1.ItemCode,
    DRF1.Dscription AS 'Dscription',
    DRF1.Quantity,
    DRF1.PriceBefDi,
    CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
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
    DRF12.StreetB     AS 'Street / PO Box12',
    DRF12.StreetNoB   AS 'Street No.12',
    DRF12.BlockB      AS 'Block12',
    DRF12.CityB       AS 'City12',
    DRF12.ZipCodeB    AS 'Zip Code12',
    DRF12.CountyB     AS 'County12',
    DRF12.StateB      AS 'State12',
    DRF12.CountryB    AS 'Country/Region12',
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
    OCPR.Tel1

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
ORDER BY [No.], [Line No.]
