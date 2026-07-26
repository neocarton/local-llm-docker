# Code-LLM Project

## Overview

This project aims to create a one-stop-shop solution for coding language models using either Ollama, Qdrant, and other necessary components.
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

1. Qdrant Dashboard:

   http://localhost:6333/dashboard


1. **Download Models**: Download the necessary models using the provided script.

    ```sh
    docker exec -it ollama ollama pull <MODEL>
    ```
    * Coding: qwen3.5:4b (Context: 256K, best match)
    * Embedding: nomic-embed-text

1. **Start Services**: Start the Docker containers for either Ollama and Qdrant.

    ```sh
    cd ollama
    ollama.bat
    ```

1. Signin Ollama for key

    ```sh
    docker exec -it ollama ollama signin
    ```

## Performance Tuning

1. Context size affect memory footprint, GPU % usage, and token output speed.

   To check GPU usage:

    ```sh
    docker exec -it ollama nvidia-smi
    docker exec -it ollama ps
    ```

## Troubleshooting

### Model request too large for system
- **Issue**: 

```commandline
"model request too large for system" requested="32.7 GiB" available="19.1 GiB" total="15.3 GiB" free="15.1 GiB" swap="4.0 GiB"
```

- **Cause**: If running in docker, it could be docker memory constants.
- **Solution**: Open memory limit constant, depending on OS is Windows or Linux solution is a bit different.

### System Hanging
- **Issue**: System hanging.
- **Cause**: Often due to out of resource.
- **Solution**: Control GPU, VRAM, CPU, RAM usages in 80% by changing context size, GPU layers, CPU threads.

### Qdrant Filesystem Check Error

- **Issue**: Filesystem check failed for storage path ./storage. Details: Unrecognized filesystem - cannot guarantee data safety.
- **Cause**: Qdrant requires a POSIX‑compatible filesystem. Mounting host folders from non‑POSIX filesystems (e.g., Windows, network share) can trigger this error.
- **Solution**: Use a Docker named volume instead of a host bind mount.

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

    For Ollama: Use `Modelfile` file to control model parameters.

### Others

Referring to NOTE.md for more:
- Embedding issues.
- CUDA Optimization.
- etc.
