local snax      = require "snax"
local skynet    = require "skynet"
local skymgr    = require "skynet.manager"

local function call_s2()
    local svc= assert(snax.queryservice("s2"))

    svc.post.log("send -> begin call")
    snax.printf("%s", svc.req.echo("hello, console!"))
    svc.post.log("send -> after call")

    skynet.exit()
end

skynet.start(function()
    skymgr.fork(call_s2)
end)
