#!/bin/bash
##The goal of this script of to automate the gathering and exportation of data, as well as provide the ability to run the tools individually
##Libraries should be statically linked to the executables called and included with script

#GLOBAL VARIABLES
script="${0}"
vers="0.0.1a"
cli=false
file=false
filename=""
netcat=false
host="nope"
port="0"

function main()
{
	##Check for root permissions.
	if [[ ${UID} -ne 0 ]]
	then
	        echo "${script} must be run as root"
	        exit 1
	fi

	parse_arguments "${@}"

	print_globals

	if ((${cli}) || [ $# -eq 0 ] )
	then
		echo 1
		scrape
	fi

	if ${file}
	then
		echo 2
		scrape >> "${filename}"
	fi		

	if ${netcat}
	then
		echo 3
		scrape | nc -q 1 ${host} ${port}
	fi
}

function parse_arguments()
{
	while getopts "hvco:n:" opt
	do
		case ${opt} in
			##help
			h)
				print_usage
				exit 1
			;;
			##Print version info
			v)
				echo "Version ${vers}"
				exit 1
			;;
			##output to command line
			c)
				kill_on_multiple_outputs
				cli=true
			;;
			##Write to file
			o)
				kill_on_multiple_outputs
				file=true
				filename=${OPTARG}
			;;
			##use netcat
			n)
				kill_on_multiple_outputs
				netcat=true
				IFS=':' read -ra PARTS <<< "${OPTARG}"
				host=${PARTS[0]}
				port=${PARTS[1]}
			;;
			\?)
				print_usage
#				echo
#				echo "Invalid option: -${OPTARG}" >&2
				exit 1
			;;
		esac
	done
}

function kill_on_multiple_outputs()
{
	if ((${netcat}) || (${cli}) || (${file}))
	then
		echo
		echo "You have selected multiple output options."
		echo
		print_usage
		exit 1
	fi
}

function print_globals()
{
	echo script    ${script}
	echo vers      ${vers}
	echo cli       ${cli}
	echo file      ${file}
	echo filename  ${filename}
	echo netcat    ${netcat}
	echo port      ${port}
	echo host      ${host}

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

function print_usage()
{
	read -d '' USAGE <<- EOF
Usage: ${script} [ -h | -v | -c | -o <file> | -n <host:port> ]

Arguments
  -h              help
  -v              version
  -c              output to standard out (default)
  -o <file>       output to file
  -n <host:port>  output to netcat
EOF
	echo "${USAGE}"
	echo
}


main "${@}"
