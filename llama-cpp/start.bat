@echo off
setlocal enabledelayedexpansion

call env.bat

echo Starting %CONTAINER_NAME%...
echo   Model: %MODEL%

set "MODEL=/models/ISTA-DASLab/Qwen3.8-27B-GSQ-RCO-GGUF/Qwen3.8-27B-GSQ-RCO-IQ3_S-mtp.gguf"

docker run -d ^
    --gpus all ^
    --env NVIDIA_VISIBLE_DEVICES=all ^
    --env GGML_CUDA_DISABLE_GRAPHS=1 ^
    --volume "%MODELS_DIR%:/models:ro" ^
    --volume "%CHAT_TEMPLATES_DIR%:/chat-templates:ro" ^
    --volume "%KV_CACHE_DIR%:/.kv_cache" ^
    --publish %HOST_PORT%:8080 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE% ^
    --port 8080 ^
    --model "%MODEL%" ^
    --jinja ^
    --flash-attn on ^
    --cache-type-k q4_0 ^
    --cache-type-v q4_0 ^
    --swa-full ^
    --spec-type draft-mtp ^
    --spec-draft-n-max 2 ^
    --parallel 1 ^
    --batch-size 256 ^
    --ubatch-size 128 ^
    --n-gpu-layers auto ^
    --fit on ^
    --fit-target 512 ^
    --load-mode mmap ^
    --metrics

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Llama.cpp API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
