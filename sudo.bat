@echo off
if "%1" == "" (
    echo No arguments provided
    echo Usage:
    
    echo    sudo /i - elevate cmd
    echo    sudo ^<command^> - runs command elevated
    timeout /t 5 > nul
    goto :eof
)

if "%1" == "executeSingularCommand" (
    goto collectArgs
)
if /I "%1"=="/i" (
    goto getAdmin
) else (
    if exist "%TEMP%\sudo-out.txt" (
        del /f "%TEMP%\sudo-out.txt"
    )
    PowerShell -Command "Start-Process cmd.exe -ArgumentList '/c cd /d \"%CD%\" && \"%~f0\" executeSingularCommand %*' -Verb RunAs"
)
:waitloop
    if exist "%TEMP%\sudo-out.txt" (
        type "%TEMP%\sudo-out.txt"
        del /f "%TEMP%\sudo-out.txt"
        goto :eof
    ) else (
        timeout /t 1 /nobreak >nul
        goto waitloop
    )

:getAdmin
    REM elevates CMD
    ECHO Requesting administrative privileges...
    PING -n 2 127.0.0.1 >NUL
    PowerShell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d \"%CD%\"' -Verb RunAs"
    EXIT

:hasArgs
    call %args% > "%TEMP%\sudo-out.txt"
    exit /B

:collectArgs
    shift
    if "%~1"=="" goto :hasArgs
    set args=%args% %~1
    goto collectArgs
