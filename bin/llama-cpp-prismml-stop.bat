@echo off

call local-llm-env.bat

cd searxng\
call searxng-stop.bat
cd ..

cd llama-cpp-prismml\
call llama-cpp-stop.bat
