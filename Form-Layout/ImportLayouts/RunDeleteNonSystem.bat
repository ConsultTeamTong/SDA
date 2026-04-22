@echo off
chcp 65001 >nul
REM ============================================================
REM  Delete ALL layouts in RDOC EXCEPT Author='-System-'
REM  ** DESTRUCTIVE ** - backup RDOC first if needed
REM ============================================================
set SERVER=10.10.10.115
set COMPANYDB=SBO_SDA_(Test)_Pre_Training
set DBUSER=sa
set DBPASSWORD=1q2w3e4r@
set SYSTEMAUTHOR=-System-

REM ============================================================
REM  MODE:
REM    -DryRun        = preview only (no delete)
REM    (leave empty)  = delete for real (will ask 'yes' confirm)
REM    -Force         = delete without asking
REM ============================================================
set MODE=

echo ============================================
echo  Delete NON-SYSTEM Layouts from RDOC
echo  Server      : %SERVER%
echo  Database    : %COMPANYDB%
echo  Keep Author : %SYSTEMAUTHOR%
echo  Mode        : %MODE%
echo ============================================
echo.
pause

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\Delete-NonSystemLayouts.ps1" ^
    -Server "%SERVER%" ^
    -CompanyDB "%COMPANYDB%" ^
    -DBUser "%DBUSER%" ^
    -DBPassword "%DBPASSWORD%" ^
    -SystemAuthor "%SYSTEMAUTHOR%" ^
    %MODE%

echo.
pause
