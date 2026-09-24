-- ============================================================
-- Report: Tax Report v25.rpt
-- Path:   Tax Report v25.rpt
-- Extracted: 2026-09-24 10:21:01
-- Source: Subreport [detail]
-- Table:  Command
-- ============================================================

SELECT [U_Type] , SUM([U_Total])-SUM([U_TaxAmount]) AS [Total], SUM([U_TaxAmount]) AS [TaxAmount] ,[U_SLD_TYPE] , [U_SubmitDate] ,[@SLDT_TS_TST].[U_Branch],[@SLDT_TS_TST].[U_SubmitDate]
                    From [@SLDT_TS_TST]
                    INNER JOIN [@SLDT_SET_VAT] ON [@SLDT_SET_VAT].[Code] = [@SLDT_TS_TST].[U_TaxCode]

                    WHERE ([@SLDT_SET_VAT].[U_SLD_TYPE] = 'E' AND [U_Type]  = 'Sell')
					AND [U_TransID] NOT IN (SELECT [TransId] FROM [OVPM] WHERE [Canceled] = 'Y')
                    GROUP BY [U_SubmitDate] , [U_Type] ,[U_SLD_TYPE],[U_Branch],[U_SubmitDate]
