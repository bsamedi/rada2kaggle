#!/bin/bash
set -e

SOURCE_DIR=ogd/zal/ppz/skl8
SOURCE_FILE=chron-json.zip

TARGET_DIR=./target/$SOURCE_DIR

main() {
    init

    cleanup_target
    get_full_binary http://data.rada.gov.ua/$SOURCE_DIR/$SOURCE_FILE $SOURCE_FILE
    unpack_json_files $SOURCE_FILE
    convert_to_utf8 `list_archived_json_files $SOURCE_FILE`
}
  init() {
    mkdir -p $TARGET_DIR
    cd $TARGET_DIR
  }
  cleanup_target() {
    touch dummy.json
    rm *.json
   }
  get_full_binary() {
    url=$1
    filename=$2
    #curl $url -o $filename
  }
  unpack_json_files() {
    unzip -n $1
  }
  list_archived_json_files() {
    zipinfo -1 $1
  }
  convert_to_utf8() {
    # pass filenames to convert as arguments
    echo -n 'Converting to UTF-8 '
    set -e
    TEMPFILE=`mktemp /tmp/rada2kaggle.XXXXXXXX`
    trap 'rm $TEMPFILE' EXIT
    for f in "$@"
    do
        echo -n .
        iconv -f WINDOWS-1251 -t UTF-8 $f > $TEMPFILE
        cp $TEMPFILE $f
    done
    echo Done
  }

main "$@"
