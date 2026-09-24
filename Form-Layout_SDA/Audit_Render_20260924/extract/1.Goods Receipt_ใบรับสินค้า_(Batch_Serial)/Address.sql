-- ============================================================
-- Report: 1.Goods Receipt_ใบรับสินค้า_(Batch_Serial).rpt
-- Path:   1.Goods Receipt_ใบรับสินค้า_(Batch_Serial).rpt
-- Extracted: 2026-09-24 10:20:10
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
