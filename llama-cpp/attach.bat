@echo off
setlocal enabledelayedexpansion

call env.bat

echo Llama.cpp API: http://localhost:%HOST_PORT%/

docker attach %CONTAINER_NAME%
