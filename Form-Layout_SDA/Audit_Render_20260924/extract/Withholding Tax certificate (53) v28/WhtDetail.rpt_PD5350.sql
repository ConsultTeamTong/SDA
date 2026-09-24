-- ============================================================
-- Report: Withholding Tax certificate (53) v28.rpt
-- Path:   Withholding Tax certificate (53) v28.rpt
-- Extracted: 2026-09-24 10:21:04
-- Source: Subreport [WhtDetail.rpt]
-- Table:  PD5350
-- ============================================================

SELECT 
  ROW_NUMBER() OVER (
    Partition By B.TransId, 
    CardCode ,RunNo
    ORDER BY 
    RunNo
  ) As Row, 
  B.TransId, 
  Sum(B.TaxbleAmnt) As TaxbleAmnt, 
  Sum(B.WTAmnt) As WTAmnt, 
  LEFT(
    CONVERT(
      VARCHAR, 
      DATEADD(YEAR, 543, B.WHTDate), 
      112
    ), 
    4
  ) AS WHTYEAR, 
  B.WHTDate, 
  B.WTCode, 
  B.WTName, 
  B.CardCode, 
  B.LicTradNum, 
  B.RunNo 
FROM 
  (
    SELECT 
      'OVPM' AS TYPE, 
      (
        SELECT 
          TOP 1 [U_DocWht] 
        FROM 
          [@SLDT_WTS_TST] 
        WHERE 
          [U_Status] = 'Y' 
          And [U_TransID] = [OVPM].[TransId] 
          AND [U_Date_Wht] = FORMAT([OVPM].[TaxDate], 'yyyyMMdd') 
          AND [U_LicTradNum] = (
            SELECT 
              [OCRD].[LicTradNum] 
            FROM 
              [OCRD] 
              JOIN [CRD1] ON [OCRD].[CardCode] = [CRD1].[CardCode] 
            WHERE 
              [OCRD].[CardCode] = [OVPM].[CardCode] 
              AND [OVPM].[PayToCode] = [CRD1].[Address] 
              AND [CRD1].[AdresType] = 'B'
          )
      ) AS RunNo, 
      OVPM.TransId, 
      OVPM.CardCode, 
      CASE WHEN CHWTH.WTCode IS NULL THEN VPM6.TaxbleAmnt ELSE WTH.TaxbleAmnt END AS TaxbleAmnt, 
      CASE WHEN CHWTH.WTCode IS NULL THEN VPM6.WTSum ELSE WTH.WTAmnt END AS WTAmnt, 
      OVPM.TaxDate as WHTDate, 
      OCRD.LicTradNum, 
      OWHT.WTCode, 
      OWHT.WTName 
    FROM 
      OVPM 
      LEFT JOIN VPM6 ON OVPM.DocEntry = VPM6.DocNum 
      LEFT JOIN OWHT ON VPM6.WTCode = OWHT.WTCode 
      LEFT JOIN OCRD ON OCRD.CardCode = OVPM.CardCode 
      LEFT JOIN (
        SELECT 
          DISTINCT DocNum, 
          WTCode 
        FROM 
          VPM6 
        WHERE 
          VPM6.WTSum < 0
      ) AS CHWTH ON OVPM.DocEntry = CHWTH.DocNum 
      LEFT JOIN (
        SELECT 
          VPM6.DocNum, 
          VPM6.WTCode, 
          VPM6.Line, 
          SUM(VPM6.WTSum) AS WTAmnt, 
          (
            (
              SUM(VPM6.WTSum)* 100
            )/ OWHT.Rate
          ) AS TaxbleAmnt 
        FROM 
          VPM6 
          LEFT JOIN OWHT ON OWHT.WTCode = VPM6.WTCode 
        GROUP BY 
          VPM6.DocNum, 
          VPM6.WTCode, 
          OWHT.Rate, 
          VPM6.Line
      ) AS WTH ON OVPM.DocEntry = WTH.DocNum 
      AND WTH.WTCode = VPM6.WTCode 
      AND VPM6.Line = WTH.Line 
    WHERE 
      OVPM.TransId IN (
        SELECT 
          TransId 
        FROM 
          JDT1 
        WHERE 
          JDT1.ShortName = (
            SELECT 
              AcctCode 
            FROM 
              OACT 
            WHERE 
              FormatCode = (
                SELECT 
                  [Name] 
                FROM 
                  [@SLDT_SET_ACCWH] 
                WHERE 
                  U_SLD_TypeWH = '53'
              )
          )
      ) 
    UNION ALL 
    SELECT 
      'OPCH' AS TYPE, 
      (
        Select 
          TOP 1 [U_DocWht] 
        from 
          [@SLDT_WTS_TST] 
        where 
          [U_Status] = 'Y' 
          And [U_TransID] = [OPCH].[TransId] 
          AND [U_Date_Wht] = FORMAT([OPCH].[TaxDate], 'yyyyMMdd') 
          And [U_LicTradNum] = [OPCH].[LicTradNum]
      ) AS RunNo, 
      OPCH.TransId, 
      OPCH.CardCode, 
      PCH5.TaxbleAmnt, 
      PCH5.WTAmnt AS WTAmnt, 
      OPCH.TaxDate as WHTDate, 
      OPCH.LicTradNum, 
      OWHT.WTCode, 
      OWHT.WTName 
    FROM 
      OPCH 
      JOIN PCH5 ON OPCH.DocEntry = PCH5.AbsEntry 
      JOIN OWHT ON PCH5.WTCode = OWHT.WTCode 
    WHERE 
      OPCH.TransId IN (
        SELECT 
          TransId 
        FROM 
          JDT1 
        WHERE 
          JDT1.ShortName = (
            SELECT 
              AcctCode 
            FROM 
              OACT 
            WHERE 
              FormatCode = (
                SELECT 
                  [Name] 
                FROM 
                  [@SLDT_SET_ACCWH] 
                WHERE 
                  U_SLD_TypeWH = '53'
              )
          )
      ) 
    UNION ALL 
    SELECT 
      'OJDT' AS TYPE, 
      (
        SELECT 
          TOP 1 [U_DocWht] 
        FROM 
          [@SLDT_WTS_TST] 
        WHERE 
          [U_Status] = 'Y' 
          And [U_TransID] = [OJDT].[TransId] 
          AND [U_Date_Wht] = FORMAT([JDT1].[TaxDate], 'yyyyMMdd') 
          And [U_LicTradNum] = [JDT1].[LicTradNum]
      ) AS RunNo, 
      JDT1.TransId, 
      JDT1.U_SLD_SuppCode, 
      JDT2.TaxbleAmnt AS TaxbleAmnt, 
      JDT2.WTAmnt, 
      JDT1.TaxDate as WHTDate, 
      ISNULL(
        JDT1.LicTradNum, JDT1.U_SLD_LBPTaxID
      ) AS LicTradNum, 
      JDT2.WTCode, 
      (
        SELECT 
          WTName 
        FROM 
          OWHT 
        WHERE 
          WTCode = JDT2.WTCode
      ) AS WTName 
    FROM 
      JDT1 
      INNER JOIN OJDT ON JDT1.TransId = OJDT.TransId 
      INNER JOIN JDT2 ON JDT2.AbsEntry = OJDT.TransId 
      AND JDT2.Account = (
        SELECT 
          AcctCode 
        FROM 
          OACT 
        WHERE 
          FormatCode = (
            SELECT 
              [Name] 
            FROM 
              [@SLDT_SET_ACCWH] 
            WHERE 
              U_SLD_TypeWH = '53'
          )
      ) 
    WHERE 
      JDT1.Credit > 0 
    UNION ALL 
    SELECT 
      'OJDT' AS TYPE, 
      (
        SELECT 
          TOP 1 [U_DocWht] 
        FROM 
          [@SLDT_WTS_TST] 
        WHERE 
          [U_Status] = 'Y' 
          And [U_TransID] = [OJDT].[TransId] 
          AND [U_Date_Wht] = FORMAT([JDT1].[U_SLD_WHdate], 'yyyyMMdd')
          And [U_LicTradNum] = [JDT1].[U_SLD_LBPTaxID]
      ) AS RunNo, 
      JDT1.TransId, 
      JDT1.U_SLD_SuppCode, 
      JDT1.U_SLD_WTBaseAmt AS TaxbleAmnt, 
      (
        (
          JDT1.U_SLD_WTBaseAmt * (
            SELECT 
              OWHT.Rate 
            FROM 
              OWHT 
            WHERE 
              OWHT.WTCode = JDT1.U_SLD_WTCode 
              AND JDT1.ShortName = (
                SELECT 
                  AcctCode 
                FROM 
                  OACT 
                WHERE 
                  FormatCode = (
                    SELECT 
                      [Name] 
                    FROM 
                      [@SLDT_SET_ACCWH] 
                    WHERE 
                      U_SLD_TypeWH = '53'
                  )
              )
          )
        ) / 100.0
      ) AS WTAmnt, 
      JDT1.U_SLD_WHdate as WHTDate, 
      ISNULL(
        JDT1.LicTradNum, JDT1.U_SLD_LBPTaxID
      ) AS LicTradNum, 
      (
        SELECT 
          OWHT.WTCode 
        FROM 
          OWHT 
        WHERE 
          OWHT.WTCode = JDT1.U_SLD_WTCode 
          AND JDT1.ShortName = (
            SELECT 
              AcctCode 
            FROM 
              OACT 
            WHERE 
              FormatCode = (
                SELECT 
                  [Name] 
                FROM 
                  [@SLDT_SET_ACCWH] 
                WHERE 
                  U_SLD_TypeWH = '53'
              )
          )
      ) WTCode, 
      (
        SELECT 
          OWHT.WTName 
        FROM 
          OWHT 
        WHERE 
          OWHT.WTCode = JDT1.U_SLD_WTCode 
          AND JDT1.ShortName = (
            SELECT 
              AcctCode 
            FROM 
              OACT 
            WHERE 
              FormatCode = (
                SELECT 
                  [Name] 
                FROM 
                  [@SLDT_SET_ACCWH] 
                WHERE 
                  U_SLD_TypeWH = '53'
              )
          )
      ) WTName 
    FROM 
      JDT1 
      JOIN OJDT ON JDT1.TransId = OJDT.TransId 
    WHERE 
      (
        JDT1.ShortName = (
          SELECT 
            AcctCode 
          FROM 
            OACT 
          WHERE 
            FormatCode = (
              SELECT 
                [Name] 
              FROM 
                [@SLDT_SET_ACCWH] 
              WHERE 
                U_SLD_TypeWH = '53'
            )
        )
      )
  ) AS B 
WHERE 
  B.WTCode IS NOT NULL 
  AND B.WTAmnt > 0 --and Transid = '74138' 
Group by 
  B.TransId, 
  B.WHTDate, 
  B.WTCode, 
  B.WTName, 
  CardCode, 
  B.LicTradNum, 
  B.RunNo 
ORDER BY 
  B.TransId

