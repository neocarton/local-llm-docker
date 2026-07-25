# llama.cpp commands to run models

---

### unsloth/Qwen3.6-35B-A3B-MTP-GGUF

**unsloth/Qwen3.6-35B-A3B-MTP-GGUF** — Q4_K_M, 256k context, MTP draft

```
--port 8080
--model "/models/unsloth/Qwen3.6-35B-A3B-MTP-GGUF/Qwen3.6-35B-A3B-UD-Q4_K_M.gguf"
--flash-attn on
--parallel 1
--spec-type draft-mtp
--spec-draft-n-max 2
--ctx-size 256000
--n-gpu-layers 10
--metrics
```

### unsloth/Qwen3.6-27B-MTP-GGUF

**unsloth/Qwen3.6-27B-MTP-GGUF** — Q4_K_M, MTP draft

```
--port 8080
--model "/models/unsloth/Qwen3.6-27B-MTP-GGUF/Qwen3.6-27B-Q4_K_M.gguf"
--flash-attn on
--parallel 1
--spec-type draft-mtp
--spec-draft-n-max 2
--ctx-size 256000
--n-gpu-layers 10
--metrics
```

### Qwen3-8B

**Qwen/Qwen3-8B-GGUF** — Q5_K_M, Jinja chat template, DeepSeek reasoning

```
--port 8080
--model "/models/Qwen/Qwen3-8B-GGUF/Qwen3-8B-Q5_K_M.gguf"
--chat-template-file /chat-templates/qwen3_nonthinking.jinja
--jinja --reasoning-format deepseek
--ctx-size 40960
--no-context-shift
--no-warmup
--flash-attn on
--split-mode row
--n-gpu-layers 8
--threads 16
--metrics
```

### Qwen2.5-Coder-7B

**Qwen/Qwen2.5-Coder-7B-Instruct-GGUF** — Q4_K_M, chatml format

```
--port 8080
--model "/models/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/qwen2.5-coder-7b-instruct-q4_k_m.gguf"
--chat-template chatml
--ctx-size 64000
--n-gpu-layers 8
--threads 16
--metrics
```

### CompendiumLabs/bge-base-en-v1.5-gguf

**CompendiumLabs/bge-base-en-v1.5-gguf** — f16, default pooling

```
--port 8081
--model "/models/CompendiumLabs/bge-base-en-v1.5-gguf/bge-base-en-v1.5-f32.gguf"
--embeddings
--metrics
```

### Qwen3-Embedding-0.6B

**Qwen/Qwen3-Embedding-0.6B-GGUF** — f16, last pooling, 2048 dim
> Note: produces vector `[null]`

```
--model "/models/Qwen/Qwen3-Embedding-0.6B-GGUF/Qwen3-Embedding-0.6B-f16.gguf"
--embeddings
--pooling last
--ubatch-size 8192
--ctx-size 32768
--metrics
```

### jina-embeddings-v4

**jinaai/jina-embeddings-v4-text-code-GGUF** — IQ3_S, mean pooling, 2048 dim
> Note: can index but correctness uncertain

```
--model "/models/jinaai/jina-embeddings-v4-text-code-GGUF/jina-embeddings-v4-text-code-IQ3_S.gguf"
--embeddings
--pooling mean
--ubatch-size 8192
--ctx-size 4096
--metrics
```

### nomic-embed-text-v1.5

**nomic-ai/nomic-embed-text-v1.5-GGUF** — f16, lightweight and successful

```
--model "/models/nomic-ai/nomic-embed-text-v1.5-GGUF/nomic-embed-text-v1.5.f16.gguf"
--embeddings
--batch-size 2048
--ubatch-size 2048
--metrics
```
