@echo off

call env.bat

cd llama.cpp
docker build -t %IMAGE% --target server -f .devops/cuda.Dockerfile .
