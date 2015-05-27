# hello-slave

这一节，我们来瞅瞅skynet的一个重要特点／模式：master/slave. 本节任务如下：

>
> 建立一个master节点，每次有新slave连上来的时候，就给这个slave发送一条“hello, slave{{slaveid}}!”的消息，其中{{slaveid}}为新连上来slave的slaveid。
>

开始动手：

1. 新建hello-slave文件夹

2. 建立master的入口文件

    入口很简单，用 <a href="https://github.com/cloudwu/skynet/wiki/UniqueService" target="_blank">skynet.uniqueservice</a>启动master-service服务，顺带还给服务注册了个别名MASTER，这样发消息就可以添服务名字了。最后，入口没事做了，就自己 exit 了：
    master.lua
    ```lua
    local skynet    = require "skynet"
    local skymgr    = require "skynet.manager"
    
    --节点启动代码
    skynet.start(function()
        -- 启动唯一的 master-service 服务，并命名为 MASTER[非必须]
        -- 注意：这里使用 uniqueservice 而非 newservice 是为了确保全局唯一
        local svc = assert(skynet.uniqueservice(true, "master-service"))
        -- 注册别名后可以直接按名字发消息
        skymgr.name("MASTER", svc)
    
        -- 启动完成
        skynet.exit()
    end)
    ```

3. 实现master-service

    照葫芦画瓢，建立服务框架，用skynet.dispatch设定lua协议消息处理函数，处理函数也很简单，直接打印接收到的消息源和内容，然后再给消息源返回一条 hello, harborN 的消息
    
    ```lua
    local skynet    = require "skynet"
    
    local svc   = {}
    svc.handler = function(session, address, cmd, id, ...)
    	skynet.error("["..skynet.address(address).."]", id, "connected")
    	skynet.send(address, "lua", "hello, slave"..id)
    end
    
    skynet.start(function()
    	-- 设置 lua 协议处理函数
    	skynet.dispatch("lua", svc.handler)
    
    	--skynet.send(skynet.self(), "lua", "MASTER", skynet.getenv "harbor")
    end)
    ```

4. slave也仿照master，实现入口和服务

    slave入口slave.lua：
    ```lua
    local skynet    = require "skynet"
    
    --节点启动代码
    skynet.start(function()
        -- 创建 master-service 服务，并命名为 MASTER
        local svc = assert(skynet.newservice("slave-service"))
    
        -- 启动完成
        skynet.exit()
    end)
    ```
    
    salve服务，对于给master-serice发送消息，这里可以有两种方式：
    ```
    *   通过skynet.queryservice(...) 查询服务文件名获取服务句柄
    *   直接通过服务注册的别名进行发送
    ```
    具体参考代码里注释的“方式一”和“方式二”：
    
    ```lua
    local skynet    = require "skynet"
    
    local svc   = {}
    
    svc.handler = function(session, address, ...)
    	skynet.error("["..skynet.address(address).."]", ...)
    end
    
    --初始化
    skynet.init(function()
    	--方式一，获取全局MASTER服务句柄
    	svc.master  = assert(skynet.queryservice(true, "master-service"))
    end)
    
    --服务入口
    skynet.start(function()
    	-- 设置 lua 协议处理函数
    	skynet.dispatch("lua", svc.handler)
    
    	--方式一，按句柄发消息
    	skynet.send(svc.master, "lua", "SLAVE", skynet.getenv "harbor")
    
    	--方式二，按名字发消息
    	--skynet.send("MASTER", "lua", "SLAVE", skynet.getenv "harbor")
    end)
    ```

5. 写master和slave的启动配置文件

    配置文件跟hello-world没太大区别，这里仅列出不同的部分：
    ```lua
    ...
    ----------------------------------
    --  master/slave 用到的参数
    ----------------------------------
    harbor      = 1
    address     = "127.0.0.1:770"..harbor
    master      = "127.0.0.1:7800"
    standalone  = "127.0.0.1:7800"
    
    -- snlua start file.
    start   = "master"
    </code>
    
    config-slave.lua<code lang="lua">
    ...
    ----------------------------------
    --  master/slave 用到的参数
    ----------------------------------
    harbor      = $harbor
    address     = "127.0.0.1:770"..harbor
    master      = "127.0.0.1:7800"
    standalone  = nil
    
    -- snlua start file.
    start   = "slave"
    ```
    
    这里需要关注的是salve配置里的 $harbor ，表示harbor的值从环境变量里读取。

6. 启动&测试

    进入项目根目录，先启动master:
    ```bash
    hello-skynet simple$ skynet/skynet hello-slave/config-master.lua
    ```
    
    再启动slave：
    ```bash
    hello-skynet simple$ export harbor=3
    hello-skynet simple$ skynet/skynet hello-slave/config-salve.lua
    ```
    
    可以看到master上的输出：
    ```bash
    [:01000004] connect from 127.0.0.1:51214 5
    [:01000004] Harbor 3 (fd=5) report 127.0.0.1:7703
    [:01000005] Connect to harbor 3 (fd=6), 127.0.0.1:7703
    [:0100000a] [:03000008] 3 connected
    ```
    
    以及slave上的输出：
    ```bash
    [:03000008] [:0100000a] hello, slave3
    ```
    
    好吧，至此任务也基本算是完成了。

7. 内容说明：

    ```
    * skynet.dispatch(...)       设置指定协议的处理函数
    * skynet.newservice(...)     启动指定的服务[文件名]，可启动多次
    * skynet.uniqueservice(...)  启动指定的服务[文件名]，唯一启动一次，可指定是否全局唯一
    * skynet.queryservice(...)   查询启动的服务[文件名]，若未启动则等待启动完成，返回服务句柄
    * skynet.name(...)           给指定服务设定别名
    * skynet.send(...)           可以给服务句柄或别名发消息
    * $xxx                       配置文件中可以用$xxxx方式获取环境变量xxxx
    ```

8. 思考：

  如果有多个slave都连接到master了，master是否可以广播新slave的消息给所有已存在的slave呢？
