-- ============================================================
-- Report: 2.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
Path:   2. Sales - AR\4. Return\2.Retrun_ใบรับคืนสินค้า_(Batch_Serial).rpt
Extracted: 2026-04-09 15:22:35
-- Source: Main Report
-- Table:  คำสั่ง
-- ============================================================

SELECT distinct
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ORDN.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ORDN.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ORDN.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ORDN.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,
 CASE 
 WHEN ORDN.Printed = 'N' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORDN.Printed = 'N' AND ORDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORDN.Printed = 'Y' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORDN.Printed = 'Y' AND ORDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
ORDN.[Address],
ORDN.[CardCode],
ORDN.[Comments],
RDN1.[ItemCode],
RDN1.[dscription] as 'Dscription',
RDN1.[Quantity],
ORDN.[DocDate],
ORDN.[DocNum],
ORDN.[DocEntry],
NNM1.[BeginStr],
ORDN.[CreateDate],
RDN1.[unitMsr],
(RDN1.[VisOrder]) As 'No.',
RDN1.LineNum as 'Line No.', 
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
  WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
RDN1.LineType
FROM ORDN  
INNER JOIN RDN1 ON ORDN.[DocEntry] = RDN1.[DocEntry]
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
LEFT JOIN OPRJ ON RDN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE ORDN.[DocEntry] = {?DocKey@}

Union all
SELECT distinct
CONCAT(OCPR.FirstName,' ',OCPR.LastName) AS 'Coontact',
BRANCH.Code ,
CASE WHEN BRANCH.Code = '00000' AND ORDN.DocCur = OADM.MainCurncy THEN N'สำนักงานใหญ่' 
  WHEN BRANCH.Code = '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Head office' 
  WHEN BRANCH.Code <> '00000' AND ORDN.DocCur = OADM.MainCurncy THEN concat(N'สาขาที่' ,' ',BRANCH.Code) 
  WHEN BRANCH.Code <> '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN concat('Branch' ,' ',BRANCH.Code) 
END 'GLN_H' ,
CASE WHEN CRD1.GlblLocNum = '00000' AND ORDN.DocCur = OADM.MainCurncy THEN N'(สำนักงานใหญ่)' 
  WHEN CRD1.GlblLocNum = '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN '(Head office)' 
  WHEN CRD1.GlblLocNum <> '00000' AND ORDN.DocCur = OADM.MainCurncy THEN concat(N'(สาขาที่' ,' ',CRD1.GlblLocNum,')') 
  WHEN CRD1.GlblLocNum <> '00000' AND ORDN.DocCur <> OADM.MainCurncy THEN concat('(Branch' ,' ',CRD1.GlblLocNum,')') 
  when CRD1.GlblLocNum = '' or CRD1.GlblLocNum is null then ''
END 'GLN_BP' ,
 CASE 
 WHEN ORDN.Printed = 'N' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Original'
 WHEN ORDN.Printed = 'N' AND ORDN.DocCur = OADM.MainCurncy THEN N'ต้นฉบับ' 
 WHEN ORDN.Printed = 'Y' AND ORDN.DocCur <> OADM.MainCurncy THEN 'Copy'  
 WHEN ORDN.Printed = 'Y' AND ORDN.DocCur = OADM.MainCurncy THEN N'สำเนา'
 END AS 'Print Status',
BRANCH.[Name] As 'BranchName',
BRANCH.U_SLD_VTAXID As 'TaxIdNum',
BRANCH.U_SLD_VComName As 'PrintHeadr',
BRANCH.U_SLD_F_VComName As 'PrintHdrF',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Building ELSE BRANCH.U_SLD_F_Building END AS 'Building',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Steet  ELSE BRANCH.U_SLD_F_Steet  END AS 'Street',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_Block  ELSE BRANCH.U_SLD_F_Block   END AS 'Block',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_City  ELSE BRANCH.U_SLD_F_City  END As 'City',
CASE WHEN ORDN.DocCur = OADM.MainCurncy THEN BRANCH.U_SLD_County ELSE BRANCH.U_SLD_F_County  END As 'County',
BRANCH.U_SLD_ZipCode As 'ZipCode',
BRANCH.U_SLD_Tel As 'Tel',
BRANCH.U_SLD_Fax As 'BFax',
BRANCH.U_SLD_Email AS 'E-Mail',
--------------------------------------------------------------------------------------------------------
ORDN.[Address],
ORDN.[CardCode],
ORDN.[Comments],
'' as [ItemCode],
CAST(RDN10.LineText as nvarchar(4000)) as 'Dscription',
'0' as [Quantity],
ORDN.[DocDate],
ORDN.[DocNum],
ORDN.[DocEntry],
NNM1.[BeginStr],
ORDN.[CreateDate],
'' as [unitMsr],
(RDN10.AftLineNum + 0.5) As 'No.', 
RDN10.LineSeq as 'Line No.', 
OCRD.U_SLD_Title,
OCRD.U_SLD_FullName,
CASE WHEN CRD1.GlblLocNum IS NULL THEN ''
  WHEN CRD1.GlblLocNum IS NOT NULL THEN N'สาขาที่ ' + CRD1.GlblLocNum
  END 'GLN',
CASE WHEN OCRD.Phone2 IS NULL THEN ''
  WHEN OCRD.Phone2 IS NOT NULL THEN ', ' + OCRD.Phone2
  END 'Phone2',
RDN10.LineType
FROM ORDN  
INNER JOIN RDN10 ON ORDN.[DocEntry] = RDN10.[DocEntry]
LEFT JOIN OCRD ON ORDN.CardCode = OCRD.CardCode
LEFT JOIN OCPR ON ORDN.CntctCode = OCPR.CntctCode
LEFT JOIN CRD1 ON (ORDN.[CardCode] = CRD1.[CardCode] AND ORDN.[PayToCode] = CRD1.[Address] AND CRD1.[AdresType] ='B')
LEFT JOIN NNM1 ON ORDN.[Series] = NNM1.[Series]
LEFT JOIN OUSR ON ORDN.UserSign = OUSR.USERID
--LEFT JOIN OPRJ ON RDN1.Project = OPRJ.PrjCode
LEFT JOIN [dbo].[@SLDT_SET_BRANCH] BRANCH ON ORDN.U_SLD_LVatBranch = BRANCH.Code , oadm

WHERE ORDN.[DocEntry] = {?DocKey@}
Order by 'No.' , 'Line No.'
