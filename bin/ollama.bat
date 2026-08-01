@echo off

call local-llm-env.bat

cd ollama\
call ollama.bat
call log.bat
