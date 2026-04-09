-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Path:   5. Inventory\3. Inventory Transfer Request\1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Extracted: 2026-04-09 15:22:50
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
