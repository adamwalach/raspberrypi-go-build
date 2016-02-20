#!/bin/bash

# based on http://dave.cheney.net/2015/09/04/building-go-1-5-on-the-raspberry-pi

GO_VERSION=1.5.3
RUN_TESTS=false

BOOTSTRAP_DIR=go-linux-arm-bootstrap
SOURCE_FILE=go$GO_VERSION.src.tar.gz

mkdir -p .build

cd .build
if [ ! -d "$BOOTSTRAP_DIR" ]; then
    echo "Unpacking bootstrap"
    tar -xjf ../blobs/go-linux-arm-bootstrap-c788a8e.tbz
fi

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Downloading Golang source (version $GO_VERSION)"
    wget https://storage.googleapis.com/golang/$SOURCE_FILE
    tar -xzf $SOURCE_FILE
fi

rm -rf go
echo "Unpacking Golang source"
tar -vxzf go$GO_VERSION.src.tar.gz


cd go/src

BASE=`dirname ../../`
BOOTSTRAP_PATH=$(
  cd $BASE
  dirname `pwd -P`
)
BOOTSTRAP_PATH=$BOOTSTRAP_PATH/$BOOTSTRAP_DIR

if [ "$RUN_TESTS" = true ]; then
    ulimit -s 1024
    ulimit -s
    GO_TEST_TIMEOUT_SCALE=10 GOROOT_BOOTSTRAP=$BOOTSTRAP_PATH ./all.bash
else
    GO_TEST_TIMEOUT_SCALE=10 GOROOT_BOOTSTRAP=$BOOTSTRAP_PATH ./make.bash
fi
