@echo off
setlocal enabledelayedexpansion

call env.bat

echo Llama.cpp API: http://localhost:%HOST_PORT%/

docker logs -f %CONTAINER_NAME%
