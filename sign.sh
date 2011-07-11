#!/bin/bash

test "$1" || exit 1

desc=${1%%.exe}; desc=$(echo ${desc} | sed -e 's/-/ /g')
vers=${1%%.exe}; vers=${vers##lb-english-}

test -f "$1.asc" || gpg -a --detach-sign "$1"
metalink \
	--overwrite \
	--publisher-name=fluffy \
	--type=static --upgrade=uninstall,install \
	--description="$desc" --version="$vers" \
	--origin="http://lb.applehq.eu/$1.metalink" \
	 "$1" mirrors
#--create-torrent=udp://tracker.openbittorrent.com:80 \
#	--publisher-url="http://tlwiki.tsukuru.info/index.php?title\=Little_Busters!" \
