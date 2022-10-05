#!/usr/bin/env bash

youtube-dl \
--external-downloader aria2c \
--external-downloader-args "-c -j 10 -x 10 -s 10 -k 1M" \
--write-srt --sub-lang en \
$1
