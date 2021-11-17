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
bash deps.sh
make && make install
```

## Luarocks
>Not support yet
```bash
#uncomment following comment incase you need customize installation location
# export INST_LIBDIR=/usr/local/lib/lua/5.1 
# export INST_LUADIR=/usr/local/share/lua/5.1
#luarocks install lua-resty-roaring
```

# Usages:
see `test.lua` `t/sainity.t`
```lua
local list = get_list()
roar:addMany(list)
--roar = nil
--roar:r32_addRange(1, 5000000)
local str = roar:tostring()

local arr, len = roar:list()

lu.assertEquals(#list, len)

for i = 1, len do
lu.assertEquals(list[i], arr[i], i .. ' index was wrong!')
end

lu.assertEquals(roar:minimum(), 4096)
lu.assertEquals(roar:maximum(), 4294967290)
roar:add(12)
lu.assertIsTrue(roar:contains(12))
lu.assertIsFalse(roar:contains(13))

lu.assertEquals(roar:count(), len + 1)

--dump(roar:list())

local m2 = roar64.new32({ 1, 2, 3, 4 })
local m3 = roar64.new32({ 3, 4, 5, 6 })

m2:add_map(m3)
local res = { 1, 2, 3, 4, 5, 6 }
local arr1, len = m2:list()
lu.assertEquals(len, #res)
for i = 1, len do
lu.assertEquals(arr1[i], res[i])
end
m2:remove_map(m3)
arr1, len = m2:list()
lu.assertEquals(len, 2)
lu.assertEquals(arr1[1], 1)
lu.assertEquals(arr1[2], 2)

m2 = roar.new32({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
res = { 1, 2, 7, 8, 9, 10 }
m2:remove_map(m3)
arr1, len = m2:list()
lu.assertEquals(len, #res)
for i = 1, len do
lu.assertEquals(arr1[i], res[i])
end

m2 = roar.new32({ 3, 4, 5, 7, 8, 9 })

m2:intersect_map(m3)
res = { 3, 4, 5 }

arr1, len = m2:list()
lu.assertEquals(len, #res)
for i = 1, len do
lu.assertEquals(arr1[i], res[i])
end

m2:bitmapOf(1, 2, 3, 4, -5, 6)
res = { 1, 2, 3, 4, 6 }
arr1, len = m2:list()
lu.assertEquals(len, #res)
for i = 1, len do
lu.assertEquals(arr1[i], res[i])
end

local m4 = m2:clone()
lu.assertEquals(m4:tostring(), m2:tostring())
m2:add_hash('cxxx1')
m4:add_hash('cxxx1')
lu.assertEquals(m4:tostring(), m2:tostring())

m2 = roar64.new32()
local len = 10
local arr = table.array(len)
local prefix = 'ux'
for i = 1, len do
local uid = prefix .. i;
arr[i] = m2:add_hash(uid) * -1
end
lu.assertEquals(m2:count(), len)
local str = m2:tostring()
--str = m2:bitmapOf(str, arr[1], arr[2], arr[3], arr[4], arr[5], arr[6], arr[7], arr[8], arr[9], arr[10])
--m3 = roar64.new32(str)
--lu.assertEquals(m3:count(), 0)

m3 = roar64.new32({ 1, 2, 3, 4, 5, 6 })
m2 = roar64.new32({ 7, 8, 9, 11, 10 })
str = m2:tostring()
m3:add_map(str)

--dump(roar64.new32(str):list())
list, len = m3:list()
res = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
for i = 1, #res do
lu.assertEquals(list[i], res[i])
end

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
