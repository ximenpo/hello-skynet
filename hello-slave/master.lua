local skynet    = require "skynet"

--节点启动代码
skynet.start(function()
    -- 启动唯一的 master-service 服务，并命名为 MASTER
    -- 注意：这里使用 uniqueservice 而非 newservice 是为了确保全局唯一
    local svc = assert(skynet.uniqueservice(true, "master-service"))
    skynet.name("MASTER", svc)

    -- 启动完成
    skynet.exit()
end)
