-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
Path:   4. Banking\2. Outgoing Payments\1.Outgoing Payments_ใบจ่ายชำระ.rpt
Extracted: 2026-04-09 15:22:48
-- Source: Subreport [Credit Card]
-- Table:  Command
-- ============================================================

SELECT T2.[CardName],  
T1.[Segment_0] 
+ case when isnull(T1.[Segment_2],'') = '' Then '' Else '-' +T1.[Segment_2] end 
+ case when isnull(T1.[Segment_3],'') = '' then '' Else '-' +T1.[Segment_3] end 
+ case when isnull(T1.[Segment_4],'') = '' then '' Else '-' + T1.[Segment_4] end
+ case when isnull(T1.[Segment_5],'') = '' then '' Else '-' + T1.[Segment_5] end
+ case when isnull(T1.[Segment_6],'') = '' then '' Else '-' + T1.[Segment_6] end
+ case when isnull(T1.[Segment_7],'') = '' then '' Else '-' + T1.[Segment_7] end
+ case when isnull(T1.[Segment_8],'') = '' then '' Else '-' + T1.[Segment_8] end
+ case when isnull(T1.[Segment_9],'') = '' then '' Else '-' + T1.[Segment_9] end as FormatCode, T0.[CreditSum] ,T0.[DocNum]

FROM VPM3 T0 INNER JOIN OACT T1 ON T1.[AcctCode] =  T0.[CreditAcct] INNER JOIN OCRC T2 ON T0.CreditCard = T2.CreditCard 
--WHERE convert(nvarchar,T0.[DocNum]) = '{?Docnum}'
