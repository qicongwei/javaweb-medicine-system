@echo off
chcp 65001 >nul 2>&1
title MedicineSystem - Start
setlocal enabledelayedexpansion

echo ==========================================
echo   MedicineSystem - One-Click Start
echo ==========================================
echo.

REM 按自己的安装位置改这两行，或提前 set TOMCAT_HOME / JAVA_HOME
if not defined TOMCAT_HOME set "TOMCAT_HOME=C:\apache-tomcat-9.0"
if not defined JAVA_HOME  set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "URL=http://localhost:8080/"

REM === 1. Kill leftover processes ===
echo [1/5] Cleaning up leftover processes...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr "LISTENING" ^| findstr ":8080 :8009"') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 2 /nobreak >nul 2>&1
echo       Done
echo.

REM === 2. Check MySQL ===
echo [2/5] Checking MySQL...
netstat -ano 2>nul | findstr "LISTENING" | findstr ":3306" >nul 2>&1
if !errorlevel! equ 0 (
    echo       MySQL is running
) else (
    echo       Starting MySQL...
    net start MySQL80 >nul 2>&1
    if !errorlevel! neq 0 net start MySQL >nul 2>&1
    timeout /t 3 /nobreak >nul 2>&1
)
echo.

REM === 3. Clean JSP cache ===
echo [3/5] Cleaning JSP cache...
if exist "%TOMCAT_HOME%\work\Catalina\localhost\ROOT" (
    rmdir /s /q "%TOMCAT_HOME%\work\Catalina\localhost\ROOT" >nul 2>&1
)
echo       Done
echo.

REM === 4. Start Tomcat ===
echo [4/5] Starting Tomcat...
set "CATALINA_HOME=%TOMCAT_HOME%"
set "JAVA_HOME=%JAVA_HOME%"
set "JRE_HOME=%JAVA_HOME%"
set "PATH=%JAVA_HOME%\bin;%PATH%"

call "%TOMCAT_HOME%\bin\startup.bat" >nul 2>&1

echo       Waiting for server...
set "tries=0"
:waitloop
timeout /t 2 /nobreak >nul 2>&1
set /a tries+=1
for /f %%c in ('curl -s -o nul -w "%%{http_code}" "%URL%" 2^>nul') do set "code=%%c"
if "!code!"=="200" goto ready
if !tries! lss 15 goto waitloop

echo       [ERROR] Tomcat startup timeout!
echo       Check logs: %TOMCAT_HOME%\logs\
pause
exit /b 1

:ready
echo       Tomcat started (HTTP 200)
echo.

REM === 5. Open browser ===
echo [5/5] Opening browser...
start "" "%URL%"

echo.
echo ==========================================
echo   System is running!
echo ==========================================
echo   URL:        http://localhost:8080/
echo   Admin:      admin / admin123
echo   User:       12 / 123456
echo   Stop:       Run StopSystem.bat
echo ==========================================
echo.
pause
