local skynet    = require "skynet"

local svc   = {}
svc.handler = function(session, address, cmd, id, ...)
    skynet.error("["..skynet.address(address).."]", id, "connected")
    skynet.send(address, "lua", "hello", "harbor"..id)
end

skynet.start(function()
    -- 设置 lua 协议处理函数
	skynet.dispatch("lua", svc.handler)

    --skynet.send(skynet.self(), "lua", "MASTER", skynet.getenv "harbor")
end)
