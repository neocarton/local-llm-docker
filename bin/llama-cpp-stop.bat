@echo off

call local-llm-env.bat

cd searxng\
call stop.bat
cd ..

cd llama-cpp\
call stop.bat
