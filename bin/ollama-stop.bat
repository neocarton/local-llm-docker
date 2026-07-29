@echo off

call env.bat

cd literag\
call literag-stop.bat
cd ..

cd searxng\
call searxng-stop.bat
cd ..

cd ollama\
call ollama-stop.bat
