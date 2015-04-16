#!/bin/bash
[ -d dist/dc-update-$VERSION ] || mkdir dist/dc-update-$VERSION
VERSION=$(cat VERSION)
rsync -av bin dist/dc-update-$VERSION
rsync -av lib dist/dc-update-$VERSION
rsync -av package dist/dc-update-$VERSION
rsync  LICENSE dist/dc-update-$VERSION
rsync  README.md dist/dc-update-$VERSION
pushd dist
tar jcvf dc-update-$VERSION.tar.bz2 dc-update-$VERSION
popd
