#!/bin/sh
export MLFLOW_SKINNY=1
cd $SRC_DIR/libs/skinny
$PYTHON -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv