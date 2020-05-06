INST_PREFIX ?= /usr
INST_LIBDIR ?= $(INST_PREFIX)/lib/lua/5.1
INST_LUADIR ?= $(INST_PREFIX)/share/lua/5.1
INSTALL ?= install
UNAME ?= $(shell uname)
OR_EXEC ?= $(shell which openresty)
CC = g++
# LUAROCKS_VER ?= $(shell luarocks --version | grep -E -o  "luarocks [0-9]+.")
LUAJIT_DIR ?= $(shell ${OR_EXEC} -V 2>&1 | grep prefix | grep -Eo 'prefix=(.*)/nginx\s+--' | grep -Eo '/.*/')luajit

CFLAGS := -O3 -g -Wall -Wextra -Wno-return-local-addr -fpic -std=c++11

C_SO_NAME := librestyroaring.so
LDFLAGS := -shared -L/usr/lib64/ -L/usr/lib/ -lxxhash

# on Mac OS X, one should set instead:
# for Mac OS X environment, use one of options
ifeq ($(UNAME),Darwin)
	LDFLAGS := -bundle -undefined dynamic_lookup
	C_SO_NAME := librestyroaring.dylib
endif

MY_CFLAGS := $(CFLAGS) -DBUILDING_SO -c src/luac.cpp
MY_LDFLAGS := $(LDFLAGS) -fvisibility=hidden
SRC := $(wildcard src/*.cpp)

CRoaringVersion := 0.2.66

.PHONY: default
default: compile


### Downloading croaring from unity build
.PHONY: deps
depens:
	rm -rf src/roaring
	curl https://github.com/lemire/CRoaringUnityBuild/archive/v${CRoaringVersion}.tar.gz -Lk | tar -xvz -C src/
	mv src/CRoar* src/roaring


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
	$(INSTALL) -d $(INST_LUADIR)/resty/
	$(INSTALL) lib/resty/*.lua $(INST_LUADIR)/resty/
	$(INSTALL) $(C_SO_NAME) $(INST_LIBDIR)/

### lint:         Lint Lua source code
.PHONY: lint
lint:
	luacheck -q lib



# g++ -O3 -g -Wall -Wextra -Wno-return-local-addr -fpic -std=c++11 -DBUILDING_SO -c src/luac.cpp

# g++ luac.o -shared -L/usr/lib64/ -L/usr/lib/ -lxxhash -o librestyroaring.so