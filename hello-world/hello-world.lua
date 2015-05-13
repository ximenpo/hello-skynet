local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local core      = require "skynet.core"

--方式1
--[[
skynet.start(function()
    --  send message to logger
    skynet.error("hello, world!")

    --  dalay and quit
    skynet.timeout(1, skymgr.abort)
end)
--]]

--方式2
--[－[
skynet.start(function()
    -- get the logger service
    local logger    = skynet.localname(".logger")
    if not logger then
        skynet.error("no logger found")
        skymgr.abort()
    end

    core.send(logger, skynet.PTYPE_TEXT, 0, "hello, world!")

    --  delay quit for the logger display
    skynet.timeout(1, function()
        skymgr.abort()
        --skynet.exit()
    end)
end)
--]]
