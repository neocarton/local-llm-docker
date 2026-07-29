@echo off

call local-llm-env.bat

cd searxng\
call stop.bat
cd ..

cd ollama\
call stop.bat
