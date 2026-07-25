@echo off

call ../env.bat

:: ============================================================
:: llama-cpp
:: LLM inference server (CUDA) - Code completion / generation
:: ============================================================

set IMAGE=ghcr.io/ggml-org/llama.cpp:server-cuda
set CONTAINER_NAME=llama-cpp
set HOST_PORT=8080
set MODEL="/models/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf"

set MODELS_DIR=%LOCAL_LLM_DATA_BASE_DIR%/models
set CHAT_TEMPLATES_DIR=./chat-templates
