--This code is auto generated you can customized it without overwrite
--Code generation Command: `orcli ffi klib/so/luac.cpp Roaring64Map luac.so`
--[[
g++ -I include/ -I cpp/ -I src/ -O3 -g -Wall -Wextra -Wno-return-local-addr -fpic -std=c++11 -Wl,rpath=/usr/local/openresty/nginx/lib -c luac.cpp
g++ luac.o xxhash.o -shared -o luac.so && mv luac.so /usr/local/openresty/site/lualib/ -f
orcli ffi /code/CRoaring/luac.cpp Roaring64Map luac.so /usr/local/openresty/nginx/
]]
---@type ffi
local ffi = require "ffi"
local C = ffi.C
local ffi_utils = require('resty.ffi_utils')
local get_string_buf = ffi_utils.get_string_buf
local get_number_list_buf = ffi_utils.get_number_list_buf
local create_number_list = ffi_utils.create_number_list
local ffi_string = ffi.string
local number_list_type = ffi_utils.number_list_type
local tonumber, tostring, type = tonumber, tostring, type

---@type resty.roaring.base
local libc = ffi_utils.load_shared_lib("librestyroaring.so")

local base = require("resty.roaring.base")
ffi.cdef([[//your definition on here
typedef struct Roaring64Map Roaring64Map;
typedef struct Roaring Roaring;

]] .. base.cdef)

---@class resty.roaring:resty.roaring.base
---@field id number @ used in Roaring64Map_pool
---@field cdata cdata @ internal cpp/c pointer
---@field is_32bit boolean @ internal cpp/c pointer
local _M = { _version = '0.1', libc = libc }
setmetatable(_M, { __index = base })

local mt = { __index = _M, __tostring = _M.tostring }

---new
---@param bytes_or_num_list number[]|string|cdata @ number list, binary string bytes, cdata pointer are accepted
---@param is_32bit boolean
function _M.new(bytes_or_num_list, is_32bit)
	if is_32bit then
		return _M.new32(bytes_or_num_list)
	end
	---@type resty.roaring
	local inst = {
		libc = libc
	}
	setmetatable(inst, mt)
	local tp = type(bytes_or_num_list)
	if tp == 'table' and bytes_or_num_list[1] then
		inst.cdata = base.new_Roaring64Map(inst)
		inst:addMany(bytes_or_num_list)
	elseif tp == 'cdata' then
		inst.cdata = bytes_or_num_list
	else
		inst.cdata = base.new_Roaring64Map(inst, bytes_or_num_list)
	end
	ffi.gc(inst.cdata, libc.delete_Roaring64Map)
	return inst
end

---new
---@param bytes_or_num_list number[]|string|cdata @ number list, binary string bytes, cdata pointer are accepted
---@return resty.roaring
function _M.new32(bytes_or_num_list)
	---@type resty.roaring
	local inst = {
		is_32bit = true,
		libc = libc
	}
	setmetatable(inst, mt)
	local tp = type(bytes_or_num_list)
	if tp == 'table' and bytes_or_num_list[1] then
		inst.cdata = base.new_Roaring(inst)
		inst:addMany(bytes_or_num_list)
	elseif tp == 'cdata' then
		inst.cdata = bytes_or_num_list
	else
		inst.cdata = libc.new_Roaring(bytes_or_num_list)
	end
	ffi.gc(inst.cdata, libc.delete_Roaring)
	return inst
end

---clone
---@return resty.roaring
function _M:clone()
	if not self.cdata then
		return
	end
	local str = self:tostring()
	if self.is_32bit then
		return _M.new32(str)
	else
		return _M.new(str)
	end
end

local list_mt = {
	__pairs = function(tbl)
		-- Iterator function
		local function stateless_iter(tbl, i)
			-- Implement your own index, value selection logic
			i = i + 1
			--ngx.say(tbl.t.len)
			if i > tbl._len then
				return -- break the loop
			end
			local v = tbl._t[i - 1]
			if v then
				return i, v
			end
		end
		-- return iterator function, table, and starting point
		return stateless_iter, tbl, 0
	end,
	__len = function(tbl)
		return tbl._len + 1
	end,
	__index = function(tbl, key)
		if not key then
			return
		end
		if key > tbl._len then
			return
		end
		return tbl._t[key - 1]
	end,
	--__gc = function()
	--	self._t = nil
	--	self._len = nil
	--end
}

---tostring
---@return string
function _M:tostring()
	local len, dst
	if self.is_32bit then
		len = tonumber(libc.r32_byte_size(self.cdata))
		dst = get_string_buf(len)
		libc.r32_tostring(self.cdata, dst)
	else
		len = tonumber(libc.r64_byte_size(self.cdata))
		dst = get_string_buf(len)
		libc.r64_tostring(self.cdata, dst)
	end
	local str = ffi_string(dst, len)
	dst = nil
	return str
end

---dispose should be called before manual destroyed
function _M:dispose()
	--if self.is_32bit then
	--	self.libc.delete_Roaring(self.cdata)
	--else
	--	self.libc.delete_Roaring64Map(self.cdata)
	--end
	self.cdata = nil
end

---add_hash
---@param uid any @ char*
---@param length any @ int
function _M:add_hash(uid)
	if self.is_32bit then
		return libc.r32_add_hash(self.cdata, uid, #uid)
	else
		return libc.r64_add_hash(self.cdata, uid, #uid)
	end
end

---add
---@param num number @
---@return boolean @ indicate add success or not
function _M:add(num)
	if self.is_32bit then
		local is_changed = libc.r32_addChecked(self.cdata, num)
		if is_changed then
			self.is_changed = is_changed or self.is_changed
		end
		return is_changed
	else
		local is_changed = libc.r64_addChecked(self.cdata, num)
		if is_changed then
			self.is_changed = is_changed or self.is_changed
		end
		return is_changed
	end
end

---remove
---@param num number @
function _M:remove(num)
	if self.is_32bit then
		return libc.r32_remove(self.cdata, num)
	else
		return libc.r64_remove(self.cdata, num)
	end
end

function _M:byte_size()
	if self.is_32bit then
		return tonumber(libc.r32_byte_size(self.cdata))
	else
		return tonumber(libc.r64_byte_size(self.cdata))
	end
end

---xxhash64
---@param str any @ char*
function _M.xxhash64(str, seed)
	local dst = get_string_buf(8)
	local ull = libc.r64_xxhash64(str, #str, seed or 33, dst)
	local b = ffi_string(dst, 8)
	dst = nil
	return b, ull
end

---xxhash32
---@param str any @ char*
function _M.xxhash32(str, seed)
	return libc.r64_xxhash32(str, #str, seed or 33)
end

---bytes_from_uint64
---@param number number @ uint64_t
---@param result string @ char*
function _M:bytes_from_uint64(number)
	local dst = get_string_buf(8)
	libc.r64_bytes_from_uint64(number, dst)
	local b = ffi_string(dst, 8)
	dst = nil
	return b
end

---r64_bitmapOf
---@param n1 number @ int64_t
---@param n2 number @ int64_t
---@param n3 number @ int64_t
---@param n4 number @ int64_t
---@param n5 number @ int64_t
---@param n6 number @ int64_t
---@param n7 number @ int64_t
---@param n8 number @ int64_t
---@param n9 number @ int64_t
---@param n10 number @ int64_t
---@return resty.roaring
function _M:bitmapOf(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10)
	if self.is_32bit then
		libc.r32_bitmapOf(self.cdata, n1, n2 or 0, n3 or 0, n4 or 0, n5 or 0, n6 or 0, n7 or 0, n8 or 0, n9 or 0, n10 or 0)
		return self
	else
		libc.r64_bitmapOf(self.cdata, n1, n2 or 0, n3 or 0, n4 or 0, n5 or 0, n6 or 0, n7 or 0, n8 or 0, n9 or 0, n10 or 0)
		return self
	end

end

---r64_count
---@return any @ uint64_t
function _M:count()
	if self.is_32bit then
		return libc.r32_count(self.cdata)
	else
		return tonumber(libc.r64_count(self.cdata))
	end
end

---list
---@param is_raw boolean @ with is_raw true, raw cdata will be returned and will be only iterate with `for i = 0, len do`
---@return number[], number @ number_list, list_length, with is_raw, index start with 0!!!
function _M:list(is_raw)
	local size = self:count()
	local list
	if self.is_32bit then
		list = get_number_list_buf(size, number_list_type.uint32)
		libc.r32_list(self.cdata, list)
	else
		list = get_number_list_buf(size, number_list_type.uint64)
		libc.r64_list(self.cdata, list)
	end
	if is_raw then
		return list, size
	end
	local arr = { _t = list, _len = tonumber(size) }
	setmetatable(arr, list_mt)
	return arr, size
end

---addMany
---@param num_list number[]
---@param len number
function _M:addMany(num_list, len)
	len = len or #num_list
	local list
	if self.is_32bit then
		list = create_number_list(num_list, ffi_utils.number_list_type.uint32)
		libc.r32_addMany(self.cdata, len, list)
		list = nil
	else
		list = create_number_list(num_list, ffi_utils.number_list_type.uint64)
		libc.r64_addMany(self.cdata, len, list)
		list = nil
	end
	return self
end

---contains
---@param num number @ uint64_t
---@return boolean @ bool
function _M:contains(num)
	if self.is_32bit then
		return libc.r32_contains(self.cdata, num)
	else
		return libc.r64_contains(self.cdata, num)
	end
end

---minimum
---@return number @ bool
function _M:minimum()
	if self.is_32bit then
		return tonumber(libc.r32_minimum(self.cdata))
	else
		return libc.r64_minimum(self.cdata)
	end
end

---maximum
---@return number @ size_t
function _M:maximum()
	if self.is_32bit then
		return tonumber(libc.r32_maximum(self.cdata))
	else
		return libc.r64_maximum(self.cdata)
	end
end

---intersect_map (and 2maps)
---@param target resty.roaring|string
function _M:intersect_map(target)
	local is_byte = type(target) == 'string'
	if self.is_32bit then
		if is_byte then
			target = libc.new_Roaring(target)
			return libc.r32_intersect_map(self.cdata, target)
		end
		return libc.r32_intersect_map(self.cdata, target.cdata)
	else
		if is_byte then
			target = libc.new_Roaring64Map(target)
			return libc.r64_intersect_map(self.cdata, target)
		end
		return libc.r64_intersect_map(self.cdata, target.cdata)
	end
end

---remove_map (and-not 2 maps)
---@param target resty.roaring|string
function _M:remove_map(target)
	local is_byte = type(target) == 'string'
	if self.is_32bit then
		if is_byte then
			target = libc.new_Roaring(target)
			return libc.r32_remove_map(self.cdata, target)
		end
		return libc.r32_remove_map(self.cdata, target.cdata)
	else
		if is_byte then
			target = libc.new_Roaring64Map(target)
			return libc.r64_remove_map(self.cdata, target)
		end
		return libc.r64_remove_map(self.cdata, target.cdata)
	end
end

---add_map (or 2 maps)
---@param target resty.roaring|string
function _M:add_map(target)
	local is_byte = type(target) == 'string'
	if self.is_32bit then
		if is_byte then
			target = libc.new_Roaring(target)
			return libc.r32_add_map(self.cdata, target)
		end
		return libc.r32_add_map(self.cdata, target.cdata)
	else
		if is_byte then
			target = libc.new_Roaring64Map(target)
			return libc.r64_add_map(self.cdata, target)
		end
		return libc.r64_add_map(self.cdata, target.cdata)
	end
end

---removeChecked indicate remove `x` is success or not
---@param x number @ uint64_t
---@return boolean @ bool
function _M:removeChecked(x)
	if self.is_32bit then
		return libc.r32_removeChecked(self.cdata, x)
	else
		return libc.r64_removeChecked(self.cdata, x)
	end
end

---get_list_from_bytes
---@param bytes string
---@param is_raw boolean
function _M.get_list_from_bytes(bytes, is_64bit, is_raw)
	local r
	if is_64bit then
		r = _M.new(bytes)
	else
		r = _M.new32(bytes)
	end
	if r then
		return r:list(is_raw)
	end
end


---new
---@param bytes_or_num_list number[]|string|cdata @ number list, binary string bytes, cdata pointer are accepted
---@return resty.roaring
function _M.flip(nstart, nstop)
	---@type resty.roaring
	local inst = {
		is_32bit = true,
		libc = libc
	}
	setmetatable(inst, mt)
	local tp = type(bytes_or_num_list)
	if tp == 'table' and bytes_or_num_list[1] then
		inst.cdata = base.new_Roaring(inst)
		inst:addMany(bytes_or_num_list)
	elseif tp == 'cdata' then
		inst.cdata = bytes_or_num_list
	else
		inst.cdata = libc.new_Roaring(bytes_or_num_list)
	end
	ffi.gc(inst.cdata, libc.delete_Roaring)
	return inst
end

return _M


--[[
memory consumption calculation map for given id range and id counts
random keys 1-4294967295
count   |size-uint32-max|size-100M	|size-50M	|size-5M
-|-|-|-|-
50000000|	99,944,300	|62562732	|12,513,208	|10782
5000000	|	10,518,468	|10010996	|9766088	|631408
500000	|	1,524,030	|1060550	|1009680	|626936
50000	|	380,552		|160988		|112182		|100078
5000	|	48,488		|39608		|21804		|10618
500		|	4,992		|4856		|4456		|1608
50		|	508			|508		|404
5		|	58
]]