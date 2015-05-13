local skynet	= require "skynet"
local mc		= require "multicast"
local dc		= require "datacenter"

local svc   = {}

svc.handler = function(session, address, ...)
	skynet.error("["..skynet.address(address).."]", ...)
end

--初始化
skynet.init(function()
	--方式一，获取全局MASTER服务句柄
	svc.master	= assert(skynet.queryservice(true, "master-service"))
end)

--服务入口
skynet.start(function()
	-- 设置 lua 协议处理函数
	skynet.dispatch("lua", svc.handler)

	-- 创建并订阅多播频道
	svc.mc	= mc.new {
		channel		= dc.wait("master", "channel")
		dispatch	= function (channel, source, ...)
			skynet.error("["..skynet.address(source).."]", ...)
		end
	}
	svc.mc:subscribe()

	--方式一，按句柄发消息
	skynet.send(svc.master, "lua", "SLAVE", skynet.getenv "harbor")

	--方式二，按名字发消息
	--skynet.send("MASTER", "lua", "SLAVE", skynet.getenv "harbor")
end)
