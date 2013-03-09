#!/bin/bash
##The goal of this script of to automate the gathering and exportation of data, as well as provide the ability to run the tools individually

##Libraries should be statically linked to the executables called and included with script

##Check for root permissions.
if [[ $UID -ne 0 ]]; then
        echo "$0 must be run as root"
        exit 1
fi

USAGE="Usage: $0 dir1 dir2 dir3 ... dirN"

if [ "$#" == "0" ]; then
        echo "$USAGE"
        exit 1
fi

vers="0.0.1a"
port="0";
host="nope";
netcat=false;
file=false;
filename="";
cli=false;
output="";
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
        C)
        cli=true;
        ;;
        \?)
        echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done
echo "$port $host"

if ! $netcat
        then
        output=" | nc -q 1 $port $host"
fi

#exit 1




##For now, just straight command line output (0), then netcat(1), then write to file(2)

#echo $output

##get start date and time
junk=date

## Network State
junk=$junk netstat -an

echo $junk

exit 1
##Running Processes
ps -aux

##Open ports and files
lsof -p

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
##logs



#####

##user group information
cat /etc/passwd

##users who have logged on
ls /home
##GET .bash_history files

##OS Information
uname -a
date

##Loaded Kernel Modules
lsmod


##End date and time
date
