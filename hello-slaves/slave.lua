local skynet    = require "skynet"

--节点启动代码
skynet.start(function()
    -- 创建 master-service 服务，并命名为 MASTER
    local svc = assert(skynet.newservice("slave-service"))

    -- 启动完成
    skynet.exit()
end)
