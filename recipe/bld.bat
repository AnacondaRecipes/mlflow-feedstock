@echo off
setlocal enabledelayedexpansion

REM Check if this is the skinny variant
if "%mlflow_variant%"=="skinny" (
    echo Building mlflow-skinny variant
    set MLFLOW_SKINNY=1

    REM Copy mlflow directory to libs\skinny\mlflow
    echo Copying mlflow directory...
    xcopy /E /I /Y /H "%SRC_DIR%\mlflow" "%SRC_DIR%\libs\skinny\mlflow"
    if errorlevel 1 (
        echo ERROR: Failed to copy mlflow directory
        exit /b 1
    )

    REM Change to skinny directory
    cd /d "%SRC_DIR%\libs\skinny"
    if errorlevel 1 (
        echo ERROR: Failed to change directory to libs\skinny
        exit /b 1
    )
) else (
    echo Building full mlflow variant
)

REM Install the package
"%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
if errorlevel 1 (
    echo ERROR: pip install failed
    exit /b 1
)

echo Build completed successfully
exit /b 0
