@echo off

REM Check if this is the skinny variant
if "%mlflow_variant%"=="skinny" (
    echo Building mlflow-skinny variant
    set MLFLOW_SKINNY=1

    REM Materialize symlinks in libs\skinny using PowerShell
    pushd libs\skinny
    powershell -NoProfile -ExecutionPolicy Bypass -File "%RECIPE_DIR%\materialize_symlinks.ps1"
    if errorlevel 1 (
        echo ERROR: Failed to materialize symlinks
        popd
        exit /b 1
    )
    popd

    REM Install from libs\skinny
    "%PYTHON%" -m pip install ./libs/skinny --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
    if errorlevel 1 (
        echo ERROR: pip install failed
        exit /b 1
    )
) else (
    REM Install regular mlflow from root
    "%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
    if errorlevel 1 (
        echo ERROR: pip install failed
        exit /b 1
    )
)

echo Build completed successfully
exit /b 0
