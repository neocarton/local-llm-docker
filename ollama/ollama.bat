@echo off
setlocal enabledelayedexpansion

call ollama-env.bat

echo Starting %CONTAINER_NAME%...

docker run -d ^
    --gpus all ^
    --env OLLAMA_KEEP_ALIVE=-1 ^
    --env OLLAMA_API_KEY=%OLLAMA_API_KEY% ^
    --env OLLAMA_CONTEXT_LENGTH=128000 ^
    --env OLLAMA_LOAD_TIMEOUT=3600 ^
    --env OLLAMA_DEBUG=0 ^
    --volume "%MODELS_DIR%:/root/.ollama/models" ^
    --volume "%CONFIG_DIR%:/root/.ollama/config" ^
    --publish %HOST_PORT%:11434 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE%

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Ollama API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
