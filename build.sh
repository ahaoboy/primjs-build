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
    gn gen out/Default --args="target_cpu=\"arm64\" enable_primjs_snapshot=true enable_compatible_mm=true enable_tracing_gc=true"
else
    gn gen out/Default --args="enable_primjs_snapshot=true enable_compatible_mm=true enable_tracing_gc=true"
fi

ninja -C out/Default -j32 qjs_exe



mkdir ../dist

ls -lh ./out/Default

cp -r ./out/Default/*qjs* ../dist

cd ..

ls -lh dist

tar -czf ./primjs-${TARGET}.tar.gz -C dist .
ls -l ./primjs-${TARGET}.tar.gz