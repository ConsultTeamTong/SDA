-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
-- Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
-- Extracted: 2026-09-24 10:20:46
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- RPT: 2. Sales - AR\1. Sales Quotation\2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
-- SCOPE: main
-- ALIAS: AR_SQ
-- FIELDS: 63
-- ---------------------------------------------------------------
-- ========================================================
-- ส่วนที่ 1.1: ดึงข้อมูลรายการสินค้า (Item Rows) ของใบเสนอราคาจริง (OQUT) - ObjectId = '23'
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
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

    DENSE_RANK() OVER (ORDER BY QUT1.VisOrder ASC) AS 'No.',
    QUT1.LineNum AS 'Line No.',
    QUT1.ItemCode,
    QUT1.Dscription AS 'Dscription',
    QUT1.Quantity,
    QUT1.PriceBefDi,
    CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.GrosProfit ELSE OQUT.GrosProfFC END AS 'GrossProfit',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OQUT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry) AS 'Sum_LineTotal_All',
    QUT1.DiscPrcnt,
    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    QUT1.unitMsr,
    OQUT.Comments,
    ISNULL(QUT1.LineType, '') AS 'LineType',

    (SELECT TOP 1 L.Project FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,

    CRD1.Street       AS 'Street / PO Box12',
    CRD1.StreetNo     AS 'Street No.12',
    CRD1.Block        AS 'Block12',
    CRD1.City         AS 'City12',
    CRD1.ZipCode      AS 'Zip Code12',
    CRD1.County       AS 'County12',
    CRD1.State        AS 'State12',
    CRD1.Country      AS 'Country/Region12',

    QUT1.U_SLD_Dis_Amount,
    OQUT.U_SDL_InternalNo,
    ISNULL(NULLIF(OUOM.UomName,''), QUT1.UomCode) AS UgpCode,

    QUT1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
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
LEFT JOIN OUOM ON QUT1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ========================================================
-- ส่วนที่ 1.2: ดึงข้อมูลข้อความ (Text Rows) ของใบเสนอราคาจริง (OQUT)
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
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

    CAST(NULL AS INT) AS 'No.',

    -- ดึง Line No. จากตาราง QUT1 ของสินค้าแม่มาใช้ เพื่อให้ตัวเลขตรงกันเป๊ะ
    QUT1.LineNum AS 'Line No.',

    NULL AS 'ItemCode',
    CAST(QUT10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.GrosProfit ELSE OQUT.GrosProfFC END AS 'GrossProfit',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN OQUT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'DiscPrcnt',
    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    NULL AS 'unitMsr',
    OQUT.Comments,
    'T' AS 'LineType',

    (SELECT TOP 1 L.Project FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,

    CRD1.Street       AS 'Street / PO Box12',
    CRD1.StreetNo     AS 'Street No.12',
    CRD1.Block        AS 'Block12',
    CRD1.City         AS 'City12',
    CRD1.ZipCode      AS 'Zip Code12',
    CRD1.County       AS 'County12',
    CRD1.State        AS 'State12',
    CRD1.Country      AS 'Country/Region12',

    NULL AS 'U_SLD_Dis_Amount',
    OQUT.U_SDL_InternalNo,
    NULL AS 'UgpCode',

    -- อ้างอิงลำดับ VisOrder จากสินค้าแม่ เพื่อจัดกลุ่ม
    COALESCE(QUT1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    QUT10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM OQUT
INNER JOIN QUT10 ON OQUT.DocEntry = QUT10.DocEntry
-- หัวใจสำคัญคือการ JOIN ตรงนี้: จับคู่ด้วย AftLineNum = LineNum
LEFT JOIN QUT1 ON QUT10.DocEntry = QUT1.DocEntry AND QUT10.AftLineNum = QUT1.LineNum
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ========================================================
-- ส่วนที่ 2.1: ดึงข้อมูลรายการสินค้า (Item Rows) ของเอกสารร่าง (ODRF) - ObjectId = '112'
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
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

    DENSE_RANK() OVER (ORDER BY DRF1.VisOrder ASC) AS 'No.',
    DRF1.LineNum AS 'Line No.',
    DRF1.ItemCode,
    DRF1.Dscription AS 'Dscription',
    DRF1.Quantity,
    DRF1.PriceBefDi,
    CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.GrosProfit ELSE ODRF.GrosProfFC END AS 'GrossProfit',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',
    DRF1.DiscPrcnt,
    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    DRF1.unitMsr,
    ODRF.Comments,
    ISNULL(DRF1.LineType, '') AS 'LineType',

    (SELECT TOP 1 L.Project FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,

    CRD1.Street       AS 'Street / PO Box12',
    CRD1.StreetNo     AS 'Street No.12',
    CRD1.Block        AS 'Block12',
    CRD1.City         AS 'City12',
    CRD1.ZipCode      AS 'Zip Code12',
    CRD1.County       AS 'County12',
    CRD1.State        AS 'State12',
    CRD1.Country      AS 'Country/Region12',

    DRF1.U_SLD_Dis_Amount,
    ODRF.U_SDL_InternalNo,
    ISNULL(NULLIF(OUOM.UomName,''), DRF1.UomCode) AS UgpCode,

    DRF1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
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
LEFT JOIN OUOM ON DRF1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

UNION ALL

-- ========================================================
-- ส่วนที่ 2.2: ดึงข้อมูลข้อความ (Text Rows) ของเอกสารร่าง (ODRF)
-- ========================================================
SELECT DISTINCT
    CASE WHEN OCRD.Phone2 IS NULL THEN ''
         WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Coontact',
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

    CAST(NULL AS INT) AS 'No.',

    -- ดึง Line No. จาก DRF1 ของสินค้าแม่
    DRF1.LineNum AS 'Line No.',

    NULL AS 'ItemCode',
    CAST(DRF10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.GrosProfit ELSE ODRF.GrosProfFC END AS 'GrossProfit',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',
    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
        FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',
    NULL AS 'DiscPrcnt',
    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    NULL AS 'unitMsr',
    ODRF.Comments,
    'T' AS 'LineType',

    (SELECT TOP 1 L.Project FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    OCTG.PymntGroup,
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,

    CRD1.Street       AS 'Street / PO Box12',
    CRD1.StreetNo     AS 'Street No.12',
    CRD1.Block        AS 'Block12',
    CRD1.City         AS 'City12',
    CRD1.ZipCode      AS 'Zip Code12',
    CRD1.County       AS 'County12',
    CRD1.State        AS 'State12',
    CRD1.Country      AS 'Country/Region12',

    NULL AS 'U_SLD_Dis_Amount',
    ODRF.U_SDL_InternalNo,
    NULL AS 'UgpCode',

    COALESCE(DRF1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DRF10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry AND L.Project IS NOT NULL AND L.Project <> '' GROUP BY L.Project ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM ODRF
INNER JOIN DRF10 ON ODRF.DocEntry = DRF10.DocEntry
-- JOIN ด้วย AftLineNum = LineNum เช่นเดียวกัน
LEFT JOIN DRF1 ON DRF10.DocEntry = DRF1.DocEntry AND DRF10.AftLineNum = DRF1.LineNum
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

-- ========================================================
-- จัดเรียงลำดับในขั้นสุดท้าย
-- ========================================================
ORDER BY
    [Sort_VisOrder] ASC,
    [Sort_IsText] ASC,
    [Sort_Seq] ASC

