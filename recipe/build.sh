#!/bin/bash

set -ex

if [ "${PKG_NAME}" = "mlflow-skinny" ]; then
  export MLFLOW_SKINNY=1
  ${PYTHON} -m pip install ./libs/skinny --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
else
  ${PYTHON} -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
fi
