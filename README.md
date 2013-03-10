Linux-Forensics-Tool
====================

LiFT: A simple tool to quickly gather live forensic data from a linux system.

The Idea is that this tool will quickly run through some commands to gather
information on the host it is run on and optionally output to the command line,
write to a file, or stream over netcat to remote host.

Currently, information is gathered using the following:
date
netstat
ps
lsof
route
arp
ifconfig
top
w
last
uname
lsmod

Right now there are two of the three output options working. 
You can write to a file
  lift -w <filename>

or You can stream over netcat
  lift -n -p <remote port> -h <remote host>

Eventually command line output with work. Theres a problem with the logic right now.
  lift -c

