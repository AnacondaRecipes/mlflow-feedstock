@echo on

REM Check if this is the skinny variant
if "%mlflow_variant%"=="skinny" (
    echo Building mlflow-skinny variant
    set MLFLOW_SKINNY=1

    REM Materialize symlinks in libs\skinny using PowerShell
    pushd libs\skinny
    powershell -NoProfile -ExecutionPolicy Bypass -File "%RECIPE_DIR%\materialize_symlinks.ps1"
    if %ERRORLEVEL% NEQ 0 (echo "ERROR: Failed to materialize symlinks" & exit /b %ERRORLEVEL%)
)

"%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
if %ERRORLEVEL% NEQ 0 (echo "ERROR: pip install failed" & exit /b %ERRORLEVEL%)

echo Build completed successfully
exit /b 0
