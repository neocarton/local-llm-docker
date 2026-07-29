# llama.cpp commands to run models

---

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
