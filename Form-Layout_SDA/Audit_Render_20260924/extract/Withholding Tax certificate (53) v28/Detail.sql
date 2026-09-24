-- ============================================================
-- Report: Withholding Tax certificate (53) v28.rpt
-- Path:   Withholding Tax certificate (53) v28.rpt
-- Extracted: 2026-09-24 10:21:04
-- Source: Main Report
-- Table:  Detail
-- ============================================================

WITH FTTV AS(
---------------------------------------------------------------------START WITH FTTV ----------------------------------------------------------------------------
			SELECT DISTINCT  B.TYPE,
						B.TransType,
						B.RunNo,
						B.DocNum,
						B.NumAtCard,
						B.TransId,
						B.CardCode,
						B.CardName,
						B.U_SLD_Title,
						B.U_SLD_CardName,
						B.Address,
						B.TaxDate,
						B.TaxId,
						B.U_SLD_VatBranch,
						B.U_SLD_VBPBranch,
						B.WHTType
		FROM (
				SELECT DISTINCT	'OVPM' AS TYPE,
						(	SELECT TransType 
							FROM OJDT 
							WHERE TransId = OVPM.TransId
						) AS TransType,
						 (
                            SELECT TOP 1 [U_DocWht]
                            FROM [@SLDT_WTS_TST]
                            WHERE [U_Status] = 'Y'
                                    And [U_TransID] = [OVPM].[TransId]
                                    AND [U_Date_Wht] = FORMAT([OVPM].[TaxDate], 'yyyyMMdd')
                                    AND [U_LicTradNum] = (SELECT [OCRD].[LicTradNum] FROM [OCRD] JOIN [CRD1] ON [OCRD].[CardCode] = [CRD1].[CardCode] WHERE [OCRD].[CardCode] = [OVPM].[CardCode] AND [OVPM].[PayToCode] = [CRD1].[Address] AND [CRD1].[AdresType] = 'B')
                            ) AS RunNo,
							OVPM.DocNum,
						'' as NumAtCard,
						OVPM.TransId,
						OVPM.CardCode,
						(	SELECT OCRD.U_SLD_FullName 
							FROM OCRD 
							JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
							WHERE OCRD.CardCode = OVPM.CardCode 
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'  
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'
							) AS CardName,
							
						(	SELECT OCRD.U_SLD_Title 
							FROM OCRD 
							JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
							WHERE OCRD.CardCode = OVPM.CardCode 
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'  
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'
							) AS U_SLD_Title,
							
						(	SELECT OCRD.U_SLD_FullName 
							FROM OCRD 
							JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
							WHERE OCRD.CardCode = OVPM.CardCode 
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'  
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'
							) AS U_SLD_CardName,
							
						OVPM.Address,
						OVPM.TaxDate,
						(	SELECT OCRD.LicTradNum 
							FROM OCRD 
							JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
							WHERE OCRD.CardCode = OVPM.CardCode 
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B' 
								AND OVPM.PayToCode = CRD1.Address 
								AND CRD1.AdresType = 'B'
							)AS TaxId,
						OVPM.U_SLD_VatBranch,
						'' AS U_SLD_VBPBranch,
						CASE WHEN VPM2.InvType = 18 THEN OPCH.U_SLD_WhPayBy
							WHEN VPM2.InvType = 19 THEN ORPC.U_SLD_WhPayBy
							WHEN VPM2.InvType = 204 THEN ODPO.U_SLD_WhPayBy
							WHEN VPM2.InvType = 30 THEN JDT1.U_SLD_WhPayBy
						END AS WHTType,
						OWHT.WTCode
						
				FROM OVPM
				LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocNum 
				LEFT JOIN VPM6 ON OVPM.DocEntry = VPM6.DocNum 
				LEFT JOIN OWHT ON VPM6.WTCode = OWHT.WTCode 
				LEFT JOIN OPCH ON VPM2.DocEntry = OPCH.DocEntry
				LEFT JOIN ODPO ON VPM2.DocEntry = ODPO.DocEntry
				LEFT JOIN ORPC ON VPM2.DocEntry = ORPC.DocEntry
				LEFT JOIN JDT1 ON OVPM.TransId = JDT1.TransId
				WHERE OVPM.TransId IN (SELECT TransId FROM JDT1 WHERE JDT1.ShortName
											= (SELECT AcctCode FROM OACT WHERE FormatCode
											 	= (SELECT [Name] FROM  [@SLDT_SET_ACCWH] WHERE U_SLD_TypeWH = '53'
											 		)
											 	)
											)
				----------------------------------------------------------------------------------------------------------------------
				UNION ALL 
				----------------------------------------------------------------------------------------------------------------------
				SELECT DISTINCT 	'OPCH' AS TYPE,
						(	SELECT TransType 
							FROM OJDT 
							WHERE TransId = OPCH.TransId
						) AS TransType,
						(
                                Select TOP 1 [U_DocWht]
                                from [@SLDT_WTS_TST]
                                where [U_Status] = 'Y'
                                    And [U_TransID] = [OPCH].[TransId]
                                    AND [U_Date_Wht] = FORMAT([OPCH].[TaxDate], 'yyyyMMdd')
                                    And [U_LicTradNum] = [OPCH].[LicTradNum]
                            ) AS RunNo,
						OPCH.DocNum,
						OPCH.NumAtCard,
						OPCH.TransId,
						OPCH.CardCode,
						'' AS CardName,
						'' AS U_SLD_Title,
						'' AS U_SLD_CardName,
						OPCH.Address,
						OPCH.TaxDate,
						OPCH.LicTradNum AS TaxId,
						OPCH.U_SLD_LVatBranch AS U_SLD_VatBranch,
						'' AS U_SLD_VBPBranch,
						OPCH.U_SLD_WhPayBy AS WHTType,
						OWHT.WTCode
						
				FROM OPCH 
				JOIN PCH5 ON OPCH.DocEntry = PCH5.AbsEntry 
				JOIN OWHT ON PCH5.WTCode = OWHT.WTCode 
				WHERE OPCH.TransId IN (SELECT TransId FROM JDT1 WHERE JDT1.ShortName 
											= (SELECT AcctCode FROM OACT WHERE FormatCode 
												= (SELECT [Name] FROM  [@SLDT_SET_ACCWH] WHERE U_SLD_TypeWH = '53'
												)
											)
										)  
				----------------------------------------------------------------------------------------------------------------------
				UNION ALL 
				----------------------------------------------------------------------------------------------------------------------
                SELECT DISTINCT	'OJDT' AS TYPE,
						JDT1.TransType AS TransType,
                           (
                                SELECT TOP 1 [U_DocWht]
                                FROM [@SLDT_WTS_TST]
                                WHERE [U_Status] = 'Y'
                                    And [U_TransID] = [OJDT].[TransId]
                                    AND [U_Date_Wht] = FORMAT([JDT1].[TaxDate], 'yyyyMMdd')
                                    And [U_LicTradNum] = [JDT1].[LicTradNum]
                            ) AS RunNo,
						JDT1.BaseRef AS DocNum,
						'' as NumAtCard,
						JDT1.TransId,
						JDT1.U_SLD_SuppCode AS CardCode,
						CASE WHEN JDT1.U_SLD_LPBranch IS NOT NULL AND JDT1.U_SLD_LPBranch <> '' THEN 
								CONCAT(JDT1.U_SLD_CardName , CONCAT('(สาขาที่ ', CONCAT(JDT1.U_SLD_LPBranch, ')'))) 
							ELSE JDT1.U_SLD_CardName END AS CardName,
						'' AS U_SLD_Title,
						'' AS U_SLD_CardName,
						JDT1.U_SLD_BPAds AS Address,
						JDT1.TaxDate AS TaxDate,
						JDT1.LicTradNum AS TaxId,
						OJDT.U_S_ComVatB AS U_SLD_VatBranch,
						JDT1.U_SLD_LPBranch AS U_SLD_VBPBranch,
						JDT1.U_SLD_WhPayBy,
						JDT2.WTCode
				FROM
				JDT1 
				INNER JOIN OJDT ON JDT1.TransId = OJDT.TransId
				INNER JOIN JDT2 ON JDT2.AbsEntry = OJDT.TransId 
				AND JDT2.Account = (SELECT AcctCode FROM OACT WHERE FormatCode = (SELECT [Name] FROM  [@SLDT_SET_ACCWH] WHERE U_SLD_TypeWH = '53'))
				WHERE JDT1.Credit > 0 				
				----------------------------------------------------------------------------------------------------------------------
				UNION ALL 
				----------------------------------------------------------------------------------------------------------------------
				SELECT DISTINCT	'OJDT' AS TYPE,
						JDT1.TransType AS TransType,
                           (
                                SELECT TOP 1 [U_DocWht]
                                FROM [@SLDT_WTS_TST]
                                WHERE [U_Status] = 'Y'
                                    And [U_TransID] = [OJDT].[TransId]
                                    AND [U_Date_Wht] = FORMAT([JDT1].[U_SLD_WHdate], 'yyyyMMdd')
                                    And [U_LicTradNum] = [JDT1].[U_SLD_LBPTaxID]
                            ) AS RunNo,
						JDT1.BaseRef AS DocNum,
						'' as NumAtCard,
						JDT1.TransId,
						JDT1.U_SLD_SuppCode AS CardCode,
						CONCAT(U_SLD_Title, U_SLD_CardName) AS CardName,
						U_SLD_Title,
						U_SLD_CardName,
						JDT1.U_SLD_BPAds AS Address,
						JDT1.U_SLD_WHdate AS TaxDate,
						JDT1.U_SLD_LBPTaxID AS TaxId,
						CASE WHEN OJDT.TransType = '46' THEN 
								(SELECT top 1 OVPM.U_SLD_VatBranch FROM OVPM WHERE OVPM.TransId = OJDT.TransId) 
							ELSE OJDT.U_S_ComVatB END  AS U_SLD_VatBranch,
						JDT1.U_SLD_LPBranch AS U_SLD_VBPBranch,
						JDT1.U_SLD_WhPayBy,
						(SELECT top 1 OWHT.WTCode FROM  OWHT WHERE OWHT.WTCode = JDT1.U_SLD_WTCode AND JDT1.ShortName = (SELECT top 1 AcctCode FROM  OACT WHERE FormatCode = (SELECT top 1 [Name] FROM  [@SLDT_SET_ACCWH] WHERE U_SLD_TypeWH = '53'))) AS WTCode
						
				FROM JDT1 
				LEFT JOIN OJDT  ON JDT1.TransId = OJDT.TransId
				WHERE JDT1.ShortName = (SELECT top 1 AcctCode FROM OACT WHERE FormatCode = (SELECT [Name] FROM  [@SLDT_SET_ACCWH] WHERE U_SLD_TypeWH = '53'))                                           
			) AS B 
			WHERE B.TaxDate IS NOT NULL AND B.WTCode IS NOT NULL
--------------------------------------------------------------------- END WITH FTTV ----------------------------------------------------------------------------
)

SELECT ROW_NUMBER() OVER (ORDER BY RunNo) As Row, * 
From (
			SELECT 
			N'ฉบับที่ 1 (สำหรับผู้ถูกหักภาษี ณ ที่จ่าย ใช้แนบแบบแสดงรายการภาษี)'  AS TypeWht,
			FTTV.*
			FROM FTTV
		UNION ALL
			SELECT 
			N'ฉบับที่ 2 (สำหรับผู้ถูกหักภาษี ณ ที่จ่าย เก็บไว้เป็นหลักฐาน)'  AS TypeWht,
			FTTV.*
			FROM FTTV
		UNION ALL
			SELECT 
			N'ฉบับที่ 3 (สำหรับฝ่ายบัญชี นำส่งภาษี)' AS TypeWht,
			FTTV.*
			FROM FTTV
		UNION ALL
			SELECT 
			N'ฉบับที่ 4 (สำหรับฝ่ายบัญชี เก็บไว้เป็นหลักฐาน)'  AS TypeWht,
			FTTV.*
			FROM FTTV
) Gup
WHERE  Gup.TaxDate Is Not Null  And Gup.TransId In ({?DocKey@})  

ORDER BY Gup.RunNo
