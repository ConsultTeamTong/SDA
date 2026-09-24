-- ============================================================
-- Report: Attachment of PP30 v28.rpt
-- Path:   Attachment of PP30 v28.rpt
-- Extracted: 2026-09-24 10:21:00
-- Source: Subreport [Branch]
-- Table:  Command
-- ============================================================


with QS (U_Type,U_Branch,U_SubmitDate,Years,MonthDate,Mount,TotalB,TaxAmountD,TotalN,TaxAmountN,TotalE,TaxAmountE)
AS (
SELECT B.U_Type ,
U_Branch
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
SELECT
U_Type,
U_Branch
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
U_SubmitDate,
U_Branch
From [@SLDT_TS_TST]
INNER JOIN[@SLDT_SET_VAT] ON [@SLDT_SET_VAT].Code = [@SLDT_TS_TST].U_TaxCode

WHERE [@SLDT_SET_VAT].U_SLD_TYPE <> 'U'  AND [@SLDT_TS_TST].U_SubmitDate ='{?DocKey@}'
--GROUP BY U_SubmitDate , U_Type ,U_SLD_TYPE) A 
GROUP BY U_SubmitDate ,U_Type ,U_SLD_TYPE,U_Branch ) AS A
) AS B
GROUP BY B.U_Type , B.U_SubmitDate,U_Branch
)
select * from (
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00000'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00000'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00000'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00000'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00000'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00000'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00000'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00000'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00000'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00000'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00000'),0)
END
  as 'Total TaxAmount'

from QS WHERE U_Branch = '00000'

UNION ALL 
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00001'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00001'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00001'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00001'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00001'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00001'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00001'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00001'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00001'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00001'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00001'),0)
END
  as 'Total TaxAmount'
from QS WHERE U_Branch = '00001'

UNION ALL 
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00002'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00002'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00002'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00002'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00002'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00002'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00002'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00002'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00002'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00002'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00002'),0)
END
  as 'Total TaxAmount'
from QS WHERE U_Branch = '00002'

UNION ALL
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00003'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00003'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00003'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00003'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00003'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00003'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00003'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00003'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00003'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00003'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00003'),0)
END
  as 'Total TaxAmount'

from QS WHERE U_Branch = '00003'

UNION ALL 
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00004'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00004'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00004'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00004'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00004'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00004'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00004'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00004'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00004'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00004'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00004'),0)
END
  as 'Total TaxAmount'

from QS WHERE U_Branch = '00004'
UNION ALL 
select 
Top 1
*,
 TotalB  as 'Total Buy',
isnull((select TaxAmountD from QS where U_Type = 'Buy'  AND U_Branch = '00005'),0) 'TaxAmount Buy',
isnull((select TaxAmountD from QS where  U_Type = 'Sell' AND U_Branch = '00005'),0) as 'TaxAmount Sale',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00005'),0) as 'Total D',
isnull((select TotalB from QS where U_Type = 'Sell' AND U_Branch = '00005'),0) as 'Total Sell',
isnull((select TotalB from QS where U_Type = 'Buy' AND U_Branch = '00005'),0) as 'Total N',
CASE 
	WHEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00005'),0) > isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00005'),0)
	THEN isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00005'),0) - isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00005'),0)
	ELSE 
	isnull((select TaxAmountD from QS where U_Type = 'Buy' AND U_Branch = '00005'),0) - isnull((select TaxAmountD from QS where U_Type = 'Sell' AND U_Branch = '00005'),0)
END
  as 'Total TaxAmount'

from QS WHERE U_Branch = '00005'

  ) AS B1 
  LEFT JOIN [@SLDT_SET_BRANCH] ON [@SLDT_SET_BRANCH].Code = U_Branch 

