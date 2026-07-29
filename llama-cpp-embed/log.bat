@echo off
setlocal enabledelayedexpansion

call env.bat
 
docker logs -f %CONTAINER_NAME%
