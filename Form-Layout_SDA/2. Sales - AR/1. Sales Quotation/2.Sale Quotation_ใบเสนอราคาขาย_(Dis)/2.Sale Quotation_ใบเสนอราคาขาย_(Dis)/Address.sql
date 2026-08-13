-- ============================================================
-- Report: 2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Path:   2.Sale Quotation_ใบเสนอราคาขาย_(Dis)\2.Sale Quotation_ใบเสนอราคาขาย_(Dis).rpt
Extracted: 2026-08-05 14:09:14
-- Source: Main Report
-- Table:  Address
-- ============================================================

select 
CompnyName,
adm1.Street,
adm1.Block,
adm1.City,
adm1.County,
adm1.ZipCode,
ADM1.StreetF,
adm1.BlockF,
adm1.CityF,
adm1.CountyF,
AliasName,
Phone1,
IntrntAdrs,
RevOffice,

CASE WHEN adm1.GlblLocNum = '00000' THEN N'สำนักงานใหญ่'
  WHEN adm1.GlblLocNum <> '00000' THEN N'สาขาที่ ' + adm1.GlblLocNum
  END as 'Branch Name'
from oadm,adm1,ADM2
