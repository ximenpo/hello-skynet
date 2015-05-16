local skynet    = require "skynet"
local socket    = require "socket"

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
    local id    = assert(socket.listen(
		skynet.getenv "app_server_ip",
		skynet.getenv "app_server_port"
	))
    socket.start(id, function(id, addr)
        skynet.error("client"..id, " ["..addr.."]", "connected")
        skynet.fork(echo, id, addr)
    end)
end)
