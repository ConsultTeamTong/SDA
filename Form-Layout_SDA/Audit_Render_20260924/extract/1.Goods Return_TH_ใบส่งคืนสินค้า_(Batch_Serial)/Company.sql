-- ============================================================
-- Report: 1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Return_TH_ใบส่งคืนสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:12
-- Source: Main Report
-- Table:  Company
-- ============================================================

select CompnyName,adm1.Street,adm1.Block,adm1.City,adm1.County,adm1.ZipCode,AliasName,Phone1,IntrntAdrs,RevOffice,
CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'GLN_H'
from oadm,adm1,ADM2
