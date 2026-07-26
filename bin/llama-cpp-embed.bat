@echo off

call env.bat

cd qdrant\
call qdrant.bat
cd ..

cd llama-cpp\
call llama-cpp-embed.bat
call llama-cpp-embed-log.bat
