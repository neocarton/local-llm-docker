@echo off

call ../env.bat

:: ============================================================
:: llama-cpp
:: LLM inference server (CUDA) - Code completion / generation
:: ============================================================

set IMAGE=ghcr.io/ggml-org/llama.cpp:server-cuda
set CONTAINER_NAME=llama-cpp
set HOST_PORT=8080
set MODEL="/models/ISTA-DASLab/Qwen3.8-27B-GSQ-RCO-GGUF/Qwen3.8-27B-GSQ-RCO-IQ3_S-mtp.gguf"

set MODELS_DIR=%LOCAL_LLM_DATA_BASE_DIR%/models
set CHAT_TEMPLATES_DIR=./chat-templates
set KV_CACHE_DIR=%LOCAL_LLM_DATA_BASE_DIR%/.kv_cache
