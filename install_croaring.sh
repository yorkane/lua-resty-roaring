#!/usr/bin/env bash
version='0.2.66'
rm -rf src/roaring
echo https://github.com/lemire/CRoaringUnityBuild/archive/v${version}.tar.gz
curl https://github.com/lemire/CRoaringUnityBuild/archive/v${version}.tar.gz -Lk | tar -xvz -C src/
mv src/CRoar* src/roaring