-- ============================================================
-- Report: Withholding Income Tax Return (P.N.D.3)v28.rpt
-- Path:   Withholding Income Tax Return (P.N.D.3)v28.rpt
-- Extracted: 2026-09-24 10:21:03
-- Source: Main Report
-- Table:  WtaxAmnt
-- ============================================================

SELECT 
  SUM(TaxbleAmnt) AS TaxbleAmnt, 
  SUM(WTAmnt) AS WTAmnt, 
  CONVERT(Varchar, C.TransId) AS 'TransId',
  C.Branch AS Branch 
FROM 
  (
    SELECT DISTINCT
      ROW_NUMBER() OVER (ORDER BY  B.TransId) AS Row, 
      B.TransId, 
      SUM(B.TaxbleAmnt) AS TaxbleAmnt, 
      SUM(B.WTAmnt) AS WTAmnt, 
      B.Branch AS Branch
    FROM 
      (
        SELECT 
          'OVPM' AS TYPE, 
          OVPM.TransId, 
          	CASE WHEN CHWTH.WTCode IS NULL THEN VPM6.TaxbleAmnt ELSE WTH.TaxbleAmnt END AS TaxbleAmnt,
			CASE WHEN CHWTH.WTCode IS NULL THEN VPM6.WTSum ELSE WTH.WTAmnt END AS WTAmnt, 
          OVPM.TaxDate AS WHTDate, 
          OWHT.WTCode, 
          OWHT.WTName, 
          OVPM.U_SLD_VatBranch AS Branch 
        FROM 
          OVPM 
          INNER JOIN VPM6 ON OVPM.DocEntry = VPM6.DocNum 
          INNER JOIN OWHT ON VPM6.WTCode = OWHT.WTCode 
          LEFT JOIN (SELECT DISTINCT DocNum, WTCode 
      				FROM VPM6 
			        WHERE VPM6.WTSum < 0 
		) AS CHWTH ON OVPM.DocEntry = CHWTH.DocNum
		LEFT JOIN (SELECT VPM6.DocNum,
                        VPM6.WTCode,
						VPM6.Line,
                        SUM(VPM6.WTSum) AS WTAmnt ,
                        ((SUM(VPM6.WTSum)*100)/OWHT.Rate) AS TaxbleAmnt 
                 FROM VPM6
                 LEFT JOIN OWHT ON OWHT.WTCode = VPM6.WTCode
                 GROUP BY VPM6.DocNum,VPM6.WTCode,OWHT.Rate,VPM6.Line
		) AS WTH ON OVPM.DocEntry = WTH.DocNum AND WTH.WTCode = VPM6.WTCode AND VPM6.Line = WTH.Line 
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
                      [U_SLD_TypeWH] = '03'
                  )
              )
          ) 
-------------------------------------------------------------------------------------------------------------------------------
        UNION ALL
-------------------------------------------------------------------------------------------------------------------------------
        SELECT DISTINCT
          'OPCH' AS TYPE, 
          OPCH.TransId, 
          PCH5.TaxbleAmnt, 
          PCH5.WTAmnt AS WTAmnt, 
          OPCH.TaxDate AS WHTDate, 
          OWHT.WTCode, 
          OWHT.WTName, 
          OPCH.U_SLD_LVatBranch AS Branch 
        FROM 
          OPCH 
          INNER JOIN PCH5 ON OPCH.DocEntry = PCH5.AbsEntry 
          INNER JOIN OWHT ON PCH5.WTCode = OWHT.WTCode 
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
                      [U_SLD_TypeWH] = '03'
                  )
              )
          ) 
-------------------------------------------------------------------------------------------------------------------------------
        UNION ALL
-------------------------------------------------------------------------------------------------------------------------------
        SELECT 
          'OJDT' AS TYPE, 
          JDT1.TransId, 
          JDT2.TaxbleAmnt AS TaxbleAmnt, 
          JDT2.WTAmnt, 
          JDT1.TaxDate AS WHTdate, 
          JDT2.WTCode, 
          (
            SELECT 
              WTName 
            FROM 
              OWHT 
            WHERE 
              WTCode = JDT2.WTCode
          ) AS WTName, 
          OJDT.U_S_ComVatB AS Branch 
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
                  [@SLDT_SET_ACCWH ]
                WHERE 
                  [U_SLD_TypeWH] = '03'
              )
          ) 
        WHERE 
          JDT1.Credit > 0
-------------------------------------------------------------------------------------------------------------------------------
        UNION ALL
-------------------------------------------------------------------------------------------------------------------------------
        SELECT 
          'OJDT' AS TYPE, 
          JDT1.TransId, 
          JDT1.U_SLD_WTBaseAmt AS TaxbleAmnt, 
          (
            (
              JDT1.U_SLD_WTBaseAmt * (
                SELECT 
                  MAX(OWHT.Rate) AS Rate 
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
                          [U_SLD_TypeWH] = '03'
                      )
                  )
              )
            ) / 100.0
          ) AS WTAmnt, 
          JDT1.U_SLD_WHdate AS WHTDate, 
          (
            SELECT 
              MAX(OWHT.WTCode) AS WTCode 
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
                      [U_SLD_TypeWH] = '03'
                  )
              )
          ) AS WTCode, 
          (
            SELECT 
              MAX(OWHT.WTName) AS WTName 
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
                      [U_SLD_TypeWH] = '03'
                  )
              )
          ) AS WTName, 
          CASE WHEN OJDT.TransType = '46' THEN 
          		(SELECT OVPM.U_SLD_VatBranch FROM OVPM WHERE OVPM.TransId = OJDT.TransId) 
          ELSE OJDT.U_S_ComVatB END AS Branch 
        FROM 
          JDT1 
          INNER JOIN OJDT ON JDT1.TransId = OJDT.TransId 
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
                    [U_SLD_TypeWH] = '03'
                )
            )
          )
      ) AS B 
    WHERE 
      B.WTCode IS NOT NULL 
      AND B.TransId IN ({?Dockey@})       
    GROUP BY 
      B.TransId, 
      B.Branch
  ) AS C 
GROUP BY C.Branch,TransId;
