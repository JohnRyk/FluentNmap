#!/bin/bash
#AUTHOR=0r1MyW4y

#Path /To modify the path by yourself
SCRIPT_PATH="/usr/share/nmap/scripts"
cd $SCRIPT_PATH

#ver
VERSION=`nmap --version |grep version`

#Counter
SCRIPT_TOTAL=$(expr `ls -la |wc |awk '{ print $1 }'` - 2)
AUTH_TOTAL=`ls | grep auth |wc |awk '{ print $1 }'`
BRUTE_TOTAL=`ls | grep brute |wc |awk '{ print $1 }'`
BROADCAST_TOTAL=`ls | grep broadcast |wc |awk '{ print $1 }'`
DISCOVER_TOTAL=`ls | grep discover |wc |awk '{ print $1 }'`
ENUM_TOTAL=`ls | grep enum |wc |awk '{ print $1 }'`
FUZZ_TOTAL=`ls | grep fuzz |wc |awk '{ print $1 }'`
INFO_TOTAL=`ls | grep info |wc |awk '{ print $1 }'`
VULN_TOTAL=`ls | grep vuln |wc |awk '{ print $1 }'`

#Script
VULNER_STATU=`if [ $(ls nmap-vulners 2>/dev/null |wc |awk '{print $1}') -eq 0 ] ; then echo "[-] nmap-vulners - is not available now, use -h to see how to install it." ; else echo "[+] nmap-vulners is available, good luck !" ; fi`
VULSCAN_STATU=`if [ $(ls vulscan 2>/dev/null |wc |awk '{print $1}') -eq 0 ] ; then echo "[-] vulscan      - is not available now, use -h to see how to install it." ; else echo "[+] vulscan is available, good luck !" ; fi`

#Servers
FTP=""
SSH=""
TELNET=""
SMTP=""
DNS=""
HTTP=""
POP=""
SMB=""

#print this help message
printHelp(){
	echo "[1] Usage: fluentnmap <Keyword>                     - List related scripts"
	echo "[2] Usage: fluentnmap <Full Script Name>            - Show the script description"
	echo "[3] Usage: fluentnmap -d <Full Script Name>         - Display the script detail"
	echo "[4] Usage: sudo fluentnmap install vulnscanner      - To install the vulnscanner packages (nmap-vulners & vulscan) from github"
	echo "[5] Usage: sudo fluentnmap remove                   - To remove the vulnscanner packages"
	echo
	echo "Example: "
	echo "   fluentnmap smb"
	echo "   fluentnmap smb-brute.nse"
	echo "   fluentnmap -d smb-brute.nse"
	echo
	exit 1
}

printInfoBoard(){
         echo ' _____ _                  _   _   _                         '
         echo '|  ___| |_   _  ___ _ __ | |_| \ | |_ __ ___   __ _ _ __    '
         echo '| |_  | | | | |/ _ \ __ \| __|  \| | __ ` _ \ / _` | __ \   '
	 echo '|  _| | | |_| |  __/ | | | |_| |\  | | | | | | (_| | |_) |  '
	 echo '|_|   |_|\__,_|\___|_| |_|\__|_| \_|_| |_| |_|\__,_| .__/   '
         echo '                                                   |_|      '

 	 echo "------------------------------------------------------------"
	 echo " A mate of nmap."
	 echo " Clean, Concise and Straightforward."
	 echo " Help you to be familiar with nmap scripts."
         echo "------------------------------------------------------------"

	 echo "$VERSION"
	 echo "	<<<<<<<<<<<<<<<<<<< Total:$SCRIPT_TOTAL >>>>>>>>>>>>>>>>>>>>"
	 echo "          auth:$AUTH_TOTAL - brute:$BRUTE_TOTAL - broadcast:$BROADCAST_TOTAL - discover:$DISCOVER_TOTAL"
	 echo "          enum:$ENUM_TOTAL    - fuzz:$FUZZ_TOTAL   - info:$INFO_TOTAL    - vuln:$VULN_TOTAL"
	 echo "           (use option -h/--help to see the help page)"
	 echo "$VULNER_STATU"
	 echo "$VULSCAN_STATU"
	 echo
}

if [ $# -eq 1 ] ; then

	#filter unvalid character ( only alapa and - are valid )
	flitered="$(echo $1 |sed -e 's/[^-.[:alnum:]]//g')"

	#check if the string format is nse script name 
	match=`echo $flitered |cut -d "." -f 2`

	if [ $flitered = $1 ] ; then
		if [ $flitered = "--help" ] || [ $flitered = "-h" ] ; then
			printInfoBoard
			printHelp
		elif [ $flitered = 'remove' ] ; then
			echo "[-] Sure to remove the vuln scanner packages ?"
			echo "[-] Please input 'y' to remove [y/n]" 
			read choice
			if [ $choice = 'y' ] ; then
				message=`rm -r $SCRIPT_PATH/nmap-vulners; rm -r $SCRIPT_PATH/vulscan`
				echo $message
			fi
		elif [ $match = "nse" ] ; then
		       	sed -n '/description/,/]]/p' $flitered
		else
			cd $SCRIPT_PATH ; ls |grep $flitered |nl
		fi
	else
		echo "[-] Parameter 3rror"
	fi
elif [ $# -eq 2 ] ; then
	
	flitered="$(echo $2 |sed -e 's/[^-.[:alnum:]]//g')"
	match=`echo $flitered |cut -d "." -f 2`
	
	if [ $1 = '-d' ] ; then
		if [ $match = 'nse' ] ; then
			less $2
		else
			echo "[-] Invalid 4rgument: $2"
		fi
	#check the parameters
	elif [ $1 = 'install' ] && [ $2 = 'vulnscanner' ] ; then
		ls|grep nmap-vulners
		check1=`echo $?`
		ls|grep vulscan
		check2=`echo $?`
		echo check1: $check1
		echo check2: $check2 
		#if [ $check1 != 'nmap-vulners' ] && [ $check2 != 'vulnscan' ] ; then
		if [ $check1 -eq 1 ] || [ $check2 -eq 1 ] ; then
			if [ $check1 != 'nmap-vulners' ] && [ $check2 != 'vulnscan' ] ; then
				echo "[-] The 'nmap-vulners' or 'vulnscan' does not be installed in your machine "
				echo "[-] Please input 'y' to install [y/n]"
				read choice
			
				if [ $choice = 'y' ] ; then
					git clone https://github.com/vulnersCom/nmap-vulners.git
					git clone https://github.com/scipag/vulscan.git
					chmod -R 755 nmap-vulners
					chmod -R 755 vulscan
					echo "[+] Install success !"
					echo
					echo "Example: "
					echo "        nmap -sV --script <nmap-vulners|vulnscan> <Target>"
					echo "        To discovery the known vulnerabilities. Have fun :)"
					echo
				fi
			fi	
		
		elif [ $check1 = 'nmap-vulners' ] || [ $check2 = 'vulscan' ] ; then
			echo "[!] Error: nmap-vulner is already exit"
			echo "[-] use: 'nmap -sV --script <nmap-vulners|vulnscan> <Target>'"
			echo "[-] If you want to remove it try to use: $0 remove nmap-vulners"
			echo
		fi
	else
		printInfoBoard
		printHelp
	fi
else
	printInfoBoard
fi

