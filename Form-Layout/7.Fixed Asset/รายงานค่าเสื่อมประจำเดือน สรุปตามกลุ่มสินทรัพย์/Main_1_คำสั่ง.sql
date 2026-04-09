-- ============================================================
-- Report: รายงานค่าเสื่อมประจำเดือน สรุปตามกลุ่มสินทรัพย์.rpt
Path:   7.Fixed Asset\รายงานค่าเสื่อมประจำเดือน สรุปตามกลุ่มสินทรัพย์.rpt
Extracted: 2026-04-09 15:22:56
-- Source: Main Report
-- Table:  คำสั่ง
-- ============================================================

declare @dateTo datetime set @dateTo = {?DateTo}

SELECT distinct OADM.PrintHeadr , OADM.PrintHdrF
,case when Month(@dateTo) = '1' then N'มกราคม' 
 when Month(@dateTo) = '2' then N'กุมภาพันธ์' 
 when Month(@dateTo) = '3' then N'มีนาคม' 
 when Month(@dateTo) = '4' then N'เมษายน' 
 when Month(@dateTo) = '5' then N'พฤษภาคม' 
 when Month(@dateTo) = '6' then N'มิถุนายน' 
 when Month(@dateTo) = '7' then N'กรกฎาคม' 
 when Month(@dateTo) = '8' then N'สิงหาคม' 
 when Month(@dateTo) = '9' then N'กันยายน' 
 when Month(@dateTo) = '10' then N'ตุลาคม' 
 when Month(@dateTo) = '11' then N'พฤศจิกายน' 
 when Month(@dateTo) = '12' then N'ธันวาคม' else '' end 'CaseMonth'
--ORTI.DocStatus 'Retirement' --เช็คว่าขายรึยัง
,T0.AssetClass 'AsClassCode'
,T2.[Name] 'AsClassName'
,T0.ItemCode
,T0.ItemName
,FixDeper.Quantity
,T0.CapDate 
--, (T5.UsefulLife) 'Usefull Life M'
, CONCAT( (100/(T5.UsefulLife/12)),' ', '%') 'DeperRate'
,case when FixPrice.APC is null  then (isnull(FixPrice.PriceCost,0) - isnull(Fixprice.CNSum,0)) - isnull(FixPrice.SumRevalu,0) 
else FixPrice.APC end as 'PriceCost'
,isnull(FixDeper.SalvageVal,0) as 'Salvage'
,isnull(FixDeper.Deper1,0) 'DeperHistorical'
,isnull(FixDeper.Deper3,0) as 'DeperPeriod'
,isnull(FixDeper.Deper1,0) + isnull(FixDeper.Deper3,0) as 'SumDeper'
,(case when FixPrice.APC is null  then (isnull(FixPrice.PriceCost,0) - isnull(Fixprice.CNSum,0)) - isnull(FixPrice.SumRevalu,0) 
else FixPrice.APC end) - (isnull(FixDeper.Deper1,0)  + isnull(FixDeper.Deper3,0)) as 'PriceNet'

FROM
OITM T0
LEFT JOIN OACS T2 ON T0.AssetClass = T2.Code
LEFT JOIN ITM7 T5 ON T0.ItemCode = T5.ItemCode	
left join RTI1 on T0.ItemCode = RTI1.ItemCode
left join ORTI on RTI1.DocEntry = ORTI.DocEntry
--calculate deperciation by Turk
left join (select distinct T0.itemcode ,Deperciation1.Deper1 ,Deperciation3.Deper3 ,Deperciation1.Quantity ,Deperciation1.SalvageVal 
			from OITM T0	
			---Pull BeginYear
			left join (select distinct itemcode,Quantity,SalvageVal,OrDpAcc 'Deper1' 
						from itm8 
						where PeriodCat = year(@dateTo)
						)Deperciation1 on Deperciation1.itemcode = T0.ItemCode
			---Pull Deperciation in period
			left join (select itemcode,sum(OrdDprPlan) 'Deper3'
						from odpv 
						where PeriodCat = year(@dateto) and SubPeriod <= month(@dateto)
						group by itemcode
						)Deperciation3 on Deperciation3.ItemCode = T0.itemcode  
			) FixDeper on FixDeper.itemcode = T0.itemcode
			
			--calculate price by Turk
			left join (select distinct Fprice.itemcode 
						,case when Fprice.CapSum is null and Fprice.CapSum = 0 then Fprice.APC else Fprice.CapSum  end 'PriceCost' 
						,Fprice.CNSum ,Fprice.CapSum ,Fprice.APC ,FPrice.SalvageVal ,Fprice.SumRevalu 
						from OITM t0
						left join (select T0.ITEMCODE,TopITM8.SalvageVal,TopITM8.APC,FXCAP.CapSum,FXCN.CNSum,FXRE.SumRevalu 
									from oitm T0
									---Capitalization
									left join (select ACQ.ItemCode ,sum(ACQ.LineTotal) 'CapSum' 
												from (select convert(varchar,OACQ.PostDate, 23) 'ACQDate', ACQ1.itemcode, ACQ1.Linetotal
														from OACQ 
														inner join ACQ1 on OACQ.DocEntry = ACQ1.DocEntry 
														where OACQ.DocStatus = 'P') ACQ 
												where ACQ.ACQDate <= @dateto  
												group by ACQ.ItemCode
												) FXCAP on T0.ITEMCODE = FXCAP.ItemCode
									---CreditMemo-FixAss			
									left join (select ACD.ItemCode
												,sum(ACD.LineTotal) 'CNSum' 
												from (select convert(varchar,OACD.PostDate, 23) 'ACDDate', ACD1.itemcode, ACD1.Linetotal
														from OACD 
														inner join ACD1 on OACD.DocEntry = ACD1.DocEntry 
														where OACD.DocStatus = 'P'
												) ACD where ACD.ACDDate <= @dateto  
												group by ACD.ItemCode
												) FXCN on T0.ITEMCODE = FXCN.itemCode	
									---Revaluation			
									left join (select Revalu.RevaluDate
												,Revalu.ItemCode
												,sum(Revalu.NBV)-sum(Revalu.New_NBV) 'SumRevalu' 
												from (select convert(varchar,OFAR.PostDate, 23) 'RevaluDate' 
														,FAR1.itemcode , FAR1.NBV , FAR1.New_NBV --,sum(NBV) 'Sum1',sum(New_NBV) 'Sum2'
														from OFAR 
														INNER JOIN FAR1 on FAR1.DocEntry = OFAR.DocEntry
														) Revalu 
												where Revalu.RevaluDate <= @dateTo 
												group by Revalu.RevaluDate,Revalu.ItemCode
												) FXRE on T0.ITEMCODE = FXRe.itemCode
									---Pull Salvage
									left join (select distinct itemcode
												,APC,SalvageVal  
												from itm8 
												where APC is not null and APC <> 0 ) TopITM8 on T0.ITEMCODE = TopITM8.itemCode
						) Fprice on Fprice.ItemCode = T0.ItemCode 
				) FixPrice on FixPrice.itemcode = T0.ItemCode
,OADM

WHERE T0.ItemType = 'F' --Type Fixed Assets 
and  (ORTI.DocStatus is null or ORTI.DocStatus <> 'P') --Retirement
--and  T0.itemCode =   'FAOE22020080020' 
