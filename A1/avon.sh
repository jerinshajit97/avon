#!/bin/bash

echo "[=] strating AVON $(date)"

echo "[+] creating required folders"

mkdir -p output


# function to validate the result of open redirect
flag() {
	if [ $1 -gt 0 ]
		then
		echo "[+] open redirect found.Payload used [$2]"
		echo $url >> output/openredirect.txt 
	fi

	}
# function to verify url scope
verify() {
	for x in $(cat output/$sub/spider/temp.txt)
		do
			if [ $( echo $x | unfurl domain | grep $sub | wc -c ) -gt 1 ]
				then
					echo $x >> output/$sub/spider/$1.txt
				fi
		done
	rm output/$sub/spider/temp.txt
	}






echo "[+] finding subdmaoin takeover"

SubOver -l $1 -a --https | grep "Possible" >> output/takeover.txt

echo "[-] updating templates"
nuclei -update-templates

for sub in $(cat $1)
	do 
		echo "[+] target locked ====$sub===="
		
		mkdir -p output/$sub
		
		echo "[+] checking open redirect"
		url=$(echo "$sub" | httprobe -prefer-https)
		
		flag $(curl -Ls $url/google.com/ | grep -io "<title>Google</title>" | wc -m ) 1

		flag $(curl -Ls $url//google.com/ | grep -io "<title>Google</title>" | wc -m ) 2

		flag $(curl -Ls $url///google.com/ | grep -io "<title>Google</title>" | wc -m ) 3

 		
		echo "[+] spidering the target"

		mkdir -p output/$sub/spider

		gospider -s $url -d 5 -c 10 -t 10 > output/$sub/spider/spider.txt

		echo "[-] finding possible xss url"
		cat output/$sub/spider/spider.txt | gf urls | grep "$sub" | gf xss | sort -u > output/$sub/spider/temp.txt

		#veryfing scope of url
		verify xss		

		echo "[-] finding possible SQLi url"
		cat output/$sub/spider/spider.txt | gf urls | grep "$sub" | gf sqli | sort -u > output/$sub/spider/temp.txt
		
		#veryfing scope of url
		verify sqli

		echo "[+] starting nuclie engine"

		mkdir -p output/$sub/nscan
			
		echo $url | nuclei -c 25 -t security-misconfiguration/ -t cves/ -t default-credentials/ -t dns/ -t files/ -t generic-detections/ -t panels/ -t subdomain-takeover/ -t technologies/ -t tokens/ -t vulnerabilities/ -t workflows/  -silent -o output/$sub/nscan/result.txt

		echo "[+] finding XSS"

		mkdir -p output/$sub/xss

		#python3 ~/VAPT/Tools/XSStrike/xsstrike.py -u $url --crawl --params -l 5 -t 10 >> output/$sub/xss/result.txt


		python3 ~/VAPT/Tools/XSStrike/xsstrike.py --seeds output/$sub/spider/xss.txt --params -l 5 -t 10 --log-file output/$sub/xss/result.txt --file-log-level GOOD
		

	done

echo "[=] stoping AVON $(date)"
echo "pease be with you !"
