## fuqiyang
##
## 2017-05-08


## global variable, also can define in "make xxx=xxx"
##
host ?= "https://api.webrtc.win:6401/v1"

signal_ws ?= "ws://signal.webrtc.win:7600/ws"

signal_wss ?= "wss://signal.webrtc.win:7601/ws"

version ?= "165"

#url ?= "https://git.oschina.net/FogVDN/Node-update/raw/master"
url ?= "https://update.webrtc.win"

update_data_dirs_name=$(patsubst update-data/%/,%,$(shell ls -d update-data/*/))


## function
##
define printf_color
	@echo "\033[33m${1}\033[0m"
endef


## target
##
all : pack_update_data json_raw_file_create json_raw_file_show json_platform_file_create upload_to_oschina
	$(call printf_color,"finish...")


pack_update_data :
	$(call printf_color,"[pack_update_data]")
	make -C ./update-data


json_raw_file_create :
	$(call printf_color,"[json_raw_file_create]")
	for dir in ${update_data_dirs_name};																\
	do																									\
		echo "{" > $${dir}.json.raw;																	\
		echo "\"fogvdn_force_update\": \"yes\"," >> $${dir}.json.raw;									\
		echo "\"fogvdn_host\": \"$(host)\"," >> $${dir}.json.raw;										\
		echo "\"fogvdn_signal_ws\":\"$(signal_ws)\"," >> $${dir}.json.raw;								\
		echo "\"fogvdn_signal_wss\":\"$(signal_wss)\"," >> $${dir}.json.raw;							\
		echo "\"fogvdn_version\": \"$(version)\"," >> $${dir}.json.raw;									\
		echo "\"fogvdn_url\": \"$(url)/$${dir}.tar.gz\"," >> $${dir}.json.raw;						\
		echo "\"fogvdn_md5\": \"$$(md5sum $${dir}.tar.gz | awk '{print $$1}')\"" >> $${dir}.json.raw;	\
		echo "}" >> $${dir}.json.raw;																	\
	done


json_raw_file_show :
	$(call printf_color,"[json_raw_file_show]")
	for dir in ${update_data_dirs_name};	\
	do										\
		cat $${dir}.json.raw;				\
	done
	

json_platform_file_create :
	$(call printf_color,"[json_platform_file_create]")
	for dir in ${update_data_dirs_name};									\
	do																		\
		base64  ./$${dir}.json.raw | tr -d  '\n' > ./$${dir}.json;			\
	done

upload_to_server:
	echo "ok"

upload_to_oschina:	
	$(call printf_color,"[upload]")
	rm -rf fog*.json.raw
	git add . && git commit -m "update" && git push origin

help :
	$(call printf_color,"[help]")
	@echo "make [host=? signal_ws=? signal_wss=? version=? url=?]"


clean:
	@-rm -rf *json*
	make -C ./update-data clean


.PHONY : json_raw_file_create json_raw_file_show json_platform_file_create pack_update_data upload





