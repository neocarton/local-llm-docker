@echo off

call local-llm-env.bat

cd searxng\
call searxng.bat
cd ..

cd llama-cpp\
call start.bat
call log.bat
