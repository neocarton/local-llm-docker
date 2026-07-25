@echo off
setlocal enabledelayedexpansion

call qdrant-env.bat

echo Starting %CONTAINER_NAME%...

docker run -d ^
    --env RUN_MODE=production ^
    --volume %VOLUME_NAME%:/qdrant/storage ^
    --publish %HOST_PORT%:6333 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE%

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Qdrant API available at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
