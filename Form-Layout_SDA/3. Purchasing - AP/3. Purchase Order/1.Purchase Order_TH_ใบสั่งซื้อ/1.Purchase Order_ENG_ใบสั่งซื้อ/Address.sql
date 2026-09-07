-- ============================================================
-- Report: 1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Path:   1.Purchase Order_ENG_ใบสั่งซื้อ.rpt
Extracted: 2026-09-01 18:40:45
-- Source: Main Report
-- Table:  Address
-- ============================================================

SELECT 
    OADM.CompnyName,
    ADM1.Street,
    ADM1.Block,
    ADM1.City,
    ADM1.County,
    ADM1.ZipCode,
    ADM1.StreetF,
    ADM1.BlockF,
    ADM1.CityF,
    ADM1.CountyF,
    OADM.AliasName,
    OADM.Phone1F as Phone1,
  OADM.RevOffice,
    CASE 
        WHEN ADM1.GlblLocNum = '00000' THEN N'(Head office)'
        WHEN ADM1.GlblLocNum <> '00000' AND ADM1.GlblLocNum IS NOT NULL THEN N'(Branch ' + ADM1.GlblLocNum + ')'
        ELSE ''
    END AS 'GLN_H',
    OCRY.Name AS 'CountryName'
FROM OADM
CROSS JOIN ADM1
CROSS JOIN ADM2
LEFT JOIN OCRY ON ADM1.Country = OCRY.Code
