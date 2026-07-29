@echo off
setlocal enabledelayedexpansion

call literag-env.bat

echo LiteRAG API: http://localhost:%HOST_PORT%/

docker attach %CONTAINER_NAME%
