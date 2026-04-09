-- ============================================================
-- Report: ทะเบียนสินทรัพย์.rpt
Path:   7.Fixed Asset\ทะเบียนสินทรัพย์.rpt
Extracted: 2026-04-09 15:22:55
-- Source: Main Report
-- Table:  คำสั่ง
-- ============================================================

SELECT distinct 
[@SLDT_SET_BRANCH].U_SLD_VComName
,T13.DocStatus 'Retirement' --เช็คว่าขายรึยัง
,T0.AssetSerNo
,T0.ItemCode, T0.ItemName
,T0.AssetClass, T2.Name,
T6.Location,-- T0.Location,
T0.employee 'emp-code' , T3.firstname 'emp-name',
T0.CapDate, --วันที่รับมา
T5.DprType, 
T5.DprStart, T5.DprEnd --วันเริ่มคิดและสิ้นสุด
, T11.Code 'Asset Group Code'
, T11.Descr 'Asset Group Name'
, (T5.UsefulLife) 'Usefull Life M'
, CONCAT( (100/(T5.UsefulLife/12)),' ', '%') 'DP RATE'
,itm13.AttriTxt1 'Supplyer',itm13.AttriTxt2 'AP-INV'
,case 
 when Fixprice.SalvageVal is null and fix.SalvageVal = 0 then (PriceCost*1)/100
 when Fixprice.SalvageVal is null						 then fix.SalvageVal
														 else Fixprice.SalvageVal end SalvageVal
,Deperciation1.Deper1 'DeperHistorical' 
,ISNULL(Deperciation1.Deper1, 0) + ISNULL(Deperciation2.Deper2, 0) 'DeperSum'
,ISNULL(Fixprice.PriceCost, 0) - ISNULL(Fixprice.CNSum, 0) - ISNULL(Fixprice.SumRevalu, 0) 'PriceCost'
,(((ISNULL(Fixprice.PriceCost, 0) - ISNULL(Fixprice.CNSum, 0))  - ISNULL(Fixprice.SumRevalu, 0)) - (ISNULL(Deperciation1.Deper1, 0) + ISNULL(Deperciation2.Deper2, 0))) 'PriceNet'

FROM
OITM T0
LEFT JOIN OITB T1 ON T0.ItmsGrpCod = T1.ItmsGrpCod
LEFT JOIN OACS T2 ON T0.AssetClass = T2.Code
LEFT JOIN OHEM T3 ON T0.Employee = T3.empID
LEFT JOIN ITM7 T5 ON T0.ItemCode = T5.ItemCode	
LEFT JOIN OLCT T6 ON T0.Location = T6.Code
LEFT JOIN ITM8 T9 ON T0.ItemCode = T9.ItemCode
LEFT JOIN OAGS T11 ON T0.AssetGroup = T11.Code
LEFT JOIN RTI1 T12 ON T0.ItemCode = T12.ItemCode
LEFT JOIN ORTI T13 ON T12.DocEntry = T13.DocEntry
left join itm13 on T0.itemcode = itm13.itemcode
--SalvageVal
	left join (select fix1.AbsEntry,fix1.itemcode,fix1.TransType,fix1.SalvageVal from fix1 
				left join (select itemcode ,max(AbsEntry) 'AbsEntryB' from fix1 where (TransType = 540 or TransType = 110) group by itemcode) Akey on Akey.itemcode = Fix1.Itemcode where Fix1.AbsEntry = Akey.AbsEntryB
				)Fix on Fix.itemcode = T0.Itemcode
--calculate deperciation by Turk
	left join (select distinct itemcode,max(OrDpAcc) 'Deper1' from itm8 group by ItemCode) 
		Deperciation1 on Deperciation1.itemcode = T0.ItemCode
	left join (select itemcode,sum(odpv.OrdDprPost) 'Deper2' from odpv where odpv.PeriodCat = left(convert(varchar,GETDATE(),112),4) group by ItemCode) 
		Deperciation2 on Deperciation2.ItemCode = T0.itemcode
--calculate price by Turk
	left join 
	(select distinct Fprice.itemcode
	,case when Fprice.CapSum is null or Fprice.CapSum = 0 then Fprice.APC else Fprice.CapSum  end 'PriceCost' 
	,Fprice.CNSum,Fprice.CapSum,Fprice.APC,FPrice.SalvageVal,Fprice.SumRevalu 
		from OITM t0
		left join 
			(select T0.ITEMCODE,TopITM8.SalvageVal,TopITM8.APC,FXCAP.CapSum,FXCN.CNSum,FXRE.SumRevalu from oitm T0
				left join (
							select itemcode,sum(Linetotal) 'CapSum' 
							from acq1 
							inner join OACQ on OACQ.DocEntry = ACQ1.DocEntry
							where DocStatus = 'P' group by itemCode
							) FXCAP on T0.ITEMCODE = FXCAP.itemCode
				left join (
							select itemcode,sum(Linetotal) 'CNSum' from acd1  
							inner join OACD on OACD.DocEntry = ACD1.DocEntry
							where DocStatus = 'P' group by itemCode
							) FXCN on T0.ITEMCODE = FXCN.itemCode
				left join (
							select itemcode, sum(NBV)-sum(New_NBV) 'SumRevalu'
							from FAR1 group by itemcode
							) FXRE on T0.ITEMCODE = FXRe.itemCode
				left join (
							select distinct itemcode,APC,SalvageVal  
							from itm8 where APC is not null and APC <> 0 
							) TopITM8 on T0.ITEMCODE = TopITM8.itemCode
			) Fprice on Fprice.ItemCode = T0.ItemCode 
	) FixPrice on FixPrice.itemcode = T0.ItemCode

,[@SLDT_SET_BRANCH]

WHERE T0.ItemType = 'F' --Type 'F' (Fixed Assets) 
and  (T13.DocStatus is null or T13.DocStatus <> 'P') --ต้องยังไม่ Retirement
