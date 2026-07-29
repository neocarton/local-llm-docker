@echo off

call local-llm-env.bat

cd searxng\
call searxng.bat
cd ..

cd llama-cpp\
call llama-cpp.bat
call llama-cpp-log.bat
