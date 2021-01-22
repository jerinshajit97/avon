#!/bin/sh
#script to find related domains [assets]
echo "[+] Starting domfinder"
mkdir -p assets
for d in $(cat $1)
	do
	   assetfinder $d | unfurl format %r.%t | sort -u > $d.txt
	done

echo "[+] mission accomplished, Peace Be With You"
