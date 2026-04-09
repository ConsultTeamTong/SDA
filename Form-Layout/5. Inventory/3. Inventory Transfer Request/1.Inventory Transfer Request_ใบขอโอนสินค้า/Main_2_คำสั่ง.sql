-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Path:   5. Inventory\3. Inventory Transfer Request\1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
Extracted: 2026-04-09 15:22:50
-- Source: Main Report
-- Table:  คำสั่ง
-- ============================================================

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
BRANCH.U_SLD_Fax As 'BFax'
FROM [dbo].[@SLDT_SET_BRANCH] BRANCH
WHERE BRANCH.Code = '00000'
