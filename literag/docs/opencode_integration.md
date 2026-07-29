# LiteRAG + OpenCode Integration Guide

> **Version:** 1.0  
> **Last Updated:** July 18, 2026  
> **Prerequisites:** OpenCode installed, LiteRAG deployed (see [LiteRAG Docker Compose Guide](deployment_docker_compose.md))

---

## Table of Contents

1. [Overview](#1-overview)
2. [Integration Architecture](#2-integration-architecture)
3. [Method 1: MCP Server (Recommended)](#3-method-1-mcp-server-recommended)
4. [Method 2: Custom Tools](#4-method-2-custom-tools)
5. [Method 3: Skills](#5-method-3-skills)
6. [Method 4: Agents](#6-method-4-agents)
7. [Method 5: Commands](#7-method-5-commands)
8. [Method 6: Plugins](#8-method-6-plugins)
9. [Complete Project Setup](#9-complete-project-setup)
10. [API Reference](#10-api-reference)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Overview

This guide shows **five methods** to integrate LiteRAG (specifically [HKUDS/LightRAG](https://github.com/HKUDS/LightRAG)) with OpenCode, ordered by recommendation:

| Method | Difficulty | Best For | What It Does |
|--------|-----------|----------|--------------|
| **MCP Server** | Easy | Plug-and-play tools | Adds 30 LiteRAG tools directly to OpenCode's tool palette |
| **Custom Tools** | Medium | Tailored integrations | Define exactly which LiteRAG endpoints OpenCode can call |
| **Skills** | Easy | Guided workflows | Teach OpenCode *how* and *when* to use LiteRAG |
| **Agents** | Easy | Dedicated RAG assistants | Create LiteRAG-specific agents with custom permissions |
| **Commands** | Easy | One-shot operations | Predefined commands for common RAG tasks |
| **Plugins** | Advanced | Deep customization | Intercept, modify, and extend OpenCode's behavior |

You can combine **any** of these methods. The recommended production setup uses **MCP Server + Skills + Agents**.

---

## 2. Integration Architecture

```
┌──────────────────────────────────────────────────────────────────┐
│                        OpenCode                                  │
│                                                                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────────┐ │
│  │  Agents  │  │  Skills  │  │ Commands │  │   Custom Tools  │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┬────────┘ │
│       │              │             │                 │          │
│  ┌────▼─────────────▼─────────────▼─────────────────▼───────┐  │
│  │                    LLM Conversation Loop                  │  │
│  └──────────────────────────┬───────────────────────────────┘  │
│                             │                                   │
│  ┌──────────────────────────▼───────────────────────────────┐  │
│  │                   Tool Execution Layer                    │  │
│  └──────┬──────────────┬──────────────┬─────────────────────┘  │
│         │              │              │                         │
│  ┌──────▼──────┐ ┌─────▼─────┐ ┌─────▼────────────┐           │
│  │ MCP Server  │ │Custom Tool│ │  Plugin Hooks    │           │
│  │ (lightrag)  │ │  (REST)   │ │  (Lifecycle)     │           │
│  └──────┬──────┘ └─────┬─────┘ └─────┬────────────┘           │
│         │               │              │                        │
│         └──────────┬────┴──────────────┘                      │
│                    │                                           │
└────────────────────┼───────────────────────────────────────────┘
                     │  HTTP REST API (port 9621)
                     ▼
┌──────────────────────────────────────────────────────────────────┐
│                       LightRAG Server                           │
│                                                                  │
│  /documents/*   │  /query/*     │  /graph/*     │  /api/*       │
│  (CRUD)         │  (Search)     │  (Graph Ops)  │  (Ollama)     │
│                                                                  │
│  ┌─────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐ │
│  │Postgres │  │ Neo4j    │  │ Milvus   │  │ Qdrant / Redis   │ │
│  │(KG+KV)  │  │(Graph)   │  │(Vectors) │  │(Optional)        │ │
│  └─────────┘  └──────────┘  └──────────┘  └──────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 3. Method 1: MCP Server (Recommended)

The **MCP Server** approach adds LiteRAG as a set of tools directly available in OpenCode. The community [lightragmcp](https://github.com/lalitsuryan/lightragmcp) project provides **30 fully working tools** via `npx`.

### 3.1 Prerequisites

- LiteRAG server running on `http://localhost:9621` (see Docker Compose guide)
- API key set in LiteRAG's `.env`: `LIGHTRAG_API_KEY=your-key`

### 3.2 Configuration

Add this to your OpenCode `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "lightrag": {
      "type": "local",
      "command": ["npx", "-y", "@g99/lightrag-mcp-server"],
      "enabled": true,
      "env": {
        "LIGHTRAG_SERVER_URL": "http://localhost:9621",
        "LIGHTRAG_API_KEY": "your-api-key-here"
      },
      "timeout": 30000
    }
  }
}
```

**For a remote LiteRAG server:**

```json
{
  "mcp": {
    "lightrag": {
      "type": "remote",
      "url": "https://your-lightrag-server.example.com/mcp",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer {env:LIGHTRAG_API_KEY}"
      },
      "timeout": 30000
    }
  }
}
```

### 3.3 Available MCP Tools

The `@g99/lightrag-mcp-server` package provides **30 tools** grouped into four categories:

#### Document Management (10 tools)

| Tool | Description |
|------|-------------|
| `lightragmcp_insert_text` | Insert a single text document |
| `lightragmcp_insert_texts` | Batch insert multiple texts |
| `lightragmcp_upload_document` | Upload a file (PDF, TXT, DOCX, etc.) |
| `lightragmcp_upload_documents` | Batch upload multiple files |
| `lightragmcp_scan_documents` | Scan input directory for new files |
| `lightragmcp_get_documents` | Retrieve all documents |
| `lightragmcp_get_documents_paginated` | Paginated document listing |
| `lightragmcp_delete_document` | Delete a document by ID |
| `lightragmcp_clear_documents` | Clear all documents |
| `lightragmcp_document_status` | Check processing status |

#### Query Tools (3 tools)

| Tool | Description |
|------|-------------|
| `lightragmcp_query_text` | Query with text (5 modes) |
| `lightragmcp_query_text_stream` | Streaming query response |
| `lightragmcp_query_with_citation` | Query with source citations |

#### Knowledge Graph Tools (8 tools)

| Tool | Description |
|------|-------------|
| `lightragmcp_get_knowledge_graph` | Retrieve full knowledge graph |
| `lightragmcp_get_graph_structure` | Get graph statistics |
| `lightragmcp_get_entities` | List all entities |
| `lightragmcp_get_relations` | List all relations |
| `lightragmcp_check_entity_exists` | Check entity existence |
| `lightragmcp_update_entity` | Update entity properties |
| `lightragmcp_delete_entity` | Delete an entity |
| `lightragmcp_delete_relation` | Delete a relation |

#### System Management (5 tools)

| Tool | Description |
|------|-------------|
| `lightragmcp_get_health` | Health check |
| `lightragmcp_get_status` | Detailed system status |
| `lightragmcp_clear_cache` | Clear internal cache |
| `lightragmcp_get_config` | Get server config |
| `lightragmcp_get_workspace_info` | Get workspace info |

### 3.4 Query Modes

LightRAG supports five query modes, available on the `query_text` tools:

| Mode | Behavior | Use Case |
|------|----------|----------|
| `naive` | Simple vector similarity | Quick lookups, no graph |
| `local` | Local context + nearby entities | Focused questions |
| `global` | Global graph understanding | Big-picture questions |
| `hybrid` | Local + global combined (default) | Most use cases |
| `mix` | Advanced graph + vector mix | Complex multi-step reasoning |

### 3.5 Example Usage

After configuration, OpenCode agents can use LiteRAG tools directly:

```
User: Search my knowledge base for information about Docker deployment

Agent: [Calls lightragmcp_query_text with query="Docker deployment", mode="hybrid"]
User: I found 3 relevant documents about Docker Compose configuration...
```

### 3.6 Troubleshooting MCP

```bash
# Check if the MCP server is running
opencode mcp list

# Authenticate if using OAuth
opencode mcp auth lightrag

# Debug connection issues
opencode mcp debug lightrag
```

---

## 4. Method 2: Custom Tools

For a **lighter-weight** integration or when you want to control exactly which endpoints are exposed, create custom tools as TypeScript files.

### 4.1 Directory Structure

```
your-project/
└── .opencode/
    └── tools/
        ├── literag-query.ts
        ├── literag-insert.ts
        ├── literag-documents.ts
        └── literag-graph.ts
```

### 4.2 Query Tool

```ts
// .opencode/tools/literag-query.ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Search the LiteRAG knowledge base. Supports 5 modes: naive, local, global, hybrid, mix",
  args: {
    query: tool.schema.string().describe("The search query"),
    mode: tool.schema
      .string()
      .enum(["naive", "local", "global", "hybrid", "mix"])
      .optional()
      .describe("Query mode (default: hybrid)"),
    topK: tool.schema
      .number()
      .optional()
      .describe("Number of top results to retrieve (default: 60)"),
  },
  async execute(args, context) {
    const serverUrl = process.env.LITERAG_SERVER_URL || "http://localhost:9621"
    const apiKey = process.env.LITERAG_API_KEY

    const headers: Record<string, string> = { "Content-Type": "application/json" }
    if (apiKey) headers["X-API-Key"] = apiKey

    const response = await fetch(`${serverUrl}/query`, {
      method: "POST",
      headers,
      body: JSON.stringify({
        query: args.query,
        mode: args.mode || "hybrid",
        top_k: args.topK || 60,
      }),
    })

    if (!response.ok) {
      throw new Error(`LiteRAG query failed: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    return JSON.stringify(data, null, 2)
  },
})
```

### 4.3 Insert Text Tool

```ts
// .opencode/tools/literag-insert.ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Insert text content into the LiteRAG knowledge base",
  args: {
    text: tool.schema.string().describe("The text content to insert"),
    description: tool.schema.string().optional().describe("Optional description"),
  },
  async execute(args, context) {
    const serverUrl = process.env.LITERAG_SERVER_URL || "http://localhost:9621"
    const apiKey = process.env.LITERAG_API_KEY

    const headers: Record<string, string> = { "Content-Type": "application/json" }
    if (apiKey) headers["X-API-Key"] = apiKey

    const response = await fetch(`${serverUrl}/documents/insert`, {
      method: "POST",
      headers,
      body: JSON.stringify({ text: args.text, description: args.description }),
    })

    if (!response.ok) {
      throw new Error(`LiteRAG insert failed: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    return JSON.stringify(data, null, 2)
  },
})
```

### 4.4 Document Management Tool

```ts
// .opencode/tools/literag-documents.ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Manage LiteRAG documents: list, delete, or check status",
  args: {
    action: tool.schema
      .string()
      .enum(["list", "delete", "status"])
      .describe("Action to perform"),
    documentId: tool.schema.string().optional().describe("Document ID (for delete/status)"),
    page: tool.schema.number().optional().describe("Page number (for list)"),
    pageSize: tool.schema.number().optional().describe("Page size (for list)"),
  },
  async execute(args, context) {
    const serverUrl = process.env.LITERAG_SERVER_URL || "http://localhost:9621"
    const apiKey = process.env.LITERAG_API_KEY

    const headers: Record<string, string> = { "Content-Type": "application/json" }
    if (apiKey) headers["X-API-Key"] = apiKey

    let response: Response

    switch (args.action) {
      case "list":
        response = await fetch(
          `${serverUrl}/documents?page=${args.page || 1}&page_size=${args.pageSize || 20}`,
          { headers }
        )
        break
      case "delete":
        if (!args.documentId) throw new Error("documentId is required for delete")
        response = await fetch(`${serverUrl}/documents/${args.documentId}`, {
          method: "DELETE",
          headers,
        })
        break
      case "status":
        const url = args.documentId
          ? `${serverUrl}/documents/status?document_id=${args.documentId}`
          : `${serverUrl}/documents/status`
        response = await fetch(url, { method: "POST", headers })
        break
      default:
        throw new Error(`Unknown action: ${args.action}`)
    }

    if (!response.ok) {
      throw new Error(`LiteRAG document action failed: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    return JSON.stringify(data, null, 2)
  },
})
```

### 4.5 Knowledge Graph Tool

```ts
// .opencode/tools/literag-graph.ts
import { tool } from "@opencode-ai/plugin"

export default tool({
  description: "Query the LiteRAG knowledge graph: get graph, entities, or relations",
  args: {
    action: tool.schema
      .string()
      .enum(["graph", "structure", "entities", "relations"])
      .describe("Graph operation to perform"),
    limit: tool.schema.number().optional().describe("Max results (for entities/relations)"),
  },
  async execute(args, context) {
    const serverUrl = process.env.LITERAG_SERVER_URL || "http://localhost:9621"
    const apiKey = process.env.LITERAG_API_KEY

    const headers: Record<string, string> = {}
    if (apiKey) headers["X-API-Key"] = apiKey

    let response: Response

    switch (args.action) {
      case "graph":
        response = await fetch(`${serverUrl}/graph`, { headers })
        break
      case "structure":
        response = await fetch(`${serverUrl}/graph/structure`, { headers })
        break
      case "entities":
        response = await fetch(
          `${serverUrl}/graph/entities?limit=${args.limit || 100}`,
          { headers }
        )
        break
      case "relations":
        response = await fetch(
          `${serverUrl}/graph/relations?limit=${args.limit || 100}`,
          { headers }
        )
        break
      default:
        throw new Error(`Unknown graph action: ${args.action}`)
    }

    if (!response.ok) {
      throw new Error(`LiteRAG graph action failed: ${response.status} ${response.statusText}`)
    }

    const data = await response.json()
    return JSON.stringify(data, null, 2)
  },
})
```

### 4.6 Environment Variables

Set these in `opencode.json` or your shell:

```json
{
  "mcp": {
    "lightrag-env": {
      "type": "local",
      "command": ["echo", "placeholder"],
      "env": {
        "LITERAG_SERVER_URL": "http://localhost:9621",
        "LITERAG_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

Or set them in your shell before launching OpenCode:

```bash
export LITERAG_SERVER_URL=http://localhost:9621
export LITERAG_API_KEY=your-api-key
opencode
```

---

## 5. Method 3: Skills

Skills teach OpenCode agents **when and how** to use LiteRAG. They don't add tools — they guide the agent's behavior.

### 5.1 Directory Structure

```
your-project/
└── .opencode/
    └── skills/
        └── literag/
            └── SKILL.md
```

### 5.2 Skill File

```markdown
---
name: literag
description: Query the LiteRAG knowledge base for answers from your indexed documents. Use when the user asks questions that require looking up information from a knowledge base, searching indexed documents, or retrieving context from RAG.
---

# LiteRAG Knowledge Retrieval

## When to Use

Use this skill when the user asks questions that may be answered by:
- Searching indexed documents
- Looking up information in the knowledge base
- Retrieving context from RAG (Retrieval-Augmented Generation)
- Checking facts against stored knowledge
- Finding information about code, architecture, or project documentation

Do NOT use this for:
- Questions about general programming knowledge (use web search instead)
- Questions about the current codebase files (use file tools)
- Simple factual questions answerable from context

## How to Use

### Step 1: Check LiteRAG is Available

First, check if the LiteRAG MCP tools are available. Look for tools starting with `lightragmcp_` in the available tools list.

### Step 2: Query LiteRAG

Call the LiteRAG query tool with an appropriate mode:

**For focused, specific questions:**
```
Tool: lightragmcp_query_text
Args: { "query": "exact question", "mode": "local", "topK": 10 }
```

**For big-picture, general questions:**
```
Tool: lightragmcp_query_text
Args: { "query": "high-level topic", "mode": "global", "topK": 20 }
```

**For most questions (recommended default):**
```
Tool: lightragmcp_query_text
Args: { "query": "natural question", "mode": "hybrid", "topK": 60 }
```

**For complex multi-part questions:**
```
Tool: lightragmcp_query_text
Args: { "query": "detailed question", "mode": "mix", "topK": 80 }
```

### Step 3: Interpret Results

The query returns relevant text chunks with context. Use this context to form your answer. Always cite sources when available.

### Step 4: Handle Missing Information

If LiteRAG returns no results or irrelevant results:
1. Check if any documents are indexed: `lightragmcp_get_documents`
2. Suggest the user add relevant documents first
3. Fall back to web search or general knowledge

## Query Modes Reference

| Mode | Best For |
|------|----------|
| `naive` | Quick single-fact lookups |
| `local` | Questions about specific documents or sections |
| `global` | Questions about the overall knowledge base |
| `hybrid` | Most questions (combines local + global) |
| `mix` | Complex multi-step reasoning questions |

## Document Management

### Adding Documents

```
Tool: lightragmcp_insert_text
Args: { "text": "content to index", "description": "optional description" }
```

```
Tool: lightragmcp_upload_document
Args: { "file_path": "/absolute/path/to/document.pdf" }
```

### Listing Documents

```
Tool: lightragmcp_get_documents_paginated
Args: { "page": 1, "page_size": 20 }
```

### Checking Status

```
Tool: lightragmcp_document_status
Args: { "document_id": "doc_123" }
```

## Examples

**User:** "What does the architecture doc say about the authentication flow?"
**Agent:** [Calls `lightragmcp_query_text` with mode="local", query="authentication flow"]
**Agent:** [Synthesizes answer from returned chunks, cites source documents]

**User:** "Summarize what the knowledge base knows about Docker deployment"
**Agent:** [Calls `lightragmcp_query_text` with mode="global", query="Docker deployment"]
**Agent:** [Creates comprehensive summary from multiple retrieved chunks]

**User:** "How do I deploy LiteRAG?"
**Agent:** [Calls `lightragmcp_query_text` with mode="hybrid", query="LiteRAG Docker Compose deployment"]
**Agent:** [Synthesizes answer with citations]
```

### 5.3 Install the Skill

```bash
mkdir -p .opencode/skills/literag
cp SKILL.md .opencode/skills/literag/SKILL.md
```

### 5.4 Skill Permissions

Optionally restrict skill access in `opencode.json`:

```json
{
  "permission": {
    "skill": {
      "literag": "allow"
    }
  }
}
```

---

## 6. Method 4: Agents

Create a LiteRAG-specific agent with tailored permissions and prompts.

### 6.1 Agent File

```markdown
.opencode/agents/literag-retriever.md
---
description: Retrieves answers from the LiteRAG knowledge base. Use for knowledge-base questions, document search, and RAG-based queries. Can only query and manage LiteRAG — cannot edit files or run shell commands.
mode: subagent
permission:
  webfetch: allow
  bash: deny
  edit: deny
  read: deny
  glob: deny
  grep: deny
  task: deny
  todowrite: deny
steps: 5
---

You are a LiteRAG knowledge retrieval specialist. Your job is to answer questions by querying the LiteRAG knowledge base.

## Rules

1. Always query LiteRAG before falling back to general knowledge
2. Cite source documents when returning answers
3. Use the most appropriate query mode for the question type
4. If LiteRAG returns no results, inform the user and suggest adding documents

## Query Strategy

- **Specific factual questions** → mode="local", topK=10
- **General overview questions** → mode="global", topK=20
- **Most questions** → mode="hybrid", topK=60
- **Complex multi-part questions** → mode="mix", topK=80

## Available LiteRAG Tools

- `lightragmcp_query_text` — Search the knowledge base
- `lightragmcp_query_with_citation` — Query with source citations
- `lightragmcp_get_documents` — List indexed documents
- `lightragmcp_get_entities` — List knowledge graph entities
- `lightragmcp_get_graph_structure` — Get graph statistics

## Response Format

When answering, format your response as:

### Answer
[Your synthesized answer based on retrieved context]

### Sources
- [Source Document 1] — Relevant excerpt
- [Source Document 2] — Relevant excerpt

If no relevant context was found, say:
"No relevant information found in the knowledge base. Consider adding relevant documents."
```

### 6.2 Using the Agent

In OpenCode, reference the agent in conversations:

```
@literag-retriever What does the knowledge base say about Docker Compose deployment?
```

Or set as default for a session via the agent selector.

---

## 7. Method 5: Commands

Predefined commands for common LiteRAG operations.

### 7.1 Command Files

```bash
mkdir -p .opencode/commands
```

### 7.2 Search Command

```markdown
.opencode/commands/literag-search.md
---
description: Search the LiteRAG knowledge base for information
agent: build
---

Search the LiteRAG knowledge base using the query tool.

Use $ARGUMENTS as the search query. Default to hybrid mode unless the question is clearly about a specific document (use local mode) or is a big-picture question (use global mode).

Execute the following tool call:
lightragmcp_query_text with arguments: { "query": "$ARGUMENTS", "mode": "hybrid", "topK": 60 }

Summarize the results in your own words and cite any source documents.
```

### 7.3 Ingest Command

```markdown
.opencode/commands/literag-ingest.md
---
description: Add documents or text to the LiteRAG knowledge base
agent: build
---

Ingest content into the LiteRAG knowledge base.

If $ARGUMENTS is a file path, use:
  lightragmcp_upload_document with { "file_path": "$ARGUMENTS" }

If $ARGUMENTS is plain text, use:
  lightragmcp_insert_text with { "text": "$ARGUMENTS" }

If $ARGUMENTS is multiple file paths separated by spaces, use:
  lightragmcp_upload_documents with { "file_paths": [...] }

Report the result to the user.
```

### 7.4 Graph Command

```markdown
.opencode/commands/literag-graph.md
---
description: Explore the LiteRAG knowledge graph structure and entities
agent: build
---

Explore the LiteRAG knowledge graph.

First, get the graph structure:
  lightragmcp_get_graph_structure with {}

Then list entities:
  lightragmcp_get_entities with { "limit": 50 }

Then list relations:
  lightragmcp_get_relations with { "limit": 50 }

Present a summary of the graph structure, most connected entities, and key relationships.
```

### 7.5 Using Commands

In OpenCode, use the command palette or type `/literag-search` followed by your query.

---

## 8. Method 6: Plugins

For advanced users who want to **automatically invoke LiteRAG** during conversations, or **modify the system prompt** to always include LiteRAG context.

### 8.1 Plugin: Auto-Query LiteRAG on Questions

```ts
// .opencode/plugins/literag-auto-query.ts
import { tool } from "@opencode-ai/plugin"

export default async ({ client, project, directory, $ }) => {
  return {
    "experimental.chat.system.transform": async (input, output) => {
      // Add LiteRAG awareness to the system prompt
      output.system.push(`
## LiteRAG Knowledge Base

This project has a LiteRAG knowledge base indexed and available via the "lightragmcp_query_text" tool.

When the user asks questions that may be answered by stored documents:
1. Query LiteRAG first using lightragmcp_query_text
2. Use the retrieved context to answer
3. Cite source documents

Default query mode: hybrid. For specific document questions, use mode: "local".
For big-picture questions, use mode: "global".
      `)
    },

    "tool.execute.before": async (input, output) => {
      // Log LiteRAG tool usage
      if (typeof input.tool === "string" && input.tool.startsWith("lightragmcp_")) {
        console.log(`[LiteRAG] Tool called: ${input.tool} with args:`, JSON.stringify(input.args, null, 2))
      }
    },
  }
}
```

### 8.2 Plugin: Register a Custom LiteRAG Tool

```ts
// .opencode/plugins/literag-tool.ts
import { tool } from "@opencode-ai/plugin"

export default async ({ client, project, directory, $ }) => {
  return {
    tool: {
      literag: tool({
        description:
          "Query the LiteRAG knowledge base with an intelligent mode selector. Automatically picks the best query mode based on the question type.",
        args: {
          query: tool.schema.string().describe("The question or search query"),
        },
        async execute(args) {
          const serverUrl = process.env.LITERAG_SERVER_URL || "http://localhost:9621"
          const apiKey = process.env.LITERAG_API_KEY

          // Smart mode selection based on query analysis
          const q = args.query.toLowerCase()
          let mode: "naive" | "local" | "global" | "hybrid" | "mix" = "hybrid"

          if (q.includes("specific") || q.includes("particular") || q.includes("about this") || q.includes("in the doc")) {
            mode = "local"
          } else if (q.includes("overview") || q.includes("summary") || q.includes("general") || q.includes("everything")) {
            mode = "global"
          } else if (q.includes("how") || q.includes("compare") || q.includes("relationship") || q.includes("vs")) {
            mode = "mix"
          }

          const headers: Record<string, string> = { "Content-Type": "application/json" }
          if (apiKey) headers["X-API-Key"] = apiKey

          const response = await fetch(`${serverUrl}/query`, {
            method: "POST",
            headers,
            body: JSON.stringify({ query: args.query, mode, top_k: 60 }),
          })

          if (!response.ok) {
            throw new Error(`LiteRAG failed: ${response.status} ${response.statusText}`)
          }

          const data = await response.json()
          return `Mode: ${mode}\n${JSON.stringify(data, null, 2)}`
        },
      }),
    },
  }
}
```

### 8.3 Register the Plugin

Add to `opencode.json`:

```json
{
  "plugin": ["./plugins/literag-auto-query.ts", "./plugins/literag-tool.ts"]
}
```

---

## 9. Complete Project Setup

Here is a **complete, ready-to-use project setup** combining all methods for a production-quality integration.

### 9.1 `opencode.json`

```json
{
  "$schema": "https://opencode.ai/config.json",
  "mcp": {
    "lightrag": {
      "type": "local",
      "command": ["npx", "-y", "@g99/lightrag-mcp-server"],
      "enabled": true,
      "env": {
        "LIGHTRAG_SERVER_URL": "http://localhost:9621",
        "LIGHTRAG_API_KEY": "your-api-key-here"
      },
      "timeout": 30000
    }
  },
  "plugin": ["./plugins/literag-auto-query.ts"],
  "permission": {
    "skill": {
      "literag": "allow"
    }
  },
  "agent": {
    "literag-retriever": {
      "description": "LiteRAG knowledge retrieval specialist. Queries the knowledge base and returns cited answers.",
      "mode": "subagent",
      "permission": {
        "edit": "deny",
        "bash": "deny",
        "read": "deny",
        "webfetch": "allow"
      },
      "steps": 5
    }
  }
}
```

### 9.2 Directory Structure

```
your-project/
├── opencode.json
├── .env                              # LITERAG_SERVER_URL, LITERAG_API_KEY
├── .opencode/
│   ├── agents/
│   │   └── literag-retriever.md
│   ├── skills/
│   │   └── literag/
│   │       └── SKILL.md
│   ├── commands/
│   │   ├── literag-search.md
│   │   ├── literag-ingest.md
│   │   └── literag-graph.md
│   ├── plugins/
│   │   └── literag-auto-query.ts
│   └── tools/
│       ├── literag-query.ts
│       ├── literag-insert.ts
│       ├── literag-documents.ts
│       └── literag-graph.ts
└── README.md
```

### 9.3 `.env` (Optional — for tool references)

```bash
LITERAG_SERVER_URL=http://localhost:9621
LITERAG_API_KEY=your-api-key-here
```

### 9.4 Installation Steps

```bash
# 1. Deploy LiteRAG (see Docker Compose guide)
git clone https://github.com/HKUDS/LightRAG.git && cd LightRAG
cp env.example .env
# Edit .env with your LLM/embedding config
make env-base
docker compose up -d

# 2. Set up OpenCode integration
cd your-project

# 3. Create directory structure
mkdir -p .opencode/{agents,skills/literag,commands,plugins,tools}

# 4. Create all files (opencode.json, SKILL.md, agent, tools, etc.)

# 5. Restart OpenCode to load the new configuration
```

---

## 10. API Reference

### 10.1 LiteRAG REST API Endpoints

All endpoints are at `http://localhost:9621` by default.

#### Authentication

Include one of these headers:

```
X-API-Key: your-api-key-here
Authorization: Bearer <jwt-token>
```

#### Document Endpoints

| Method | Path | Body | Description |
|--------|------|------|-------------|
| `POST` | `/documents/insert` | `{ "text": "..." }` | Insert single text |
| `POST` | `/documents/insert_texts` | `{ "texts": [...] }` | Batch insert texts |
| `POST` | `/documents/upload` | Multipart file | Upload document |
| `POST` | `/documents/scan` | — | Scan input directory |
| `GET` | `/documents` | Query params: `page`, `page_size` | List documents |
| `DELETE` | `/documents/{id}` | — | Delete document |
| `DELETE` | `/documents/clear` | — | Clear all documents |
| `POST` | `/documents/status` | `{ "document_id": "..." }` | Check status |

#### Query Endpoints

| Method | Path | Body | Description |
|--------|------|------|-------------|
| `POST` | `/query` | `{ "query": "...", "mode": "hybrid" }` | Query text |
| `POST` | `/query/stream` | `{ "query": "...", "mode": "hybrid" }` | Stream query |
| `POST` | `/query/with_citation` | `{ "query": "...", "mode": "hybrid" }` | Query with citations |

#### Graph Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/graph` | Full knowledge graph |
| `GET` | `/graph/structure` | Graph statistics |
| `GET` | `/graph/entities` | List entities (query: `limit`) |
| `GET` | `/graph/relations` | List relations (query: `limit`) |

#### System Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Health check |
| `GET` | `/docs` | Swagger UI |
| `GET` | `/config` | Server configuration |

#### Ollama-Compatible (Open WebUI)

| Path | Description |
|------|-------------|
| `/api/chat` | Chat completion (RAG-enhanced) |
| `/api/generate` | Text generation |
| `/api/embeddings` | Embedding generation |

### 10.2 OpenCode Integration Endpoints Summary

```
┌──────────────────────────────────────────────────────────────┐
│                    OpenCode → LiteRAG                        │
│                                                              │
│  MCP Server (lightragmcp_*)                                  │
│  ├── Document Management (10 tools)                         │
│  ├── Query (3 tools)                                        │
│  ├── Knowledge Graph (8 tools)                              │
│  └── System Management (5 tools)                            │
│                                                              │
│  Custom Tools (TypeScript)                                   │
│  ├── literag-query.ts  → POST /query                        │
│  ├── literag-insert.ts → POST /documents/insert              │
│  ├── literag-documents.ts → GET/DELETE /documents            │
│  └── literag-graph.ts → GET /graph/*                        │
│                                                              │
│  Plugin Hook                                                 │
│  ├── tool.execute.before  → log LiteRAG calls               │
│  └── system.transform  → inject LiteRAG awareness           │
└──────────────────────────────────────────────────────────────┘
```

---

## 11. Troubleshooting

### 11.1 MCP Server Won't Start

```bash
# Check OpenCode logs for MCP errors
opencode mcp list

# Debug the connection
opencode mcp debug lightrag

# Verify LiteRAG is running
curl http://localhost:9621/health

# Test MCP server manually
npx @g99/lightrag-mcp-server --help
```

### 11.2 LiteRAG API Returns 401 (Unauthorized)

- Verify `LIGHTRAG_API_KEY` is set in both LiteRAG's `.env` and the OpenCode MCP config
- Check the header format: `X-API-Key: your-key` (not `Authorization`)
- Ensure `.env` permissions: `chmod 0600 .env`

### 11.3 Query Returns No Results

```bash
# Check if any documents are indexed
curl http://localhost:9621/documents

# Check LiteRAG logs
docker compose logs lightrag --tail=50

# Try inserting test data
curl -X POST http://localhost:9621/documents/insert \
  -H "Content-Type: application/json" \
  -d '{"text": "This is a test document for verification.", "description": "Test"}'

# Then query it
curl -X POST http://localhost:9621/query \
  -H "Content-Type: application/json" \
  -d '{"query": "test document", "mode": "naive"}'
```

### 11.4 Custom Tools Can't Connect

- Verify environment variables are set: `echo $LITERAG_SERVER_URL`
- Check if LiteRAG is accessible from the OpenCode process: `curl http://localhost:9621/health`
- If using Docker, the container's `localhost` differs from the host — use `host.docker.internal` or the Docker network name

### 11.5 Skill Not Appearing

- Verify the file is at `.opencode/skills/literag/SKILL.md` (note: `SKILL.md` must be exact)
- Check the frontmatter has both `name` and `description`
- Restart OpenCode after adding the skill
- Check permissions: `permission.skill.literag` should be `allow`

### 11.6 Agent Not Available

- Verify the file is at `.opencode/agents/literag-retriever.md`
- Check the frontmatter has `mode` and `description`
- Reference with `@literag-retriever` in conversation
- Restart OpenCode after adding the agent

### 11.7 Plugin Not Loading

- Verify the file is at `.opencode/plugins/literag-tool.ts`
- Check that `plugin` is configured in `opencode.json`
- Restart OpenCode after adding the plugin
- Check OpenCode logs for TypeScript errors

### 11.8 Port Conflicts

```bash
# Check if port 9621 is in use
lsof -i :9621

# Change the LiteRAG port
# In LiteRAG's .env: PORT=9622

# Update OpenCode config to match
# LITERAG_SERVER_URL=http://localhost:9622
```

---

## Appendix A: Quick Reference Card

| Task | Method | Command / File |
|------|--------|---------------|
| Add LiteRAG as tools | MCP Server | `opencode.json` → `mcp.lightrag` |
| Add custom LiteRAG tools | Custom Tools | `.opencode/tools/literag-*.ts` |
| Teach LiteRAG workflows | Skill | `.opencode/skills/literag/SKILL.md` |
| Create LiteRAG agent | Agent | `.opencode/agents/literag-retriever.md` |
| One-shot search | Command | `.opencode/commands/literag-search.md` |
| Auto-inject LiteRAG context | Plugin | `.opencode/plugins/literag-auto-query.ts` |
| Batch ingest documents | MCP Tool | `lightragmcp_upload_documents` |
| Query with citations | MCP Tool | `lightragmcp_query_with_citation` |
| Explore knowledge graph | MCP Tool | `lightragmcp_get_entities` |

## Appendix B: Resource Links

| Resource | URL |
|----------|-----|
| LightRAG GitHub | https://github.com/HKUDS/LightRAG |
| LightRAG MCP Server | https://github.com/lalitsuryan/lightragmcp |
| LightRAG MCP (npm) | `npx @g99/lightrag-mcp-server` |
| OpenCode Config Schema | https://opencode.ai/config.json |
| OpenCode MCP Docs | https://opencode.ai/docs/mcp-servers/ |
| OpenCode Custom Tools | https://opencode.ai/docs/custom-tools/ |
| OpenCode Skills | https://opencode.ai/docs/skills/ |
| OpenCode Agents | https://opencode.ai/docs/agents/ |
| OpenCode Plugins | https://opencode.ai/docs/plugins/ |
| LiteRAG Docker Compose Guide | `./LiteRAG_Docker_Compose_Deployment_Guide.md` |

---

*After making any configuration changes, quit and restart OpenCode for changes to take effect. Running sessions use the already-loaded configuration.*
