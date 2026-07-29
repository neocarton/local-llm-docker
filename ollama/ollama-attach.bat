@echo off
setlocal enabledelayedexpansion

call ollama-env.bat

echo Ollama API: http://localhost:%HOST_PORT%/

docker attach %CONTAINER_NAME%
