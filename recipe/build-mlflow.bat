@echo on
setlocal enabledelayedexpansion

"%PYTHON%" -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
if !ERRORLEVEL! NEQ 0 (echo "ERROR: pip install failed" & exit /b !ERRORLEVEL!)

echo Build completed successfully
exit /b 0
