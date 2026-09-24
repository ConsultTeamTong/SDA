-- ============================================================
-- Report: Withholding Tax certificate (53) v28_A0070001.rpt
-- Path:   Withholding Tax certificate (53) v28_A0070001.rpt
-- Extracted: 2026-09-24 10:21:05
-- Source: Main Report
-- Table:  CountRow
-- ============================================================

SELECT COUNT("Name")/5 AS "Row"

FROM (
SELECT DISTINCT ROW_NUMBER() OVER ( ORDER BY "Name") AS "Row", * 
FROM (
		SELECT  "Name" 
		FROM "@SLDT_RT_TST" 
		WHERE "U_SubmitDate" IS NOT NULL AND "U_TaxType" = '5'
		) AS CountPage
	) AS CountP
