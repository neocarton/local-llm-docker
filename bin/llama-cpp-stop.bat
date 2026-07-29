@echo off

call local-llm-env.bat

cd searxng\
call searxng-stop.bat
cd ..

cd llama-cpp\
call llama-cpp-embed-stop.bat
call llama-cpp-stop.bat
