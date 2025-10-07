#!/bin/bash
set -ex

# Check if this is the skinny variant
if [ "${mlflow_variant}" = "skinny" ]; then
    echo "Building mlflow-skinny variant"
    export MLFLOW_SKINNY=1
    cd "${SRC_DIR}/libs/skinny"
else
    echo "Building full mlflow variant"
fi

# Install the package
${PYTHON} -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vvv
