#!/bin/bash
##The goal of this script of to automate the gathering and exportation of data, as well as provide the ability to run the tools individually
##Libraries should be statically linked to the executables called and included with script

vers="0.0.1a"
port="0";
host="nope";
netcat=false;
file=false;
filename="";
cli=false;
output="";

function main()
{
	##Check for root permissions.
	if [[ $UID -ne 0 ]]; then
	        echo "lift must be run as root"
	        exit 1
	fi

	USAGE="Usage: lift [vnc] [-p remoteport] [-h remotehost] [-w filename]"

	if [ "$#" == "0" ]; then
	        echo "$USAGE"
	        exit 1
	fi

	parse_arguments "$@"

	print_globals


	if (($netcat) && (! $cli) && (! $file))
	then
		echo 1
		scrape | nc -q 1 $host $port
	elif ((! $netcat) && ($cli) && (! $file))
	then
		echo 2
		scrape
	elif ((! $netcat) && (! $cli) && ($file))
	then
		echo 3
		scrape >> $filename
	else
		echo 4
	fi
}

function parse_arguments()
{
	while getopts "vncw:h:p:" opt; do
		case $opt in
			##Print version info
			v)
				echo "Version $vers"
				exit 1
			;;
			##host for netcat
			h)
				host=$OPTARG
			;;
			##use netcate
			n)
				netcat=true
			;;
			##port for netcat
			p)
				port=$OPTARG
			;;
			##Write to file
			w)
				file=true
				filename=$OPTARG
			;;
			##output to command line
			c)
				cli=true
			;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				exit 1
			;;
		esac
	done
}

function print_globals()
{
	echo vers      ${vers}
	echo port      ${port}
	echo host      ${host}
	echo netcat    ${netcat}
	echo file      ${file}
	echo filename  ${filename}
	echo cli       ${cli}
	echo output    ${output}

}

function scrape()
{
	##get start date and time
	date
	## Network State
	netstat -an
	##Running Processes
	ps -aux
	##Open ports and files
	lsof
	##Routing and ARP Tables
	netstat -rn
	route -Cn
	arp -an
	##interface information
	ifconfig
	##process load informations
	top -n 1
	##currently logged on users
	w
	## logon history
	last
	#####
	##logs-tar and send, need to seperate
	####
	##user group information
	cat /etc/passwd
	##users who have logged on
	ls /home
	##GET .bash_history files
	##OS Information
	uname -a
	##Loaded Kernel Modules
	lsmod
	##End date and time
	date
}


#exit 1
##For now, just straight command line output (0), then netcat(1), then write to file(2)
#echo $output
#scrape

main "$@"
