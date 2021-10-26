local error, concat, find = error, table.concat, string.find
local tostring, tonumber, reverse, floor, byte, sub, char = tostring, tonumber, string.reverse, math.floor, string.byte, string.sub, string.char
local type = type
local ffi = require "ffi"
local ffi_new = ffi.new
local _M = {
	---@class ffi_utils.number_list_type
	number_list_type = {
		uint32 = 'uint32_t[',
		int32 = 'size_t[',
		long = 'long[',
		ulong = 'unsigned long[',
		uint64 = 'uint64_t['
	}
}
local number_list_type = _M.number_list_type

---load_shared_lib load `libxxx.so`
---@param so_name string @ relative path to `package.cpath` or full path
function _M.load_shared_lib(so_name)
	local tried_paths = {}
	local i = 1
	for k, _ in package.cpath:gmatch("[^;]+") do
		local fpath = k:match("(.*/)")
		fpath = fpath .. so_name
		local f = io.open(fpath)
		if f ~= nil then
			io.close(f)
			return ffi.load(fpath)
		end
		tried_paths[i] = fpath
		i = i + 1
	end
	local f = io.open(so_name)
	if f ~= nil then
		io.close(f)
		return ffi.load(so_name)
	end
	tried_paths[#tried_paths + 2] = 'tried above paths but can not load ' .. so_name
	error(concat(tried_paths, '\n'))
end

local str_buf_size = 4096
local str_buf
local c_buf_type = ffi.typeof("char[?]")
local uc_buf_type = ffi.typeof("unsigned char[?]")
local c_size_t_list = ffi.typeof("size_t[?]")

---get_string_buf create a referable string buffer to inject into C functions
---@param size number @ string buffer length, Larger than target content required!
---@return table
function _M.get_string_buf(size)
	if size > str_buf_size then
		return ffi_new(c_buf_type, size)
	end
	if not str_buf then
		str_buf = ffi_new(c_buf_type, str_buf_size)
	end
	return str_buf
end

function _M.get_ustring_buf(size)

	if size > str_buf_size then
		return ffi_new(uc_buf_type, size)
	end
	if not str_buf then
		str_buf = ffi_new(uc_buf_type, str_buf_size)
	end
	return str_buf
end

---get_number_list_buf
---@param size number
---@param c_num_list_type klib.base.ffi_utils.number_list_type
function _M.get_number_list_buf(size, c_num_list_type)
	if not c_num_list_type then
		return ffi_new(c_num_list_type or c_size_t_list, size)
	else
		return ffi_new(c_num_list_type .. size .. ']')
	end
	--c_num_list_type = c_num_list_type or number_list_type.int32
	--local s = list_type .. #list + 1 .. ']'
	--return ffi_new(c_num_list_type or c_size_t_list, size)
end

---create_int_list
---@param list number[]
---@param list_type string @[Default uint32]
---@see klib.base.ffi_utils.number_list_type
---@return table
function _M.create_number_list(list, list_type)
	list_type = list_type or number_list_type.uint32
	local s = list_type .. #list .. ']'
	local res = ffi.new(s, list)
	return res
end

local str_type = "char *["
local str_const_type = "const char*["

--[[
ffi.cdef("
int c_function(const char*file, const char**argv);
")
--]]

---create_string_list
---@param list string[]
---@param is_const boolean
---@return table
function _M.create_string_list(list, is_const)
	local tp
	if is_const then
		tp = str_const_type .. (#list + 1) .. ']'
	else
		tp = str_type .. (#list + 1) .. ']'
	end
	local res = ffi.new(tp, list)
	return res
end

return _M