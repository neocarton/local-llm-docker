@echo off
setlocal enabledelayedexpansion

call env.bat

echo Starting %CONTAINER_NAME%...
echo   Model: %MODEL%

docker run -d ^
    --gpus all ^
    --env NVIDIA_VISIBLE_DEVICES=all ^
    --volume "%MODELS_DIR%:/models:ro" ^
    --volume "%CHAT_TEMPLATES_DIR%:/chat-templates:ro" ^
    --publish %HOST_PORT%:8080 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE% ^
    --port 8080 ^
    --model %MODEL% ^
    --jinja ^
    --ctx-size 1048576 ^
    --flash-attn on ^
    --cache-type-k q4_0 ^
    --cache-type-v q4_0 ^
    --n-gpu-layers 10 ^
    --load-mode mmap ^
    --no-repack ^
    --n-cpu-moe 43 ^
    --metrics

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Llama.cpp API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
