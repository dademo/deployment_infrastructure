#!/bin/bash

HELM_EXEC_PATH="$(command -v helm)"
if [ $? -ne 0 ]; then
    echo "Unable to locate the helm command"
    exit 1
fi

if [ "$1" == "--update" ]; then
    git submodule update --recursive --init --remote --checkout --force
fi

find "$(dirname "$0")" \( \! -path '**/testdata/**' \) -type f -name 'Chart.yaml' -exec dirname {} \; |
    while read CHART_DIR; do
        pushd "${CHART_DIR}"
        helm dependency update
        popd
    done