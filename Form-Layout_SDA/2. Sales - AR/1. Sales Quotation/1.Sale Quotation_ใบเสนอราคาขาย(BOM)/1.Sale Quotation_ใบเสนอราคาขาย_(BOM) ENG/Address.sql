-- ============================================================
-- Report: 1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
Path:   1.Sale Quotation_ใบเสนอราคาขาย(BOM)\1.Sale Quotation_ใบเสนอราคาขาย_(BOM) ENG.rpt
Extracted: 2026-08-17 11:43:02
-- Source: Main Report
-- Table:  Address
-- ============================================================

SELECT TOP 1
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
    CASE 
        WHEN adm1.GlblLocNum = '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN '(Head office)' 
        WHEN adm1.GlblLocNum <> '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN CONCAT('(Branch ', adm1.GlblLocNum, ')') 
        WHEN adm1.GlblLocNum = '' OR adm1.GlblLocNum IS NULL THEN ''
    END AS 'Branch Name'
FROM OADM, ADM1, OQUT
WHERE 
    CASE 
        WHEN adm1.GlblLocNum = '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN '(Head office)' 
        WHEN adm1.GlblLocNum <> '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN CONCAT('(Branch ', adm1.GlblLocNum, ')') 
        WHEN adm1.GlblLocNum = '' OR adm1.GlblLocNum IS NULL THEN ''
    END IS NOT NULL;
