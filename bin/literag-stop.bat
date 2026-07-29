@echo off

call local-llm-env.bat

cd llama-cpp\
call llama-cpp-embed-stop.bat
cd ..

cd literag\
call literag-stop.bat
