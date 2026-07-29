# Code-LLM Project

## Overview

This project aims to create a one-stop-shop solution for coding language models using either Llama.cpp, Qdrant, and other necessary components.
The goal is to provide a seamless environment where developers can interact with advanced AI models for coding assistance.

## Environment Configuration

The project requires specific environment configurations to ensure proper operation. The `env_linux` and `env_win`
directories contain the necessary configuration files.

### Linux Environment

The `env_linux/.env` file contains environment variables for Linux environments.

```env
LOCAL_LLM_DATA_BASE_DIR=<data-base-dir> 
HF_TOKEN=<huggingface-token>
```

### Windows Environment

The `env.bat` script sets up the environment variables for Windows environments.

```bat
@echo off
set LOCAL_LLM_DATA_BASE_DIR=<data-base-dir> 
set HF_TOKEN=<huggingface-token>
```

## How to Run It

To run the project, follow these steps:

1. **Download Models**: Download the necessary models using the provided script.

    ```
    download_hf_model.bat --model prism-ml/Ternary-Bonsai-27B-gguf --file Ternary-Bonsai-27B-Q2_0.gguf
    ```

   * Coding: Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/qwen2.5-coder-7b-instruct-q4_k_m.gguf
   * Embedding: CompendiumLabs/bge-base-en-v1.5-gguf/bge-base-en-v1.5-f32.gguf

2. **Start Services**: Start the Docker containers for either Llama.cpp and Qdrant.

    ```sh
    llama-cpp.bat
    ```

## Performance Tuning

1. Context size affect memory footprint, GPU % usage, and token output speed.

   To check GPU usage:

    ```sh
    docker exec -it llama-llm-code nvidia-smi
    ```

## Troubleshooting

### System Hanging
- **Issue**: System hanging.
- **Cause**: Often due to out of resource.
- **Solution**: Control GPU, VRAM, CPU, RAM usages in 80% by changing context size, GPU layers, CPU threads.

### RooCode Loops (?)

- **Issue**: RooCode loops and not moving forward.
- **Cause**: Incorrect context size.
- **Solution**: Ensure the model has the correct context size.

### Mouse Lag or RooCode Error

- **Issue**:
  - Mouse lagging.
  - RooCode Error:
    > This may indicate a failure in the model's thought process or inability to use a tool properly, which can be mitigated with some user guidance (e.g. "Try breaking down the task into smaller steps").
- **Cause**: Model response issues (empty string, null JSON, partial output).
- **Solution**: Check logs, potential VRAM issues. Limit VRAM by reducing GPU layers.

    For Llama.cpp: --ctx-size, --n-gpu-layers, --threads

### Others

Referring to NOTE.md for more:
- Embedding issues.
- CUDA Optimization.
- etc.
