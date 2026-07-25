@echo off
setlocal enabledelayedexpansion

call llama-cpp-embed-env.bat

echo Starting %CONTAINER_NAME%...
echo   Model: %MODEL%

docker run -d ^
    --volume "%MODELS_DIR%:/models:ro" ^
    --publish %HOST_PORT%:8081 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE% ^
    --port 8081 ^
    --model %MODEL% ^
    --embeddings ^
    --pooling last ^
    --ubatch-size 8192 ^
    --ctx-size 32768 ^
    --metrics

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Llama.cpp Embedding API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
