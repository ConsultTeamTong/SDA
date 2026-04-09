-- ============================================================
-- Report: 4.AP Debit Note_ใบเพิ่มหนี้.rpt
Path:   3. Purchasing - AP\7. AP Invoice\4.AP Debit Note_ใบเพิ่มหนี้.rpt
Extracted: 2026-04-09 15:22:46
-- Source: Main Report
-- Table:  Command
-- ============================================================

SELECT DISTINCT
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND OPCH.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD.GlblLocNum = '00000' AND OPCH.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD.GlblLocNum = '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD.GlblLocNum <> '00000' AND OPCH.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD.GlblLocNum,')') 
  WHEN CRD.GlblLocNum <> '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD.GlblLocNum,')') 
  when CRD.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,
 CASE 
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
OPCH.DocEntry,
OPCH.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD.GlblLocNum IS NULL THEN ''
  WHEN CRD.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.Phone1, 
OCRD.Fax,
OCRD.LicTradNum,  
NNM1.BeginStr, 
OPCH.DocNum, 
OPCH.DocDate, 
OPCH.DocDueDate, 
OCTG.PymntGroup, 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',
(PCH1.VisOrder) AS 'No.', 
PCH1.LineNum as 'Line No.', 
PCH1.ItemCode, 
PCH1.Dscription as 'Dscription',
PCH1.LineType as 'LineType',
PCH1.Quantity,
PCH1.PriceBefDi, 
PCH1.DiscPrcnt As 'LDiscPrcnt', 
PCH1.LineTotal,
PCH1.TotalFrgn, 
OPCH.VatSum,
OPCH.VatSumFC,
OPCH.DiscSum,
OPCH.DiscSumFC, 
OPCH.DiscPrcnt,
OPCH.DocCur, 
OPCH.DocTotal,
OPCH.DocTotalFC,
PCH1.unitMsr,
OPCH.Comments,
OPCH.DpmAmnt,
OPCH.DpmAmntFC,
CASE WHEN OPCH.U_DB_02 IS not NULL THEN ''
  WHEN OPCH.U_DB_02 IS NULL THEN T10.[Name]
  END 'Reason_DB',
CASE WHEN OPCH.U_DB_02 IS NULL THEN ''
  WHEN OPCH.U_DB_02 IS NOT NULL THEN N'เพิ่มหนี้เนื่องจาก' + OPCH.U_DB_02
  END 'Reason_DB_Remark',
OPCH.U_CN_01,
OPCH.U_CN_02,
OPCH.U_CN_03,
opch.Printed

FROM OPCH   
INNER JOIN PCH1 ON OPCH.DocEntry = PCH1.DocEntry 
LEFT JOIN OITM ON PCH1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B') 
LEFT JOIN OPRJ ON PCH1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN OSLP ON OPCH.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_DBNOTE] T10 ON OPCH.U_DB_01 = T10.code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OPCH.DocEntry = {?DocKey@}

Union all
SELECT DISTINCT
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND OPCH.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD.GlblLocNum = '00000' AND OPCH.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD.GlblLocNum = '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD.GlblLocNum <> '00000' AND OPCH.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD.GlblLocNum,')') 
  WHEN CRD.GlblLocNum <> '00000' AND OPCH.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD.GlblLocNum,')') 
  when CRD.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,
 CASE 
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OPCH.Printed = 'N' AND OPCH.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OPCH.Printed = 'Y' AND OPCH.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OPCH.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
OPCH.DocEntry,
OPCH.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD.GlblLocNum IS NULL THEN ''
  WHEN CRD.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.Phone1, 
OCRD.Fax,
OCRD.LicTradNum,  
NNM1.BeginStr, 
OPCH.DocNum, 
OPCH.DocDate, 
OPCH.DocDueDate, 
OCTG.PymntGroup, 
ISNULL(OPCH.NumAtCard,'') AS 'NumAtCard',
(PCH10.AftLineNum + 0.5) AS 'No.', 
PCH10.LineSeq as 'Line No.', 
'' as ItemCode, 
CAST(PCH10.LineText as nvarchar(4000)) as 'Dscription', 
PCH10.LineType as 'LineType',
'0' as Quantity,
'0' as PriceBefDi, 
'0' as LDiscPrcnt,
'0' as LineTotal,
'0' as TotalFrgn, 
OPCH.VatSum,
OPCH.VatSumFC,
OPCH.DiscSum,
OPCH.DiscSumFC, 
OPCH.DiscPrcnt,
OPCH.DocCur, 
OPCH.DocTotal,
OPCH.DocTotalFC,
'' as unitMsr,
OPCH.Comments,
OPCH.DpmAmnt,
OPCH.DpmAmntFC,
CASE WHEN OPCH.U_DB_02 IS not NULL THEN ''
  WHEN OPCH.U_DB_02 IS NULL THEN T10.[Name]
  END 'Reason_DB',
CASE WHEN OPCH.U_DB_02 IS NULL THEN ''
  WHEN OPCH.U_DB_02 IS NOT NULL THEN N'เพิ่มหนี้เนื่องจาก' + OPCH.U_DB_02
  END 'Reason_DB_Remark',
OPCH.U_CN_01,
OPCH.U_CN_02,
OPCH.U_CN_03,
opch.Printed

FROM OPCH   
INNER JOIN PCH10 ON OPCH.DocEntry = PCH10.DocEntry 
--LEFT JOIN OITM ON PCH1.ItemCode = OITM.ItemCode 
LEFT JOIN OCRD ON OPCH.CardCode = OCRD.CardCode 
LEFT JOIN CRD1 ON OCRD.CardCode = CRD1.CardCode 
LEFT JOIN OCPR ON OPCH.CntctCode = OCPR.CntctCode 
LEFT JOIN NNM1 ON OPCH.Series = NNM1.Series 
LEFT JOIN OCTG ON OPCH.GroupNum = OCTG.GroupNum
LEFT JOIN OHEM ON OPCH.OwnerCode = OHEM.empID
LEFT JOIN CRD1 CRD ON (OPCH.PaytoCode = CRD.[Address] AND OPCH.CardCode = CRD.CardCode AND CRD.AdresType ='B') 
--LEFT JOIN OPRJ ON PCH1.Project = OPRJ.PrjCode
LEFT JOIN OUSR ON OPCH.UserSign = OUSR.USERID
LEFT JOIN OSLP ON OPCH.SlpCode = OSLP.SlpCode
LEFT JOIN [dbo].[@SLD_REASON_DBNOTE] T10 ON OPCH.U_DB_01 = T10.code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OPCH.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OPCH.DocEntry = {?DocKey@}
Order by 'No.' , 'Line No.'
