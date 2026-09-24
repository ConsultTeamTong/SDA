-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
-- Path:   1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
-- Extracted: 2026-09-24 10:20:31
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- RPT: 2. Sales - AR\1. Sales Quotation\1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
-- SCOPE: main
-- ALIAS: AR_SQ
-- FIELDS: 60
-- ---------------------------------------------------------------
-- ========================================================
-- ประกาศ CTE สำหรับคำนวณยอดของ Component (รองรับทั้ง OQUT และ ODRF)
-- ========================================================
WITH ComponentSums AS (
    -- ส่วนคำนวณของเอกสารใบเสนอราคาจริง (OQUT) - ObjType = 23
    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder
         FROM QUT1 P
         WHERE P.DocEntry = T0.DocEntry
           AND P.VisOrder < T0.VisOrder
           AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) -- รองรับแม่ BOM ทุกประเภท
         ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
         T0.U_SLD_T_BeDis AS PriceBefDi,
         T0.U_SLD_Dis_Amount AS U_SLD_Dis_Amount,
        CASE WHEN OQ.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '23' AS ObjType
    FROM QUT1 T0
    INNER JOIN OQUT OQ ON T0.DocEntry = OQ.DocEntry
    WHERE T0.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'
      AND (
          T0.TreeType IN ('i', 'I') -- ลูก BOM ปกติ
          OR (
              -- ลูกที่ถูก SAP แปลงเป็น N (Template BOM) แต่เช็คแล้วว่าเป็นลูกจริงๆ จาก Master Data
              ISNULL(T0.TreeType, 'N') = 'N'
              AND EXISTS (
                  SELECT 1 FROM ITT1
                  WHERE Code = T0.ItemCode
                    AND Father = (SELECT TOP 1 P.ItemCode FROM QUT1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
              )
          )
      )

    UNION ALL

    -- ส่วนคำนวณของเอกสารร่าง (ODRF) - ObjType = 112
    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder
         FROM DRF1 P
         WHERE P.DocEntry = T0.DocEntry
           AND P.VisOrder < T0.VisOrder
           AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) -- รองรับแม่ BOM ทุกประเภท
         ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
         T0.U_SLD_T_BeDis AS PriceBefDi,
         T0.U_SLD_Dis_Amount AS U_SLD_Dis_Amount,
        CASE WHEN OQ.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '112' AS ObjType
    FROM DRF1 T0
    INNER JOIN ODRF OQ ON T0.DocEntry = OQ.DocEntry
    WHERE T0.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND OQ.ObjType = '23'
      AND (
          T0.TreeType IN ('i', 'I') -- ลูก BOM ปกติ
          OR (
              -- ลูกที่ถูก SAP แปลงเป็น N (Template BOM) แต่เช็คแล้วว่าเป็นลูกจริงๆ จาก Master Data
              ISNULL(T0.TreeType, 'N') = 'N'
              AND EXISTS (
                  SELECT 1 FROM ITT1
                  WHERE Code = T0.ItemCode
                    AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
              )
          )
      )
),
GroupedParent AS (
    SELECT
        DocEntry,
        Parent_VisOrder,
        SUM(PriceBefDi) AS PriceBefDi,
        SUM(U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
        SUM(CompLineTotal) AS Sum_LineTotal,
        ObjType
    FROM ComponentSums
    WHERE Parent_VisOrder IS NOT NULL
    GROUP BY DocEntry, Parent_VisOrder, ObjType
)

-- ========================================================
-- ส่วนที่ 1.1: รายการสินค้า (Item Rows) ของใบเสนอราคาจริง (OQUT) - ObjectId = '23'
-- ========================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
    OQUT.DocEntry,
    OQUT.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2',
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

    CASE 
        WHEN QUT1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL 
        THEN (GPS.Sum_LineTotal / NULLIF(QUT1.Quantity, 0)) 
        ELSE QUT1.PriceBefDi 
    END AS PriceBefDi,

    CASE
        WHEN QUT1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL THEN GPS.Sum_LineTotal
        ELSE QUT1.LineTotal
    END AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',

    -- แก้ไข: บวก LineTotal ทั้งเอกสาร
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
    QUT1.LineType,
    QPJ.Project,
    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName12',

    CASE 
        WHEN QUT1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL THEN GPS.U_SLD_Dis_Amount 
        ELSE QUT1.U_SLD_Dis_Amount 
    END AS U_SLD_Dis_Amount,

    OUOM.U_SLD_Uomforeign AS UgpCode,
    QUT1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0             AS 'Sort_Seq'

FROM OQUT
INNER JOIN QUT1 ON OQUT.DocEntry = QUT1.DocEntry
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM QUT1 P
    WHERE P.DocEntry = OQUT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OITM ON QUT1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE
LEFT JOIN OITT ON QUT1.ItemCode = OITT.Code AND OITT.TreeType = 'S'
INNER JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OUOM ON QUT1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
-- ผูก GroupedParent โดยระบุ ObjType = '23'
LEFT JOIN GroupedParent GPS ON QUT1.DocEntry = GPS.DocEntry AND QUT1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '23'
CROSS JOIN OADM

WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'
  AND QUT1.TreeType NOT IN ('I', 'i') -- ซ่อนบรรทัดลูก BOM ปกติ
  AND NOT (
      -- ซ่อนบรรทัดลูก Template BOM ที่เช็คแล้วว่าผูกกับบรรทัดแม่ด้านบน
      ISNULL(QUT1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
          WHERE Code = QUT1.ItemCode
            AND Father = (SELECT TOP 1 P.ItemCode FROM QUT1 P WHERE P.DocEntry = QUT1.DocEntry AND P.VisOrder < QUT1.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
      )
  )

UNION ALL

-- ========================================================
-- ส่วนที่ 1.2: บรรทัดหมายเหตุ (Text Rows) ของใบเสนอราคาจริง (QUT10)
-- ========================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
    OQUT.DocEntry,
    OQUT.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2',
    OCRD.Fax,
    OCRD.LicTradNum,
    NNM1.BeginStr,
    OQUT.DocNum,
    OQUT.DocDate,
    OQUT.DocDueDate,

    -- บรรทัดหมายเหตุไม่กินเลขลำดับ
    CAST(NULL AS INT) AS 'No.',

    QUT1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(QUT10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS 'DiscSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS 'VatSum',
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS 'DocTotal',

    -- แก้ไข: บวก LineTotal ทั้งเอกสาร
    (SELECT CASE WHEN OQUT.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM QUT1 L WHERE L.DocEntry = OQUT.DocEntry) AS 'Sum_LineTotal_All',

    OQUT.DiscPrcnt AS 'DiscP',
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    NULL AS 'unitMsr',
    OQUT.Comments,
    'T' AS 'LineType',
    QPJ.Project,
    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName12',
    NULL AS U_SLD_Dis_Amount,
    NULL AS UgpCode,
    COALESCE(QUT1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    QUT10.LineSeq         AS 'Sort_Seq'

FROM OQUT
INNER JOIN QUT10 ON OQUT.DocEntry = QUT10.DocEntry
LEFT JOIN QUT1 ON QUT10.DocEntry = QUT1.DocEntry AND QUT10.AftLineNum = QUT1.LineNum
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM QUT1 P
    WHERE P.DocEntry = OQUT.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE
INNER JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM

WHERE OQUT.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '23'

UNION ALL

-- ========================================================
-- ส่วนที่ 2.1: รายการสินค้า (Item Rows) ของเอกสารร่าง (ODRF) - ObjectId = '112'
-- ========================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
    ODRF.DocEntry,
    ODRF.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2',
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
    
    CASE 
        WHEN DRF1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL 
        THEN (GPS.Sum_LineTotal / NULLIF(DRF1.Quantity, 0)) 
        ELSE DRF1.PriceBefDi 
    END AS PriceBefDi,

    CASE
        WHEN DRF1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL THEN GPS.Sum_LineTotal
        ELSE DRF1.LineTotal
    END AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',

    -- แก้ไข: บวก LineTotal ทั้งเอกสาร
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
    DRF1.LineType,
    QPJ.Project,
    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName12',

    CASE 
        WHEN DRF1.LineTotal = 0 AND GPS.Sum_LineTotal IS NOT NULL THEN GPS.U_SLD_Dis_Amount 
        ELSE DRF1.U_SLD_Dis_Amount 
    END AS U_SLD_Dis_Amount,

    OUOM.U_SLD_Uomforeign AS UgpCode,
    DRF1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0             AS 'Sort_Seq'

FROM ODRF
INNER JOIN DRF1 ON ODRF.DocEntry = DRF1.DocEntry
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ODRF.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OITM ON DRF1.ItemCode = OITM.ItemCode
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE
LEFT JOIN OITT ON DRF1.ItemCode = OITT.Code AND OITT.TreeType = 'S'
INNER JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN OUOM ON DRF1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
-- ผูก GroupedParent โดยระบุ ObjType = '112'
LEFT JOIN GroupedParent GPS ON DRF1.DocEntry = GPS.DocEntry AND DRF1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '112'
CROSS JOIN OADM

WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'
  AND DRF1.TreeType NOT IN ('I', 'i') -- ซ่อนบรรทัดลูก BOM ปกติ
  AND NOT (
      -- ซ่อนบรรทัดลูก Template BOM ที่เช็คแล้วว่าผูกกับบรรทัดแม่ด้านบน
      ISNULL(DRF1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
          WHERE Code = DRF1.ItemCode
            AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = DRF1.DocEntry AND P.VisOrder < DRF1.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
      )
  )

UNION ALL

-- ========================================================
-- ส่วนที่ 2.2: บรรทัดหมายเหตุ (Text Rows) ของเอกสารร่าง (DRF10)
-- ========================================================
SELECT DISTINCT
    CASE
        WHEN OCRD.Phone2 IS NULL THEN ''
        WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
    ODRF.DocEntry,
    ODRF.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS 'Phone2',
    OCRD.Fax,
    OCRD.LicTradNum,
    NNM1.BeginStr,
    ODRF.DocNum,
    ODRF.DocDate,
    ODRF.DocDueDate,

    CAST(NULL AS INT) AS 'No.',

    DRF1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(DRF10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',

    -- แก้ไข: บวก LineTotal ทั้งเอกสาร
    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM DRF1 L WHERE L.DocEntry = ODRF.DocEntry) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    NULL AS 'unitMsr',
    ODRF.Comments,
    'T' AS 'LineType',
    QPJ.Project,
    OCPR.E_MailL AS 'Contact',
    OCPR.Cellolar AS 'Mobile Phone',
    OCPR.Cellolar AS 'Tel1',
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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    OCRY.Name         AS 'CountryName12',
    NULL AS U_SLD_Dis_Amount,
    NULL AS UgpCode,
    COALESCE(DRF1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DRF10.LineSeq         AS 'Sort_Seq'

FROM ODRF
INNER JOIN DRF10 ON ODRF.DocEntry = DRF10.DocEntry
LEFT JOIN DRF1 ON DRF10.DocEntry = DRF1.DocEntry AND DRF10.AftLineNum = DRF1.LineNum
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = ODRF.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OCRD ON ODRF.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (ODRF.CardCode = CRD1.CardCode AND ODRF.PaytoCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON ODRF.CntctCode = OCPR.CntctCode
LEFT JOIN NNM1 ON ODRF.Series = NNM1.Series
LEFT JOIN OCTG ON ODRF.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
LEFT JOIN OSLP ON ODRF.SLPCODE = OSLP.SLPCODE
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PRJCODE
INNER JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code
CROSS JOIN OADM

WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '23'

-- ========================================================
-- การเรียงลำดับ (ORDER BY ต้องอยู่ล่างสุดของการทำ UNION)
-- ========================================================
ORDER BY [Sort_VisOrder] ASC, [Sort_IsText] ASC,[Sort_Seq] ASC
