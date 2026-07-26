@echo off

call env.bat

cd qdrant\
call qdrant-stop.bat
cd ..

cd llama-cpp\
call llama-cpp-embed-stop.bat
