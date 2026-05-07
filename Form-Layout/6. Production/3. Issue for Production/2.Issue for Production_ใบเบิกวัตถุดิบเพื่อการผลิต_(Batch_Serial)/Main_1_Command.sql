SELECT DISTINCT
OIGE.docentry,
PNNM.BeginStr As 'OderBeginStr',
PNNM.SeriesName As 'OderSeries',
OWOR.DocNum As 'OderNo.',
OWOR.ItemCode AS 'Production_No',
OWOR.ProdName,
OWOR.PlannedQty,
OWOR.Warehouse,
NNM1.SeriesName,
OIGE.DocNum,
OIGE.DocDate,
(IGE1.VisOrder+1) AS 'No.',
IGE1.ItemCode,
IGE1.Dscription,
IGE1.Quantity,
IGE1.UomCode,
IGE1.WhsCode,
OWOR.PostDate as 'PostDate' ,
NNM1.BeginStr,
OIGE.Comments,
BRANCH.Code as 'BranchCode' ,
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_Building As 'Building',
BRANCH.U_SLD_Steet As 'Street',
BRANCH.U_SLD_Block As 'Block',
BRANCH.U_SLD_City As 'City',
BRANCH.U_SLD_County As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax'

FROM OIGE 
LEFT JOIN IGE1 ON OIGE.DocEntry = IGE1.DocEntry 
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series 
LEFT JOIN OWOR ON IGE1.BaseEntry = OWOR.DocEntry
LEFT JOIN NNM1 PNNM ON OWOR.Series = PNNM.Series
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OWHS ON OIGE.U_SLD_LVatbranch = OWHS.GlblLocNum
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code

WHERE 
OIGE.DocEntry  = {?DocKey@}
AND 
IGE1.BaseType = '202'

ORDER BY (IGE1.VisOrder+1)