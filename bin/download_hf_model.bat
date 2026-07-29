@echo off

call local-llm-env.bat

cd download_hf_model\
call download_hf_model.bat %*
