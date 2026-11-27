@echo off
chcp 65001 >nul 2>&1
title MedicineSystem - Stop
setlocal enabledelayedexpansion

echo ==========================================
echo   Stopping MedicineSystem...
echo ==========================================
echo.

if not defined TOMCAT_HOME set "TOMCAT_HOME=C:\apache-tomcat-9.0"
if not defined JAVA_HOME set "JAVA_HOME=C:\Program Files\Java\jdk-17"
set "PATH=%JAVA_HOME%\bin;%PATH%"

REM === 1. Graceful shutdown via catalina stop ===
echo [1/2] Sending stop command...
if exist "%TOMCAT_HOME%\bin\catalina.bat" (
    set "CATALINA_HOME=%TOMCAT_HOME%"
    set "JRE_HOME=%JAVA_HOME%"
    call "%TOMCAT_HOME%\bin\catalina.bat" stop -force >nul 2>&1
)

REM === 2. Force kill leftovers ===
echo [2/2] Cleaning up...
for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr "LISTENING" ^| findstr ":8080 :8009"') do (
    taskkill /F /PID %%a >nul 2>&1
)
timeout /t 2 /nobreak >nul 2>&1

echo.
echo System stopped.
echo.
pause
