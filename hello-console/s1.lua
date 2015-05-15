local skynet    = require "skynet"

--服务入口
skynet.start(function()
    --注册lua协议处理函数，这里只是简单打印接受到的消息内容
    skynet.dispatch("lua", function(session, address, cmd, ...)
        skynet.error("["..address.."]", cmd, ...)
    end)
end)
