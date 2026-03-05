INSTALL := /home/dev/openresty-openspec/build/install

.PHONY: all install clean

all:
	cd /home/dev/openresty-openspec/build/LuaJIT-2.1-20250117 && $(MAKE) TARGET_STRIP=@: CCDEBUG=-g Q= XCFLAGS='-DLUAJIT_ENABLE_LUA52COMPAT -DLUA_USE_APICHECK -DLUA_USE_ASSERT' CC=cc PREFIX=/usr/local/home/dev/openresty-openspec/luajit
	cd /home/dev/openresty-openspec/build/lua-cjson-2.1.0.14 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/usr/local/home/dev/openresty-openspec/lualib LUA_MODULE_DIR=/usr/local/home/dev/openresty-openspec/lualib CJSON_CFLAGS="-g -O -fpic" CC=cc
	cd /home/dev/openresty-openspec/build/lua-resty-signal-0.04 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall -fpic" CC=cc
	cd /home/dev/openresty-openspec/build/lua-redis-parser-0.13 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall" CC=cc
	cd /home/dev/openresty-openspec/build/lua-rds-parser-0.06 && $(MAKE) DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall" CC=cc
	cd /home/dev/openresty-openspec/build/nginx-1.27.1 && $(MAKE)

install: all
	mkdir -p $(DESTDIR)/usr/local/home/dev/openresty-openspec/
	-cp /home/dev/openresty-openspec/COPYRIGHT $(DESTDIR)/usr/local/home/dev/openresty-openspec/
	cd /home/dev/openresty-openspec/build/LuaJIT-2.1-20250117 && $(MAKE) install TARGET_STRIP=@: CCDEBUG=-g Q= XCFLAGS='-DLUAJIT_ENABLE_LUA52COMPAT -DLUA_USE_APICHECK -DLUA_USE_ASSERT' CC=cc PREFIX=/usr/local/home/dev/openresty-openspec/luajit DESTDIR=$(DESTDIR)
	cd /home/dev/openresty-openspec/build/lua-cjson-2.1.0.14 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_CMODULE_DIR=/usr/local/home/dev/openresty-openspec/lualib LUA_MODULE_DIR=/usr/local/home/dev/openresty-openspec/lualib CJSON_CFLAGS="-g -O -fpic" CC=cc
	cd /home/dev/openresty-openspec/build/lua-resty-signal-0.04 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall -fpic" CC=cc
	cd /home/dev/openresty-openspec/build/lua-redis-parser-0.13 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall" CC=cc
	cd /home/dev/openresty-openspec/build/lua-rds-parser-0.06 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_INCLUDE_DIR=/home/dev/openresty-openspec/build/luajit-root/usr/local/home/dev/openresty-openspec/luajit/include/luajit-2.1 LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib CFLAGS="-g -O -Wall" CC=cc
	cd /home/dev/openresty-openspec/build/lua-resty-dns-0.23 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-memcached-0.17 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-redis-0.31 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-mysql-0.27 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-string-0.16 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-upload-0.11 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-websocket-0.12 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-lock-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-lrucache-0.15 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-core-0.1.31 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-upstream-healthcheck-0.08 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-limit-traffic-0.09 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-resty-shell-0.03 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	cd /home/dev/openresty-openspec/build/lua-tablepool-0.03 && $(MAKE) install DESTDIR=$(DESTDIR) LUA_LIB_DIR=/usr/local/home/dev/openresty-openspec/lualib INSTALL='$(INSTALL)'
	mkdir -p '$(DESTDIR)/usr/local/home/dev/openresty-openspec/bin/'
	cd /home/dev/openresty-openspec/build/opm-0.0.8 && $(INSTALL) bin/* '$(DESTDIR)/usr/local/home/dev/openresty-openspec/bin/'
	cd /home/dev/openresty-openspec/build/resty-cli-0.30 && $(INSTALL) bin/* $(DESTDIR)/usr/local/home/dev/openresty-openspec/bin/
	cp /home/dev/openresty-openspec/build/resty.index $(DESTDIR)/usr/local/home/dev/openresty-openspec/
	cp -r /home/dev/openresty-openspec/build/pod $(DESTDIR)/usr/local/home/dev/openresty-openspec/
	cd /home/dev/openresty-openspec/build/nginx-1.27.1 && $(MAKE) install DESTDIR=$(DESTDIR)
	mkdir -p $(DESTDIR)/usr/local/home/dev/openresty-openspec/site/lualib $(DESTDIR)/usr/local/home/dev/openresty-openspec/site/pod $(DESTDIR)/usr/local/home/dev/openresty-openspec/site/manifest
	ln -sf /usr/local/home/dev/openresty-openspec/nginx/sbin/nginx $(DESTDIR)/usr/local/home/dev/openresty-openspec/bin/openresty

clean:
	rm -rf build *.exe *.dll openresty-*
