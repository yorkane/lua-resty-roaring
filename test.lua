local lu = require('lib.luaunit')
local find, sub, lower, is_empty, sreverse, gsub, char, s_empty = string.find, string.sub, string.lower, table.isempty, string.reverse, string.gsub, string.char, string.is_empty
local say, print = ngx.say, print
local roar64 = require('resty.roaring.init')

local _M = {
}


local function get_list()
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
    return list
end

local l1, l2, l3 = { 1, 2, 3, 4, 5, 10 }, { 3, 4, 5, 6, 7, 9 }, { 4, 5, 8, 9, 10, 11, 8 }

function _M.main()
    local k = roar64.new32()
    k:bitmapOf(1, 2, 3, 4, 5, 6)
    k:bitmapOf(-2)
    dump(k:clone():list())
    _M.test_roar32()
    _M.test_roar64()
end

function _M.memory_burn(num)
    num = num or 10000000
    for k = 1, num do
        for n = 1, 20000 do
            local m = roar64.new32(list)
            m:r32_addRange(1, 65535)
            m:clone():list()

            local m1 = roar64.new(list)
            m1:add(n + k)
            m1:clone():list()
        end

        say('bytes in lua memoery	', collectgarbage("count") * 1024)
        --p:dispose()
        collectgarbage('collect')
        say('done collectgarbage:	', collectgarbage("count") * 1024)
    end
end

function _M.test_sanity()
    local roar = roar64.new('sdfds')
    lu.assertEquals(roar:count(), 0)
end

function _M.test_roar64()
    --dump(#bitstr, nc)
    local roar = roar64.new()
    local list = {1,2,3,4,5,6,7,8,9,10,11,12}
    roar:addMany(list)
    local str = roar:tostring()
    local arr, len = roar:list()
    --dump(list, arr, roar:count())
    lu.assertEquals(#list, len)

    for i = 1, len do
        lu.assertEquals(tonumber(arr[i]), list[i], i .. ' index was wrong!')
    end

    local list = get_list()
    roar = roar64.new(list)

    lu.assertEquals(tonumber(roar:minimum()), 4096)
    lu.assertEquals(tonumber(roar:maximum()), 4294967290)
    roar:add(12)
    lu.assertIsTrue(roar:contains(12))
    lu.assertIsFalse(roar:contains(13))


    local m2 = roar64.new({ 1, 2, 3, 4 })
    local m3 = roar64.new({ 3, 4, 5, 6 })

    m2:add_map(m3)
    local res = { 1, 2, 3, 4, 5, 6 }
    local arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(tonumber(arr1[i]), res[i])
    end
    m2:remove_map(m3)
    arr1, len = m2:list()
    lu.assertEquals(len, 2)
    lu.assertEquals(tonumber(arr1[1]), 1)
    lu.assertEquals(tonumber(arr1[2]), 2)

    m2 = roar64.new({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 })
    res = { 1, 2, 7, 8, 9, 10 }
    m2:remove_map(m3)
    arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(tonumber(arr1[i]), res[i])
    end

    m2 = roar.new({ 3, 4, 5, 7, 8, 9 })

    m2:intersect_map(m3)

    res = { 3, 4, 5 }

    arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(tonumber(arr1[i]), res[i])
    end

    m2:bitmapOf(1, 2, 3, 4, -5, 6)
    res = { 1, 2, 3, 4, 6 }
    arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(tonumber(arr1[i]), res[i])
    end

    local m4 = m2:clone()
    lu.assertEquals(m4:tostring(), m2:tostring())
    m2:add_hash('xxx1')
    m4:add_hash('xxx1')
    lu.assertEquals(m4:tostring(), m2:tostring())
end

function _M.test_roar32()
    local roar = roar64.new32()
    --dump(#bitstr, nc)
    --roar64:r32_removeRange(1,99999999)
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

end

function _M.test_roar32_range()
    local roar, res, arr1, len = roar64.new32()
    local m2 = roar.new32({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 })
    lu.assertIsTrue(m2:r32_containsRange(1, 10))
    m2:r32_removeRange(11, 16)
    res = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
    arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(arr1[i], res[i])
    end

    m2:r32_addRange(16, 20)
    res = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 16, 17, 18, 19 }
    arr1, len = m2:list()
    lu.assertEquals(len, #res)
    for i = 1, len do
        lu.assertEquals(arr1[i], res[i])
    end

    for i = 16, 19 do
        --ngx.say('return ', m2:removeChecked(i))
        lu.assertIsTrue(m2:removeChecked(i))
    end
    lu.assertIsFalse(m2:removeChecked(20))
end

return _M