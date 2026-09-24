-- ============================================================
-- Report: 1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
-- Path:   1.Inventory Transfer Request_ใบขอโอนสินค้า.rpt
-- Extracted: 2026-09-24 10:20:15
-- Source: Main Report
-- Table:  Transfer_Re
-- ============================================================

SELECT T0.*
FROM (
-- 1.1 item rows of the real document
SELECT DISTINCT
 
OWTQ.Docentry,

OWTQ.DocNum,
 
NNM1.BeginStr,
 
OWTQ.DocDate,
 
WTQ1.ItemCode,
 
WTQ1.LineNum,

WTQ1.Dscription,
 
WTQ1.FromWhsCod as 'L WH Fr',
 
WTQ1.WhsCode as 'L WH To',
 
WTQ1.Quantity,
 
WTQ1.UomCode ,

OWTQ.Comments,

(WTQ1.VisOrder+1) as 'No',

QPJ.Project
,
    WTQ1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OWTQ 
INNER JOIN WTQ1 ON OWTQ.DocEntry = WTQ1.DocEntry 
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM WTQ1 P
    WHERE P.DocEntry = OWTQ.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OBPL ON OWTQ.BPLId = OBPL.BPLId 
LEFT JOIN NNM1 ON OWTQ.Series = NNM1.Series 
,OADM  , OADP
Where
OWTQ.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '1250000001'



UNION ALL
-- 1.2 text rows (remarks) of the real document
SELECT DISTINCT
 
OWTQ.Docentry,

OWTQ.DocNum,
 
NNM1.BeginStr,
 
OWTQ.DocDate,
    NULL AS 'ItemCode',
    NULL AS 'LineNum',
    CAST(WTQ10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'L WH Fr',
    NULL AS 'L WH To',
    NULL AS 'Quantity',
    NULL AS 'UomCode',

OWTQ.Comments,
    NULL AS 'No',

QPJ.Project
,
    WTQ1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    WTQ10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM OWTQ 
INNER JOIN WTQ10 ON OWTQ.DocEntry = WTQ10.DocEntry
LEFT JOIN WTQ1 ON WTQ10.DocEntry = WTQ1.DocEntry AND WTQ10.AftLineNum = WTQ1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM WTQ1 P
    WHERE P.DocEntry = OWTQ.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OBPL ON OWTQ.BPLId = OBPL.BPLId 
LEFT JOIN NNM1 ON OWTQ.Series = NNM1.Series 
,OADM  , OADP
Where
OWTQ.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '1250000001'



UNION ALL
-- 2.1 item rows of the draft document
SELECT DISTINCT
 
OWTQ.Docentry,

OWTQ.DocNum,
 
NNM1.BeginStr,
 
OWTQ.DocDate,
 
WTQ1.ItemCode,
 
WTQ1.LineNum,

WTQ1.Dscription,
 
WTQ1.FromWhsCod as 'L WH Fr',
 
WTQ1.WhsCode as 'L WH To',
 
WTQ1.Quantity,
 
WTQ1.UomCode ,

OWTQ.Comments,

(WTQ1.VisOrder+1) as 'No',

QPJ.Project
,
    WTQ1.VisOrder AS 'Sort_VisOrder',
    0 AS 'Sort_IsText',
    0 AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OWTQ
INNER JOIN DRF1 WTQ1 ON OWTQ.DocEntry = WTQ1.DocEntry 
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OWTQ.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OBPL ON OWTQ.BPLId = OBPL.BPLId 
LEFT JOIN NNM1 ON OWTQ.Series = NNM1.Series 
,OADM  , OADP
Where
OWTQ.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OWTQ.ObjType = '1250000001'


UNION ALL
-- 2.2 text rows (remarks) of the draft document
SELECT DISTINCT
 
OWTQ.Docentry,

OWTQ.DocNum,
 
NNM1.BeginStr,
 
OWTQ.DocDate,
    NULL AS 'ItemCode',
    NULL AS 'LineNum',
    CAST(WTQ10.LineText AS NVARCHAR(4000)) AS 'Dscription',
    NULL AS 'L WH Fr',
    NULL AS 'L WH To',
    NULL AS 'Quantity',
    NULL AS 'UomCode',

OWTQ.Comments,
    NULL AS 'No',

QPJ.Project
,
    WTQ1.VisOrder AS 'Sort_VisOrder',
    1 AS 'Sort_IsText',
    WTQ10.LineSeq AS 'Sort_Seq'

,
    (SELECT TOP 1 PJN.PrjName FROM OPRJ PJN WHERE PJN.PrjCode = (QPJ.Project)) AS 'ProjectName'
FROM ODRF OWTQ
INNER JOIN DRF10 WTQ10 ON OWTQ.DocEntry = WTQ10.DocEntry
LEFT JOIN DRF1 WTQ1 ON WTQ10.DocEntry = WTQ1.DocEntry AND WTQ10.AftLineNum = WTQ1.VisOrder
-- OUTER APPLY keeps Project a header-level lookup; the old pj join
-- multiplied every detail row. Do not turn it back into a JOIN.

OUTER APPLY (
    SELECT TOP 1 P.Project
    FROM DRF1 P
    WHERE P.DocEntry = OWTQ.DocEntry
      AND P.Project IS NOT NULL
      AND P.Project <> ''
) QPJ
LEFT JOIN OPRJ ON QPJ.Project = OPRJ.PrjCode
LEFT JOIN OBPL ON OWTQ.BPLId = OBPL.BPLId 
LEFT JOIN NNM1 ON OWTQ.Series = NNM1.Series 
,OADM  , OADP
Where
OWTQ.DocEntry  = {?DocKey@}
  AND {?ObjectId@} = '112' AND OWTQ.ObjType = '1250000001'


) T0
ORDER BY T0.[Sort_VisOrder] ASC, T0.[Sort_IsText] ASC, T0.[Sort_Seq] ASC
