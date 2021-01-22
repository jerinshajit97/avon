#!/bin/sh
#script to find related domains [assets]
echo "[+] Starting domfinder"
mkdir -p assets
for d in $(cat $1)
	do
	   echo "[-] searching assets of $d"
	   
	   assetfinder $d | unfurl format %r.%t | sort -u > assets/$d.txt

	   echo "[-] $d completed"
	   echo "[-] found $(cat assets/$d.txt | wc -l) for $d"
	done

echo "[+] mission accomplished, Peace Be With You"
