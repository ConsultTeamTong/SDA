-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
Path:   4. Banking\2. Outgoing Payments\1.Outgoing Payments_ใบจ่ายชำระ.rpt
Extracted: 2026-04-09 15:22:48
-- Source: Subreport [Bank]
-- Table:  Command
-- ============================================================

select T1.DueDate ,T1.CheckNum ,T1.BankCode ,T1.Branch 
,T1.AcctNum ,T1.[CheckSum] ,T1.[DocNum]
from vpm1 T1
--Where convert(nvarchar,T1.[DocNum]) = '{?Docnum}'

