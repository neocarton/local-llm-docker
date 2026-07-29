@echo off

call local-llm-env.bat

cd searxng\
call stop.bat
cd ..

cd llama-cpp-prismml\
call stop.bat
