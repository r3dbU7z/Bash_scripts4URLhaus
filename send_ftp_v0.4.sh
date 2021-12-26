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
log_path="...urlhaus_logs..." <- EDIT THIS 
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
	echo "       $0 <address> -t tag -- Default tag: 'gafgyt' "
	echo "       $0 <address> -t tag -- Default tag: 'gafgyt'  -p path"
	sprtr
	exit 0
fi

_tag="gafgyt"

while getopts "u:t:p:" opt
do
case $opt in
u) echo "Selected IP-address: $OPTARG"
	_url=$OPTARG
	URL_ADDR=$(echo $_url | egrep -o '[f|ht]+tp://[^ ]+/')
	URL_ADDR_HTTP=$(echo $_url| egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )
	;;
t) echo "Selected Tag: $OPTARG"
	_tag=$OPTARG
	;;
p) echo "Selected Path: $OPTARG"
	dir_path=$OPTARG
	URL_ADDR_HTTP=$(echo $_url | egrep -o '[f|ht]+tp://[^ ]+/' | sed 's/ftp/http/' )${dir_path}/
	;;
*) echo "No reasonable options found!";;
esac
done

#Set variables

IP_ADDR=$(echo $URL_ADDR | egrep -o '[f|ht]+tp://[^ ]+/' | awk -F'//' '{print $2}' | tr -d '/')

_dir_path=${PWD}/${_tag}_IP_$(echo ${IP_ADDR})
echo "Selected tag: ${_tag}"
echo "Selected path: ${dir_path}"

_get_names(){
	eval _names=(`curl -s ${URL_ADDR} | sed '/^d/d' | awk '{print $9}' | sed /^ftp1.sh$/d`)
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
