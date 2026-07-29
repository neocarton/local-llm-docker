@echo off
setlocal enabledelayedexpansion

call env.bat

echo Ollama API: http://localhost:%HOST_PORT%/

docker attach %CONTAINER_NAME%
