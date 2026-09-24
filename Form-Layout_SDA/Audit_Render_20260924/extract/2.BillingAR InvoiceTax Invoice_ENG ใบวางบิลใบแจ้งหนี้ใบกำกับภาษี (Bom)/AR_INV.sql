-- ============================================================
-- Report: 2.BillingAR InvoiceTax Invoice_ENG ใบวางบิลใบแจ้งหนี้ใบกำกับภาษี (Bom).rpt
-- Path:   2.BillingAR InvoiceTax Invoice_ENG ใบวางบิลใบแจ้งหนี้ใบกำกับภาษี (Bom).rpt
-- Extracted: 2026-09-24 10:20:38
-- Source: Main Report
-- Table:  AR_INV
-- ============================================================

-- RPT: 2. Sales - AR\6. AR Invoice\2.AR Invoice_ใบแจ้งหนี้_(Dis)\1.AR Invoice_ENG_ปกติ ใบแจ้งหนี้_(Dis).rpt
-- SCOPE: main
-- ALIAS: AR_INV
-- FIELDS: 51
-- ---------------------------------------------------------------
-- ============================================================
-- BOM roll-up. ComponentSums collects every CHILD line and pins it to the
-- closest PARENT line above it; GroupedParent sums those per parent.
-- Parent  = TreeType S/A/T, or an item that exists in OITT (SAP saves some
--           Template BOM headers as TreeType 'N').
-- Child   = TreeType I/i, or TreeType 'N' whose ItemCode is a component of
--           that parent in ITT1 (Template BOM children).
-- Children are hidden from the printed rows; their amounts are rolled up.
-- ============================================================
WITH ComponentSums AS (
    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder FROM INV1 P
          WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder
            AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
          ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
        T0.U_SLD_T_BeDis                                  AS PriceBefDi,
        T0.U_SLD_Dis_Amount                               AS U_SLD_Dis_Amount,
        CASE WHEN H.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '13' AS ObjType
    FROM INV1 T0
    INNER JOIN OINV H ON T0.DocEntry = H.DocEntry
    WHERE T0.DocEntry = {?DocKey@} AND {?ObjectId@} = '13'
      AND (
          T0.TreeType IN ('I', 'i')
          OR (
              ISNULL(T0.TreeType, 'N') = 'N'
              AND EXISTS (
                  SELECT 1 FROM ITT1
                   WHERE ITT1.Code = T0.ItemCode
                     AND ITT1.Father = (
                         SELECT TOP 1 P.ItemCode FROM INV1 P
                          WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder
                            AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                          ORDER BY P.VisOrder DESC)
              )
          )
      )

    UNION ALL

    SELECT
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder FROM DRF1 P
          WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder
            AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
          ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
        T0.U_SLD_T_BeDis                                  AS PriceBefDi,
        T0.U_SLD_Dis_Amount                               AS U_SLD_Dis_Amount,
        CASE WHEN H.DocCur = 'THB' THEN T0.LineTotal ELSE T0.TotalFrgn END AS CompLineTotal,
        '112' AS ObjType
    FROM DRF1 T0
    INNER JOIN ODRF H ON T0.DocEntry = H.DocEntry
    WHERE T0.DocEntry = {?DocKey@} AND {?ObjectId@} = '112' AND H.ObjType = '13'
      AND (
          T0.TreeType IN ('I', 'i')
          OR (
              ISNULL(T0.TreeType, 'N') = 'N'
              AND EXISTS (
                  SELECT 1 FROM ITT1
                   WHERE ITT1.Code = T0.ItemCode
                     AND ITT1.Father = (
                         SELECT TOP 1 P.ItemCode FROM DRF1 P
                          WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder
                            AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                          ORDER BY P.VisOrder DESC)
              )
          )
      )
),
GroupedParent AS (
    SELECT
        DocEntry,
        Parent_VisOrder,
        SUM(PriceBefDi)       AS PriceBefDi,
        SUM(U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
        SUM(CompLineTotal)    AS Sum_LineTotal,
        ObjType
    FROM ComponentSums
    WHERE Parent_VisOrder IS NOT NULL
    GROUP BY DocEntry, Parent_VisOrder, ObjType
)
SELECT T0.*
FROM (
-- ========================================================
-- 1.1 item rows of the real document (OINV)
-- ========================================================
SELECT DISTINCT

OCPR.Name AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' THEN 'Original'
 WHEN OINV.Printed = 'Y' THEN 'Copy'
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
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,

    -- แปลงเงื่อนไขการชำระเงินเป็นภาษาอังกฤษ (วัน -> Days, เงินสด -> Cash)
    CASE 
        WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
        ELSE LTRIM(RTRIM(REPLACE(OCTG.PymntGroup, N'วัน', 'Days')))
    END AS 'PymntGroup',

OINV.DocDueDate,

DENSE_RANK() OVER (ORDER BY INV1.VisOrder ASC) As 'No.',
INV1.LineNum as 'Line No.',
 
INV1.ItemCode,
COALESCE(GPS.U_SLD_Dis_Amount, INV1.U_SLD_Dis_Amount) AS 'U_SLD_Dis_Amount',
INV1.Dscription as 'Dscription',
INV1.Quantity,
INV1.DiscPrcnt,
OINV.Comments,
OINV.DocCur,
COALESCE(GPS.PriceBefDi, INV1.PriceBefDi) AS 'PriceBefDi',

COALESCE(NULLIF(CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END, 0), GPS.Sum_LineTotal, 0) AS 'LineTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',

    (SELECT CASE WHEN OINV.DocCur = 'THB'
                 THEN SUM(COALESCE(NULLIF(L.LineTotal, 0), G2.Sum_LineTotal, 0))
                 ELSE SUM(COALESCE(NULLIF(L.TotalFrgn, 0), G2.Sum_LineTotal, 0))
            END
        FROM INV1 L
        LEFT JOIN GroupedParent G2 ON G2.DocEntry = L.DocEntry AND G2.Parent_VisOrder = L.VisOrder AND G2.ObjType = '13'
       WHERE L.DocEntry = OINV.DocEntry
      AND ISNULL(L.TreeType, 'N') NOT IN ('I', 'i')
      AND NOT (
          ISNULL(L.TreeType, 'N') = 'N'
          AND EXISTS (
              SELECT 1 FROM ITT1
               WHERE ITT1.Code = L.ItemCode
                 AND ITT1.Father = (
                     SELECT TOP 1 P.ItemCode FROM INV1 P
                      WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder
                        AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                      ORDER BY P.VisOrder DESC)
          )
      )    ) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
INV1.LineType,
QPJ.Project,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,
OCRY.Name         AS 'CountryName',
CRD1.StreetNo AS StreetNoB,
CRD1.Block AS BlockB,
CRD1.City AS CityB,
CRD1.ZipCode AS ZipCodeB,
CRD1.County AS CountyB,
CRD1.Country AS CountryB,

ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), INV1.UomCode) AS UgpCode,

    COALESCE(INV1.VisOrder, -1) AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM OINV
Left JOIN INV1 ON OINV.DocEntry = INV1.DocEntry
LEFT JOIN GroupedParent GPS ON INV1.DocEntry = GPS.DocEntry AND INV1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '13'
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM INV1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUOM ON INV1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '13'
  AND ISNULL(INV1.TreeType, 'N') NOT IN ('I', 'i')
  AND NOT (
      ISNULL(INV1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
           WHERE ITT1.Code = INV1.ItemCode
             AND ITT1.Father = (
                 SELECT TOP 1 P.ItemCode FROM INV1 P
                  WHERE P.DocEntry = INV1.DocEntry AND P.VisOrder < INV1.VisOrder
                    AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                  ORDER BY P.VisOrder DESC)
      )
  )


UNION ALL
-- ========================================================
-- 1.2 text rows (remarks) of the real document (INV10)
-- ========================================================
SELECT DISTINCT

OCPR.Name AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' THEN 'Original'
 WHEN OINV.Printed = 'Y' THEN 'Copy'
 END AS 'Print Status',

OINV.DocEntry,
NNM1.BeginStr,
OINV.DocNum,
OINV.DocDate,
OINV.CardCode,
    NULL AS 'UnitMsr',
OINV.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,

    -- แปลงเงื่อนไขการชำระเงินเป็นภาษาอังกฤษ
    CASE 
        WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
        ELSE LTRIM(RTRIM(REPLACE(OCTG.PymntGroup, N'วัน', 'Days')))
    END AS 'PymntGroup',

OINV.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    INV1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    NULL AS 'U_SLD_Dis_Amount',
    CAST(INV10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'DiscPrcnt',

OINV.Comments,
OINV.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',

    (SELECT CASE WHEN OINV.DocCur = 'THB'
                 THEN SUM(COALESCE(NULLIF(L.LineTotal, 0), G2.Sum_LineTotal, 0))
                 ELSE SUM(COALESCE(NULLIF(L.TotalFrgn, 0), G2.Sum_LineTotal, 0))
            END
        FROM INV1 L
        LEFT JOIN GroupedParent G2 ON G2.DocEntry = L.DocEntry AND G2.Parent_VisOrder = L.VisOrder AND G2.ObjType = '13'
       WHERE L.DocEntry = OINV.DocEntry
      AND ISNULL(L.TreeType, 'N') NOT IN ('I', 'i')
      AND NOT (
          ISNULL(L.TreeType, 'N') = 'N'
          AND EXISTS (
              SELECT 1 FROM ITT1
               WHERE ITT1.Code = L.ItemCode
                 AND ITT1.Father = (
                     SELECT TOP 1 P.ItemCode FROM INV1 P
                      WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder
                        AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                      ORDER BY P.VisOrder DESC)
          )
      )    ) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
    'T' AS 'LineType',
QPJ.Project,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,
OCRY.Name         AS 'CountryName',
CRD1.StreetNo AS StreetNoB,
CRD1.Block AS BlockB,
CRD1.City AS CityB,
CRD1.ZipCode AS ZipCodeB,
CRD1.County AS CountyB,
CRD1.Country AS CountryB,

ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), INV1.UomCode) AS UgpCode,

    COALESCE(INV1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    INV10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM OINV
INNER JOIN INV10 ON OINV.DocEntry = INV10.DocEntry
LEFT JOIN INV1 ON INV10.DocEntry = INV1.DocEntry AND INV10.AftLineNum = INV1.LineNum

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM INV1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUOM ON INV1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '13'
  AND ISNULL(INV1.TreeType, 'N') NOT IN ('I', 'i')
  AND NOT (
      ISNULL(INV1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
           WHERE ITT1.Code = INV1.ItemCode
             AND ITT1.Father = (
                 SELECT TOP 1 P.ItemCode FROM INV1 P
                  WHERE P.DocEntry = INV1.DocEntry AND P.VisOrder < INV1.VisOrder
                    AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                  ORDER BY P.VisOrder DESC)
      )
  )


UNION ALL
-- ========================================================
-- 2.1 item rows of the draft document (ODRF)
-- ========================================================
SELECT DISTINCT

OCPR.Name AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' THEN 'Original'
 WHEN OINV.Printed = 'Y' THEN 'Copy'
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
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,

    -- แปลงเงื่อนไขการชำระเงินเป็นภาษาอังกฤษ
    CASE 
        WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
        ELSE LTRIM(RTRIM(REPLACE(OCTG.PymntGroup, N'วัน', 'Days')))
    END AS 'PymntGroup',

OINV.DocDueDate,

DENSE_RANK() OVER (ORDER BY INV1.VisOrder ASC) As 'No.',
INV1.LineNum as 'Line No.',
 
INV1.ItemCode,
COALESCE(GPS.U_SLD_Dis_Amount, INV1.U_SLD_Dis_Amount) AS 'U_SLD_Dis_Amount',
INV1.Dscription as 'Dscription',
INV1.Quantity,
INV1.DiscPrcnt,
OINV.Comments,
OINV.DocCur,
COALESCE(GPS.PriceBefDi, INV1.PriceBefDi) AS 'PriceBefDi',

COALESCE(NULLIF(CASE WHEN OINV.DocCur = 'THB' THEN INV1.LineTotal ELSE INV1.TotalFrgn END, 0), GPS.Sum_LineTotal, 0) AS 'LineTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',

    (SELECT CASE WHEN OINV.DocCur = 'THB'
                 THEN SUM(COALESCE(NULLIF(L.LineTotal, 0), G2.Sum_LineTotal, 0))
                 ELSE SUM(COALESCE(NULLIF(L.TotalFrgn, 0), G2.Sum_LineTotal, 0))
            END
        FROM DRF1 L
        LEFT JOIN GroupedParent G2 ON G2.DocEntry = L.DocEntry AND G2.Parent_VisOrder = L.VisOrder AND G2.ObjType = '112'
       WHERE L.DocEntry = OINV.DocEntry
      AND ISNULL(L.TreeType, 'N') NOT IN ('I', 'i')
      AND NOT (
          ISNULL(L.TreeType, 'N') = 'N'
          AND EXISTS (
              SELECT 1 FROM ITT1
               WHERE ITT1.Code = L.ItemCode
                 AND ITT1.Father = (
                     SELECT TOP 1 P.ItemCode FROM DRF1 P
                      WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder
                        AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                      ORDER BY P.VisOrder DESC)
          )
      )    ) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
INV1.LineType,
QPJ.Project,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,
OCRY.Name         AS 'CountryName',
CRD1.StreetNo AS StreetNoB,
CRD1.Block AS BlockB,
CRD1.City AS CityB,
CRD1.ZipCode AS ZipCodeB,
CRD1.County AS CountyB,
CRD1.Country AS CountryB,

ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), INV1.UomCode) AS UgpCode,

    COALESCE(INV1.VisOrder, -1) AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM ODRF OINV
Left JOIN DRF1 INV1 ON OINV.DocEntry = INV1.DocEntry
LEFT JOIN GroupedParent GPS ON INV1.DocEntry = GPS.DocEntry AND INV1.VisOrder = GPS.Parent_VisOrder AND GPS.ObjType = '112'
OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN DRF12 INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN DRF11 INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUOM ON INV1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OINV.ObjType = '13'
  AND ISNULL(INV1.TreeType, 'N') NOT IN ('I', 'i')
  AND NOT (
      ISNULL(INV1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
           WHERE ITT1.Code = INV1.ItemCode
             AND ITT1.Father = (
                 SELECT TOP 1 P.ItemCode FROM DRF1 P
                  WHERE P.DocEntry = INV1.DocEntry AND P.VisOrder < INV1.VisOrder
                    AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                  ORDER BY P.VisOrder DESC)
      )
  )


UNION ALL
-- ========================================================
-- 2.2 text rows (remarks) of the draft document (DRF10)
-- ========================================================
SELECT DISTINCT

OCPR.Name AS 'Coontact',

 CASE
 WHEN OINV.Printed = 'N' THEN 'Original'
 WHEN OINV.Printed = 'Y' THEN 'Copy'
 END AS 'Print Status',

OINV.DocEntry,
NNM1.BeginStr,
OINV.DocNum,
OINV.DocDate,
OINV.CardCode,
    NULL AS 'UnitMsr',
OINV.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,

    -- แปลงเงื่อนไขการชำระเงินเป็นภาษาอังกฤษ
    CASE 
        WHEN OCTG.PymntGroup = N'เงินสด' THEN 'Cash'
        ELSE LTRIM(RTRIM(REPLACE(OCTG.PymntGroup, N'วัน', 'Days')))
    END AS 'PymntGroup',

OINV.DocDueDate,
    CAST(NULL AS INT) AS 'No.',
    INV1.LineNum AS 'Line No.',
    NULL AS 'ItemCode',
    NULL AS 'U_SLD_Dis_Amount',
    CAST(INV10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'Quantity',
    NULL AS 'DiscPrcnt',

OINV.Comments,
OINV.DocCur,
    NULL AS 'PriceBefDi',
    NULL AS 'LineTotal',

CASE WHEN OINV.DocCur = 'THB' THEN OINV.DiscSum ELSE OINV.DiscSumFC END AS 'DiscSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.VatSum ELSE OINV.VatSumFC END AS 'VatSum',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DocTotal ELSE OINV.DocTotalFC END AS 'DocTotal',
CASE WHEN OINV.DocCur = 'THB' THEN OINV.DpmAmnt ELSE OINV.DpmAmntFC END AS 'DpmAmnt',

    (SELECT CASE WHEN OINV.DocCur = 'THB'
                 THEN SUM(COALESCE(NULLIF(L.LineTotal, 0), G2.Sum_LineTotal, 0))
                 ELSE SUM(COALESCE(NULLIF(L.TotalFrgn, 0), G2.Sum_LineTotal, 0))
            END
        FROM DRF1 L
        LEFT JOIN GroupedParent G2 ON G2.DocEntry = L.DocEntry AND G2.Parent_VisOrder = L.VisOrder AND G2.ObjType = '112'
       WHERE L.DocEntry = OINV.DocEntry
      AND ISNULL(L.TreeType, 'N') NOT IN ('I', 'i')
      AND NOT (
          ISNULL(L.TreeType, 'N') = 'N'
          AND EXISTS (
              SELECT 1 FROM ITT1
               WHERE ITT1.Code = L.ItemCode
                 AND ITT1.Father = (
                     SELECT TOP 1 P.ItemCode FROM DRF1 P
                      WHERE P.DocEntry = L.DocEntry AND P.VisOrder < L.VisOrder
                        AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                      ORDER BY P.VisOrder DESC)
          )
      )    ) AS 'Sum_LineTotal_All',

OINV.DiscPrcnt As 'DiscP',
    'T' AS 'LineType',
QPJ.Project,
OCPR.Name,
OCPR.Cellolar AS 'Tel1',
OCPR.E_MailL,

CRD1.Street AS StreetB,
CRD1.State        AS StateB,
OCRY.Name         AS 'CountryName',
CRD1.StreetNo AS StreetNoB,
CRD1.Block AS BlockB,
CRD1.City AS CityB,
CRD1.ZipCode AS ZipCodeB,
CRD1.County AS CountyB,
CRD1.Country AS CountryB,

ISNULL(NULLIF(OUOM.U_SLD_Uomforeign,''), INV1.UomCode) AS UgpCode,

    COALESCE(INV1.VisOrder, -1) AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    INV10.LineSeq AS 'Sort_Seq',
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'

FROM ODRF OINV
INNER JOIN DRF10 INV10 ON OINV.DocEntry = INV10.DocEntry
LEFT JOIN DRF1 INV1 ON INV10.DocEntry = INV1.DocEntry AND INV10.AftLineNum = INV1.LineNum

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OINV.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
Left JOIN DRF12 INV12 ON OINV.DocEntry = INV12.DocEntry
Left JOIN NNM1 ON OINV.Series = NNM1.Series 
Left JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
Left JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCRY ON CRD1.Country = OCRY.Code
Left JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
Left JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
Left JOIN OHEM ON OINV.OwnerCode = OHEM.empID
Left JOIN DRF11 INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
Left JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
Left JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OUOM ON INV1.UomCode = OUOM.UomCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OINV.ObjType = '13'
  AND ISNULL(INV1.TreeType, 'N') NOT IN ('I', 'i')
  AND NOT (
      ISNULL(INV1.TreeType, 'N') = 'N'
      AND EXISTS (
          SELECT 1 FROM ITT1
           WHERE ITT1.Code = INV1.ItemCode
             AND ITT1.Father = (
                 SELECT TOP 1 P.ItemCode FROM DRF1 P
                  WHERE P.DocEntry = INV1.DocEntry AND P.VisOrder < INV1.VisOrder
                    AND (P.TreeType IN ('S', 'A', 'T') OR EXISTS (SELECT 1 FROM OITT WHERE OITT.Code = P.ItemCode))
                  ORDER BY P.VisOrder DESC)
      )
  )

) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
