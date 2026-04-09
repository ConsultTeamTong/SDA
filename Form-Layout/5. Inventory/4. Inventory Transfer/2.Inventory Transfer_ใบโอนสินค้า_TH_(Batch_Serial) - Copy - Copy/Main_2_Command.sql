-- ============================================================
-- Report: 2.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial) - Copy - Copy.rpt
Path:   5. Inventory\4. Inventory Transfer\2.Inventory Transfer_ใบโอนสินค้า_TH_(Batch_Serial) - Copy - Copy.rpt
Extracted: 2026-04-09 15:22:51
-- Source: Main Report
-- Table:  Command
-- ============================================================

select 
oadm.CompnyName,
oadm.AliasName,
oadm.Phone1,
adm1.IntrntAdrs,
oadm.RevOffice,
adm1.Street,
adm1.City,
adm1.ZipCode,
CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'Branch Name'
from oadm
left join adm1 on oadm.Country = adm1.Country
