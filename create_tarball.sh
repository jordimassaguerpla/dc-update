#!/bin/bash
VERSION=$(cat VERSION)
[ -d dist/dc-update-$VERSION ] || mkdir -p dist/dc-update-$VERSION
rsync -av bin dist/dc-update-$VERSION
rsync -av lib dist/dc-update-$VERSION
rsync  LICENSE dist/dc-update-$VERSION
rsync  README.md dist/dc-update-$VERSION
mkdir dist/dc-update-$VERSION/package
sed -e "s/##VERSION##/$VERSION/g" package/dc-update.in > dist/dc-update-$VERSION/package/dc-update
pushd dist
tar jcvf dc-update-$VERSION.tar.bz2 dc-update-$VERSION
popd
