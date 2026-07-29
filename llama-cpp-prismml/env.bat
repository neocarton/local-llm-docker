@echo off

call ../env.bat

:: ============================================================
:: llama-cpp
:: LLM inference server (CUDA) - Code completion / generation
:: ============================================================

set IMAGE=llama.cpp:prismml-server-cuda
set CONTAINER_NAME=llama-cpp-prismml
set HOST_PORT=8088
set MODEL="/models/prism-ml/Ternary-Bonsai-27B-gguf/Ternary-Bonsai-27B-Q2_0.gguf"

set MODELS_DIR=%LOCAL_LLM_DATA_BASE_DIR%/models
