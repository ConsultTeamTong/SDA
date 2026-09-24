-- ============================================================
-- Report: 2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Path:   2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- Extracted: 2026-09-24 10:20:44
-- Source: Main Report
-- Table:  AR_SO
-- ============================================================

-- RPT: 2. Sales - AR\2. Sales Order\3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- SCOPE: main
-- ALIAS: AR_SO
-- FIELDS: 63
-- ---------------------------------------------------------------
-- RPT: 2. Sales - AR\2. Sales Order\3.Sale Order_ใบสั่งขาย_(Bomm)\2.Sale Order_ใบสั่งขาย_(Bom).rpt
-- SCOPE: main
-- ALIAS: AR_SO
-- FIELDS: 63
-- ---------------------------------------------------------------
WITH ComponentSums AS (
    -- 1. ส่วนคำนวณของเอกสาร Sales Order จริง (ORDR / RDR1) - ObjType = '17'
    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder 
         FROM RDR1 P 
         WHERE P.DocEntry = T0.DocEntry 
           AND P.VisOrder < T0.VisOrder 
           AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) 
         ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
        T0.U_SLD_T_BeDis AS PriceBefDi,
        T0.U_SLD_Dis_Amount AS U_SLD_Dis_Amount,
        CASE WHEN ORDR.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '17' AS ObjType
    FROM RDR1 T0
    INNER JOIN ORDR ON T0.DocEntry = ORDR.DocEntry
    WHERE T0.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '17'
      AND (
          T0.TreeType IN ('i', 'I') -- ลูก BOM ปกติ
          OR (
              -- ลูกที่ถูกแปลงเป็น N (Template BOM) แต่เช็คแล้วว่าเป็นลูกจริงๆ จาก Master Data
              ISNULL(T0.TreeType, 'N') = 'N'
              AND EXISTS (
                  SELECT 1 FROM ITT1
                  WHERE Code = T0.ItemCode
                    AND Father = (SELECT TOP 1 P.ItemCode FROM RDR1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
              )
          )
      )

    UNION ALL

    -- 2. ส่วนคำนวณของเอกสารร่าง (ODRF / DRF1) - ObjType = '112' (Draft SO)
    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder 
         FROM DRF1 P 
         WHERE P.DocEntry = T0.DocEntry 
           AND P.VisOrder < T0.VisOrder 
           AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) 
         ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
        T0.U_SLD_T_BeDis AS PriceBefDi,
        T0.U_SLD_Dis_Amount AS U_SLD_Dis_Amount,
        CASE WHEN ODRF.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '112' AS ObjType
    FROM DRF1 T0
    INNER JOIN ODRF ON T0.DocEntry = ODRF.DocEntry
    WHERE T0.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '17'
      AND (
          T0.TreeType IN ('i', 'I') -- ลูก BOM ปกติ
          OR (
              -- ลูกที่ถูกแปลงเป็น N (Template BOM) แต่เช็คแล้วว่าเป็นลูกจริงๆ จาก Master Data
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
-- 1.1 Item rows of the real document (ORDR / RDR1)
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
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

    -- ลำดับรายการรันใหม่ให้เรียงสวยงาม
    DENSE_RANK() OVER (ORDER BY RDR1.VisOrder ASC) AS 'No.',
    RDR1.LineNum AS 'Line No.',
    RDR1.ItemCode,
    RDR1.Dscription AS 'Dscription',
    RDR1.Quantity,

    COALESCE(GPS.PriceBefDi, RDR1.PriceBefDi) AS PriceBefDi,

    CASE
        WHEN RDR1.LineTotal = 0 THEN GPS.Sum_LineTotal
        ELSE CASE WHEN ORDR.DocCur = 'THB' THEN RDR1.LineTotal ELSE RDR1.TotalFrgn END
    END AS LineTotal,

    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DiscSum ELSE ORDR.DiscSumFC END AS 'DiscSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.VatSum ELSE ORDR.VatSumFC END AS 'VatSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DocTotal ELSE ORDR.DocTotalFC END AS 'DocTotal',

    (SELECT CASE WHEN ORDR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM RDR1 L 
      WHERE L.DocEntry = ORDR.DocEntry
        AND L.TreeType NOT IN ('I', 'i')
        AND NOT (
            ISNULL(L.TreeType, 'N') = 'N'
            AND EXISTS (
                SELECT 1 FROM ITT1
                WHERE Code = L.ItemCode
                  AND Father = (SELECT TOP 1 P.ItemCode FROM RDR1 P WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
            )
        )) AS 'Sum_LineTotal_All',

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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    RDR12.Streets     ,
    RDR12.StreetNos   ,
    RDR12.Blocks      ,
    RDR12.Citys       ,
    RDR12.ZipCodes    ,
    RDR12.Countys     ,
    RDR12.States      ,
    RDR12.Countrys    ,

    COALESCE(GPS.U_SLD_Dis_Amount, RDR1.U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
    OCPR.Name,
    OCPR.Cellolar AS 'Tel1',
    RDR1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM ORDR   
INNER JOIN RDR1 ON ORDR.DocEntry = RDR1.DocEntry 
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
LEFT JOIN GroupedParent GPS ON RDR1.DocEntry = GPS.DocEntry AND RDR1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '17'
CROSS JOIN OADM

WHERE ORDR.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '17'
  AND RDR1.TreeType NOT IN ('I', 'i')
  AND NOT (
      ISNULL(RDR1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
          WHERE Code = RDR1.ItemCode
            AND Father = (SELECT TOP 1 P.ItemCode FROM RDR1 P WHERE P.DocEntry = RDR1.DocEntry AND P.VisOrder < RDR1.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
      )
  )

UNION ALL

-- ========================================================
-- 1.2 Text rows (remarks) of the real document (RDR10)
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
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
    CAST(NULL AS INT) AS 'No.',
    RDR1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    CAST(RDR10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DiscSum ELSE ORDR.DiscSumFC END AS 'DiscSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.VatSum ELSE ORDR.VatSumFC END AS 'VatSum',
    CASE WHEN ORDR.DocCur = 'THB' THEN ORDR.DocTotal ELSE ORDR.DocTotalFC END AS 'DocTotal',

    (SELECT CASE WHEN ORDR.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM RDR1 L 
      WHERE L.DocEntry = ORDR.DocEntry
        AND L.TreeType NOT IN ('I', 'i')
        AND NOT (
            ISNULL(L.TreeType, 'N') = 'N'
            AND EXISTS (
                SELECT 1 FROM ITT1
                WHERE Code = L.ItemCode
                  AND Father = (SELECT TOP 1 P.ItemCode FROM RDR1 P WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
            )
        )) AS 'Sum_LineTotal_All',

    ORDR.DiscPrcnt AS 'DiscP',
    ORDR.DocCur,
    NULL AS 'unitMsr',
    ORDR.Comments,
    'T' AS 'LineType',
    QPJ.Project,
    OCPR.E_MailL,
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    RDR12.Streets     ,
    RDR12.StreetNos   ,
    RDR12.Blocks      ,
    RDR12.Citys       ,
    RDR12.ZipCodes    ,
    RDR12.Countys     ,
    RDR12.States      ,
    RDR12.Countrys    ,
    NULL AS 'U_SLD_Dis_Amount',
    OCPR.Name,
    OCPR.Cellolar AS 'Tel1',
    COALESCE(RDR1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    RDR10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM ORDR   
INNER JOIN RDR10 ON ORDR.DocEntry = RDR10.DocEntry
LEFT JOIN RDR1 ON RDR10.DocEntry = RDR1.DocEntry AND RDR10.AftLineNum = RDR1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM RDR1 P 
    WHERE P.DocEntry = ORDR.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ORDR.SlpCode = OHEM.salesPrson
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
-- 2.1 Item rows of the draft document (ODRF / DRF1)
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
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

    DENSE_RANK() OVER (ORDER BY DRF1.VisOrder ASC) AS 'No.',
    DRF1.LineNum AS 'Line No.',
    DRF1.ItemCode,
    DRF1.Dscription AS 'Dscription',
    DRF1.Quantity,

    COALESCE(GPS.PriceBefDi, DRF1.PriceBefDi) AS PriceBefDi,

    CASE
        WHEN DRF1.LineTotal = 0 THEN GPS.Sum_LineTotal
        ELSE CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END
    END AS LineTotal,

    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS 'DiscSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS 'VatSum',
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS 'DocTotal',

    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM DRF1 L 
      WHERE L.DocEntry = ODRF.DocEntry
        AND L.TreeType NOT IN ('I', 'i')
        AND NOT (
            ISNULL(L.TreeType, 'N') = 'N'
            AND EXISTS (
                SELECT 1 FROM ITT1
                WHERE Code = L.ItemCode
                  AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
            )
        )) AS 'Sum_LineTotal_All',

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
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    DRF12.Streets     ,
    DRF12.StreetNos   ,
    DRF12.Blocks      ,
    DRF12.Citys       ,
    DRF12.ZipCodes    ,
    DRF12.Countys     ,
    DRF12.States      ,
    DRF12.Countrys    ,

    COALESCE(GPS.U_SLD_Dis_Amount, DRF1.U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
    OCPR.Name,
    OCPR.Cellolar AS 'Tel1',
    DRF1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

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
LEFT JOIN GroupedParent GPS ON DRF1.DocEntry = GPS.DocEntry AND DRF1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '112'
CROSS JOIN OADM

WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '17'
  AND DRF1.TreeType NOT IN ('I', 'i')
  AND NOT (
      ISNULL(DRF1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
          WHERE Code = DRF1.ItemCode
            AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = DRF1.DocEntry AND P.VisOrder < DRF1.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
      )
  )

UNION ALL

-- ========================================================
-- 2.2 Text rows (remarks) of the draft document (DRF10)
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCPR.Cellolar IS NULL THEN ''
        ELSE OCPR.Cellolar
    END AS 'Phone2_Format',
    OCPR.Name AS 'Coontact',
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

    (SELECT CASE WHEN ODRF.DocCur = 'THB' THEN SUM(L.LineTotal) ELSE SUM(L.TotalFrgn) END
       FROM DRF1 L 
      WHERE L.DocEntry = ODRF.DocEntry
        AND L.TreeType NOT IN ('I', 'i')
        AND NOT (
            ISNULL(L.TreeType, 'N') = 'N'
            AND EXISTS (
                SELECT 1 FROM ITT1
                WHERE Code = L.ItemCode
                  AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder AND (P.TreeType IN ('S','A','T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode)) ORDER BY P.VisOrder DESC)
            )
        )) AS 'Sum_LineTotal_All',

    ODRF.DiscPrcnt AS 'DiscP',
    ODRF.DocCur,
    NULL AS 'unitMsr',
    ODRF.Comments,
    'T' AS 'LineType',
    QPJ.Project,
    OCPR.E_MailL,
    OSLP.SlpName AS 'Sale Name contact',
    OHEM.Mobile AS 'Mobile',
    OHEM.Email AS 'Email-Sale',
    CRD1.Street     AS 'Street / PO Box12',
    CRD1.StreetNo   AS 'Street No.12',
    CRD1.Block      AS 'Block12',
    CRD1.City       AS 'City12',
    CRD1.ZipCode    AS 'Zip Code12',
    CRD1.County     AS 'County12',
    CRD1.State      AS 'State12',
    CRD1.Country    AS 'Country/Region12',
    DRF12.Streets     ,
    DRF12.StreetNos   ,
    DRF12.Blocks      ,
    DRF12.Citys       ,
    DRF12.ZipCodes    ,
    DRF12.Countys     ,
    DRF12.States      ,
    DRF12.Countrys    ,
    NULL AS 'U_SLD_Dis_Amount',
    OCPR.Name,
    OCPR.Cellolar AS 'Tel1',
    COALESCE(DRF1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    DRF10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM ODRF   
INNER JOIN DRF10 ON ODRF.DocEntry = DRF10.DocEntry
LEFT JOIN DRF1 ON DRF10.DocEntry = DRF1.DocEntry AND DRF10.AftLineNum = DRF1.VisOrder
OUTER APPLY (
    SELECT TOP 1 P.Project 
    FROM DRF1 P 
    WHERE P.DocEntry = ODRF.DocEntry 
      AND P.Project IS NOT NULL 
      AND P.Project <> ''
) QPJ
LEFT JOIN OHEM ON ODRF.SlpCode = OHEM.salesPrson
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

WHERE ODRF.DocEntry = '{?DocKey@}' AND '{?ObjectId@}' = '112' AND ODRF.ObjType = '17'

ORDER BY
    [Sort_VisOrder] ASC,
    [Sort_IsText] ASC,
    [Sort_Seq] ASC
