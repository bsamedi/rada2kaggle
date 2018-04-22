#!/bin/bash
set -e

SOURCE_DIR=ogd/zal/ppz/skl8
SOURCE_FILE=chron-json.zip

TARGET_DIR=./target/$SOURCE_DIR

main() {
    #cleanup_target
    #get_full_binary
    unpack_json_files
    convert_to_utf8 `list_archived_json_files`
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
        -o $TARGET_DIR/$SOURCE_FILE
  }
  unpack_json_files() {
    (   cd $TARGET_DIR
        rm *.json
        unzip -n $SOURCE_FILE
    )
  }
  list_archived_json_files() {
    zipinfo -1 $TARGET_DIR/$SOURCE_FILE
  }
  convert_to_utf8() {
    echo -n 'Converting to UTF-8 '
    set -e
    TEMPFILE=`mktemp /tmp/rada2kaggle.XXXXXXXX`
    trap 'rm $TEMPFILE' EXIT
    for f in "$@"
    do
        echo -n .
        iconv -f WINDOWS-1251 -t UTF-8 $TARGET_DIR/$f > $TEMPFILE
        cp $TEMPFILE $TARGET_DIR/$f
    done
    echo Done
  }

main "$@"
