local skynet    = require "skynet"
local socket    = require "socket"

local name = ... or ""

function _read(id)
    while true do
        local str   = socket.read(id)
        if str then
            skynet.error(id, "server says: ", str)
            socket.close(id)
            skynet.exit()
        else
            socket.close(id)
            skynet.error("disconnected")
            skynet.exit()
        end
    end
end

skynet.start(function()
    --连接到服务器
    local addr  = skynet.getenv "app_server"
    local id    = socket.open(addr)
    if not id then
        skynet.error("can't connect to "..addr)
        skynet.exit()
    end

    skynet.error("connected")

    --启动读协程
    skynet.fork(_read, id)

    socket.write(id, "hello, "..name)
end)
