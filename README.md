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
local roar = roar64.new('sdfds') -- treat as unsign int64
--local roar = roar64.new32() --treat as unsign int32
say(roar:count()) -- 0
local roar64 = require('resty.roaring')
local roar = roar64.new()
-- local k = roar64.new32()
roar:bitmapOf(1, 2, 3, 4, 5, 6)
roar:bitmapOf(-2)
local arr, count = roar:list()
roar:contains(6) -- true
roar:count() -- 5
roar:maximum() -- 6
say(roar:addMany({11, 12, 13, 14, 16}))
say(roar:maximum()) -- 16ULL
local bytes = roar:tostring()
say(#bytes) --48
local r2 = roar64.new(bytes)
say(r2:count()) --10
dump(r2:list())
--[[
{
	[1] = 1ULL,
	[2] = 3ULL,
	[3] = 4ULL,
	[4] = 5ULL,
	[5] = 6ULL,
	[6] = 11ULL,
	[7] = 12ULL,
	[8] = 13ULL,
	[9] = 14ULL,
	[10] = 16ULL
}
--]]

```

# Todo
Separate test cases from orginal test-suits-pack