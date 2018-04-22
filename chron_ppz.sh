#!/bin/bash
set -e

SOURCE_DIR=ogd/zal/ppz/skl8
SOURCE_FILE=chron-json.zip

TARGET_DIR=./target/$SOURCE_DIR
TARGET_FILE=$SOURCE_FILE

main() {
    cleanup_target
    get_full_binary
    #unpack_json_files
    #convert_all_to_utf8
}
  cleanup_target() {
    if [ -n "$TARGET_DIR" ]
    then
        mkdir -p $TARGET_DIR
        touch $TARGET_DIR/dummy
        rm $TARGET_DIR/*
    else
        echo 'Target directory not set' >&2
        exit 1
    fi
   }
  get_full_binary() {
    curl \
        http://data.rada.gov.ua/$SOURCE_DIR/$SOURCE_FILE \
        -o $TARGET_DIR/$TARGET_FILE
  }
  unpack_json_files() {
    echo Not implemented
  }
  convert_all_to_utf8() {
    echo Not implemented
  }

main "$@"
