-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Path:   1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(Bom).rpt
Extracted: 2026-08-17 11:43:02
-- Source: Main Report
-- Table:  AR_SQ
-- ============================================================

-- ========================================================
-- ประกาศ CTE สำหรับคำนวณยอดของ Component (รองรับทั้ง OQUT และ ODRF)
-- ========================================================
WITH ComponentSums AS (
    -- 🟢 ส่วนคำนวณของเอกสารใบเสนอราคาจริง (OQUT)
    SELECT 
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder FROM QUT1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
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
                    AND Father = (SELECT TOP 1 P.ItemCode FROM QUT1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC)
              )
          )
      )

    UNION ALL

    -- 🟢 ส่วนคำนวณของเอกสารร่าง (ODRF)
    SELECT 
        T0.DocEntry,
        (SELECT TOP 1 P.VisOrder FROM DRF1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC) AS Parent_VisOrder,
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
                    AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = T0.DocEntry AND P.VisOrder < T0.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC)
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
-- 🟢 ส่วนที่ 1: ดึงข้อมูลจากใบเสนอราคาจริง (OQUT) - ObjectId = '23'
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        ELSE ', ' + OCRD.Phone2
    END AS Phone2_Format,
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS Coontact,
    OQUT.DocEntry,
    OQUT.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CASE 
        WHEN OCRD.GlblLocNum = '00000' THEN N'(สำนักงานใหญ่)'
        ELSE N'สาขาที่ ' + OCRD.GlblLocNum
    END AS [Branch Name],
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS Phone2,
    OCRD.Fax,
    OCRD.LicTradNum,
    OCRD.CardName,
    NNM1.BeginStr,
    OQUT.DocNum,
    OQUT.DocDate,
    OQUT.DocDueDate,
    QUT1.VisOrder AS [No.],
    QUT1.LineNum AS [Line No.], 
    QUT1.ItemCode,
    QUT1.Dscription AS Dscription,
    QUT1.Quantity,
    
    COALESCE(GPS.PriceBefDi, QUT1.PriceBefDi) AS PriceBefDi, 
    
    CASE 
        WHEN QUT1.LineTotal = 0 THEN GPS.Sum_LineTotal
        ELSE QUT1.LineTotal
    END AS LineTotal,
    
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.GrosProfit ELSE OQUT.GrosProfFC END AS GrossProfit,
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DiscSum ELSE OQUT.DiscSumFC END AS DiscSum,
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.VatSum ELSE OQUT.VatSumFC END AS VatSum,
    CASE WHEN OQUT.DocCur = 'THB' THEN OQUT.DocTotal ELSE OQUT.DocTotalFC END AS DocTotal,
    
    SUM(CASE WHEN OQUT.DocCur = 'THB' THEN QUT1.LineTotal ELSE QUT1.TotalFrgn END) OVER() AS Sum_LineTotal_All,
    
    QUT1.DiscPrcnt,
    OQUT.DiscPrcnt AS DiscP,
    OQUT.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    OQUT.CreateDate,
    OQUT.CntctCode,
    QUT1.unitMsr,
    OQUT.Comments,
    QUT1.LineType,
    QPJ.Project,
    OCPR.E_MailL AS Contact,
    OCPR.Cellolar AS [Mobile Phone],
    OCPR.Tel1 AS Tel1,
    OSLP.SlpName AS [Sale Name contact],
    OHEM.Mobile AS Mobile,
    OHEM.Email AS [Email-Sale],
    OCTG.PymntGroup,
    OCPR.Name,
    QUT12.StreetB     AS [Street / PO Box12],
    QUT12.StreetNoB   AS [Street No.12],
    QUT12.BlockB      AS [Block12],
    QUT12.CityB       AS [City12],
    QUT12.ZipCodeB    AS [Zip Code12],
    QUT12.CountyB     AS [County12],
    QUT12.StateB      AS [State12],
    QUT12.CountryB    AS [Country/Region12],
    
    COALESCE(GPS.U_SLD_Dis_Amount, QUT1.U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
    OCRD.CardFName

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
INNER JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code 
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
            AND Father = (SELECT TOP 1 P.ItemCode FROM QUT1 P WHERE P.DocEntry = QUT1.DocEntry AND P.VisOrder < QUT1.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC)
      )
  )

UNION ALL

-- ========================================================
-- 🟢 ส่วนที่ 2: ดึงข้อมูลจากเอกสารร่าง (ODRF) - ObjectId = '112'
-- ========================================================
SELECT DISTINCT
    CASE 
        WHEN OCRD.Phone2 IS NULL THEN ''
        ELSE ', ' + OCRD.Phone2
    END AS Phone2_Format,
    CONCAT(OCPR.FirstName, ' ', OCPR.LastName) AS Coontact,
    ODRF.DocEntry,
    ODRF.[Address],
    OCRD.U_SLD_Title,
    OCRD.U_SLD_FullName,
    CASE 
        WHEN OCRD.GlblLocNum = '00000' THEN N'(สำนักงานใหญ่)'
        ELSE N'สาขาที่ ' + OCRD.GlblLocNum
    END AS [Branch Name],
    CRD1.GlblLocNum,
    OCRD.Phone1,
    ISNULL(OCRD.Phone2,'') AS Phone2,
    OCRD.Fax,
    OCRD.LicTradNum,
    OCRD.CardName,
    NNM1.BeginStr,
    ODRF.DocNum,
    ODRF.DocDate,
    ODRF.DocDueDate,
    DRF1.VisOrder AS [No.],
    DRF1.LineNum AS [Line No.], 
    DRF1.ItemCode,
    DRF1.Dscription AS Dscription,
    DRF1.Quantity,
    
    COALESCE(GPS.PriceBefDi, DRF1.PriceBefDi) AS PriceBefDi, 
    
    CASE 
        WHEN DRF1.LineTotal = 0 THEN GPS.Sum_LineTotal
        ELSE DRF1.LineTotal
    END AS LineTotal,
    
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.GrosProfit ELSE ODRF.GrosProfFC END AS GrossProfit,
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DiscSum ELSE ODRF.DiscSumFC END AS DiscSum,
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.VatSum ELSE ODRF.VatSumFC END AS VatSum,
    CASE WHEN ODRF.DocCur = 'THB' THEN ODRF.DocTotal ELSE ODRF.DocTotalFC END AS DocTotal,
    
    SUM(CASE WHEN ODRF.DocCur = 'THB' THEN DRF1.LineTotal ELSE DRF1.TotalFrgn END) OVER() AS Sum_LineTotal_All,
    
    DRF1.DiscPrcnt,
    ODRF.DiscPrcnt AS DiscP,
    ODRF.DocCur,
    OCPR.FirstName,
    OCPR.LastName,
    ODRF.CreateDate,
    ODRF.CntctCode,
    DRF1.unitMsr,
    ODRF.Comments,
    DRF1.LineType,
    QPJ.Project,
    OCPR.E_MailL AS Contact,
    OCPR.Cellolar AS [Mobile Phone],
    OCPR.Tel1 AS Tel1,
    OSLP.SlpName AS [Sale Name contact],
    OHEM.Mobile AS Mobile,
    OHEM.Email AS [Email-Sale],
    OCTG.PymntGroup,
    OCPR.Name,
    DRF12.StreetB     AS [Street / PO Box12],
    DRF12.StreetNoB   AS [Street No.12],
    DRF12.BlockB      AS [Block12],
    DRF12.CityB       AS [City12],
    DRF12.ZipCodeB    AS [Zip Code12],
    DRF12.CountyB     AS [County12],
    DRF12.StateB      AS [State12],
    DRF12.CountryB    AS [Country/Region12],
    
    COALESCE(GPS.U_SLD_Dis_Amount, DRF1.U_SLD_Dis_Amount) AS U_SLD_Dis_Amount,
    OCRD.CardFName

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
INNER JOIN DRF12 ON ODRF.DocEntry = DRF12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ODRF.U_SLD_LVatBranch = BRANCH.Code 
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
            AND Father = (SELECT TOP 1 P.ItemCode FROM DRF1 P WHERE P.DocEntry = DRF1.DocEntry AND P.VisOrder < DRF1.VisOrder AND P.TreeType IN ('S', 'A', 'T') ORDER BY P.VisOrder DESC)
      )
  )

ORDER BY [No.], [Line No.]
