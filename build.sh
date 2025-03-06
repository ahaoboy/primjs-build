#!/bin/bash

if [ $# -ne 1 ]; then
    echo "not found target"
    exit 1
fi

TARGET=$1

git clone https://github.com/lynx-family/primjs

cd primjs
source tools/envsetup.sh
hab sync .

ARCH=$(uname -m)

if [[ "$ARCH" == "arm"* || "$ARCH" == "aarch64" ]]; then
    # if [[ "$(uname)" == "Darwin" ]]; then
    #   gn gen out/Default --args='
    #     enable_quickjs_debugger=false
    #     enable_tracing_gc = true
    #     enable_compatbile_mm = true
    #     enable_primjs_snapshot = true
    #     target_cpu = "arm64"
    #     target_os = "mac"
    #     is_debug=false
    #     enable_optimize_with_O2=true
    #   '
    # else
      gn gen out/Default --args='
        target_cpu="arm64"
        enable_primjs_snapshot = true
        enable_compatible_mm = true
        enable_tracing_gc = true
      '
    # fi
else
    gn gen out/Default --args='
        enable_primjs_snapshot=true
        enable_compatible_mm=true
        enable_tracing_gc=true
    '
fi

ninja -C out/Default -j32 qjs_exe



mkdir ../dist

ls -lh ./out/Default

cp -r ./out/Default/*qjs* ../dist

cd ..

ls -lh dist

tar -czf ./primjs-${TARGET}.tar.gz -C dist .
ls -l ./primjs-${TARGET}.tar.gz