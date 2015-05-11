local skynet    = require "skynet"
local core      = require "skynet.core"

--方式1
--[[
skynet.start(function()
    --  send message to logger
    skynet.error("hello, world!")

    --  dalay and quit
    skynet.timeout(1, skynet.abort)
end)
--]]

--方式2
--[－[
skynet.start(function()
    -- get the logger service
    local logger    = skynet.localname(".logger")
    if not logger then
        skynet.error("no logger found")
        skynet.abort()
    end

    core.send(logger, skynet.PTYPE_TEXT, 0, "hello, world!")

    --  delay quit for the logger display
    skynet.timeout(1, function()
        skynet.abort()
        --skynet.exit()
    end)
end)
--]]
