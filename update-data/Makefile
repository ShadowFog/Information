## fuqiyang
##
## 2017-05-08

DIRS_NAME := $(patsubst %/,%,$(shell ls -d */))


all : 
	for dir_name in ${DIRS_NAME}; do make -C $${dir_name}; done


clean :
	for dir_name in ${DIRS_NAME}; do make -C $${dir_name} clean; done



