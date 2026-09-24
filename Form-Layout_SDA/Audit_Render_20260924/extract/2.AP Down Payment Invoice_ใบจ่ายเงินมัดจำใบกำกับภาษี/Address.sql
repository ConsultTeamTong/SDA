-- ============================================================
-- Report: 2.AP Down Payment Invoice_ใบจ่ายเงินมัดจำใบกำกับภาษี.rpt
-- Path:   2.AP Down Payment Invoice_ใบจ่ายเงินมัดจำใบกำกับภาษี.rpt
-- Extracted: 2026-09-24 10:20:34
-- Source: Main Report
-- Table:  Address
-- ============================================================

select CompnyName,adm1.Street,adm1.Block,adm1.City,adm1.County,adm1.ZipCode,AliasName,Phone1,IntrntAdrs,RevOffice,
CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'GLN_H'
from oadm,adm1,ADM2
