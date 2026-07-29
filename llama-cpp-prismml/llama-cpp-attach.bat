@echo off
setlocal enabledelayedexpansion

call llama-cpp-env.bat

echo Llama.cpp API: http://localhost:%HOST_PORT%/

docker attach %CONTAINER_NAME%
