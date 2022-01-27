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

urlhaus_path=./urlhaus.py
urlhaus=urlhaus.py

if [ ! -f "$urlhaus" ]; then
    echo "$urlhaus does not exist. Aborting execution"
	exit 0
fi

if [ $# -lt 1 -o "$1" == "-h" -o "$1" == "--help" ]; then
	exec >&2
	sprtr
	printf "Send URL to URLhaus. Hajime & Mozi Edition\n"
	printf "Usage: $0 <address> [ -h | --help ] -- Specify the HTTP-server address: http://192.168.10.16/ \n"
	printf "       $0 <address>/[:<port>/] -- Specify the HTTP-server <address>:port:  http://192.168.10.16:8080/\n"
	printf "       $0 <address>/ -t tag -- Specify the Tag: http://192.168.10.16/ -t Hajime\n"
	printf "       $0 <address>/ -n filename -- Specify the name for URLhaus: http://192.168.10.16/ -n Hajime\n"
	sprtr
	exit 0
fi

_tag="unknow"

#Set variables
URL_ADDR=$(echo $1 | egrep -o '[f|ht]+tp://[^ ]+/')

sample_hash=$(wget  --timeout=15 -O - -o /dev/null $URL_ADDR | md5sum | cut -d" " -f1)

printf "Sample MD5 hash: $sample_hash\n"

check_hash(){
	if [  $sample_hash == "5377e8f2ebdb280216c37a6195da9d6c" ]; then
		_tag="Hajime"
		printf "Selected tag: Hajime; Math sample 53377...\n"
	fi
	if [  $sample_hash == "9b6c3518a91d23ed77504b5416bfb5b3" ]; then
		_tag="Hajime"
		printf "Selected tag: Hajime; Math sample 9b6c3...\n"
	fi
	if [  $sample_hash == "b8ed2cb3e9fedec5b164ce84ad5a08d0" ]; then
		_tag="Hajime"
		printf "Selected tag: Hajime; Math sample b8ed2...\n"
	fi
	if [  $sample_hash == "3849f30b51a5c49e8d1546960cc206c7" ]; then 
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample 3849f...\n"
	fi
	if [  $sample_hash == "eec5c6c219535fba3a0492ea8118b397" ]; then 
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample eec5c...\n"
	fi
	if [  $sample_hash == "fbe51695e97a45dc61967dc3241a37dc" ]; then 
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample fbe51...\n"
	fi
	if [ $sample_hash == "d253b6fc961673435c0e034675f43cf6" ]; then
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample d253b6...\n"
	fi
	if [ $sample_hash == "59ce0baba11893f90527fc951ac69912" ]; then
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample 59ce0b...\n"
	fi
	if [ $sample_hash == "9a111588a7db15b796421bd13a949cd4" ]; then
		_tag="Mozi"
		printf "Selected tag: Mozi; Math sample 59ce0b...\n"
	fi	
	if [ $sample_hash == "5d4415f39431a1d99b0fa2f20e988b3b" ]; then
		printf "VT Green!\n"
		exit 0
	fi	
	if [ $sample_hash == "e0bd9b9d7cb8e75e1fcce4db575830a4" ]; then
		printf "VT Green!\n"
		exit 0
	fi	
	if [ $sample_hash == "86ac1aa43f8c580dfc2e1077e351ad72" ]; then
		printf "VT Green!\n"
		exit 0		
	fi	
	if [ $sample_hash == "dd7effbed0add9562414a7c5f0522153" ]; then
		printf "VT Green!\n"
		exit 0
	fi	
	if [ $sample_hash == "5b64fda2c6d21fe8a2eec38fb5015bdc" ]; then
		printf "VT Green!\n"
		exit 0
	fi	
	if [ $sample_hash == "0a0f1ef9fc3964643d998e43b5ea9464" ]; then
		printf "VT Green!\n"
		exit 0
	fi
}

#Check the sample on famous hash
check_hash

if [ $# -gt 1 ]; then
	if [ "$2" == "-t" ]; then
		if [ -n "$3" ]; then
			_tag=$3
		fi
	fi
fi

if [ $_tag == "unknow" ]; then
	printf "Please, input 'tag'  for sample: "
	read _tag
fi


_dir_path=${PWD}/${_tag} #_IP_$(echo ${IP_ADDR})
#_dir_path=${log_path}/${_tag} 

printf "Selected tag: ${_tag}\n"

_set_name(){
	 tag_flag=$(echo "${_tag,,}")
	if [ "$tag_flag" == "mozi" ]; then
		_name="Mozi"
	else
		_name=".i"
	fi
}

_submit_urls(){

length=${#_name[@]}

if [ $length -gt 0 ]; then #check whether there is load
		sprtr
		#mkdir -p ${_dir_path}
		mkdir -p ${log_path}/${_tag}
		#cd ${_dir_path}
		echo "Submit URLs from IP: $URL_ADDR"
   				${urlhaus_path} -t ${_tag} elf -u ${URL_ADDR}"$_name" | 2>&1 tee -a\
					${log_path}/${_tag}/${_tag}_$(echo ${IP_ADDR}_date_$(date '+%Y-%m-%d')  | sed 's-:-_-').log
	else
		echo "Nothing to do. Exit from the script"
		exit 0
fi
}

#Get samples name
_set_name

if [ $# -gt 1 ]; then
	if [ "$2" == "-n" ]; then
		if [ -n "$3" ]; then
			_name=$3
			printf "Selected filename: ${_name}\n"
		fi
	 fi
fi

#Submit all url from shellscrit to URLhaus
_submit_urls

exit 0
