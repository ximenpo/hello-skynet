local skynet    = require "skynet"
local codecache = require "skynet.codecache"

skynet.start(function()
    codecache.clear()
    skynet.exit()
end)
