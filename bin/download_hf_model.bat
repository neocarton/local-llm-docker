@echo off

call env.bat

cd download_hf_model\
call download_hf_model.bat %*
