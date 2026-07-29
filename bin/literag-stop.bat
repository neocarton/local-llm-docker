@echo off

call local-llm-env.bat

cd llama-cpp-embed\
call stop.bat
cd ..

cd literag\
call stop.bat
