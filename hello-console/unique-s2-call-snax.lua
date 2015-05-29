local snax      = require "snax"
local skymgr    = require "skynet.manager"

local function call_s2()
    local svc= assert(snax.queryservice("s2"))

    svc.post.log("send -> begin call")
    snax.printf("%s", svc.req.echo("hello, console!"))
    svc.post.log("send -> after call")
    
    snax.exit()
end

function init(...)
    skymgr.fork(call_s2)
end
