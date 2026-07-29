@echo off

call local-llm-env.bat

cd llama-cpp\
call llama-cpp-embed.bat
cd ..

cd literag\
call literag.bat
