local skynet    = require "skynet"
local core      = require "skynet.core"

skynet.start(function()
    -- get the logger service
    local logger    = skynet.localname(".logger")
    if not logger then
        print("no logger found.")
        skynet.abort()
    end

    --  send message
    core.send(logger, skynet.PTYPE_TEXT, 0, "hello, world!")

    --  quit after 10 ms
    skynet.timeout(0, function()
        skynet.abort()
        --skynet.exit()
    end)
end)
