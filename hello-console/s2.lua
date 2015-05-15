local skynet= require "skynet"
local snax  = require "snax"

handler = handler or {}
handler.name    = nil

--处理post／send消息
function    accept.log(...)
    skynet.error("<"..handler.name..">", ...)
end

--处理post／send消息
function    accept.exit()
    snax.exit()
end

--处理req/call消息
function response.echo(...)
    return ...
end

--启动入口
function    init(name, ...)
    handler.name    = name or "unnamed"
end

--退出处理
function    exit()
end
