local roar = require("resty.roaring.init")
local id = roar.xxhash32('xxx')
---@class resty.roar.year_record
---@field roar resty.roaring
---@field count number
local _M = {
}
local lost_rate = {

}
--[[

366*24*60 = 527040  * 8 = 4216320
4294967295=max
4216320XXX (precise as 7.5 seconds) 1000 slots

366*24*60 * 18 = 527040 * 18 = 9486720
4294967295=max
09486720XX
19486720XX
29486720XX
39486720XX
X9486720XX (precise as 3.3 seconds) 400 slots

366*24*60*60 = 527040 * 60 = 31622400
4294967295=max
31622400XX (precise as 1 seconds) 100 slots

]]
local max_int = 4294967295 -- 0xFFFFFFFF
local band, bor, bxor, lshift, rshift, rolm, bnot = bit.band, bit.bor, bit.bxor, bit.lshift, bit.rshift, bit.rol, bit.bnot
local tostring, tonumber, reverse, floor, ceil, byte, sub, char = tostring, tonumber, string.reverse, math.floor, math.ceil, string.byte, string.sub, string.char
local utc_now = 1610452396
local mt = { __index = _M }
function _M.new(name)
    local inst = {
        name = name,
        roar = roar.new32()
    }
    setmetatable(inst, mt)
    return inst
end

local function build_record(record_num, utc_time, x3)
    local secs, pre = (utc_time - utc_now), 0

    if x3 and record_num > 499 then
        return nil, 'x3 mode less then 500'
    elseif not x3 and record_num > 99 then
        return nil, 'precise mode less than 100'
    elseif record_num < 0 then
        return nil, 'negative number not allowed'
    end
    if x3 then
        secs = floor(secs * 18 / 60)
        if record_num and record_num > 99 then
            pre = floor(record_num / 100)
            record_num = record_num - pre * 100
            pre = pre * 1000000000
        end
    end
    secs = secs * 100
    local rnum = pre + secs + record_num
    return rnum
end

function _M:add(record_num, utc_time)
    local rnum = build_record(record_num, utc_time)
    self.roar:add(rnum)
end

local function parse_record(fnum, x3)
    fnum = fnum / 100
    local num = 0
    if x3 and fnum > 10000000 then
        local pre = floor(fnum / 10000000)
        fnum = fnum - (pre * 10000000)
        num = pre * 100
    end
    local tmp = fnum
    fnum = floor(fnum)
    num = num + floor((tmp - fnum) * 101)
    if x3 then
        fnum = ceil(fnum * 60 / 18)
    end
    return num, fnum + utc_now
end

function _M:get(time_range, record_num)
    local list, len = self.roar:list(true)
    for i = 0, len - 1 do
        local rnum = list[i]
        if record_num then

            if record_num then

            end
        else

        end
    end
end

function _M.main()
    local rec, utc = 331, 1620000050
    local fnum, err = build_record(rec, utc, true)
    --require('klib.dump').global()
    --require('klib.util').benchmark(function()
    --    return build_record(rec, utc, true)
    --return parse_record(fnum)
    --end)
    local res_rec, res_utc = parse_record(fnum, true)
    assert(res_rec == rec)
    assert(res_utc == utc or res_utc + 1 == utc or res_utc + 2 == utc or res_utc + 3 == utc)

    local rec, utc = 31, 1620000023
    local fnum, err = build_record(rec, utc)

    local res_rec, res_utc = parse_record(fnum)
    assert(res_rec == rec)
    assert(res_utc == utc)


end

return _M