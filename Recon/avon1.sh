#!/bin/bash

echo "[=] starting avon $(date)"
echo "[+] reading $1"

echo "[+] creating required folders"
mkdir -p output

for domain in $(cat $1)
	do
		mkdir -p output/$domain
		mkdir -p output/$domain/wordlist
		mkdir -p output/$domain/subdomain
	
		echo "[*] locked the target $domain "	
		echo "[+] creating wordlist"

		/home/jack/VAPT/Tools/CeWL/cewl.rb --lowercase -m 5 -w output/$domain/wordlist/wordlist.txt -o $domain

		echo "[+] starting subdomain enumeration"
		
		echo ===================================SUBLIST3R===============================
		python3 /home/kali/VAPT/Sublist3r/sublist3r.py -d $domain -o output/$domain/subdomain/output.txt

		echo ===================================SUBFINDER================================
		subfinder -d $domain  >> output/$domain/subdomain/output.txt
		
		echo ==================================Amass======================================
		amass enum --passive -d $domain >> output/$domain/subdomain/output.txt

		echo ==========================SUBDOMAIN BRUTEFORCING====================
		amass enum -active -d $domain -brute -w output/$domain/wordlist/wordlist.txt >> output/$domain/subdomain/output.txt

	
		echo "[+] Probing for alive domains..."
		cat output/$domain/subdomain/output.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' | sort -u > output/$domain/subdomain/alive.txt
	
	done

echo "[=] stopping avon $(date)"
echo "peace be with you !"

