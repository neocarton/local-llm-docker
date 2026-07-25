@echo off

call ../env.bat

:: ============================================================
:: llama-cpp-embedding
:: Embedding model server (CPU) - Text embeddings
:: ============================================================

set IMAGE=ghcr.io/ggml-org/llama.cpp:server
set CONTAINER_NAME=llama-cpp-embedding
set HOST_PORT=8081
set MODEL="/models/Qwen/Qwen3-Embedding-0.6B-GGUF/Qwen3-Embedding-0.6B-f16.gguf"

set MODELS_DIR=%LOCAL_LLM_DATA_BASE_DIR%/models
