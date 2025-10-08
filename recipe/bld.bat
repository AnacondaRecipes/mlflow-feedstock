@echo off
setlocal enabledelayedexpansion

echo ===== BLD.BAT DEBUG INFO =====
echo SRC_DIR: %SRC_DIR%
echo mlflow_variant: %mlflow_variant%
echo Current directory: %CD%

REM Check if this is the skinny variant
if "%mlflow_variant%"=="skinny" (
    echo Building mlflow-skinny variant
    set MLFLOW_SKINNY=1

    echo Checking if source mlflow directory exists...
    if exist "%SRC_DIR%\mlflow" (
        echo Source directory exists: %SRC_DIR%\mlflow
        dir "%SRC_DIR%\mlflow" | findstr /C:"<DIR>" | findstr /V /C:"." | findstr /C:"DIR"
    ) else (
        echo ERROR: Source directory does not exist: %SRC_DIR%\mlflow
        exit /b 1
    )

    echo Checking if libs\skinny exists...
    if not exist "%SRC_DIR%\libs\skinny" (
        echo Creating directory: %SRC_DIR%\libs\skinny
        mkdir "%SRC_DIR%\libs\skinny"
        if errorlevel 1 (
            echo ERROR: Failed to create libs\skinny directory
            exit /b 1
        )
    )

    echo Copying mlflow directory...
    echo From: %SRC_DIR%\mlflow
    echo To: %SRC_DIR%\libs\skinny\mlflow
    robocopy /E /NFL /NDL /NJH /NJS /nc /ns /np "%SRC_DIR%\mlflow" "%SRC_DIR%\libs\skinny\mlflow"
    set ROBOCOPY_EXIT=%ERRORLEVEL%
    echo robocopy exit code: %ROBOCOPY_EXIT%
    REM robocopy returns 1 for successful copy, 0 for no files, >= 8 for errors
    if %ROBOCOPY_EXIT% GEQ 8 (
        echo ERROR: Failed to copy mlflow directory
        exit /b 1
    )

    echo Verifying copied directory...
    if exist "%SRC_DIR%\libs\skinny\mlflow" (
        echo Directory copied successfully
        dir "%SRC_DIR%\libs\skinny\mlflow" | findstr /C:"File(s)"
    ) else (
        echo ERROR: Destination directory was not created
        exit /b 1
    )

    echo Changing to skinny directory...
    cd /d "%SRC_DIR%\libs\skinny"
    if errorlevel 1 (
        echo ERROR: Failed to change directory to libs\skinny
        exit /b 1
    )
    echo Current directory after cd: %CD%
)

REM Install the package
"%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
if errorlevel 1 (
    echo ERROR: pip install failed
    exit /b 1
)

echo Build completed successfully
exit /b 0
