INST_PREFIX ?= /usr/local
INST_LIBDIR ?= /usr/local/openresty/site/lualib
INST_LUADIR ?= /usr/local/openresty/site/lualib
INSTALL ?= install
UNAME ?= $(shell uname)
OR_EXEC ?= $(shell which openresty)
CC = g++
# LUAROCKS_VER ?= $(shell luarocks --version | grep -E -o  "luarocks [0-9]+.")
LUAJIT_DIR ?= $(shell ${OR_EXEC} -V 2>&1 | grep prefix | grep -Eo 'prefix=(.*)/nginx\s+--' | grep -Eo '/.*/')luajit

CFLAGS := -O3 -g -Wall -Wextra -Wno-return-local-addr -fpic -std=c++11

C_SO_NAME := librestyroaring.so
LDFLAGS := -shared -L/usr/local/lib/ -lxxhash -lroaring

# on Mac OS X, one should set instead:
# for Mac OS X environment, use one of options
ifeq ($(UNAME),Darwin)
	LDFLAGS := -bundle -undefined dynamic_lookup
	C_SO_NAME := librestyroaring.dylib
endif

MY_CFLAGS := $(CFLAGS) -DBUILDING_SO -c src/luac.cpp
MY_LDFLAGS := $(LDFLAGS) -fvisibility=hidden
SRC := $(wildcard src/*.cpp)

CRoaringVersion := 0.3.4

.PHONY: default
default: deps compile


### Downloading croaring from unity build
### Downloading xxhash github
.PHONY: deps
deps:
    git clone https://github.com/RoaringBitmap/CRoaring.git
	cd CRoaring && ./amalgamation.sh
	cd CRoaring  && cc -O3 -std=c11 -shared -o libroaring.so -fPIC roaring.c && mv libroaring.so /usr/lib/
	ln -sf /usr/lib/libroaring.so /usr/lib/libroaring.so.2


### test:         Run test suite. Use test=... for specific tests
.PHONY: test
test: compile
	TEST_NGINX_LOG_LEVEL=info \
	prove -I../test-nginx/lib -r -s t/


### clean:        Remove generated files
.PHONY: clean
clean:
	rm -f $(C_SO_NAME) *.o


### compile:      Compile library
.PHONY: compile

#compile: ${OBJS} $(C_SO_NAME)
compile:
	$(CC) $(MY_CFLAGS)
	$(CC) luac.o $(LDFLAGS) -o $(C_SO_NAME)


### install:      Install the library to runtime
.PHONY: install
install:
	$(INSTALL) -d $(INST_LUADIR)/resty/roaring
	$(INSTALL) lib/resty/*.lua $(INST_LUADIR)/resty/
	$(INSTALL) lib/resty/roaring/*.lua $(INST_LUADIR)/resty/roaring
	$(INSTALL) $(C_SO_NAME) $(INST_LIBDIR)/

.PHONY: uninstall
uninstall:
	rm -rf $(INST_LUADIR)/resty/roaring
	rm -f $(INST_LIBDIR)/$(C_SO_NAME)

### lint:         Lint Lua source code
.PHONY: lint
lint:
	luacheck -q lib



# g++ -O3 -g -Wall -Wextra -Wno-return-local-addr -fpic -std=c++11 -DBUILDING_SO -c src/luac.cpp

# g++ luac.o -shared -L/usr/lib64/ -L/usr/lib/ -lxxhash -o librestyroaring.so