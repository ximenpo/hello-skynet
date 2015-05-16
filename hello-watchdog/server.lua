local skynet    = require "skynet"
local netpack   = require "netpack"
local socket 	= require "socket"

--gate服务句柄
local gate
--命令处理
local CMD = {}
--客户端连接处理
local SOCKET = {}

--command处理
function CMD.xxx()
end

--socket事件处理
function SOCKET.open(fd, addr)
	skynet.error("client"..fd, "connected: ", addr)
end

function SOCKET.close(fd)
	skynet.error("client"..fd, "disconnected")
end

function SOCKET.error(fd, msg)
	skynet.error("client"..fd, "disconnected: ", msg)
end

function SOCKET.data(fd, msg)
	skynet.error("client"..fd, "says: ", msg)
	socket.write(fd, msg)
end

--简单echo服务
function    echo(id, addr)
	socket.start(id)
	while true do
		local str = socket.read(id)
		if str then
			skynet.error("client"..id, " says: ", str)
			socket.write(id, str)
		else
			socket.close(id)
            skynet.error("client"..id, " ["..addr.."]", "disconnected")
			return
		end
	end
end

--服务入口
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "socket" then
			local f = SOCKET[subcmd]
			if f then
				f(...)
			else
				skynet.error("unknown socket command: ", subcmd)
			end
			-- socket api don't need return
		else
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)

	gate = skynet.unqueservice("gate")
end)
