local skynet    = require "skynet"
local sc        = require "socketchannel"

local name = ... or ""

function _do()
    --创建一个channel
    local c = sc.channel{
        host    = skynet.getenv "app_server_ip",
        port    = skynet.getenv "app_server_port",
    }
    --执行操作
    local msg = c:request("hello, "..name, function(sock)
        local str = sock:read()
        if str then
            return true, str
        else
            return false
        end
    end)

    if msg then
        skynet.error("server says: ", msg)
    else
        skynet.error("error")
    end

    c:close()
    skynet.exit()
end

skynet.start(function()
    --连接到服务器
    skynet.fork(_do)
end)
