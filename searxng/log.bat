@echo off
setlocal enabledelayedexpansion

call env.bat

echo Searxng: http://localhost:%HOST_PORT%/

docker logs -f %CONTAINER_NAME%
