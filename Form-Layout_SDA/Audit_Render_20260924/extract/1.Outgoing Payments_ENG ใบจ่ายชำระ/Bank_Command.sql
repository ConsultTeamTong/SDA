-- ============================================================
-- Report: 1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Path:   1.Outgoing Payments_ENG ใบจ่ายชำระ.rpt
-- Extracted: 2026-09-24 10:20:21
-- Source: Subreport [Bank]
-- Table:  Command
-- ============================================================

select T1.DueDate ,T1.CheckNum ,T1.BankCode ,T1.Branch 
,T1.AcctNum ,T1.[CheckSum] ,T1.[DocNum]
from vpm1 T1
--Where convert(nvarchar,T1.[DocNum]) = '{?Docnum}'

