# LightRAG (HKUDS) — Deployment Guide

> **Version:** 1.0  
> **Last Updated:** July 2026  
> **Repository:** [github.com/HKUDS/LightRAG](https://github.com/HKUDS/LightRAG)  
> **Prerequisites:** Docker, Docker Compose v2, Git

---

## Table of Contents

1. [Overview](#1-overview)
2. [Quick Start](#2-quick-start)
3. [Configuration](#3-configuration)
4. [API Reference](#4-api-reference)
5. [Security](#5-security)
6. [Operations](#6-operations)
7. [Known Limitations](#7-known-limitations)
8. [Troubleshooting](#8-troubleshooting)

---

## 1. Overview

**LightRAG** is a lightweight, knowledge-graph-based RAG framework that combines knowledge graphs (KGs) with vector embeddings. It offers a dual-layer architecture bridging traditional vector RAG and graph RAG.

- **Paper:** [EMNLP2025 — "LightRAG: Simple and Fast Retrieval-Augmented Generation"](https://arxiv.org/abs/2410.05779)
- **PyPI:** `lightrag-hku`
- **License:** MIT
- **Language:** Python 3.10+

### Key Features

- Entity-relation extraction with 5 query modes (naive/local/global/hybrid/mix)
- Multimodal support (RAG-Anything integration)
- Citation-aware retrieval
- Reranking (Cohere/Jina/Aliyun)
- Multiple storage backends (PostgreSQL, MongoDB, OpenSearch, Neo4j, Milvus, Qdrant)
- Built-in React WebUI
- Ollama-compatible API (for Open WebUI)
- Signed, security-hardened Docker images (CIS Docker Benchmark 4.1)

### Prerequisites

- Docker Engine (latest stable)
- Git
- 4 GB+ RAM (8 GB+ recommended)
- Internet connection for initial model downloads

---

## 2. Quick Start

### 2.1 Clone and Configure

```bash
# Clone the repository
git clone https://github.com/HKUDS/LightRAG.git
cd LightRAG

# Copy the environment template
cp env.example .env

# Edit .env with your LLM and embedding configuration
# See Section 3 for full variable reference
```

### 2.2 Interactive Setup (Optional)

LightRAG provides an interactive setup wizard:

```bash
make env-base           # Configure LLM, Embedding, Reranker
make env-storage        # Add storage backends (PostgreSQL, Neo4j, Milvus, etc.)
make env-server         # Configure ports, authentication, SSL
make env-security-check # Audit .env for security risks
```

Alternatively, edit `.env` manually.

### 2.5 Upload and Query Documents

```bash
# Upload a document
curl -X POST http://localhost:9621/documents/upload \
  -H "Authorization: Bearer ${LIGHTRAG_API_KEY}" \
  -F "file=@/path/to/your/document.pdf"

# List documents
curl http://localhost:9621/documents?page=1&page_size=20

# Query the knowledge base
curl -X POST http://localhost:9621/query \
  -H "Content-Type: application/json" \
  -H "X-API-Key: ${LIGHTRAG_API_KEY}" \
  -d '{"query": "What is this about?", "mode": "hybrid"}'
```

---

## 3. Configuration

### 3.1 Environment Variables

**Server Configuration:**
```bash
HOST="0.0.0.0"
PORT="9621"
WORKING_DIR="/app/data/rag_storage"
INPUT_DIR="/app/data/inputs"
PROMPT_DIR="/app/data/prompts"
```

**LLM Configuration:**
```bash
LLM_BINDING=openai|ollama|lollms
LLM_BINDING_HOST=http://localhost:11434  # Ollama default
LLM_MODEL=gpt-4o-mini
```

**Embedding Configuration:**
```bash
EMBEDDING_BINDING=openai|ollama
EMBEDDING_BINDING_HOST=http://localhost:11434
EMBEDDING_MODEL=nomic-embed-text
EMBEDDING_DIM=768
EMBEDDING_ASYMMETRIC=false
EMBEDDING_DOCUMENT_PREFIX=
EMBEDDING_QUERY_PREFIX=
```

**Advanced RAG:**
```bash
QUERY_MODE=mix                                    # local|global|hybrid|naive|mix
SUMMARY_LANGUAGE=Chinese|English
ENTITY_EXTRACTION_USE_JSON=true
ENABLE_CONTENT_HEADINGS=true
MAX_ENTITY_TOKENS=2048
MAX_RELATION_TOKENS=2048
MAX_TOTAL_TOKENS=8192
ENABLE_LLM_CACHE=true
VLM_PROCESS_ENABLE=true
VLM_LLM_MODEL=your-vlm-model
MAX_PARALLEL_INSERT=3
EMBEDDING_FUNC_MAX_ASYNC=16
EMBEDDING_BATCH_NUM=32
```

**Ollama-Compatible Prefixes (for `/api/chat`):**
`/local`, `/global`, `/hybrid`, `/naive`, `/mix`, `/bypass`, `/context`, `/localcontext`, `/globalcontext`, `/hybridcontext`, `/naivecontext`, `/mixcontext`

### 3.2 Port Reference

| Port | Service | Default? |
|------|---------|----------|
| **9621** | LightRAG Server (primary) | Yes |
| **8001** | vLLM Embedding (optional) | Optional |
| **8000** | vLLM Rerank (optional) | Optional |
| **5432** | PostgreSQL (optional) | Optional |
| **7687** | Neo4j (optional) | Optional |
| **9200** | OpenSearch (optional) | Optional |
| **6379** | Redis (optional) | Optional |
| **19530** | Milvus (optional) | Optional |
| **6333** | Qdrant (optional) | Optional |
| **3000** | Milvus Attu UI (optional) | Optional |

---

## 4. API Reference

All endpoints are at `http://localhost:9621` by default.

### 4.1 Authentication

Include one of these headers:

```
X-API-Key: your-api-key-here
Authorization: Bearer <jwt-token>
```

### 4.2 Health & Status

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Liveness probe + config info |
| `GET` | `/docs` | Swagger UI |
| `GET` | `/redoc` | ReDoc alternative |

### 4.3 Document Endpoints

| Method | Path | Description | Request Body |
|--------|------|-------------|--------------|
| `POST` | `/documents/insert` | Insert single text | `{"text": "...", "description": "optional"}` |
| `POST` | `/documents/insert_texts` | Batch insert texts | `{"texts": [...]}` |
| `POST` | `/documents/upload` | Upload file(s) | `multipart/form-data` |
| `POST` | `/documents/scan` | Scan input directory | Empty body |
| `GET` | `/documents` | List documents | Query: `page`, `page_size` |
| `DELETE` | `/documents/{id}` | Delete document | — |
| `DELETE` | `/documents/clear` | Clear all documents | Empty body |
| `POST` | `/documents/status` | Check processing status | `{"document_id": "..."}` |
| `POST` | `/documents/reprocess_failed` | Re-process failed documents | Empty body |
| `POST` | `/documents/cancel_pipeline` | Cancel pipeline | Empty body |

### 4.4 Query Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/query` | Text query with RAG |
| `POST` | `/query/stream` | Streaming query (SSE) |
| `POST` | `/query/with_citation` | Query with source citations |

**Query Modes:** `naive`, `local`, `global`, `hybrid`, `mix`

**Query Request Body:**
```json
{
  "query": "...",
  "mode": "hybrid",
  "top_k": 60,
  "only_need_context": false,
  "enable_rerank": true,
  "include_chunk_content": false
}
```

**Query Response:**
```json
{
  "result": "The generated answer...",
  "context": ["retrieved chunk 1", "retrieved chunk 2"],
  "references": [{"reference_id": 0, "file_path": "path/to/doc.pdf"}],
  "query": "original query",
  "mode": "hybrid"
}
```

### 4.5 Graph Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/graph` | Full knowledge graph |
| `GET` | `/graph/structure` | Graph statistics |
| `GET` | `/graph/entities` | List entities (query: `limit`) |
| `GET` | `/graph/relations` | List relations (query: `limit`) |
| `POST` | `/graph/entities/create` | Create new entity |
| `POST` | `/graph/relations/create` | Create new relation |
| `POST` | `/graph/entities/merge` | Merge two entities |
| `DELETE` | `/graph/entities/{id}` | Delete entity |
| `DELETE` | `/graph/relations/{id}` | Delete relation |

### 4.6 Ollama-Compatible Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/api/version` | Ollama version compatibility |
| `POST` | `/api/tags` | List available models |
| `POST` | `/api/chat` | Chat completion (RAG-enhanced) |
| `POST` | `/api/generate` | Text generation |
| `POST` | `/api/embeddings` | Embedding generation |

### 4.7 System Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/config` | Server configuration |
| `GET` | `/status` | System status and statistics |
| `GET` | `/workspace/info` | Workspace info |
| `POST` | `/cache/clear` | Clear internal cache |
| `POST` | `/token` | Login for JWT token |

### 4.8 Request/Response Examples

**Insert text:**
```bash
curl -X POST http://localhost:9621/documents/insert \
  -H "Content-Type: application/json" \
  -d '{"text": "LightRAG is a graph-based RAG system."}'
```

**Upload file:**
```bash
curl -X POST http://localhost:9621/documents/upload \
  -H "X-API-Key: mykey" \
  -F "file=@./document.pdf"
```

**Ollama-style chat:**
```bash
curl -X POST http://localhost:9621/api/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "lightrag:latest",
    "messages": [{"role": "user", "content": "What is RAG?"}],
    "stream": false
  }'
```

### 4.9 Concurrency & Rate Limits

| Parameter | Default | Description |
|-----------|---------|-------------|
| `MAX_ASYNC_LLM` | 4 | Max concurrent LLM requests |
| `MAX_PARALLEL_INSERT` | 3 | Max parallel file uploads |
| `MAX_ASYNC_RERANK` | 4 | Max concurrent rerank requests |
| `LLM_TIMEOUT` | 150s | LLM timeout (effective = 2x config) |
| `RERANK_TIMEOUT` | 30s | Rerank timeout |
| `MAX_UPLOAD_SIZE` | 100MB | Max file upload size |
| `WORKERS` | 1 | Gunicorn worker count |

*Note: No explicit rate limiting (requests-per-second) is implemented. Concurrency controls are the primary throttling mechanism.*

---

## 5. Security

### 5.1 API Key Authentication

Set in `.env`:
```bash
LIGHTRAG_API_KEY=your-secure-api-key-here
WHITELIST_PATHS=/health,/api/*
```

Include in requests: `X-API-Key: your-secure-api-key-here`

### 5.2 JWT Account-Based Authentication

Set in `.env`:
```bash
AUTH_ACCOUNTS='{"user1": "password1", "user2": "password2"}'
TOKEN_SECRET=your-jwt-secret
TOKEN_EXPIRE_HOURS=4
```

Login:
```bash
curl -X POST http://localhost:9621/token \
  -d "grant_type=password&username=admin&password=mypass"
```

Send JWT: `Authorization: Bearer <token>`

### 5.3 Security Notes

- **Default: no authentication** — every endpoint is public without auth configured
- **Health check and Ollama endpoints are whitelisted by default**
- Set `WHITELIST_PATHS=/health` to require auth on all endpoints
- Passwords can be plaintext or bcrypt-prefixed (`{bcrypt}...`)
- Generate bcrypt hashes: `lightrag-hash-password --username admin`
- A single request should send **either** `X-API-Key` **or** `Authorization: Bearer` — not both
- `.env` permissions should be `0600` or `0644`

---

## 6. Operations

### 6.1 Common Commands

```bash
# Start services
docker compose up -d

# View logs
docker compose logs -f lightrag

# Check status
docker compose ps

# Restart
docker compose restart

# Stop
docker compose down

# Stop and remove all data (clean slate)
docker compose down -v
```

### 6.2 Updating

```bash
# Pull latest images
docker compose pull

# Restart with new images
docker compose down
docker compose up -d
```

### 6.3 Startup Notes

- **Image starts as root** to fix volume ownership, then drops to uid 1000
- **First-time startup is slow** — model downloads can take 5–30 minutes
- **Memory pressure** — embedding + LLM + vector DB simultaneously can exhaust <8 GB machines
- **Port conflicts** — check availability of common ports (9621, 8000, 8001, etc.)
- **Data persistence** — volume mounts must be created before first run or they'll be owned by root (uid 0)

---

## 7. Known Limitations

| Issue | Severity | Details |
|-------|----------|---------|
| **Security by default** | High | Without `LIGHTRAG_API_KEY` or `AUTH_ACCOUNTS`, every endpoint is public. Configure auth before exposing on any network. |
| **Embedding model immutability** | High | Must be set before indexing. Changing it requires re-embedding ALL data. |
| **Storage migration** | High | PostgreSQL data formats are incompatible across major versions. |
| **Offline deployment limitations** | Medium | `transformers`, `torch`, `cuda` are NOT preinstalled. Only native docx parser with spaCy works offline. |
| **LLM timeout during extraction** | Medium | Slow models (< 50 tokens/sec) can timeout. Use `EXTRACT_LLM_TIMEOUT` to increase. Effective timeout = 2x configured value. |
| **Model stuck in output loop** | Medium | Some local Qwen models can enter endless-output loops. Re-processing usually resolves it. |
| **vLLM GPU requirements** | Medium | Requires NVIDIA Container Toolkit + CUDA drivers. CPU images are larger and slower. |
| **MINIO credentials** | Medium | Generated compose files require `MINIO_ACCESS_KEY_ID` and `MINIO_SECRET_ACCESS_KEY` at startup. |
| **.env permissions** | Low | Must be readable by uid 1000 (default `0644` works). |

---

## 8. Troubleshooting

### 8.1 Startup & Connection Issues

| Issue | Solution |
|-------|----------|
| `OutOfMemory` errors | Reduce memory limits in `deploy.resources.limits` |
| Slow first startup | Model download takes time; be patient on first run |
| Container exits immediately | Check logs with `docker compose logs lightrag --tail=50` |
| Port conflict on 9621 | Check with `lsof -i :9621`, change port in `.env` |

### 8.2 API Issues

| Issue | Solution |
|-------|----------|
| 401 Unauthorized | Verify `LIGHTRAG_API_KEY` is set in both `.env` and request headers |
| Query returns no results | Check indexed documents with `GET /documents`; try inserting test data |
| Upload fails | Check file size (max 100 MB default); verify `multipart/form-data` content type |
| Ollama endpoints return 500 | Verify LLM binding is configured correctly in `.env` |

### 8.3 Performance Issues

| Issue | Solution |
|-------|----------|
| High CPU usage | Reduce concurrency settings; check model speed |
| Slow query responses | Check model speed; enable `ENABLE_LLM_CACHE`; consider `naive` mode for speed |
| Disk space full | Clean up: `docker system prune`; check volume mounts |

### 8.4 Data Issues

| Issue | Solution |
|-------|----------|
| Documents not indexing | Check processing status: `POST /documents/status`; check `docker compose logs` |
| Embedding model changed, old data stale | Re-embedding required for ALL data — no automatic re-embedding tool exists |
| Storage migration issues | Plan major version upgrades carefully; test migration before production |

### 8.5 Diagnostic Commands

```bash
# Check all service status
docker compose ps

# View service logs
docker compose logs lightrag --tail=100

# Check health endpoint
curl http://localhost:9621/health

# Check system status
curl http://localhost:9621/status

# List indexed documents
curl http://localhost:9621/documents

# Check graph structure
curl http://localhost:9621/graph/structure

# Test with sample data
curl -X POST http://localhost:9621/documents/insert \
  -H "Content-Type: application/json" \
  -d '{"text": "This is a test document.", "description": "Test"}'

curl -X POST http://localhost:9621/query \
  -H "Content-Type: application/json" \
  -d '{"query": "test document", "mode": "naive"}'
```
