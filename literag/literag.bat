@echo off
setlocal enabledelayedexpansion

call literag-env.bat

echo Starting %CONTAINER_NAME%...

docker run -d ^
    --env WORKING_DIR="/app/data/rag_storage" ^
    --env INPUT_DIR="/app/data/inputs" ^
    --env PROMPT_DIR="/app/data/prompts" ^
    --env PORT="%HOST_PORT%" ^
    --volume "%DATA_DIR%:/app/data" ^
    --volume "./.env:/app/.env" ^
    --publish %HOST_PORT%:9621 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE%

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo LiteRAG API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
