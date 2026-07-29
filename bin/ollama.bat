@echo off

call env.bat

cd literag\
call literag.bat
cd ..

cd searxng\
call searxng.bat
cd ..

cd ollama\
call ollama.bat
call ollama-log.bat
