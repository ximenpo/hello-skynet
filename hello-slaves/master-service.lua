local skynet	= require "skynet"
local mc		= require "multicast"
local dc		= require "datacenter"

local svc   = {}

svc.handler = function(session, address, cmd, id, ...)
	skynet.error("["..skynet.address(address).."]", cmd, id, ...)

	--将单播更改为广播到频道
	--skynet.send(address, "lua", "hello, slave"..id)
	svc.mc:publish("hello, slave"..id)
end

skynet.start(function()
	-- 设置 lua 协议处理函数
	skynet.dispatch("lua", svc.handler)

	-- 生成多播频道, 并保存到 master.channel ,供 slaves 读取
	svc.mc	= mc.new()
	dc.set("hello-slaves", "channel", svc.mc.channel)
end)
