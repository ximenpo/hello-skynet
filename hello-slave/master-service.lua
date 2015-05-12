local skynet    = require "skynet"

local svc   = {}
svc.handler = function(session, address, ...)
    skynet.error("[master-service]", skynet.address(address), ...)
end

skynet.start(function()
    -- 设置 lua 协议处理函数
	skynet.dispatch("lua", svc.handler)

    skynet.send(skynet.self(), "lua", skynet.getenv "harbor")
end)
