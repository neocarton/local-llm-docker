@echo off
setlocal enabledelayedexpansion

call env.bat
 
docker attach %CONTAINER_NAME%
