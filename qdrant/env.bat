@echo off

call ../env.bat

:: ============================================================
:: qdrant
:: Vector database for storing and querying embeddings
:: ============================================================

set IMAGE=qdrant/qdrant:latest
set CONTAINER_NAME=qdrant
set HOST_PORT=6333
set VOLUME_NAME=qdrant_storage
