-- This code is auto generated should only changed by ffi_utils @2020-06-09 01:20:05
local cdef = [[
bool r32_load_from_bytes(Roaring *self, const char *bytes);
bool r64_load_from_bytes(Roaring64Map *self, const char *bytes);
void *new_Roaring64Map(const char *bytes);
void *new_Roaring(const char *bytes);
void delete_Roaring64Map(Roaring64Map *self);
void delete_Roaring(Roaring *self);
void r64_add_uint64(Roaring64Map *self, uint64_t num);
void r32_add_uint(Roaring *self, uint32_t num);
void *r64_bitmapOf(Roaring64Map *self, int64_t n1, int64_t n2, int64_t n3,
                   int64_t n4, int64_t n5, int64_t n6, int64_t n7, int64_t n8,
                   int64_t n9, int64_t n10);
void *r32_bitmapOf(Roaring *self, int64_t n1, int64_t n2, int64_t n3,
                   int64_t n4, int64_t n5, int64_t n6, int64_t n7, int64_t n8,
                   int64_t n9, int64_t n10);
bool r32_containsRange(Roaring *self, uint64_t x, uint64_t y);
void r32_addRange(Roaring *self, uint64_t x, uint64_t y);
void r32_removeRange(Roaring *self, uint32_t x, uint32_t y);
void r64_remove_map(Roaring64Map *self, Roaring64Map *target);
void r32_remove_map(Roaring *self, Roaring *target);
void r64_add_map(Roaring64Map *self, Roaring64Map *target);
void r32_add_map(Roaring *self, Roaring *target);
void r64_intersect_map(Roaring64Map *self, Roaring64Map *target);
void r32_intersect_map(Roaring *self, Roaring *target);
size_t r64_maximum(Roaring64Map *self);
size_t r32_maximum(Roaring *self);
size_t r64_minimum(Roaring64Map *self);
size_t r32_minimum(Roaring *self);
void r64_addMany(Roaring64Map *self, size_t n_args, const size_t *vals);
void r32_addMany(Roaring *self, size_t n_args, const uint32_t *vals);
bool r64_contains(Roaring64Map *self, uint64_t num);
bool r32_contains(Roaring *self, uint64_t num);
bool r64_addChecked(Roaring64Map *self, size_t num);
bool r32_addChecked(Roaring *self, size_t num);
uint64_t r64_add_hash(Roaring64Map *self, const char *uid, int length);
uint32_t r32_add_hash(Roaring *self, const char *uid, int length);
uint32_t r64_byte_size(Roaring64Map *self);
uint32_t r32_byte_size(Roaring *self);
void r64_tostring(Roaring64Map *self, char *dst);
void r32_tostring(Roaring *self, char *dst);
uint64_t r64_count(Roaring64Map *self);
uint32_t r32_count(Roaring *self);
void r64_list(Roaring64Map *self, uint64_t *num_list_buff);
void r32_list(Roaring *self, uint32_t *num_list_buff);
void r64_runOptimize(Roaring64Map *self);
void r32_runOptimize(Roaring *self);
void r64_remove(Roaring64Map *self, uint64_t x);
void r32_remove(Roaring *self, uint32_t x);
bool r64_removeChecked(Roaring64Map *self, uint64_t x);
bool r32_removeChecked(Roaring *self, uint32_t x);
void r64_bytes_from_uint64(uint64_t number, char *result);
uint64_t r64_uint64_from_byte(const char *buffer);
uint64_t r64_xxhash64(const char *str, size_t length, uint64_t seed,
                      char *dst_8bytes);
uint32_t r64_xxhash32(const char *str, size_t length, uint64_t seed);
bool runOptimize(Roaring64Map *self);
size_t shrinkToFit(Roaring64Map *self);
void clear(Roaring64Map *self);
]]

---@class resty.roaring.base
local _M = {
	_source = 'luac.cpp',
	cdef = cdef
}

---r32_load_from_bytes
---@param bytes string @ char
---@return boolean @ bool
function _M:r32_load_from_bytes(bytes)
	return self.libc.r32_load_from_bytes(self.cdata, bytes)
end

---r64_load_from_bytes
---@param bytes string @ char
---@return boolean @ bool
function _M:r64_load_from_bytes(bytes)
	return self.libc.r64_load_from_bytes(self.cdata, bytes)
end

---new_Roaring64Map
---@param bytes string @ char
---@return any @ void *
function _M:new_Roaring64Map(bytes)
	return self.libc.new_Roaring64Map(bytes)
end

---new_Roaring
---@param bytes string @ char
---@return any @ void *
function _M:new_Roaring(bytes)
	return self.libc.new_Roaring(bytes)
end

---delete_Roaring64Map
---@return any @ void
function _M:delete_Roaring64Map()
	return self.libc.delete_Roaring64Map(self.cdata)
end

---delete_Roaring
---@return any @ void
function _M:delete_Roaring()
	return self.libc.delete_Roaring(self.cdata)
end

---r64_add_uint64
---@param num number @ uint64_t
---@return any @ void
function _M:r64_add_uint64(num)
	return self.libc.r64_add_uint64(self.cdata, num)
end

---r32_add_uint
---@param num number @ uint32_t
---@return any @ void
function _M:r32_add_uint(num)
	return self.libc.r32_add_uint(self.cdata, num)
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
---@return any @ void *
function _M:r64_bitmapOf(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10)
	return self.libc.r64_bitmapOf(self.cdata, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10)
end

---r32_bitmapOf
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
---@return any @ void *
function _M:r32_bitmapOf(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10)
	return self.libc.r32_bitmapOf(self.cdata, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10)
end

---r32_containsRange
---@param x number @ uint64_t
---@param y number @ uint64_t
---@return boolean @ bool
function _M:r32_containsRange(x, y)
	return self.libc.r32_containsRange(self.cdata, x, y)
end

---r32_addRange
---@param x number @ uint64_t
---@param y number @ uint64_t
---@return any @ void
function _M:r32_addRange(x, y)
	return self.libc.r32_addRange(self.cdata, x, y)
end

---r32_removeRange
---@param x number @ uint32_t
---@param y number @ uint32_t
---@return any @ void
function _M:r32_removeRange(x, y)
	return self.libc.r32_removeRange(self.cdata, x, y)
end

---r64_remove_map
---@param target any @ Roaring64Map
---@return any @ void
function _M:r64_remove_map(target)
	return self.libc.r64_remove_map(self.cdata, target)
end

---r32_remove_map
---@param target any @ Roaring
---@return any @ void
function _M:r32_remove_map(target)
	return self.libc.r32_remove_map(self.cdata, target)
end

---r64_add_map
---@param target any @ Roaring64Map
---@return any @ void
function _M:r64_add_map(target)
	return self.libc.r64_add_map(self.cdata, target)
end

---r32_add_map
---@param target any @ Roaring
---@return any @ void
function _M:r32_add_map(target)
	return self.libc.r32_add_map(self.cdata, target)
end

---r64_intersect_map
---@param target any @ Roaring64Map
---@return any @ void
function _M:r64_intersect_map(target)
	return self.libc.r64_intersect_map(self.cdata, target)
end

---r32_intersect_map
---@param target any @ Roaring
---@return any @ void
function _M:r32_intersect_map(target)
	return self.libc.r32_intersect_map(self.cdata, target)
end

---r64_maximum
---@return number @ size_t
function _M:r64_maximum()
	return self.libc.r64_maximum(self.cdata)
end

---r32_maximum
---@return number @ size_t
function _M:r32_maximum()
	return self.libc.r32_maximum(self.cdata)
end

---r64_minimum
---@return number @ size_t
function _M:r64_minimum()
	return self.libc.r64_minimum(self.cdata)
end

---r32_minimum
---@return number @ size_t
function _M:r32_minimum()
	return self.libc.r32_minimum(self.cdata)
end

---r64_addMany
---@param n_args number @ size_t
---@param vals number @ size_t
---@return any @ void
function _M:r64_addMany(n_args, vals)
	return self.libc.r64_addMany(self.cdata, n_args, vals)
end

---r32_addMany
---@param n_args number @ size_t
---@param vals number @ uint32_t
---@return any @ void
function _M:r32_addMany(n_args, vals)
	return self.libc.r32_addMany(self.cdata, n_args, vals)
end

---r64_contains
---@param num number @ uint64_t
---@return boolean @ bool
function _M:r64_contains(num)
	return self.libc.r64_contains(self.cdata, num)
end

---r32_contains
---@param num number @ uint64_t
---@return boolean @ bool
function _M:r32_contains(num)
	return self.libc.r32_contains(self.cdata, num)
end

---r64_addChecked
---@param num number @ size_t
---@return boolean @ bool
function _M:r64_addChecked(num)
	return self.libc.r64_addChecked(self.cdata, num)
end

---r32_addChecked
---@param num number @ size_t
---@return boolean @ bool
function _M:r32_addChecked(num)
	return self.libc.r32_addChecked(self.cdata, num)
end

---r64_add_hash
---@param uid string @ char
---@param length number @ int
---@return number @ uint64_t
function _M:r64_add_hash(uid, length)
	return self.libc.r64_add_hash(self.cdata, uid, length)
end

---r32_add_hash
---@param uid string @ char
---@param length number @ int
---@return number @ uint32_t
function _M:r32_add_hash(uid, length)
	return self.libc.r32_add_hash(self.cdata, uid, length)
end

---r64_byte_size
---@return number @ uint32_t
function _M:r64_byte_size()
	return self.libc.r64_byte_size(self.cdata)
end

---r32_byte_size
---@return number @ uint32_t
function _M:r32_byte_size()
	return self.libc.r32_byte_size(self.cdata)
end

---r64_tostring
---@param dst string @ char
---@return any @ void
function _M:r64_tostring(dst)
	return self.libc.r64_tostring(self.cdata, dst)
end

---r32_tostring
---@param dst string @ char
---@return any @ void
function _M:r32_tostring(dst)
	return self.libc.r32_tostring(self.cdata, dst)
end

---r64_count
---@return number @ uint64_t
function _M:r64_count()
	return self.libc.r64_count(self.cdata)
end

---r32_count
---@return number @ uint32_t
function _M:r32_count()
	return self.libc.r32_count(self.cdata)
end

---r64_list
---@param num_list_buff number @ uint64_t
---@return any @ void
function _M:r64_list(num_list_buff)
	return self.libc.r64_list(self.cdata, num_list_buff)
end

---r32_list
---@param num_list_buff number @ uint32_t
---@return any @ void
function _M:r32_list(num_list_buff)
	return self.libc.r32_list(self.cdata, num_list_buff)
end

---r64_runOptimize
---@return any @ void
function _M:r64_runOptimize()
	return self.libc.r64_runOptimize(self.cdata)
end

---r32_runOptimize
---@return any @ void
function _M:r32_runOptimize()
	return self.libc.r32_runOptimize(self.cdata)
end

---r64_remove
---@param x number @ uint64_t
---@return any @ void
function _M:r64_remove(x)
	return self.libc.r64_remove(self.cdata, x)
end

---r32_remove
---@param x number @ uint32_t
---@return any @ void
function _M:r32_remove(x)
	return self.libc.r32_remove(self.cdata, x)
end

---r64_removeChecked
---@param x number @ uint64_t
---@return boolean @ bool
function _M:r64_removeChecked(x)
	return self.libc.r64_removeChecked(self.cdata, x)
end

---r32_removeChecked
---@param x number @ uint32_t
---@return boolean @ bool
function _M:r32_removeChecked(x)
	return self.libc.r32_removeChecked(self.cdata, x)
end

---r64_bytes_from_uint64
---@param number number @ uint64_t
---@param result string @ char
---@return any @ void
function _M:r64_bytes_from_uint64(number, result)
	return self.libc.r64_bytes_from_uint64(number, result)
end

---r64_uint64_from_byte
---@param buffer string @ char
---@return number @ uint64_t
function _M:r64_uint64_from_byte(buffer)
	return self.libc.r64_uint64_from_byte(buffer)
end

---r64_xxhash64
---@param str string @ char
---@param length number @ size_t
---@param seed number @ uint64_t
---@param dst_8bytes string @ char
---@return number @ uint64_t
function _M:r64_xxhash64(str, length, seed, dst_8bytes)
	return self.libc.r64_xxhash64(str, length, seed, dst_8bytes)
end

---r64_xxhash32
---@param str string @ char
---@param length number @ size_t
---@param seed number @ uint64_t
---@return number @ uint32_t
function _M:r64_xxhash32(str, length, seed)
	return self.libc.r64_xxhash32(str, length, seed)
end

---runOptimize
---@return boolean @ bool
function _M:runOptimize()
	return self.libc.runOptimize(self.cdata)
end

---shrinkToFit
---@return number @ size_t
function _M:shrinkToFit()
	return self.libc.shrinkToFit(self.cdata)
end

---clear
---@return any @ void
function _M:clear()
	return self.libc.clear(self.cdata)
end

return _M
