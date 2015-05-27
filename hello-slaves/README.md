# hello-slaves

>
> 当有新的slave连接上来时，给所有的slave（包括新连接上来这个），发送“hello, slaveN!”的消息
> 

在hello-slave的基础上继续，主要用到<a href="https://github.com/cloudwu/skynet/wiki/DataCenter" target="_blank">DataCenter</a>和<a href="https://github.com/cloudwu/skynet/wiki/Multicast" target="_blank">Multicast</a>两个概念／库。

1. 复制hello-slave文件夹为hello-slaves，作为本节的新项目

2. 修改hello-slaves下的 config-master.lua 和 config-slave.lua 文件，修改项目名：
    
    ```lua
    app_name    	= "hello-slaves"
    ```

3. 给master-service和slave-service都引入前面提到的两个库：
    
    ```lua
    local mc		= require "multicast"
    local dc		= require "datacenter"
    ```

4. 修改master-service.lua服务
    
    在启动函数中添加创建 multicast 和 datacenter相 的代码
    ```lua
    	-- 生成多播频道, 并保存到 master.channel ,供 slaves 读取
    	svc.mc	= mc.new()
    	dc.set("hello-slaves", "channel", svc.mc.channel)
    ```
    
    在消息处理中添加多播消息的代码
    ```lua
    svc.handler = function(session, address, cmd, id, ...)
    	skynet.error("["..skynet.address(address).."]", cmd, id, ...)
    
    	--将单播更改为广播到频道
    	--skynet.send(address, "lua", "hello, slave"..id)
    	svc.mc:publish("hello, slave"..id)
    end
    ```

5. 修改slave-service.lua服务

    在启动入口处添加 datacenter项读取 和 多播消息处理
    ```lua
    --服务入口
    skynet.start(function()
    	-- 设置 lua 协议处理函数
    	skynet.dispatch("lua", svc.handler)
    
    	-- 创建并订阅多播频道
    	svc.mc	= mc.new {
    		channel		= dc.get("hello-slaves", "channel"),
    		dispatch	= function (channel, source, ...)
    			skynet.error("["..skynet.address(source).."]", ...)
    		end,
    	}
    	svc.mc:subscribe()
    
    	--方式一，按句柄发消息
    	skynet.send(svc.master, "lua", "SLAVE", skynet.getenv "harbor")
    
    	--方式二，按名字发消息
    	--skynet.send("MASTER", "lua", "SLAVE", skynet.getenv "harbor")
    end)
    ```

6. 保存&测试
    
    启动master:
    ```
    hello-skynet simple$ skynet/skynet hello-slaves/config-master.lua
    ```
    
    再启动几个slave：
    ```bash
    hello-skynet simple$ export harbor=2
    hello-skynet simple$ skynet/skynet hello-slaves/config-salve.lua
    ```
    
    ```bash
    hello-skynet simple$ export harbor=3
    hello-skynet simple$ skynet/skynet hello-slaves/config-salve.lua
    ```
    
    ```bash">
    hello-skynet simple$ export harbor=4
    hello-skynet simple$ skynet/skynet hello-slaves/config-salve.lua
    ```
    
    master显示：
    ```bash
    [:0100000a] [:02000008] SLAVE 2
    [:01000004] connect from 127.0.0.1:51573 7
    [:01000004] Harbor 3 (fd=7) report 127.0.0.1:7703
    [:01000005] Connect to harbor 3 (fd=8), 127.0.0.1:7703
    [:0100000a] [:03000008] SLAVE 3
    [:01000004] connect from 127.0.0.1:51576 9
    [:01000004] Harbor 4 (fd=9) report 127.0.0.1:7704
    [:01000005] Connect to harbor 4 (fd=10), 127.0.0.1:7704
    [:0100000a] [:04000008] SLAVE 4
    ```
    
    slave2显示：
    ```bash
    [:02000002] KILL self
    [:02000008] [:0100000a] hello, slave2
    [:02000004] Connect to harbor 3 (fd=4), 127.0.0.1:7703
    [:02000008] [:0100000a] hello, slave3
    [:02000004] Connect to harbor 4 (fd=5), 127.0.0.1:7704
    [:02000008] [:0100000a] hello, slave4
    [:02000004] Master disconnect
    ```
    
    slave3显示：
    ```bash
    [:03000002] KILL self
    [:03000008] [:0100000a] hello, slave3
    [:03000004] Connect to harbor 4 (fd=5), 127.0.0.1:7704
    [:03000008] [:0100000a] hello, slave4
    ```
    
    slave4显示：
    ```bash
    [:04000002] KILL self
    [:04000008] [:0100000a] hello, slave4
    ```

7. 内容说明
    
    ```
    * datacenter.set(...)    设置全局数据
    * datacenter.get(...)    获取全局数据，不存在返回nil
    * datacenter.wait(...)   获取全局数据，不存在则等待，直到有数据时返回
    * multicast.new(...)     创建新的多播
    * multicast:subscribe()  开始接收多播数据
    * multicast:publish(...) 发送多播数据
    ```

8. 思考

    一堆slave可以通讯了，是不是该“人类”介入了？；）
