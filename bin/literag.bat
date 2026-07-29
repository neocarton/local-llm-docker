@echo off

call local-llm-env.bat

cd llama-cpp-embed\
call start.bat
cd ..

cd literag\
call start.bat
