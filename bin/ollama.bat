@echo off

call local-llm-env.bat

cd searxng\
call searxng.bat
cd ..

cd ollama\
call ollama.bat
call log.bat
