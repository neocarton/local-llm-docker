@echo off

call ../env.bat

:: ============================================================
:: searxng
:: Meta-search engine frontend
:: ============================================================

set IMAGE=docker.io/searxng/searxng:latest
set CONTAINER_NAME=searxng
set HOST_PORT=8888
set SEARXNG_SECRET=nokey

set CACHE_DIR=%LOCAL_LLM_DATA_BASE_DIR%/searxng/core-data
set CONFIG_DIR=./searxng/core-config
