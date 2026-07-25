# Usage:

```commandline
download_hf_model.bat --model [MODEL_NAME] --file [MODEL_FILE] [--to-gguf]
```

## Arguments:

- `MODEL_NAME`: Hugging Face model name (e.g. SanctumAI/Mistral-7B-Instruct-v0.3-GGUF)
- `MODEL_FILE`: Hugging Face model file (e.g. mistral-7b-instruct-v0.3.Q4_K_M.gguf)
- `--to-gguf`: Convert downloaded model to GGUF format after download
- `--help`: Show this help message and exit

## Environment variables (from .env):

- `HF_TOKEN`: Your Hugging Face token

## Example:

```commandline
download_hf_model.bat --model "SanctumAI/Mistral-7B-Instruct-v0.3-GGUF" --file "mistral-7b-instruct-v0.3.Q4_K_M.gguf"
download_hf_model.bat --model "Qwen/Qwen2.5-Coder-7B-Instruct-GGUF" --file "qwen2.5-coder-7b-instruct-q4_k_m.gguf"
download_hf_model.bat --model "unsloth/Qwen3-Coder-30B-A3B-Instruct-GGUF" --file "Qwen3-Coder-30B-A3B-Instruct-Q4_K_M.gguf"
download_hf_model.bat --model "intfloat/multilingual-e5-base"
```
