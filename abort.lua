local skynet    = require "skynet"
local skymgr    = require "skynet.manager"

skynet.start(function()
    skymgr.abort()
end)
