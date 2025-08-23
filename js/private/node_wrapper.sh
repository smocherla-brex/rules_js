#!/usr/bin/env bash

set -o pipefail -o errexit -o nounset

js_runtime=%%JS_RUNTIME%%
if [ $js_runtime == "node" ]; then
    exec "$JS_BINARY__NODE_BINARY" --require "$JS_BINARY__NODE_PATCHES" "$@"
else
    # if using bun, not apply fs patches
    exec "$JS_BINARY__NODE_BINARY" "$@"
fi
