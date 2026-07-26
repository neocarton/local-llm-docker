@echo off

call env.bat

cd searxng\
call searxng-stop.bat
cd ..

cd ollama\
call ollama-stop.bat
