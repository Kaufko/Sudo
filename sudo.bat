@echo off

set args=

if "%1" == "test" goto :hasAdmin

:getadmin
    REM elevates CMD
    ECHO Requesting administrative privileges...
    PING -n 2 127.0.0.1 >NUL
    PowerShell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d \"%CD%\" && \"%~f0\" test %*' -Verb RunAs"
    EXIT

:hasAdmin
    if "%2" == "" goto :noInput
    if not "%2" == "" goto :collectArgs

:noInput
    EXIT /B

:hasArgs
    call %args%
    exit /B

:collectArgs
    shift
    if "%~1"=="" goto :hasArgs
    set args=%args% %~1
    goto :collectArgs
