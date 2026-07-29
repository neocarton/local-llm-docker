@echo off

call ../env.bat

:: ============================================================
:: literag
:: RAG API + knowledge graphs (LightRAG)
:: Requires: Ollama (LLM), Qdrant (vector DB)
:: ============================================================

set IMAGE=ghcr.io/hkuds/lightrag:latest
set CONTAINER_NAME=lightrag
set HOST_PORT=9621
set LIGHTRAG_API_KEY=nokey

set DATA_DIR=%WORKSPACE_DIR%/.literag

mkdir "%DATA_DIR%"
