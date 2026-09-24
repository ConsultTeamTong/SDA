-- ============================================================
-- Report: Tax Report v25.rpt
-- Path:   Tax Report v25.rpt
-- Extracted: 2026-09-24 10:21:01
-- Source: Main Report
-- Table:  Command
-- ============================================================

select (Left(U_SubmitDate,4)+543) as YearDate,
Case When Right(U_SubmitDate,2) = '01' Then N'มกราคม'
When Right(U_SubmitDate,2) = '02' Then N'กุมภาพันธ์'
When Right(U_SubmitDate,2) = '03' Then N'มีนาคม'
When Right(U_SubmitDate,2) = '04' Then N'เมษายน'
When Right(U_SubmitDate,2) = '05' Then N'พฤษภาคม'
When Right(U_SubmitDate,2) = '06' Then N'มิถุนายน'
When Right(U_SubmitDate,2) = '07' Then N'กรกฎาคม'
When Right(U_SubmitDate,2) = '08' Then N'สิงหาคม'
When Right(U_SubmitDate,2) = '09' Then N'กันยายน'
When Right(U_SubmitDate,2) = '10' Then N'ตุลาคม'
When Right(U_SubmitDate,2) = '11' Then N'พฤศจิกายน'
When Right(U_SubmitDate,2) = '12' Then N'ธันวาคม'
End

as MonthDate,
Concat(Right(U_Date,2),'/',Left(Right(U_Date,4),2),'/',(Left(U_Date,4))) as U_Date ,
[@SLDT_RT_TST].Name as 'DocKey',
OVTG.Rate,
 * From [@SLDT_RT_TST]
LEFT JOIN [@SLDT_SET_BRANCH] ON [@SLDT_SET_BRANCH].Code = [@SLDT_RT_TST].U_Branch
LEFT JOIN OVTG ON OVTG.Code = [@SLDT_RT_TST].U_VatGroup
Where 
[@SLDT_RT_TST].U_TaxType IN ({?DocKey@}) AND
CONCAT([@SLDT_RT_TST].U_DocNum,[@SLDT_RT_TST].U_TaxId) IN ({?DocKey@})
