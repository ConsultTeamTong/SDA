-- ============================================================
-- Report: 1.Outgoing Payments_ใบจ่ายชำระ.rpt
Path:   4. Banking\2. Outgoing Payments\1.Outgoing Payments_ใบจ่ายชำระ.rpt
Extracted: 2026-04-09 15:22:48
-- Source: Main Report
-- Table:  Command_2
-- ============================================================

SELECT DISTINCT
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND OVPM.DocCurr = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND OVPM.DocCurr <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND OVPM.DocCurr = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND OVPM.DocCurr <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD1.GlblLocNum = '00000' AND OVPM.DocCurr = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND OVPM.DocCurr <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND OVPM.DocCurr = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND OVPM.DocCurr <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,

 CASE 
 WHEN OVPM.Printed = 'N' AND OVPM.DocCurr <> OADM.MainCurncy THEN 'Original'
 WHEN OVPM.Printed = 'N' AND OVPM.DocCurr = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN OVPM.Printed = 'Y' AND OVPM.DocCurr <> OADM.MainCurncy THEN 'Copy'  
 WHEN OVPM.Printed = 'Y' AND OVPM.DocCurr = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
--CASE WHEN OQUT.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_VComName ELSE BRANCH.U_SLD_F_VComName END AS 'PrintHeadr',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN OVPM.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN OVPM.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN OVPM.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN OVPM.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN OVPM.DocCurr = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
CONVERT(NVARCHAR,OVPM.Docnum) AS Docnum1,
--CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
--  WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
--  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
OVPM.DocEntry,
OVPM.DocNum,
OVPM.DocDate,
OVPM.CardCode,
OVPM.[Address],
OVPM.CashAcct,
OVPM.CreditSum,
OVPM.TrsfrSum,
OVPM.DocCurr,
OVPM.Comments,
OVPM.JrnlMemo,
OVPM.TransId,
OVPM.CheckSumSy, 
NNM1.Beginstr, 
CONVERT(NVARCHAR(100),OCRD.Building ) AS 'BPBuilding'  

FROM OVPM 
LEFT JOIN VPM1 ON OVPM.DocENTRY = VPM1.DocNum
LEFT JOIN VPM2 ON OVPM.DocEntry = VPM2.DocNum
INNER JOIN NNM1 ON OVPM.Series = NNM1.Series
LEFT OUTER JOIN OCRD ON OVPM.CardCode = OCRD.CardCode
LEFT OUTER JOIN OCPR ON OVPM.CardCode = OCPR.CardCode
LEFT JOIN CRD1 ON (OCRD.CardCode = CRD1.CardCode AND OVPM.PayToCode = CRD1.Address AND CRD1.AdresType ='B')
LEFT JOIN OUSR ON OVPM.UserSign = OUSR.USERID
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON OVPM.U_SLD_VatBranch = BRANCH.Code , oadm
