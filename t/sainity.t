# https://metacpan.org/pod/Test::Nginx::Socket
use Test::Nginx::Socket::Lua 'no_plan';

log_level('info');

our $HttpConfig = <<'_EOC_';
    lua_socket_log_errors off;
    lua_package_path 'lib/?.lua;/usr/local/share/lua/5.3/?.lua;/usr/share/lua/5.1/?.lua;;';
_EOC_

run_tests();

__DATA__

=== TEST 1: sanity_roar64
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua_block {
	local roar64 = require('resty.roaring.init')
	local roar = roar64.new()
local list = table.new(1000, 0)
local nc = 0
for i = 4096, 8192, 16 do
	nc = nc + 1
	list[nc] = i
end
for i = 16757215, 16777216, 128 do
	nc = nc + 1
	list[nc] = i
end

for i = 4294965295, 4294967296, 15 do
	nc = nc + 1
	list[nc] = i
end
	roar:addMany(list)
	local str = roar:tostring()
	local arr, len = roar:list()

	assert(#list, len)

	for i = 1, len do
		assert(tonumber(arr[i]), list[i], i .. ' index was wrong!')
	end

	assert(tonumber(roar:minimum()), 4096)
	assert(tonumber(roar:maximum()), 4294967290)
	roar:add(12)
	assert(roar:contains(12))
	assert(roar:contains(13) == false)

	assert(roar:count(), len + 1)

	--dump(roar:list())

	local m2 = roar64.new({ 1, 2, 3, 4 })
	local m3 = roar64.new({ 3, 4, 5, 6 })

	m2:add_map(m3)
	local res = { 1, 2, 3, 4, 5, 6 }
	local arr1, len = m2:list()
	assert(len, #res)
	for i = 1, len do
		assert(tonumber(arr1[i]), res[i])
	end
	m2:remove_map(m3)
	arr1, len = m2:list()
	assert(len, 2)
	assert(tonumber(arr1[1]) == 1)
	assert(tonumber(arr1[2]) == 2)

	m2 = roar64.new({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
	res = { 1, 2, 7, 8, 9, 10 }
	m2:remove_map(m3)
	arr1, len = m2:list()
	assert(len == #res)
	for i = 1, len do
		assert(tonumber(arr1[i]) == res[i])
	end

	m2 = roar.new({ 3, 4, 5, 7, 8, 9 })

	m2:intersect_map(m3)

	res = { 3, 4, 5 }

	arr1, len = m2:list()
	assert(len, #res)
	for i = 1, len do
		assert(tonumber(arr1[i]) ==  res[i])
	end

	m2:bitmapOf(1, 2, 3, 4, -5, 6)
	res = { 1, 2, 3, 4, 6 }
	arr1, len = m2:list()
	assert(len, #res)
	for i = 1, len do
		assert(tonumber(arr1[i]) == res[i])
	end

	local m4 = m2:clone()
	assert(m4:tostring() == m2:tostring())
	m2:add_hash('xxx1')
	m4:add_hash('xxx1')
	assert(m4:tostring() == m2:tostring())
	ngx.say('EndOfTest')
        }
    }
--- request
GET /t
--- error_log
--- error_code: 200
--- response_body
EndOfTest

=== TEST 1: sanity_roar32
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua_block {
	local roar64 = require('resty.roaring.init')
	local roar = roar64.new32()
local list = table.new(1000, 0)
local nc = 0
for i = 4096, 8192, 16 do
	nc = nc + 1
	list[nc] = i
end
for i = 16757215, 16777216, 128 do
	nc = nc + 1
	list[nc] = i
end

for i = 4294965295, 4294967296, 15 do
	nc = nc + 1
	list[nc] = i
end

roar:addMany(list)
	--roar = nil
	--roar:r32_addRange(1, 5000000)
	local str = roar:tostring()

	local arr, len = roar:list()

	assert(#list == len)

	for i = 1, len do
		assert(list[i], arr[i], i .. ' index was wrong!')
	end

	assert(roar:minimum() == 4096)
	assert(roar:maximum() == 4294967290)
	roar:add(12)
	assert(roar:contains(12) == true)
	assert(roar:contains(13) == false)

	assert(roar:count() == len + 1)

	local m2 = roar64.new32({ 1, 2, 3, 4 })
	local m3 = roar64.new32({ 3, 4, 5, 6 })

	m2:add_map(m3)
	local res = { 1, 2, 3, 4, 5, 6 }
	local arr1, len = m2:list()
	assert(len == #res)
	for i = 1, len do
		assert(arr1[i] == res[i])
	end
	m2:remove_map(m3)
	arr1, len = m2:list()
	assert(len, 2)
	assert(arr1[1], 1)
	assert(arr1[2], 2)

	m2 = roar.new32({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
	res = { 1, 2, 7, 8, 9, 10 }
	m2:remove_map(m3)
	arr1, len = m2:list()
	assert(len == #res)
	for i = 1, len do
		assert(arr1[i] == res[i])
	end

	m2 = roar.new32({ 3, 4, 5, 7, 8, 9 })

	m2:intersect_map(m3)
	res = { 3, 4, 5 }

	arr1, len = m2:list()
	assert(len, #res)
	for i = 1, len do
		assert(arr1[i] == res[i])
	end

	m2:bitmapOf(1, 2, 3, 4, -5, 6)
	res = { 1, 2, 3, 4, 6 }
	arr1, len = m2:list()
	assert(len == #res)
	for i = 1, len do
		assert(arr1[i] == res[i])
	end
	--
	local m4 = m2:clone()
	assert(m4:tostring() == m2:tostring())
	m2:add_hash('cxxx1')
	m4:add_hash('cxxx1')
	assert(m4:tostring() == m2:tostring())
	
	m2 = roar64.new32()
	local len = 10
	local arr = {}
	local prefix = 'ux'
	for i = 1, len do
		local uid = prefix .. i;
		arr[i] = m2:add_hash(uid) * -1
	end
	assert(m2:count() == len)


	m3 = roar64.new32({ 1, 2, 3, 4, 5, 6 })
	m2 = roar64.new32({ 7, 8, 9, 11, 10 })
	str = m2:tostring()
	m3:add_map(str)
	list, len = m3:list()
	res = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 }
	for i = 1, #res do
		assert(list[i] == res[i])
	end
	ngx.say('EndOfTest')
        }
    }
--- request
GET /t
--- error_log
--- error_code: 200
--- response_body
EndOfTest
