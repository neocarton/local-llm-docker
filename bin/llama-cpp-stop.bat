@echo off

call env.bat

cd searxng\
call searxng-stop.bat
cd ..

cd llama-cpp\
call llama-cpp-stop.bat
