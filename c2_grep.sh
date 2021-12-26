#!/usr/bin/env bash

#Debug section
set -o errexit
#set -o nounset
set -o pipefail
#set -o xtrace

#Separator
sprtr() {
echo $'\n'"================================================================"
}

if [ $# -lt 0 -o "$1" == "-h" -o "$1" == "--help" ]; then
	exec >&2
	sprtr
	printf "Grep binary file for IP adresses\n"
	printf "Usage: $0 [ -h | --help ]\n"
	printf "       $0 <filename> -- Specify the filen for search IP addresses\n"
	sprtr
	exit 0
fi


IP_ADDRS=$(strings $1 | grep -E -o "(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\:([0-9]{1,5})")

printf "Found IPs: $IP_ADDRS\n"

exit 0;
