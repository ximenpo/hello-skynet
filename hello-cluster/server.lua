local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local cluster   = require "cluster"

--处理器
local data   = {
    name    = ... or "unnamed"
}
local accept  = {}
local response= {}

--处理post／send消息
function accept.log(...)
    local msg = ... or ""
    skynet.error("<"..data.name.."> :", msg)
end

--处理req/call消息
function response.echo(...)
    skynet.error(...)
    return ...
end

--启动入口
skynet.start(function()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        if response[cmd] then
            skynet.retpack(response[cmd](...))
        elseif accept[cmd] then
            accept[cmd](...)
        end
    end)
    skymgr.register(".srv")
    cluster.open "srv"
end)
