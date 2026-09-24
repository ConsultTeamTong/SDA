-- ============================================================
-- Report: Value Added Tax Return under the Revenue Code (P.P.30) v28.rpt
-- Path:   Value Added Tax Return under the Revenue Code (P.P.30) v28.rpt
-- Extracted: 2026-09-24 10:21:02
-- Source: Main Report
-- Table:  Command
-- ============================================================

Select Code,U_SLD_VTAXID,U_SLD_VComAddress,U_SLD_VComName  From [@SLDT_SET_BRANCH] Where Code = '00000'
