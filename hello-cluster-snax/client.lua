local snax      = require "snax"
local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local cluster   = require "cluster"

local methods    = {
    --方式一，cluster.proxy，可以call，可以send
    [1] = function()
        local intf  = assert(snax.interface("server"))
        local proxy = cluster.proxy("srv", ".srv")
        -- send
        skynet.send(proxy, "snax", intf.accept["log"], "cluster invoke begin")
        -- call
        local ret   = skynet.call(proxy, "snax", intf.response["echo"], "hello, cluster proxy")
        skynet.error("srv says:", ret)
        -- send
        skynet.send(proxy, "snax", intf.accept["log"], "cluster invoke end")
        skynet.exit()
    end,
    --方式二，采用snax方式调用，可以req，可以post
    [3] = function()
        local proxy = cluster.snax("srv", "server", ".srv")
        proxy.post.log("cluster invoke with snax begin")
        local ret   = proxy.req.echo("hello, cluster snas")
        skynet.error(ret)
        proxy.post.log("cluster invoke with snax end")
    end,
}


function init(...)
    local method_type   = tonumber(... or 1)
    local func  = methods[method_type]
    if func then
        skymgr.fork(func)
    else
        snax.printf("unknown method: %d", method_type)
        skymgr.fork(snax.exit)
    end
end
