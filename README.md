# lua-resty-roaring
Croaring binding for luajit with openresty

Integrated with high performance roaring function C/C++ implementation
Orginally from https://github.com/RoaringBitmap/CRoaring

Integrated with high performance xxhash32, xxhash64
Originally from Y.C. https://github.com/Cyan4973/xxHash

local test cases passed
# Installation
## From Source 
```bash
#uncomment following comment incase you need customize installation location with default openresty installed
# export INST_LIBDIR=/usr/local/openresty/site/lualib
# export INST_LUADIR=/usr/local/openresty/site/lualib
git clone https://github.com/yorkane/lua-resty-roaring.git
cd lua-resty-roaring
make && make install
```

## Luarocks
```bash
#uncomment following comment incase you need customize installation location
# export INST_LIBDIR=/usr/local/lib/lua/5.1 
# export INST_LUADIR=/usr/local/share/lua/5.1
luarocks install lua-resty-roaring
```

# Usages:
```lua
local bec = require('resty.xxhashencode')
local b = bec.uint_byte(bec.max_int)
local num = bec.byte_uint(b)
local ulong = bec.xxhash64(teststr)

```

# Todo
Separate test cases from orginal test-suits-pack