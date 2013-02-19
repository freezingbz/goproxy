### Makefile --- 

## Author: shell@shell-deb.shdiv.qizhitech.com
## Version: $Id: Makefile,v 0.0 2012/11/02 06:18:14 shell Exp $
## Keywords: 
## X-URL: 
TARGET=goproxy

all: clean build

build: $(TARGET)

install:
	install -d $(DESTDIR)/usr/bin/
	install goproxy $(DESTDIR)/usr/bin/
	install daemonized $(DESTDIR)/usr/bin/
	install -d $(DESTDIR)/usr/share/goproxy/
	install routes.list.gz $(DESTDIR)/usr/share/goproxy/
	install -d $(DESTDIR)/etc/goproxy/
	install resolv.conf $(DESTDIR)/etc/goproxy/

clean:
	rm -f $(TARGET)

goproxy: goproxy.go server.go client.go httproxy.go dail.go
	go build -o $@ $^
	strip $@
	chmod 755 $@

glookup: glookup.go dail.go
	go build -o $@ $^
	strip $@
	chmod 755 $@

tsrv: goproxy
	./goproxy -loglevel=DEBUG -mode=server -passfile=users.pwd

# tcli: goproxy
# 	./goproxy -loglevel=DEBUG -black=routes.list.gz -mode=client -listen :1080 localhost:5233

tpxy: goproxy
	./goproxy -loglevel=DEBUG -black=routes.list.gz -mode=httproxy -listen :8118 -username=shell -password=123 localhost:5233

### Makefile ends here
