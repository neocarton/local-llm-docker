@echo off

call env.bat

cd literag\
call literag.bat
cd ..

cd searxng\
call searxng.bat
cd ..

cd llama-cpp\
call llama-cpp-embed.bat
cd ..

cd llama-cpp-prismml\
call llama-cpp.bat
call llama-cpp-log.bat
