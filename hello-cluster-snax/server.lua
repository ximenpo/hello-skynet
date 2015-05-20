local snax      = require "snax"
local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local cluster   = require "cluster"

--处理器
local data   = {}

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
function init(...)
    data.name    = ... or "unnamed"
    snax.enablecluster()
    skymgr.register(".srv")
    cluster.open "srv"
end
