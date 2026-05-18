SELECT
BRANCH.[Code] As 'BranchCode',
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
BRANCH.U_SLD_Fax As 'BFax',
OIGE.DocEntry,
OIGE.DocNum,
OIGE.DocDate,
NNM1.BeginStr,
(IGE1.VisOrder+1) AS 'No.',
IGE1.LineNum,
IGE1.ItemCode,
--IGE1.Dscription,
OITM.FrgnName,
IGE1.UomCode,
IGE1.Quantity,
IGE1.WhsCode,
OIGE.Comments,
IGE1.unitmsr,
OIGE.U_GI_RE,
pj.Project
FROM OIGE
INNER JOIN IGE1 IGE1 ON OIGE.DocEntry = IGE1.DocEntry
LEFT JOIN IGE1 pj ON OIGE.DocEntry = IGE1.DocEntry AND pj.Project IS NOT NULL AND pj.Project <> ''
LEFT JOIN NNM1 ON OIGE.Series = NNM1.Series
LEFT JOIN OPRJ ON pj.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OIGE.UserSign = OUSR.USERID
LEFT JOIN OITM ON IGE1.ItemCode = OITM.ItemCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OIGE.U_SLD_LVatBranch = BRANCH.Code
WHERE OIGE.DocEntry  = {?DocKey@}
AND OIGE.BaseType <> '202'

ORDER BY IGE1.VisOrder
