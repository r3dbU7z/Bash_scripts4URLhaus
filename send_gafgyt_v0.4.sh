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
	echo "       $0 <address>:<port>-- Specify the HTTP-server port: <address>:8080"
	echo "       $0 <address> -t tag -- Default tag: 'gafgyt' "
	echo "       $0 <address> -w  -- Set http type for shellscript"
	sprtr
	exit 0
fi

_tag="gafgyt"
shellscript_type="ftp"

if [ $# -gt 1 ]; then
	if [ "$2" == "-t" ]; then
		if [ -n "$3" ]; then
			_tag=$3
		fi
	else 
		if [ "$2" == "-w" ]; then
			shellscript_type="http"	
		fi
	fi
fi

if [ $# -gt 3 ]; then
	if [ "$4" == "-w" ]; then
		shellscript_type="http"
	fi
fi

echo $'\n'"Selected tag: ${_tag}"
echo $'\n'"Selected type: ${shellscript_type}"

#Set variables
URL_ADDR=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/')
IP_ADDR=$(echo $URL_ADDR | egrep -o '[f|ht]+tp://[^ ]+/' | awk -F'//' '{print $2}' | tr -d '/')
shellscript_path=$(echo $1 | awk -F'/'  '{print $4}')
_dir_path=${PWD}/${_tag}_IP_$(echo ${IP_ADDR})

_get_names(){

	if [ "$shellscript_type" == "http" ]; then
	  eval _names=(`wget -O - ${URL_ADDR}/${shellscript_path} | egrep -o 'https?://[^ ]+' | sed  '/;cat/d' | tr -d ";" | sort | uniq | tr -d "\r"`)
		
    else 
		if  [ "$shellscript_type" == "ftp" ];then
			eval _names=(`wget -O - ${URL_ADDR}/${shellscript_path} | awk -F'-P' '{print $2}' | awk -F ' ' '{print "http://"$2"/"$3}' | sort | uniq | tr -d "\r"`)
		fi
	fi
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
   				${urlhaus_path} -t ${_tag} elf -u "${_names[i]}" | 2>&1 tee -a\
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
