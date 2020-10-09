#!/bin/bash

# path variables
avr=/../part1/output #path of avon Recon output
ava="../part2/output" #path of avon A1 output

# fuctions to perform actions
open_1() {
	echo "================================================$1====================================================="
	echo "=============================================================nuclie============================================================="
	cat $ava/$1/nscan/result.txt | sort -u 
 	echo "================================================================xss============================================================="
	cat $ava/$1/xss/result.txt
	echo "=================================================================================================================================="
}

# funtion to show all result
open_all() {
	for x in $(ls $ava)
		do
			#echo $x
			if [ $x == 'takeover.txt' ]
			then
				cat $ava/$x
			else
				open_1 $x
			fi
		done
	}


echo "=====================================AVON============================================"
echo "=======$(date)======="

x=1

while [ $x != 0 ]
	do
		echo "**********MENU**********"
		echo "1) SHOW AVAILABLE DOMAINS"
		echo "2) RESULT OF A DOMAIN"
		echo "3) OPEN ALL RESULTS"
		echo "4) TAKEOVERS"
		echo "0) EXIT"
		echo "***Enter your choice***"
		read choice
		if [ $choice -eq 0 ] # to exit
			then
				x=0

		elif [ $choice -eq 1 ] # to list all avialbe domain
			then
			ls $ava

		elif [ $choice -eq 2 ] # to show result of a domain
			then
			echo "enter the domain"
		        read d
			open_1 $d | less -r

		elif [ $choice -eq 3 ] # to show all result
			then
			open_all | less -r 

		elif [ $choice -eq 4 ] # to show takeover
			then
			cat $ava/takeover.txt | less -r 
		else
			echo "Carefull AMIGO ! Wrong choice..."
		fi

	done

echo "PEACE BE WITH YOU !!!"
