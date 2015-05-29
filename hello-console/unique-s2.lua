local skynet = require "skynet"
local skymgr = require "skynet.manager"
local snax   = require "snax"

skynet.start(function()
    snax.uniqueservice("s2")

    skynet.exit()
end)
