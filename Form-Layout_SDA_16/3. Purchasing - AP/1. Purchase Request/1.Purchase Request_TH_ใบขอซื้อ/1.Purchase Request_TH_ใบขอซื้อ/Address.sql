-- ============================================================
-- Report: 1.Purchase Request_TH_ใบขอซื้อ.rpt
Path:   1.Purchase Request_TH_ใบขอซื้อ.rpt
Extracted: 2026-08-05 18:29:45
-- Source: Main Report
-- Table:  Address
-- ============================================================





Select CompnyName,adm1.Street,adm1.Block,adm1.City,adm1.County,adm1.ZipCode,AliasName,Phone1,IntrntAdrs,RevOffice,
CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'GLN_H'
from oadm,adm1,ADM2
