@echo on

if [%PKG_NAME%] == [mlflow-skinny] (
  set MLFLOW_SKINNY=1

  @rem Using symlinks doesn't seem to work on windows, materialize them.
  pushd libs\skinny
  powershell -NoProfile -ExecutionPolicy Bypass -File "%RECIPE_DIR%\materialize_symlinks.ps1"
  if %ERRORLEVEL% neq 0 exit 1
  popd

  %PYTHON% -m pip install ./libs/skinny --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
) else (
  %PYTHON% -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
)

if %ERRORLEVEL% neq 0 exit 1
