@echo off

call ../env.bat

setlocal enabledelayedexpansion

REM ===============================
REM Load environment variables
REM ===============================
set CONVERT_TO_GGUF=

REM ===============================
REM Parse command-line arguments
REM ===============================
:parse_args
if "%~1"=="" goto after_parse

if "%~1"=="--to-gguf" (
    set "CONVERT_TO_GGUF=true"
    shift
    goto parse_args
)
if "%~1"=="--model" (
    set "MODEL_NAME=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--file" (
    set "MODEL_FILE=%~2"
    shift
    shift
    goto parse_args
)
if "%~1"=="--help" (
    goto show_help
)
if "%~1"=="-h" (
    goto show_help
)
shift
goto parse_args

:after_parse

REM ===============================
REM Create folders with permissions
REM ===============================
if not exist "%LOCAL_LLM_DATA_BASE_DIR%/models" (
    mkdir "%LOCAL_LLM_DATA_BASE_DIR%/models"
)
if not exist "%LOCAL_LLM_DATA_BASE_DIR%/.hf_cache" (
    mkdir "%LOCAL_LLM_DATA_BASE_DIR%/.hf_cache"
)

REM ===============================
REM Build Docker image
REM ===============================
docker build -t model-hf-downloader ./model_hf_downloader

REM ===============================
REM Run Docker container
REM ===============================
docker run ^
    -v "%LOCAL_LLM_DATA_BASE_DIR%/models:/app/models" ^
    -v "%LOCAL_LLM_DATA_BASE_DIR%/.hf_cache:/tmp/hf_cache" ^
    -e MODEL_NAME="%MODEL_NAME%" ^
    -e MODEL_FILE="%MODEL_FILE%" ^
    -e HF_TOKEN="%HF_TOKEN%" ^
    -e HF_CACHE_DIR="/tmp/hf_cache" ^
    -e CONVERT_TO_GGUF="%CONVERT_TO_GGUF%" ^
    --rm ^
    model-hf-downloader
exit

REM ===============================
REM Help Section
REM ===============================
:show_help
type download_hf_model.md
exit
