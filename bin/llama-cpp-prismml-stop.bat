@echo off

call env.bat

cd literag\
call literag-stop.bat
cd ..

cd searxng\
call searxng-stop.bat
cd ..

cd llama-cpp-prismml\
call llama-cpp-stop.bat
