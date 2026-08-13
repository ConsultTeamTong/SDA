-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Extracted: 2026-08-05 14:09:14
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- ========================================================
-- ส่วนที่ 1: ดึงข้อมูลจากใบเสนอราคาจริง (OQUT) - ObjectId = '23'
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Coontact',
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
    QUT1.VisOrder AS 'No.',
    QUT1.LineNum AS 'Line No.', 
    QUT1.ItemCode,
    OITM.ItemName AS 'Dscription',
    QUT1.Quantity,
    QUT1.PriceBefDi,
    CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.GrosProfit ELSE OQUT.GrosProfFC END AS 'GrossProfit',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
    QUT1.DiscPrcnt,
    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    QUT1.unitMsr,
    OQUT.Comments,
    QUT1.LineType AS 'LineType', -- 🟢 ระบุชื่อฟิลด์ชัดเจน

    -- ===== Subquery สำหรับดึง Project =====
    (SELECT TOP 1 L.Project
     FROM QUT1 L
     WHERE L.DocEntry = OQUT.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',
    -- =====================================

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Tel1 AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
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
    QUT1.U_SLD_Dis_Amount,
    OQUT.U_SDL_InternalNo,
    OUGP.UgpCode

FROM OQUT  
INNER JOIN QUT1 ON OQUT.DocEntry = QUT1.DocEntry 
LEFT JOIN OITM ON QUT1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B') 
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series 
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE 
LEFT JOIN OUGP ON QUT1.UomCode = OUGP.UgpCode
INNER JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM 

WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ========================================================
-- ส่วนที่ 2: ดึงข้อมูลจากเอกสารร่าง (ODRF) - ObjectId = '112'
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS 'Coontact',
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
    DRF1.VisOrder AS 'No.',
    DRF1.LineNum AS 'Line No.', 
    DRF1.ItemCode,
    OITM.ItemName AS 'Dscription',
    DRF1.Quantity,
    DRF1.PriceBefDi,
    CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.GrosProfit ELSE ODRF.GrosProfFC END AS 'GrossProfit',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    SUM(CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END) OVER() AS 'Sum_LineTotal_All',
    DRF1.DiscPrcnt,
    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    DRF1.unitMsr,
    ODRF.Comments,
    DRF1.LineType AS 'LineType', -- 🟢 ระบุชื่อฟิลด์ชัดเจน

    -- ===== Subquery สำหรับดึง Project ของ Draft =====
    (SELECT TOP 1 L.Project
     FROM DRF1 L
     WHERE L.DocEntry = ODRF.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',
    -- ==============================================

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Tel1 AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
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
    DRF1.U_SLD_Dis_Amount,
    ODRF.U_SDL_InternalNo,
    OUGP.UgpCode

FROM ODRF  
INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry 
LEFT JOIN OITM ON DRF1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType ='B') 
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series 
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE 
LEFT JOIN OUGP ON DRF1.UomCode = OUGP.UgpCode
INNER JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM 

-- เช็คว่าเป็น Draft (112) และเป็น Draft ของเอกสารประเภท 23 (ใบเสนอราคา)
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

-- ========================================================
-- การจัดเรียง (ORDER BY) ให้อยู่ล่างสุด
-- ========================================================
ORDER BY [No.], [Line No.]
