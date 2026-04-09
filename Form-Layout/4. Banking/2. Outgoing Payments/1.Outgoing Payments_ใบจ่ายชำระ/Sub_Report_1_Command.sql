-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
Path:   4. Banking\2. Outgoing Payments\1.Outgoing Payments_ใบจ่ายชำระ.rpt
Extracted: 2026-04-09 15:22:48
-- Source: Subreport [Report]
-- Table:  Command
-- ============================================================

select 
		T2.InvType,
		T2.DocNum as DocNum,
		T3.DocDate,
		T3.NumAtCard,
	Amount = 
	case 
	when T2.[AppliedFC] = 0 then T2.[SumApplied] 
	else T2.[AppliedFC] 
	end ,

	AmountTax =
	case 
	when T2.[AppliedFC] = 0 then T2.[SumApplied] + T2.[WtAppld]
	else T2.[AppliedFC] + T2.[WtAppldFC]
	end ,

		T2.DocTransId,
		T3.DocNum as DocNumINV,
		T2.InvoiceId  

	From VPM2 T2 
	INNER JOIN ODPO T3 ON T2.InvType = 204 and T2.DocEntry = T3.docEntry   

Union all

select 
		T2.InvType,
		T2.DocNum as DocNum,
		T3.DocDate,
		T3.NumAtCard,

	Amount = 
	case 
	when T2.[AppliedFC] = 0 then T2.[SumApplied] 
	else T2.[AppliedFC] 
	end ,

	AmountTax =
	case 
	when T2.[AppliedFC] = 0 then T2.[SumApplied] + T2.[WtAppld]
	else T2.[AppliedFC] + T2.[WtAppldFC]
	end ,

		T2.DocTransId,
		T3.DocNum as DocNumINV,
		T2.InvoiceId   

	From VPM2 T2 
	INNER JOIN OPCH T3 ON T2.InvType = 18 and T2.DocEntry = T3.docEntry 

Union all

select 
		T2.InvType,
		T2.DocNum as DocNum,
		T3.DocDate,
		T3.NumAtCard,

	Amount = 
	case 
	when T2.[AppliedFC] = 0 then T2.[SumApplied]*-1 
	else T2.[AppliedFC]*-1 
	end ,

	AmountTax =
	case 
	when T2.[AppliedFC] = 0 then (T2.[SumApplied] + T2.[WtAppld])*-1
	else (T2.[AppliedFC] + T2.[WtAppldFC])*-1
	end ,

		T2.DocTransId,
		T3.DocNum as DocNumINV,
		T2.InvoiceId 
		
	From VPM2 T2 
	INNER JOIN ORPC T3 ON T2.InvType = 19 and T2.DocEntry = T3.docEntry 

Union all

select 
		T2.InvType,
		T2.DocNum as DocNum,
		T3.refDate as DocDate,
		T3.Ref2 as NumAtCard,
		T2.AppliedSys,

	AmountTax =
	case 
	when T2.[AppliedFC] = 0 then (T2.[SumApplied] + T2.[WtAppld])
	else (T2.[AppliedFC] + T2.[WtAppldFC])
	end ,

		T2.DocTransId,
		T3.Number as DocNumINV,
		T2.InvoiceId     

	From VPM2 T2 
	INNER JOIN OJDT T3 ON T2.DocTransId = T3.TransId 
	LEFT JOIN OVPM T5 ON T5.TransId = T2.DocEntry
where T2.InvType in (46,30)

order by T2.InvoiceId  
