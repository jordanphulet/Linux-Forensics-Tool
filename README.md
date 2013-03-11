Linux-Forensics-Tool
====================

LiFT: A simple tool to quickly gather live forensic data from a linux system.

The Idea is that this tool will quickly run through some commands to gather
information on the host it is run on and optionally output to the command line,
write to a file, or stream over netcat to remote host.

Currently, information is gathered using the following:
* date
* netstat
* ps
* lsof
* route
* arp
* ifconfig
* top
* w
* last
* uname
* lsmod

Right now there are three output options: 

1. stdout
    lift.sh -c
2. output to file
    lift.sh -o [filename]
3. netcat
    lift.sh -n [host:port]
