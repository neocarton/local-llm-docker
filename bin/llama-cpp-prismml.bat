@echo off

call local-llm-env.bat

cd searxng\
call searxng.bat
cd ..

cd llama-cpp-prismml\
call start.bat
call log.bat
