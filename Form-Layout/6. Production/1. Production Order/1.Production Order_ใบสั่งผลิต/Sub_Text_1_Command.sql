-- ============================================================
-- Report: 1.Production Order_ใบสั่งผลิต.rpt
Path:   6. Production\1. Production Order\1.Production Order_ใบสั่งผลิต.rpt
Extracted: 2026-04-09 15:22:52
-- Source: Subreport [Text]
-- Table:  Command
-- ============================================================

select distinct
DocEntry,
[VisOrder] as 'No.',
cast([LineText] as NVARCHAR(2000)) as 'Text' 
from wor1
where DocEntry = 1 

order by 'No.'
