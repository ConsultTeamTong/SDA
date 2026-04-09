-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
Path:   4. Banking\2. Outgoing Payments\1.Outgoing Payments_ใบจ่ายชำระ.rpt
Extracted: 2026-04-09 15:22:48
-- Source: Subreport [JE]
-- Table:  Command
-- ============================================================

SELECT T0.[TransId],T5.Number ,T0.Line_ID ,T0.[ShortName]
, T1.[Segment_0]
+ case when isnull(T1.[Segment_2],'') = '' Then '' Else '-' +T1.[Segment_2] end 
+ case when isnull(T1.[Segment_3],'') = '' then '' Else '-' +T1.[Segment_3] end 
+ case when isnull(T1.[Segment_4],'') = '' then '' Else '-' + T1.[Segment_4] end
+ case when isnull(T1.[Segment_5],'') = '' then '' Else '-' + T1.[Segment_5] end
+ case when isnull(T1.[Segment_6],'') = '' then '' Else '-' + T1.[Segment_6] end
+ case when isnull(T1.[Segment_7],'') = '' then '' Else '-' + T1.[Segment_7] end
+ case when isnull(T1.[Segment_8],'') = '' then '' Else '-' + T1.[Segment_8] end
+ case when isnull(T1.[Segment_9],'') = '' then '' Else '-' + T1.[Segment_9] end as BPAcctCode
, T1.[AcctName]  as BPAcctName
, T0.[Debit], T0.[Credit], T0.[FCDebit], T0.[FCCredit], T0.[DueDate], T0.[LineMemo], T0.[Ref1], T0.[Ref2]
,T3.[OcrCode], T4.[PrjCode]
FROM JDT1 T0 
LEFT JOIN OACT T1 ON T0.[Account]  = T1.AcctCode 
Left JOIN OCRD T2 ON T2.[CardCode] = T0.[ShortName] 
LEFT JOIN OOCR T3 ON T0.ProfitCode = T3.OcrCode 
LEFT JOIN OPRJ T4 ON T0.Project = T4.PrjCode
LEFT JOIN OJDT T5 ON T0.TransId = T5.TransId
--Order by T0.[Credit]
ORDER BY (T0.Line_ID+1)
