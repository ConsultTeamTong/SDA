SELECT DISTINCT
case when OCRD.Phone2 is null then ''
  when OCRD.Phone2 is not null then ', ' + OCRD.Phone2
  END 'Phone2',
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
OQUT.DocEntry,
OQUT.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
Case when Ocrd.GlblLocNum = '00000' Then N'(สำนักงานใหญ่)'
	when Ocrd.GlblLocNum <> '00000' Then N'สาขาที' + Ocrd.GlblLocNum
END as 'Branch Name',
CRD1.GlblLocNum,
OCRD.Phone1,
ISNULL(OCRD.Phone2,'') As 'Phone2',
OCRD.Fax,
OCRD.LicTradNum,
OCRD.Cardname,
NNM1.BeginStr,
OQUT.DocNum,
OQUT.DocDate,
OQUT.DocDueDate,
(QUT1.VisOrder) As 'No.',
QUT1.LineNum as 'Line No.', 
QUT1.ItemCode,
QUT1.Dscription 'Dscription',
QUT1.Quantity,
QUT1.PriceBefDi,
QUT1.LineTotal,
QUT1.TotalFrgn,
QUT1.DiscPrcnt,
OQUT.VatSum,
OQUT.VatSumFC,
OQUT.DiscSum,
OQUT.DiscSumFC,
OQUT.DiscPrcnt As 'DiscP',
OQUT.DocCur,
OQUT.DocTotal,
OQUT.DocTotalFC,
OCPR.FirstName,
OCPR.LastName,
OQUT.CreateDate,
OQUT.CntctCode,
QUT1.unitMsr,
OQUT.Comments
,qut1.LineType,
qut1.Project,
OCPR.E_MailL as 'Contact',
OCPR.Cellolar as 'Mobile Phone',
ocpr.Tel1 as 'Tel1',
OSLP.SlpName as 'Sale Name contact',
OSLP.Mobil as 'Mobile',
OSLP.Email as 'Email-Sale',
OCTG.PymntGroup,
OCPR.name,
QUT12.StreetB     AS 'Street / PO Box12',
QUT12.StreetNoB   AS 'Street No.12',
QUT12.BlockB      AS 'Block12',
QUT12.CityB       AS 'City12',
QUT12.ZipCodeB    AS 'Zip Code12',
QUT12.CountyB     AS 'County12',
QUT12.StateB      AS 'State12',
QUT12.CountryB    AS 'Country/Region12',
QUT1.U_SLD_Dis_Amount,
OCRD.CardFname
FROM OQUT  
INNER JOIN QUT1 ON OQUT.DocEntry = QUT1.DocEntry 
LEFT JOIN OITM ON QUT1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OQUT.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON (OQUT.CardCode = CRD1.CardCode AND OQUT.PaytoCode = CRD1.Address AND CRD1.AdresType ='B') 
LEFT JOIN OCPR ON OQUT.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OQUT.Series = NNM1.Series 
LEFT JOIN OCTG ON OQUT.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OQUT.OwnerCode = OHEM.empID
LEFT JOIN OSLP ON OQUT.SLPCODE = OSLP.SLPCODE 
LEFT JOIN OPRJ ON QUT1.PROJECT = OPRJ.PRJCODE
INNER JOIN OITT ON QUT1.ItemCode = OITT.Code AND OITT.TreeType = 'S'
INNER JOIN QUT12 ON OQUT.DocEntry = QUT12.DocEntry
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OQUT.U_SLD_LVatBranch = BRANCH.Code , oadm
WHERE OQUT.DocEntry = '{?DocKey@}'
Order by 'No.' , 'Line No.'