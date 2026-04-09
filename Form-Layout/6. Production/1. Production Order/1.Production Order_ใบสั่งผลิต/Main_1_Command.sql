-- ============================================================
-- Report: 1.Production Order_ใบสั่งผลิต.rpt
Path:   6. Production\1. Production Order\1.Production Order_ใบสั่งผลิต.rpt
Extracted: 2026-04-09 15:22:52
-- Source: Main Report
-- Table:  Command
-- ============================================================

SELECT DISTINCT
(WOR1.VisOrder) 'No.' ,
WOR1.ItemType,
--Case 
--	when ORSC.ResName is not null or ORSC.ResName <> '' then ORSC.ResName
--		when WOR1.ItemName is not null or WOR1.ItemName <> '' then WOR1.ItemName
--			end 'Item' ,
WOR1.ItemName ,
CAST(WOR1.LineText as nvarchar(4000)) as 'Text',
BRANCH.Code as 'BranchCode' ,
BRANCH.[Name] AS 'BranchName',
BRANCH.U_SLD_VComName AS 'PrintHeadr',
BRANCH.U_SLD_F_VComName AS 'PrintHdrF',
BRANCH.U_SLD_VTAXID AS 'TaxIdNum',
BRANCH.U_SLD_Building AS 'Building',
BRANCH.U_SLD_Steet AS 'Street',
BRANCH.U_SLD_Block AS 'Block',
BRANCH.U_SLD_City AS 'City',
BRANCH.U_SLD_County AS 'County',
BRANCH.U_SLD_ZipCode AS 'ZipCode',
BRANCH.U_SLD_Tel AS 'Tel',
BRANCH.U_SLD_Fax AS 'BFax',
OWOR.DocEntry,
NNM1.SeriesName AS 'SeriesName',
NNM1.BeginStr,
OWOR.DocNum AS 'DocNum' ,
OWOR.PostDate AS 'PostDate' ,
OWOR.DueDate AS 'DueDate',
OWOR.ItemCode AS 'Code FG',
OWOR.ProdName AS 'ProdName',
OWOR.PlannedQty AS 'PlannedQty',
OWOR.Uom AS 'Uom', 
OWOR.Warehouse AS 'Warehouse',
WOR1.ItemCode AS 'Code RM',
OWOR.OriginNum As 'Sale No.',
WOR1.UomCode As 'UomCode',
WOR1.PlannedQty,
WOR1.IssuedQty,
WOR1.wareHouse AS 'WH' ,
OWOR.Comments

FROM OWOR 
LEFT Outer JOIN WOR1 ON OWOR.DocEntry = WOR1.DocEntry
LEFT JOIN OITM ON WOR1.ItemCode = OITM.ItemCode 
LEFT JOIN NNM1 ON OWOR.Series = NNM1.Series
LEFT JOIN ORSC ON WOR1.ItemCode = ORSC.VisResCode
LEFT JOIN OPRJ ON OWOR.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OWOR.UserSign = OUSR.USERID
LEFT JOIN OWHS ON OWOR.Warehouse = OWHS.WhsCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OWOR.U_SLD_LVatBranch = BRANCH.Code

WHERE OWOR.DocEntry  =  '{?DocKey@}'

Order by VisOrder

