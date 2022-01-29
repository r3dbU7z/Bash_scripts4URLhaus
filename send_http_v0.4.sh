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

#Logs path
log_path="/cygdrive/e/tmp/urlhaus_logs"
#URLhaus script path
urlhaus_path=./urlhaus.py
urlhaus=urlhaus.py

# urlhaus_path=../urlhaus.py
# urlhaus=urlhaus.py

if [ ! -f "$urlhaus" ]; then
    echo "$urlhaus does not exist. Aborting execution"
	exit 0
fi

if [ $# -lt 1 -o "$1" == "-h" -o "$1" == "--help" ]; then
	exec >&2
	sprtr
	echo "Usage: $0 [ -h | --help ]"
	echo "       $0 <address>/shellscript_name.sh -- Enter address HTTP-server : 144.233.0.1 AND shellscript path - e.g bins.sh" 
	echo "       $0 <address>:<port> -- Specify the HTTP-server port: <address>:8080"
	echo "       $0 <address> -t tag -- Default tag: 'mirai' "
	sprtr
	exit 0
fi

if [ $# -gt 1 -a "$2" == "-t" ]; then
		_tag=$3
		echo "Selected tag: ${_tag}"
	else
		_tag="mirai"
		echo "Selected tag: ${_tag}"
fi

#Set variables
URL_ADDR=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/')
URL_ADDR_HTTP=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )
IP_ADDR=$(echo $URL_ADDR | egrep -o '[f|ht]+tp://[^ ]+/' | awk -F'//' '{print $2}' | tr -d '/')

_dir_path=${PWD}/${_tag}_IP_$(echo ${IP_ADDR})


if [ $# -gt 2 -a "$4" == "-p" ]; then
	echo "Path: $5"
	dir_path=$5
	echo "Selected path: ${dir_path}"
	URL_ADDR_HTTP=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )${dir_path}/
	echo $URL_ADDR_HTTP
	else 
	dir_path=$(echo $1 | awk -F'/'  '{print $4}')
	echo "Selected path: ${dir_path}"
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
		mkdir -p ${log_path}/${_tag}
		#mkdir -p ${_dir_path}
		#cd ${_dir_path}
		echo "Submit URLs from IP: $URL_ADDR"
			for ((i = 0; i != length; i++)); do
   				${urlhaus_path} -t ${_tag} elf -u ${URL_ADDR_HTTP}"${_names[i]}" | 2>&1 tee -a\
					${log_path}/${_tag}/${_tag}_$(echo ${IP_ADDR}_date_$(date '+%Y-%m-%d')  | sed 's-:-_-').log
			done
	else
		echo "Nothing to do. Exit from the script"
		exit 0
fi
}

#Get samples name
_get_names
#Submit all url from shellscrit to URLhaus
_submit_urls

exit 0
