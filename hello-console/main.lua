local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local snax      = require "snax"

skynet.start(function()
    --启动console服务，并命名为 .console
    skymgr.name(".console", skynet.newservice("console"))
    --启动debug_console服务，并命名为 .dbgconsole
    skymgr.name(".dbgconsole", skynet.newservice("debug_console", 7800))
end)
