
dir_name=$(notdir $(shell pwd))


all:
	@tar -zcvf ../../$(dir_name).tar.gz $(shell ls ./) --exclude=Makefile


clean:
	@rm -rf ../../$(dir_name).tar.gz

