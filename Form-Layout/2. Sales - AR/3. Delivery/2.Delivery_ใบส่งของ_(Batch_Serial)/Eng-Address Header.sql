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


CASE WHEN adm1.GlblLocNum = '00000' AND OQUT.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN adm1.GlblLocNum = '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN adm1.GlblLocNum <> '00000' AND OQUT.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',adm1.GlblLocNum,')') 
  WHEN adm1.GlblLocNum <> '00000' AND OQUT.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',adm1.GlblLocNum,')') 
  when adm1.GlblLocNum = '' or adm1.GlblLocNum is null then ''
END as 'Branch Name'
from oadm,adm1,ADM2,OQUT

where OQUT.DocEntry = '{?Dockey@}'