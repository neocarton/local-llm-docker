@echo off
setlocal enabledelayedexpansion

call env.bat

echo Starting %CONTAINER_NAME%...

docker run -d ^
    --env SEARXNG_SECRET=%SEARXNG_SECRET% ^
    --volume "%CONFIG_DIR%:/etc/searxng/:Z" ^
    --volume "%CACHE_DIR%:/var/cache/searxng/" ^
    --publish %HOST_PORT%:8080 ^
    --rm ^
    --name %CONTAINER_NAME% ^
    %IMAGE%

if %errorlevel% equ 0 (
    echo Container %CONTAINER_NAME% started successfully.
    echo Searxng Web interface at: http://localhost:%HOST_PORT%/
) else (
    echo Failed to start container %CONTAINER_NAME%.
)
echo.
