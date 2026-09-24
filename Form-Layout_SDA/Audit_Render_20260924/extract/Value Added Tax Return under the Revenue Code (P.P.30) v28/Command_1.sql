-- ============================================================
-- Report: Value Added Tax Return under the Revenue Code (P.P.30) v28.rpt
-- Path:   Value Added Tax Return under the Revenue Code (P.P.30) v28.rpt
-- Extracted: 2026-09-24 10:21:02
-- Source: Main Report
-- Table:  Command_1
-- ============================================================


with QS (U_Type,U_SubmitDate,Years,MonthDate,Mount,TotalB,TaxAmountD,TotalN,TaxAmountN,TotalE,TaxAmountE)
AS (
SELECT B.U_Type 
, B.U_SubmitDate
, LEFT(U_SubmitDate,4)+543 As 'Years'
, Case When Right(U_SubmitDate,2) = '01' Then N'มกราคม'
When Right(U_SubmitDate,2) = '02' Then N'กุมภาพันธ์'
When Right(U_SubmitDate,2) = '53' Then N'มีนาคม'
When Right(U_SubmitDate,2) = '04' Then N'เมษายน'
When Right(U_SubmitDate,2) = '05' Then N'พฤษภาคม'
When Right(U_SubmitDate,2) = '06' Then N'มิถุนายน'
When Right(U_SubmitDate,2) = '07' Then N'กรกฎาคม'
When Right(U_SubmitDate,2) = '08' Then N'สิงหาคม'
When Right(U_SubmitDate,2) = '09' Then N'กันยายน'
When Right(U_SubmitDate,2) = '10' Then N'ตุลาคม'
When Right(U_SubmitDate,2) = '11' Then N'พฤศจิกายน'
When Right(U_SubmitDate,2) = '12' Then N'ธันวาคม'
End as MonthDate,
RIGHT(U_SubmitDate,2) As 'Mount'
, SUM(B.TotalD) AS TotalB
, SUM(B.TaxAmountD) AS TaxAmountD
, SUM(B.TotalN) AS TotalN
, SUM(B.TaxAmountN) AS TaxAmountN
, SUM(B.TotalE) AS TotalE
, SUM(B.TaxAmountE) AS TaxAmountE
FROM (
SELECT U_Type
, A.U_SubmitDate
, CASE WHEN SLD_TYPE = 'D' AND Total <> 0 THEN Total ELSE 0 END TotalD
, CASE WHEN SLD_TYPE = 'N' AND Total <> 0 THEN Total ELSE 0 END TotalN
, CASE WHEN SLD_TYPE = 'E' AND Total <> 0 THEN Total ELSE 0 END TotalE
, CASE WHEN SLD_TYPE = 'D' AND TaxAmount <> 0 THEN TaxAmount ELSE 0 END TaxAmountD
, CASE WHEN SLD_TYPE = 'N' AND TaxAmount <> 0 THEN TaxAmount ELSE 0 END TaxAmountN
, CASE WHEN SLD_TYPE = 'E' AND TaxAmount <> 0 THEN TaxAmount ELSE 0 END TaxAmountE
FROM (
SELECT 
SUM(U_Total)-SUM(U_TaxAmount) As 'Total'
,SUM(U_TaxAmount)  As 'TaxAmount',
 U_Type,
[@SLDT_SET_VAT].U_SLD_TYPE as SLD_TYPE,
U_SubmitDate
From [@SLDT_TS_TST]
INNER JOIN[@SLDT_SET_VAT] ON [@SLDT_SET_VAT].Code = [@SLDT_TS_TST].U_TaxCode

WHERE [@SLDT_SET_VAT].U_SLD_TYPE <>'U'  AND [@SLDT_TS_TST].U_SubmitDate ='{?DocKey@}'
--GROUP BY U_SubmitDate , U_Type ,U_SLD_TYPE )A
GROUP BY U_SubmitDate ,U_Type ,U_SLD_TYPE )A
)B
GROUP BY B.U_Type , B.U_SubmitDate

)

select 
--Top 1
*,
 TotalB  as 'Total Sell',
isnull((select TaxAmountD from QS where U_Type = 'Buy'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy'),0) as 'Total Buy',
CASE 
	WHEN (select TaxAmountD from QS where U_Type = 'Sell') > (select TaxAmountD from QS where U_Type = 'Buy') 
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell'),0)
END as 'Total TaxAmount'
from QS
where U_Type = 'Sell'
