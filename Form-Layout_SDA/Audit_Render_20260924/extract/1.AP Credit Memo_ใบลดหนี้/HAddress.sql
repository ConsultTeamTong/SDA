-- ============================================================
-- Report: 1.AP Credit Memo_ใบลดหนี้.rpt
-- Path:   1.AP Credit Memo_ใบลดหนี้.rpt
-- Extracted: 2026-09-24 10:19:50
-- Source: Main Report
-- Table:  HAddress
-- ============================================================

Select CompnyName,adm1.Street,adm1.Block,adm1.City,adm1.County,adm1.ZipCode,AliasName,Phone1,IntrntAdrs,RevOffice,
CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'GLN_H'
from oadm,adm1,ADM2
