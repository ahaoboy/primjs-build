#!/bin/bash

if [ $# -ne 1 ]; then
    echo "not found target"
    exit 1
fi

TARGET=$1

# FIXME: buildroot clone error
# git clone https://github.com/lynx-family/primjs
git clone https://github.com/ahaoboy/primjs.git

cd primjs
source tools/envsetup.sh
hab sync .

gn gen out/Default --args= '
  is_debug = false'

ninja -C out/Default -j32 qjs_exe



mkdir ../dist

ls -lh ./out/Default

cp -r ./out/Default/*qjs* ../dist

cd ..

ls -lh dist

tar -czf ./primjs-${TARGET}.tar.gz -C dist .
ls -l ./primjs-${TARGET}.tar.gz