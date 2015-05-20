local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local cluster   = require "cluster"

local methods    = {
    --方式一，cluster.proxy，可以call，可以send
    [1] = function()
        local proxy = cluster.proxy("srv", ".srv")
        -- send
        skynet.send(proxy, "lua", "log", "cluster invoke begin")
        -- call
        local ret   = skynet.call(proxy, "lua", "echo", "hello, cluster proxy")
        skynet.error("srv says:", ret)
        -- send
        skynet.send(proxy, "lua", "log", "cluster invoke end")
        skynet.exit()
    end,
    --方式二，cluster.call，只可以call，不可以send
    [2] = function()
        local ret = cluster.call("srv", ".srv", "echo", "hello, cluster call")
        skynet.error("srv says:", ret)
        skynet.exit()
    end,
}

local method_type   = tonumber(... or 1)

skynet.start(function()
    local func  = methods[method_type]
    if func then
        skymgr.fork(func)
    else
        skynet.error("unknown method: ", method_type)
        skynet.exit()
    end
end)
