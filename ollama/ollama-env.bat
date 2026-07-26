@echo off

call ../env.bat

:: ============================================================
:: ollama
:: LLM inference server (Ollama) - Code completion / generation
:: ============================================================

set IMAGE=ollama/ollama:latest
set CONTAINER_NAME=ollama
set HOST_PORT=11434
set OLLAMA_API_KEY=nokey

set MODELS_DIR=%LOCAL_LLM_DATA_BASE_DIR%/models/ollama
set CONFIG_DIR=./config
