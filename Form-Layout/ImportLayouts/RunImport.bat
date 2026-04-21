@echo off
chcp 65001 >nul
REM ============================================================
REM  Import Crystal Layouts to SAP B1 (SQL Direct)
REM  EDIT THE 4 CREDENTIAL LINES + 2 MODE LINES BELOW IF NEEDED
REM ============================================================
set SERVER=10.10.10.115
set COMPANYDB=SBO_SDA_MARK1
set DBUSER=sa
set DBPASSWORD=1q2w3e4r@

REM ============================================================
REM  AUTHOR: who to record as the layout author
REM  Use "manager" to overwrite existing layouts created by manager
REM ============================================================
set AUTHOR=manager

REM ============================================================
REM  MODE: choose one of these for MODE
REM    -DryRun        = preview only (no changes)
REM    (leave empty)  = real import
REM ============================================================
set MODE=

REM ============================================================
REM  ONDUP: how to handle duplicate layouts (DocName+TypeCode+Author match)
REM    Update  = overwrite existing (recommended, default)
REM    Skip    = leave existing alone, only insert new
REM    Insert  = always insert new row (creates duplicates - careful!)
REM ============================================================
set ONDUP=Update

echo ============================================
echo  SAP B1 Layout Import
echo  Server   : %SERVER%
echo  Database : %COMPANYDB%
echo  Mode     : %MODE% (empty=real run)
echo  OnDup    : %ONDUP%
echo ============================================
echo.
pause

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Import_SQL_Direct.ps1" ^
    -Server "%SERVER%" ^
    -CompanyDB "%COMPANYDB%" ^
    -DBUser "%DBUSER%" ^
    -DBPassword "%DBPASSWORD%" ^
    -Author "%AUTHOR%" ^
    -UseFileNameAsDocName ^
    -OnDuplicate %ONDUP% ^
    %MODE%

echo.
echo ============================================
echo  Done. Check log: %~dp0Import_SQL_Log.txt
echo ============================================
pause
