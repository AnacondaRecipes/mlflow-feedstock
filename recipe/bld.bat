@echo off
setlocal enabledelayedexpansion

REM Check if this is the skinny variant
if "%mlflow_variant%"=="skinny" (
    echo Building mlflow-skinny variant
    set MLFLOW_SKINNY=1

    REM Copy mlflow directory to libs\skinny\mlflow
    echo Copying mlflow directory...
    robocopy /E /NFL /NDL /NJH /NJS /nc /ns /np "%SRC_DIR%\mlflow" "%SRC_DIR%\libs\skinny\mlflow"
    REM robocopy returns 1 for successful copy, 0 for no files, >= 8 for errors
    if errorlevel 8 (
        echo ERROR: Failed to copy mlflow directory
        exit /b 1
    )

    REM Change to skinny directory
    cd /d "%SRC_DIR%\libs\skinny"
    if errorlevel 1 (
        echo ERROR: Failed to change directory to libs\skinny
        exit /b 1
    )
)

REM Install the package
"%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
if errorlevel 1 (
    echo ERROR: pip install failed
    exit /b 1
)

echo Build completed successfully
exit /b 0
