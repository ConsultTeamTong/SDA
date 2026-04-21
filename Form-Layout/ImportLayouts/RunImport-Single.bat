@echo off
chcp 65001 >nul
REM ============================================================
REM  Import a SINGLE layout by keyword (asks you what to import)
REM ============================================================
set SERVER=10.10.10.115
set COMPANYDB=SBO_SDA_MARK1
set DBUSER=sa
set DBPASSWORD=1q2w3e4r@
set AUTHOR=manager

echo ============================================
echo  Single Layout Import
echo  Server   : %SERVER%
echo  Database : %COMPANYDB%
echo ============================================
echo.
set /p FILTER=Type keyword from filename (e.g. Journal Entry, Sale Order, AR Invoice):

if "%FILTER%"=="" (
    echo No keyword entered. Exiting.
    pause
    exit /b
)

echo.
echo Importing rows matching "%FILTER%" ...
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Import_SQL_Direct.ps1" ^
    -Server "%SERVER%" ^
    -CompanyDB "%COMPANYDB%" ^
    -DBUser "%DBUSER%" ^
    -DBPassword "%DBPASSWORD%" ^
    -Author "%AUTHOR%" ^
    -FilterFileName "%FILTER%" ^
    -UseFileNameAsDocName ^
    -OnDuplicate Update

echo.
pause
