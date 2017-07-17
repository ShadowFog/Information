#!/bin/sh
#
## AUTHOR: fuqiyang
#
## 2017-05-05
#
## reference from http://www.dnspod.cn/docs/records.html#record-modify
#


## ------------- global variable --------------
#
global_token=${1}

global_mac=${2}

global_domain=${3}

global_extern_ip=${4}

global_out_recordID="init"



## ------------- private function --------------
#
# nothing
#
##


## ------------- global function ---------------
#
## function: do ddns operations
##
## argument: 
## 			${1}-Create, List, Modify, Remove, Ddns, Remark, Info, Status
##
pear_curl_post() {

	local request="https://dnsapi.cn/Record.${1} -d login_token=${global_token}&format=json&domain=${global_domain}"

	case "${1}" in
		Create)
			request="${request}&sub_domain=${global_mac}&record_type=A&record_line=默认&value=${global_extern_ip}"
			;;
		List)
			request="${request}&sub_domain=${global_mac}"
			;;
		Modify)
			request="${request}&record_id=${global_out_recordID}&sub_domain=${global_mac}&value=${global_extern_ip}&record_type=A&record_line=默认"
			;;
		Remove)
			request="${request}&record_id=${global_out_recordID}"
			;;
		Ddns)
			request="${request}&record_id=${global_out_recordID}&sub_domain=${global_domain}"
			;;
		Remark)
			request="${request}&record_id=${global_out_recordID}&remark=test"
			;;
		Info)
			request="${request}&record_id=${global_out_recordID}"
			;;
		Status)
			request="${request}&record_id=${global_out_recordID}&status=disable"
			;;
		*)
			;;
		esac

	curl -X POST ${request}
}


## function: if record exist, store record_id in global_out_recordID
##
pear_record_is_exist() {

    # Get Record ID
	#
    global_out_recordID=$(pear_curl_post List 2>/dev/null)
    global_out_recordID=$(echo ${global_out_recordID} | sed 's/.*\[{"id":"\([0-9]*\)".*/\1/')

    ## Output ID
	#
    case "$global_out_recordID" in 
      [1-9][0-9]*)
	  	return 0
        ;;
      *)
	  	return 1
        ;;
    esac
}

## ----------------  main  -------------

# 1.Modify record when record exist

if pear_record_is_exist
then

	echo -n "exist: ${global_out_recordID}\n"

	pear_curl_post Modify 2>/dev/null

## 2.add new record when record not exist
#
else

	echo -n "not exist: ${global_out_recordID}\n"

	pear_curl_post Create 2>/dev/null

fi
