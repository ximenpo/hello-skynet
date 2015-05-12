local skynet    = require "skynet"

local svc   = {}

svc.handler = function(session, address, ...)
    skynet.error("[slave-service]", skynet.address(address), ...)
end

--初始化
skynet.init(function()
    --获取全局MASTER服务句柄
    svc.master  = assert(skynet.queryservice(true, "MASTER"))
end)

--服务入口
skynet.start(function()
    -- 设置 lua 协议处理函数
	skynet.dispatch("lua", svc.handler)

skynet.error(svc.master)
    skynet.send(svc.master, "lua", skynet.getenv "harbor")
end)
