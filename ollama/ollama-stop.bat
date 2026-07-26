@echo off
setlocal enabledelayedexpansion

call ollama-env.bat

echo Stopping %CONTAINER_NAME%...

docker stop %CONTAINER_NAME%

if %errorlevel% equ 0 (
    echo Stopped %CONTAINER_NAME%.
) else (
    echo Failed to stop container %CONTAINER_NAME%.
)
