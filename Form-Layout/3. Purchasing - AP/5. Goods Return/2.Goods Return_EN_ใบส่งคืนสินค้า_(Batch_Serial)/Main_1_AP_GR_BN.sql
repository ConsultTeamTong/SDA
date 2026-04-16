SELECT distinct
ORPD.DocEntry,
(RPD1.VisOrder) AS 'No.',
RPD1.LineNum as 'Line No.', 
ORPD.[Address],  
OCRD.LicTradNum, 
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.Phone1 , 
OCRD.Fax,  
ORPD.NumAtCard, 
ORPD.Comments,
RPD1.ItemCode,
RPD1.dscription as 'Dscription', 
RPD1.Quantity, 
ORPD.DocDate, 
ORPD.DocNum, 
NNM1.BeginStr,
ORPD.CreateDate,
ORPD.CardCode,
ORPD.U_SLD_Returnreason,
RPD1.unitMsr,
RPD1.LineType,
rpD1.Project,
OCRD.CntctPrsn,
OCrd.E_Mail,
ocrd.phone1,
ocrd.phone2,
CAST(rpd12.StreetB AS nvarchar(max)) as StreetB, CAST(rpd12.StreetNoB AS nvarchar(max)) as StreetNoB,CAST(rpd12.BlockB AS nvarchar(max)) as BlockB, CAST(rpd12.BuildingB AS nvarchar(max)) as BuildingB, 
CAST(rpd12.CityB AS nvarchar(max)) as CityB, rpd12.ZipCodeB, CAST(rpd12.CountyB AS nvarchar(max)) as CountyB, rpd12.StateB
FROM ORPD 
INNER JOIN RPD1 ON ORPD.DocEntry = RPD1.DocEntry
INNER JOIN RPD12 ON ORPD.DocEntry = RPD12.DocEntry
LEFT JOIN NNM1 ON ORPD.Series = NNM1.Series
LEFT JOIN OUSR ON ORPD.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RPD1.Project = OPRJ.PrjCode
LEFT JOIN OCRD ON ORPD.CardCode = OCRD.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND ORPD.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OCPR ON OCRD.CardCode = OCPR.CardCode
LEFT JOIN OITM ON RPD1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORPD.U_SLD_LVatBranch = BRANCH.Code, OADM
WHERE ORPD.DocEntry = {?DocKey@}
