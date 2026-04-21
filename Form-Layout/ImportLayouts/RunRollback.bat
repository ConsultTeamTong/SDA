@echo off
chcp 65001 >nul
REM ============================================================
REM  Rollback Crystal Layouts imported from RPT_Import_Map.xlsx
REM  Deletes rows in RDOC matching (DocName + TypeCode + Author)
REM ============================================================
set SERVER=10.10.10.115
set COMPANYDB=SBO_SDA_MARK1
set DBUSER=sa
set DBPASSWORD=1q2w3e4r@
set AUTHOR=SDA

REM ============================================================
REM  MODE:
REM    -DryRun        = preview only (no delete)
REM    (leave empty)  = delete for real (will ask confirmation)
REM    -Force         = delete without asking
REM ============================================================
set MODE=

echo ============================================
echo  Rollback Layouts
echo  Server   : %SERVER%
echo  Database : %COMPANYDB%
echo  Author   : %AUTHOR%
echo  Mode     : %MODE%
echo ============================================
echo.
pause

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Rollback-FromExcel.ps1" ^
    -Server "%SERVER%" ^
    -CompanyDB "%COMPANYDB%" ^
    -DBUser "%DBUSER%" ^
    -DBPassword "%DBPASSWORD%" ^
    -Author "%AUTHOR%" ^
    %MODE%

echo.
pause
