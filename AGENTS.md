# AGENTS.md — local-llm-docker

Local LLM + embedding + vector DB + search running on Docker containers.

## Architecture

| Service | Container | Port | Role |
|---|---|---|---|
| llama-cpp | `llama-cpp` | 8080 | LLM inference (CUDA, MTP draft) |
| llama-cpp-embed | `llama-cpp-embedding` | 8081 | Embedding server (CPU) |
| ollama | `ollama` | 11434 | LLM inference (Ollama, CUDA) |
| qdrant | `qdrant` | 6333 | Vector DB (named volume) |
| searxng | `searxng` | 8888 | Web search |
| literag | `lightrag` | 9621 | RAG API + knowledge graphs |

**Default model:** `unsloth/Qwen3.6-35B-A3B-MTP-GGUF` (Q4_K_M, 256k ctx, 10 GPU layers).
Switch models by editing the corresponding `*-env.bat` file's `MODEL` variable, or the compose file.

## Quick Start

```bat
:: From repo root (uses .bin/ shortcuts):
bin\llama-cpp.bat          :: start LLM + SearXNG, tail logs
bin\llama-cpp-stop.bat     :: stop LLM + SearXNG
bin\llama-cpp-log.bat      :: attach to llama-cpp logs
bin\llama-cpp-embed.bat    :: start embedding + qdrant, tail logs
bin\llama-cpp-embed-stop.bat :: stop embedding + qdrant
bin\ollama.bat             :: start Ollama + SearXNG, tail logs
bin\ollama-stop.bat        :: stop Ollama + SearXNG
bin\ollama-log.bat         :: attach to ollama logs
bin\literag.bat            :: start LiteRAG (requires Ollama + Qdrant)
bin\literag-stop.bat       :: stop LiteRAG
bin\literag-log.bat        :: attach to LiteRAG logs

:: Download a model:
bin\download_hf_model.bat --model "org/model-name" --file "filename.gguf"
```

Each service also has its own `start.bat`, `stop.bat`, `log.bat` (or equivalent) inside its directory.

## Environment

Set `LOCAL_LLM_DATA_BASE_DIR` (default `.`) before starting anything. It controls where models, caches, and data live.

`.env` and `env.bat` contain the HF token and timezone — both are gitignored.

## Model Switching

Edit `llama-cpp-env.bat` (`MODEL` variable).

For embedding, edit `llama-cpp-embed-env.bat` (`MODEL` variable).

For LiteRAG, edit `literag-env.bat` — change `EMBEDDING_MODEL` and `LLM_MODEL` variables.

## Gotchas

- **Qdrant on non-POSIX filesystems** fails. Use Docker named volumes (the default `qdrant.bat` already does this).
- **Embedding model `Qwen3-Embedding-0.6B`** uses `pooling last`.
- HF downloads go to `%LOCAL_LLM_DATA_BASE_DIR%/models/<MODEL_NAME>/` per HuggingFace repo path.
