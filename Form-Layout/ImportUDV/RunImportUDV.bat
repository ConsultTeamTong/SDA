@echo off
chcp 65001 >nul
REM ============================================================
REM  Import User-Defined Values (FMS) to SAP B1 via DI API
REM  Connection settings are in _settings.bat (shared, gitignored).
REM
REM  Auto-detects DI API bitness:
REM    B1 v10+  in Program Files\SAP\...           -> 64-bit PS
REM    B1 v9.x  in Program Files (x86)\SAP\...     -> 32-bit PS
REM ============================================================
if not exist "%~dp0_settings.bat" (
    echo ERROR: _settings.bat not found.
    echo Copy _settings.bat.example to _settings.bat and edit it.
    pause
    exit /b 1
)
call "%~dp0_settings.bat"

REM ============================================================
REM  SAP B1 application login (required by DI API even with sa)
REM    Put SAPUSER / SAPPASSWORD in _settings.bat if you prefer.
REM    Fallback defaults below.
REM ============================================================
if "%SAPUSER%"==""     set SAPUSER=manager
if "%SAPPASSWORD%"=="" set SAPPASSWORD=%DBPASSWORD%

REM ============================================================
REM  DBTYPE: MSSQL or HANA
REM ============================================================
if "%DBTYPE%"=="" set DBTYPE=MSSQL

REM ============================================================
REM  MODE:
REM    -DryRun        = validate CSV, no DI API connect, no writes
REM    (leave empty)  = real import
REM ============================================================
set MODE=

setlocal enabledelayedexpansion
set "CFG=%~dp0Config"

echo ============================================
echo  Select UDV mapping CSV from:
echo  !CFG!
echo ============================================
set IDX=0
for %%F in ("!CFG!\UDV_*.csv") do (
    set /a IDX+=1
    set "FILE_!IDX!=%%~nxF"
    echo   !IDX!. %%~nxF
)
if %IDX%==0 (
    echo No UDV_*.csv files found in !CFG!
    echo Copy UDV_Map.csv.example -^> UDV_Map.csv and edit it.
    pause
    exit /b
)
echo.
set /p PICK=Enter number (1-%IDX%):
if "%PICK%"=="" ( echo No selection. & pause & exit /b )
call set "MAPFILE=%%FILE_%PICK%%%"
if "%MAPFILE%"=="" ( echo Invalid selection. & pause & exit /b )

echo.
echo ============================================
echo  SAP B1 UDV/FMS Import (DI API)
echo  Server    : %SERVER%
echo  Database  : %COMPANYDB%
echo  DBType    : %DBTYPE%
echo  B1 User   : %SAPUSER%
echo  MapFile   : !MAPFILE!
echo  Mode      : %MODE% (empty=real run)
echo ============================================
echo.
pause

REM Auto-select PowerShell arch to match installed DI API
set "PS64=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
set "PS32=%SystemRoot%\SysWOW64\WindowsPowerShell\v1.0\powershell.exe"
set "PFX64=%ProgramFiles%"
set "PFX86=%ProgramFiles(x86)%"
set "PS="
if exist "%PFX64%\SAP\SAP Business One DI API\" set "PS=%PS64%"
if defined PS goto :ps_found
if exist "%PFX86%\SAP\SAP Business One DI API\" set "PS=%PS32%"
if defined PS goto :ps_found
echo ERROR: DI API not detected.
echo   Looked in: %PFX64%\SAP\SAP Business One DI API\
echo   Looked in: %PFX86%\SAP\SAP Business One DI API\
pause
exit /b 2
:ps_found
echo Using PowerShell: %PS%

"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0Scripts\Import_UDV_DI.ps1" ^
    -Server "%SERVER%" ^
    -CompanyDB "%COMPANYDB%" ^
    -DBUser "%DBUSER%" ^
    -DBPassword "%DBPASSWORD%" ^
    -SapUser "%SAPUSER%" ^
    -SapPassword "%SAPPASSWORD%" ^
    -DBType "%DBTYPE%" ^
    -MapFile "!CFG!\!MAPFILE!" ^
    %MODE%

endlocal

echo.
echo ============================================
echo  Done. Check log: %~dp0Import_UDV_Log.txt
echo ============================================
pause
