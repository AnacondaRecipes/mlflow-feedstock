#!/bin/bash

set -euxo pipefail

if [ ! -f pyproject.full.toml ]; then
  cp pyproject.toml pyproject.full.toml
fi

if [[ "${PKG_NAME}" == "mlflow-skinny" ]]; then
  export MLFLOW_SKINNY=1
  # https://github.com/mlflow/mlflow/pull/4134
  cp ${RECIPE_DIR}/README_SKINNY.rst ${SRC_DIR}
  cp pyproject.skinny.toml pyproject.toml
else
  cp pyproject.full.toml pyproject.toml
fi

if [[ "${PKG_NAME}" == "mlflow-ui" ]]; then
  pushd mlflow/server/js
  yarn install
  yarn build
  popd
fi

$PREFIX/bin/python -m pip install . --no-deps --no-build-isolation --ignore-installed --no-cache-dir -vv
if [[ "$PKG_NAME" != "mlflow-ui-dbg" ]]; then
  rm -rf $SP_DIR/mlflow/server/js/node_modules
  rm -f $SP_DIR/mlflow/server/js/build/static/css/*.css.map
  rm -f $SP_DIR/mlflow/server/js/build/static/js/*.js.map
fi
