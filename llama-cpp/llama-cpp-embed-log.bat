@echo off
setlocal enabledelayedexpansion

call llama-cpp-embed-env.bat
 
docker attach %CONTAINER_NAME%
