#!/bin/bash

#Debug section
set -o errexit
#set -o nounset
set -o pipefail
#set -o xtrace

#Separator
sprtr() {
echo $'\n'"================================================================"
}

if [ $# -lt 1 -o "$1" == "-h" -o "$1" == "--help" ]; then
	exec >&2
	sprtr
	printf  "Usage: $0 [ -h | --help ]\n"
	printf  "       $0 <address>:<port> -- Specify the HTTP-server port: <address>:8080\n"
	sprtr
	exit 0
fi

#Set variables
URL_ADDR=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/')
URL_ADDR_HTTP=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )
IP_ADDR=$(echo $URL_ADDR | egrep -o '[f|ht]+tp://[^ ]+/' | awk -F'//' '{print $2}' | tr -d '/')

_dir_path=${PWD}/${_tag}_IP_$(echo ${IP_ADDR})

if [ $# -gt 2 -a "$4" == "-p" ]; then
	printf  "Path: $5\n"
	dir_path=$5
	printf "Selected path: ${dir_path}\n"
	URL_ADDR_HTTP=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )${dir_path}/
	printf  "$URL_ADDR_HTTP\n"
	else 
	dir_path=$(echo $1 | awk -F'/'  '{print $4}')
	printf  "Selected path: ${dir_path}\n"
	URL_ADDR_HTTP=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )
fi

#exit 0

_get_names(){

	eval _names=(`curl -s ${URL_ADDR} | grep -io '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
	sed -e 's/^<a href=["'"'"']//i' -e 's/["'"'"']$//i' | sed  '/^[?|/|../]/d'`)
}

_submit_urls(){
	
length=${#_names[@]}

if [ $length -gt 0 ]; then #check whether there is load
		sprtr
		mkdir -p ${_dir_path}
		cd ${_dir_path}
		printf "Get files from HTTP-server: $URL_ADDR\n"
			for ((i = 0; i != length; i++)); do
				wget ${URL_ADDR_HTTP}"${_names[i]}" 
			done
		cd ..
	else
		printf "Nothing to do. Exit from the script\n"
		exit 0
fi
}

#Get samples name
_get_names
#Submit all url from shellscrit to URLhaus
_submit_urls

exit 0