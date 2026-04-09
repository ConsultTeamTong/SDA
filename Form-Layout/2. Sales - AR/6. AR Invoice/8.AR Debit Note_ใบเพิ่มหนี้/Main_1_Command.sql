-- ============================================================
-- Report: 8.AR Debit Note_ใบเพิ่มหนี้.rpt
Path:   2. Sales - AR\6. AR Invoice\8.AR Debit Note_ใบเพิ่มหนี้.rpt
Extracted: 2026-04-09 15:22:40
-- Source: Main Report
-- Table:  Command
-- ============================================================

SELECT DISTINCT
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,
 CASE 
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
--CASE WHEN OQUT.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_VComName ELSE BRANCH.U_SLD_F_VComName END AS 'PrintHeadr',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
OINV.DocEntry,
NNM1.BeginStr,
OINV.DocNum,
OINV.DocDate,
OINV.CardCode,
INV1.UnitMsr,
OINV.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
  WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,
OCTG.PymntGroup,
OINV.DocDueDate,
(INV1.VisOrder) As 'No.',
INV1.LineNum as 'Line No.', 
INV1.ItemCode,
INV1.Dscription as 'Dscription', 
INV1.LineType as 'LineType',
INV1.Quantity,
OINV.Comments,
OINV.DocCur,
INV1.PriceBefDi,
INV1.LineTotal,
OINV.VatSum,
OINV.DiscSum 'Dis bill',
OINV.DocTotal,
OINV.DpmAmnt,
INV1.TotalFrgn,
OINV.VatSumFC, 
OINV.DocTotalFC,
OINV.DpmAmntFC,
OINV.Printed,
OINV.U_CN_01,
OINV.U_CN_02,
OINV.U_CN_03,
CASE WHEN OINV.U_DB_02 IS not NULL THEN ''
  WHEN OINV.U_DB_02 IS NULL THEN T10.[Name]
  END 'Reason_DB',
CASE WHEN OINV.U_DB_02 IS NULL THEN ''
  WHEN OINV.U_DB_02 IS NOT NULL THEN N'เพิ่มหนี้เนื่องจาก' + OINV.U_DB_02
  END 'Reason_DB_Remark'
  ,inv1.DiscPrcnt 'LDiscPrcnt'

FROM OINV   
INNER JOIN INV1 ON OINV.DocEntry = INV1.DocEntry 
LEFT JOIN NNM1 ON OINV.Series = NNM1.Series 
LEFT JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON OINV.OwnerCode = OHEM.empID
LEFT JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
LEFT JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
LEFT JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON INV1.Project = OPRJ.PrjCode
Left join [dbo].[@SLD_REASON_DBNOTE] T10 on OINV.U_DB_01 = T10.code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry = {?DocKey@}

Union all
SELECT DISTINCT
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND OINV.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND OINV.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,

 CASE 
 WHEN OINV.Printed = 'N' AND OINV.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN OINV.Printed = 'N' AND OINV.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OINV.Printed = 'Y' AND OINV.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN OINV.Printed = 'Y' AND OINV.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OINV.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
OINV.DocEntry,
NNM1.BeginStr,
OINV.DocNum,
OINV.DocDate,
OINV.CardCode,
'' as UnitMsr,
OINV.[Address],
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
  WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.Phone1,
OCRD.Fax,
OINV.LicTradNum,
OINV.NumAtCard,
OCTG.PymntGroup,
OINV.DocDueDate,
(INV10.AftLineNum + 0.5) As 'No.',
INV10.LineSeq as 'Line No.', 
'' as ItemCode,
CAST(INV10.LineText as nvarchar(4000)) as 'Dscription', 
INV10.LineType as 'LineType',
'0' as Quantity,
OINV.Comments,
OINV.DocCur,
'0' as PriceBefDi,
'0' as LineTotal,
OINV.VatSum,
OINV.DiscSum 'Dis bill',
OINV.DocTotal,
OINV.DpmAmnt,
'0' as TotalFrgn,
OINV.VatSumFC, 
OINV.DocTotalFC,
OINV.DpmAmntFC,
OINV.Printed,
OINV.U_CN_01,
OINV.U_CN_02,
OINV.U_CN_03,
CASE WHEN OINV.U_DB_02 IS not NULL THEN ''
  WHEN OINV.U_DB_02 IS NULL THEN T10.[Name]
  END 'Reason_DB',
CASE WHEN OINV.U_DB_02 IS NULL THEN ''
  WHEN OINV.U_DB_02 IS NOT NULL THEN N'เพิ่มหนี้เนื่องจาก' + OINV.U_DB_02
  END 'Reason_DB_Remark',
'0' as LDiscPrcnt

FROM OINV   
INNER JOIN INV10 ON OINV.DocEntry = INV10.DocEntry 
LEFT JOIN NNM1 ON OINV.Series = NNM1.Series 
LEFT JOIN OCRD ON OINV.CardCode = OCRD.CardCode 
LEFT JOIN OCPR ON OINV.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OINV.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OSLP ON OINV.SlpCode = OSLP.SlpCode 
LEFT JOIN OCTG ON OINV.GroupNum = OCTG.GroupNum 
LEFT JOIN OHEM ON OINV.OwnerCode = OHEM.empID
LEFT JOIN INV11 ON OINV.DocEntry = INV11.DocEntry AND INV11.LineType = 'D'
LEFT JOIN ODPI ON INV11.BASEABS = ODPI.DocEntry
LEFT JOIN NNM1 NNM ON ODPI.Series = NNM.Series 
LEFT JOIN OUSR ON OINV.UserSign = OUSR.USERID
--LEFT JOIN OPRJ ON INV1.Project = OPRJ.PrjCode
Left join [dbo].[@SLD_REASON_DBNOTE] T10 on OINV.U_DB_01 = T10.code
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OINV.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE OINV.DocEntry = {?DocKey@}

Order by 'No.' , 'Line No.'


