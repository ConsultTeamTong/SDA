-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
Extracted: 2026-08-17 11:43:03
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- ==========================================
-- ส่วนที่ 1: ดึงข้อมูลจากใบเสนอราคาจริง (OQUT) - รูปแบบ ENG
-- ==========================================
SELECT DISTINCT
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Contact',
    OQUT.DocEntry,
    OQUT.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2, '') AS 'Phone2_2',
    OCRD.Fax,
    OCRD.LicTradNum,
    NNM1.BeginStr,
    OQUT.DocNum,
    OQUT.DocDate,
    OQUT.DocDueDate,
    CAST(QUT1.VisOrder AS FLOAT) AS 'No.',
    QUT1.LineNum AS 'Line No.', 
    QUT1.ItemCode,
    QUT1.Dscription AS 'Dscription',
    QUT1.Quantity,
    QUT1.PriceBefDi,
    CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    QUT1.unitMsr,
    OQUT.Comments,
    QUT1.LineType,
    QUT1.Project,
    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Tel1 AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
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
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,
    QUT12.StreetB     AS 'Street / PO Box12',
    QUT12.StreetNoB   AS 'Street No.12',
    QUT12.BlockB      AS 'Block12',
    QUT12.CityB       AS 'City12',
    QUT12.ZipCodeB    AS 'Zip Code12',
    QUT12.CountyB     AS 'County12',
    QUT12.StateB      AS 'State12',
    QUT12.CountryB    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName', -- เพิ่มชื่อประเทศ
    QUT1.U_SLD_Dis_Amount,
    OQUT.U_SDL_InternalNo, -- *หมายเหตุ: ตรวจสอบตัวสะกดว่าเป็น U_SDL_ หรือ U_SLD_ (บางทีอาจพิมพ์สลับกันตอนตั้งชื่อฟิลด์ใน SAP)
    OUOM.U_SLD_Uomforeign AS UgpCode

FROM OQUT  
INNER JOIN QUT1 ON OQUT.DocEntry = QUT1.DocEntry 
LEFT JOIN OITM ON QUT1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B') 
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series 
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE 
LEFT JOIN OPRJ ON QUT1.PROJECT = OPRJ.PRJCODE
LEFT JOIN OUOM ON QUT1.UomCode = OUOM.UomCode
LEFT JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry 
LEFT JOIN OCRY ON QUT12.CountryB = OCRY.Code -- เพิ่ม LEFT JOIN เชื่อมกับรหัสประเทศ
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM 

-- เช็คว่าเป็นเอกสารจริง (Object Type = 23)
WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ==========================================
-- ส่วนที่ 2: ดึงข้อมูลจากเอกสารร่าง (ODRF) - รูปแบบ ENG
-- ==========================================
SELECT DISTINCT
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Contact',
    ODRF.DocEntry,
    ODRF.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2, '') AS 'Phone2_2',
    OCRD.Fax,
    OCRD.LicTradNum,
    NNM1.BeginStr,
    ODRF.DocNum,
    ODRF.DocDate,
    ODRF.DocDueDate,
    CAST(DRF1.VisOrder AS FLOAT) AS 'No.',
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
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    DRF1.unitMsr,
    ODRF.Comments,
    DRF1.LineType,
    DRF1.Project,
    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Tel1 AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
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
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,
    DRF12.StreetB     AS 'Street / PO Box12',
    DRF12.StreetNoB   AS 'Street No.12',
    DRF12.BlockB      AS 'Block12',
    DRF12.CityB       AS 'City12',
    DRF12.ZipCodeB    AS 'Zip Code12',
    DRF12.CountyB     AS 'County12',
    DRF12.StateB      AS 'State12',
    DRF12.CountryB    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName', -- เพิ่มชื่อประเทศ
    DRF1.U_SLD_Dis_Amount,
    ODRF.U_SDL_InternalNo,
    OUOM.U_SLD_Uomforeign AS UgpCode

FROM ODRF  
INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry 
LEFT JOIN OITM ON DRF1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType ='B') 
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series 
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE 
LEFT JOIN OPRJ ON DRF1.PROJECT = OPRJ.PRJCODE
LEFT JOIN OUOM ON DRF1.UomCode = OUOM.UomCode
LEFT JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry 
LEFT JOIN OCRY ON DRF12.CountryB = OCRY.Code -- เพิ่ม LEFT JOIN เชื่อมกับรหัสประเทศ
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code 
CROSS JOIN OADM 

-- เช็คว่าเป็น Draft (Object Type = 112) และเป็น Draft ของใบเสนอราคา (ODRF.ObjType = 23)
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

-- ==========================================
-- เรียงลำดับข้อมูล
-- ==========================================
ORDER BY [No.], [Line No.]
