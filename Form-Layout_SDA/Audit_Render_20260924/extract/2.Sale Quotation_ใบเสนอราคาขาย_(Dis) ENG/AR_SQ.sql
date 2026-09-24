-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
-- Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis) ENG.rpt
-- Extracted: 2026-09-24 10:20:45
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- ============================================================
-- 1.1  ใบเสนอราคาจริง (OQUT) - บรรทัดสินค้า - ObjectId = '23'
-- ============================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Contact',
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

    -- บรรทัดสินค้า: ใช้ VisOrder เดิมบวก 1 (เริ่มที่ 1)
    DENSE_RANK() OVER (ORDER BY QUT1.VisOrder ASC) AS 'No.',

    QUT1.LineNum AS 'Line No.',
    QUT1.ItemCode,
    QUT1.Dscription AS 'Dscription',
    QUT1.Quantity,
    QUT1.PriceBefDi,
    CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum   ELSE OQUT.DiscSumFC   END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum    ELSE OQUT.VatSumFC    END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal  ELSE OQUT.DocTotalFC  END AS 'DocTotal',

    -- ยอดรวมทั้งใบ: ใช้ scalar subquery เพื่อให้บรรทัด text มีค่าเท่ากัน
    (SELECT CASE WHEN OQUT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry) AS 'Sum_LineTotal_All',

    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    QUT1.unitMsr,
    OQUT.Comments,
    ISNULL(QUT1.LineType, '') AS 'LineType',

    (SELECT TOP 1 L.Project
     FROM QUT1 L
     WHERE L.DocEntry = OQUT.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CASE
        WHEN OCTG.PymntGroup = N'เงินสด'  THEN 'Cash'
        WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
        WHEN OCTG.PymntGroup = N'90 วัน'  THEN '90 Days'
        WHEN OCTG.PymntGroup = N'60 วัน'  THEN '60 Days'
        WHEN OCTG.PymntGroup = N'45 วัน'  THEN '45 Days'
        WHEN OCTG.PymntGroup = N'30 วัน'  THEN '30 Days'
        WHEN OCTG.PymntGroup = N'15 วัน'  THEN '15 Days'
        WHEN OCTG.PymntGroup = N'7 วัน'   THEN '7 Days'
        WHEN OCTG.PymntGroup = N'3 วัน'   THEN '3 Days'
    END AS 'PaymentEng',
    OCRD.Cardname,
    OCRD.CardFname,
    OCPR.name,

    -- ที่อยู่จาก Master Data (CRD1)
    CRD1.Street       AS 'Street / PO Box12',
    CRD1.StreetNo     AS 'Street No.12',
    CRD1.Block        AS 'Block12',
    CRD1.City         AS 'City12',
    CRD1.ZipCode      AS 'Zip Code12',
    CRD1.County       AS 'County12',
    CRD1.State        AS 'State12',
    CRD1.Country      AS 'Country/Region12',
    OCRY.Name         AS 'CountryName',

    QUT1.U_SLD_Dis_Amount,
    OQUT.U_SDL_InternalNo,
    OUOM.U_SLD_Uomforeign AS UgpCode,

    QUT1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project
     FROM QUT1 L
     WHERE L.DocEntry = OQUT.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM OQUT
INNER JOIN QUT1 ON OQUT.DocEntry = QUT1.DocEntry
LEFT JOIN OITM ON QUT1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType = 'B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON QUT1.PROJECT = OPRJ.PRJCODE
LEFT JOIN OUOM ON QUT1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ============================================================
-- 1.2  ใบเสนอราคาจริง (OQUT) - บรรทัดหมายเหตุ (QUT10)
-- ============================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Contact',
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

    -- บรรทัดหมายเหตุ: ไม่มีเลขลำดับ
    CAST(NULL AS INT) AS 'No.',

    QUT1.LineNum AS 'Line No.',
    CAST(NULL AS NVARCHAR(50)) AS 'ItemCode',
    CAST(QUT10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    CAST(NULL AS NUMERIC(19,6)) AS 'Quantity',
    CAST(NULL AS NUMERIC(19,6)) AS 'PriceBefDi',
    CAST(NULL AS NUMERIC(19,6)) AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum  ELSE OQUT.DiscSumFC  END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum   ELSE OQUT.VatSumFC   END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',

    (SELECT CASE WHEN OQUT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry) AS 'Sum_LineTotal_All',

    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    CAST(NULL AS NVARCHAR(20)) AS 'unitMsr',
    OQUT.Comments,
    'T' AS 'LineType',

    (SELECT TOP 1 L.Project
     FROM QUT1 L
     WHERE L.DocEntry = OQUT.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CASE
        WHEN OCTG.PymntGroup = N'เงินสด'  THEN 'Cash'
        WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
        WHEN OCTG.PymntGroup = N'90 วัน'  THEN '90 Days'
        WHEN OCTG.PymntGroup = N'60 วัน'  THEN '60 Days'
        WHEN OCTG.PymntGroup = N'45 วัน'  THEN '45 Days'
        WHEN OCTG.PymntGroup = N'30 วัน'  THEN '30 Days'
        WHEN OCTG.PymntGroup = N'15 วัน'  THEN '15 Days'
        WHEN OCTG.PymntGroup = N'7 วัน'   THEN '7 Days'
        WHEN OCTG.PymntGroup = N'3 วัน'   THEN '3 Days'
    END AS 'PaymentEng',
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
    OCRY.Name         AS 'CountryName',

    CAST(NULL AS NUMERIC(19,6)) AS 'U_SLD_Dis_Amount',
    OQUT.U_SDL_InternalNo,
    CAST(NULL AS NVARCHAR(100)) AS UgpCode,

    COALESCE(QUT1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    QUT10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project
     FROM QUT1 L
     WHERE L.DocEntry = OQUT.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM OQUT
INNER JOIN QUT10 ON OQUT.DocEntry = QUT10.DocEntry
LEFT JOIN QUT1 ON QUT10.DocEntry = QUT1.DocEntry AND QUT10.AftLineNum = QUT1.LineNum
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType = 'B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ============================================================
-- 2.1  เอกสารร่าง (ODRF) - บรรทัดสินค้า - ObjectId = '112'
-- ============================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Contact',
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
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum   ELSE ODRF.DiscSumFC   END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum    ELSE ODRF.VatSumFC    END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal  ELSE ODRF.DocTotalFC  END AS 'DocTotal',

    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    DRF1.unitMsr,
    ODRF.Comments,
    ISNULL(DRF1.LineType, '') AS 'LineType',

    (SELECT TOP 1 L.Project
     FROM DRF1 L
     WHERE L.DocEntry = ODRF.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CASE
        WHEN OCTG.PymntGroup = N'เงินสด'  THEN 'Cash'
        WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
        WHEN OCTG.PymntGroup = N'90 วัน'  THEN '90 Days'
        WHEN OCTG.PymntGroup = N'60 วัน'  THEN '60 Days'
        WHEN OCTG.PymntGroup = N'45 วัน'  THEN '45 Days'
        WHEN OCTG.PymntGroup = N'30 วัน'  THEN '30 Days'
        WHEN OCTG.PymntGroup = N'15 วัน'  THEN '15 Days'
        WHEN OCTG.PymntGroup = N'7 วัน'   THEN '7 Days'
        WHEN OCTG.PymntGroup = N'3 วัน'   THEN '3 Days'
    END AS 'PaymentEng',
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
    OCRY.Name         AS 'CountryName',

    DRF1.U_SLD_Dis_Amount,
    ODRF.U_SDL_InternalNo,
    OUOM.U_SLD_Uomforeign AS UgpCode,

    DRF1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project
     FROM DRF1 L
     WHERE L.DocEntry = ODRF.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM ODRF
INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry
LEFT JOIN OITM ON DRF1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType = 'B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON DRF1.PROJECT = OPRJ.PRJCODE
LEFT JOIN OUOM ON DRF1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

UNION ALL

-- ============================================================
-- 2.2  เอกสารร่าง (ODRF) - บรรทัดหมายเหตุ (DRF10)
-- ============================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2',
    OCPR.Name AS 'Contact',
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

    DRF1.LineNum AS 'Line No.',
    CAST(NULL AS NVARCHAR(50)) AS 'ItemCode',
    CAST(DRF10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    CAST(NULL AS NUMERIC(19,6)) AS 'Quantity',
    CAST(NULL AS NUMERIC(19,6)) AS 'PriceBefDi',
    CAST(NULL AS NUMERIC(19,6)) AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum  ELSE ODRF.DiscSumFC  END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum   ELSE ODRF.VatSumFC   END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',

    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    CAST(NULL AS NVARCHAR(20)) AS 'unitMsr',
    ODRF.Comments,
    'T' AS 'LineType',

    (SELECT TOP 1 L.Project
     FROM DRF1 L
     WHERE L.DocEntry = ODRF.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC) AS 'Project',

    OCPR.E_MailL AS 'ContactEmail',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
    OSLP.U_Name_Foreign AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CASE
        WHEN OCTG.PymntGroup = N'เงินสด'  THEN 'Cash'
        WHEN OCTG.PymntGroup = N'120 วัน' THEN '120 Days'
        WHEN OCTG.PymntGroup = N'90 วัน'  THEN '90 Days'
        WHEN OCTG.PymntGroup = N'60 วัน'  THEN '60 Days'
        WHEN OCTG.PymntGroup = N'45 วัน'  THEN '45 Days'
        WHEN OCTG.PymntGroup = N'30 วัน'  THEN '30 Days'
        WHEN OCTG.PymntGroup = N'15 วัน'  THEN '15 Days'
        WHEN OCTG.PymntGroup = N'7 วัน'   THEN '7 Days'
        WHEN OCTG.PymntGroup = N'3 วัน'   THEN '3 Days'
    END AS 'PaymentEng',
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
    OCRY.Name         AS 'CountryName',

    CAST(NULL AS NUMERIC(19,6)) AS 'U_SLD_Dis_Amount',
    ODRF.U_SDL_InternalNo,
    CAST(NULL AS NVARCHAR(100)) AS UgpCode,

    COALESCE(DRF1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DRF10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = ((SELECT TOP 1 L.Project
     FROM DRF1 L
     WHERE L.DocEntry = ODRF.DocEntry
       AND L.Project IS NOT NULL
       AND L.Project <> ''
     GROUP BY L.Project
     ORDER BY COUNT(*) DESC, L.Project ASC))) AS 'ProjectName'
FROM ODRF
INNER JOIN DRF10 ON ODRF.DocEntry = DRF10.DocEntry
LEFT JOIN DRF1 ON DRF10.DocEntry = DRF1.DocEntry AND DRF10.AftLineNum = DRF1.LineNum
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType = 'B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM
WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

-- ============================================================
-- เรียงลำดับ: ตาม VisOrder ของบรรทัดสินค้า แล้วตามด้วย LineSeq ของหมายเหตุ
-- ============================================================
ORDER BY [Sort_VisOrder] ASC, [Sort_IsText] ASC,[Sort_Seq] ASC


