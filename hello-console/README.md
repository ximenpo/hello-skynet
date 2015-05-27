# hello-console

我们可以把skynet当成一个虚拟机使用，然后用手动敲命令的方式来使用skynet。用到的内容：

```
* snax服务              如何写snax服务
* console服务           敲命令启动snlua/snax服务
* debug_console服务     远程查看/调试服务，执行热更新
* 增加abort服务          从控制台退出skynet
* 增加clearcache服务     清理skynet缓存的lua文件
```

从这个例开始，我们都采用类似的配置文件／启动方式：

配置文件为config.lua，注意新增加的<strong>snax</strong>项，用来指定搜索snax服务文件的路径。
```lua
snax    = _skynet.."service/?.lua;"..app_root.."?.lua"
```

为了简单，项目统一使用主入口服务main.lua，不用master/slave模式。main.lua内容如下：
```lua
local skynet    = require "skynet"
local skymgr    = require "skynet.manager"
local snax      = require "snax"

skynet.start(function()
    --初始化随机数
    math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )

    --启动console服务，并命名为 .console
    skymgr.name(".console", skynet.newservice("console"))
    --启动debug_console服务，并命名为 .dbgconsole，端口随机（7000-7799）
    skymgr.name(".dbgconsole", skynet.newservice("debug_console", 7000 + math.random(800)))

    --启动好了，没事做就退出
    skynet.exit()
end)
```

入口服务也很简单，就是分别启动 console 和 debug_console 两个服务，其中debug_console的端口为7000-7999之间的随机端口，具体的端口号可以看skynet的输出信息。

现在，开始步入正题：

1. 测试main服务
    
    进入hello-skynet目录，在控制台输入 **skynet/skynet hello-console/config.lua** 启动skynet
    ```bash
    simple$ skynet/skynet hello-console/config.lua 
    [:00000001] LAUNCH logger 
    [:00000002] LAUNCH snlua bootstrap
    [:00000003] LAUNCH snlua launcher
    [:00000004] LAUNCH snlua cdummy
    [:00000005] LAUNCH harbor 0 4
    [:00000006] LAUNCH snlua datacenterd
    [:00000007] LAUNCH snlua service_mgr
    [:00000008] LAUNCH snlua main
    [:00000009] LAUNCH snlua console
    [:0000000a] LAUNCH snlua debug_console 7616
    [:0000000a] Start debug console at 127.0.0.1 7616
    [:00000008] KILL self
    [:00000002] KILL self
    ```
    看到类似上面的输出，那么恭喜你，hello-console服务启动了，注意下<em>Start debug console at 127.0.0.1 7616</em>这一句，表示debug_console的端口为7616(端口随机)

2. 启动snlua服务
    
    参考s1.lua，写一个snlua服务，然后在控制台直接敲服务名启动
    ```bash
    ...
    s1
    [:0000000b] LAUNCH snlua s1
    ```

    如果没有错误信息，并且有<em>LAUNCH snlua s1</em>的日志输出，表示s1服务已经启动成功。

3. 启动telnet连接debug_console
    
    新开控制台中断，根据skynet打印出的debug_console端口，进行telnet连接
    ```bash
    simple$ telnet 127.0.0.1 7616
    Trying 127.0.0.1...
    Connected to localhost.
    Escape character is '^]'.
    Welcome to skynet console
    
    ```
    
    看到这样的提示，表示连接成功，下面敲<strong>help</strong>看看debug_console都支持的命令
    ```
    help
    clearcache	clear lua code cache
    debug	debug address : debug a lua service
    exit	exit address : kill a lua service
    gc	gc : force every lua service do garbage collect
    help	This help message
    info	Info address : get service infomation
    inject	inject address luascript.lua
    kill	kill address : kill service
    list	List all the service
    log	launch a new lua service with log
    logoff	logoff address
    logon	logon address
    mem	mem : show memory status
    service	List unique service
    signal	signal address sig
    snax	lanuch a new snax service
    start	lanuch a new lua service
    stat	Dump all stats
    task	task address : show service task detail
    ```
    
    具体命令可以自己试试，具体参考<a href="https://github.com/cloudwu/skynet/wiki/DebugConsole" target="_blank">debug_console说明</a>。下面是list的结果
    
    ```bash
    list
    :00000004	snlua cdummy
    :00000006	snlua datacenterd
    :00000007	snlua service_mgr
    :00000009	snlua console
    :0000000a	snlua debug_console 7616
    :0000000b	snlua s1
    OK
    ```

4. 启动snax服务

    参考s2.lua，写一个snax服务，然后在控制台启动
    ```bash
    snax s2
    [:0000000c] LAUNCH snlua snaxd s2
    
    ```
    
    snax服务主要由以下几个部分构成：
    ```
    init函数      服务启动时调用
    exit函数      函数退出时调用
    hotfix函数    热更新时调用
    accept.xxx   收到send操作xxx时调用
    response.xxx 收到call操作xxx时调用，函数返回值即call返回值
    ```
    
    切换到debug_console，输入list看看结果：
    
    ```bash
    list
    :00000004	snlua cdummy
    :00000006	snlua datacenterd
    :00000007	snlua service_mgr
    :00000009	snlua console
    :0000000a	snlua debug_console 7616
    :0000000b	snlua s1
    :0000000c	snlua snaxd s2
    OK
    ```
    
    确实多了 **:0000000c	snlua snaxd s2** 这个服务

5. 注入snax代码
    
    参考s2-call.lua，该脚本用来执行s2服务的调用，在debug_console注入该脚本
    ```bash
    inject c hello-console/s2-call.lua
    ```
    
    第二个参数c是s2的服务地址，即上面的list里看到的 :0000000c ，简写为c.
    
    切换到skynet终端，可以看到对应的输出：
    ```bash
    [:0000000c] <unnamed> send -> begin call
    [:0000000c] hello, console!
    [:0000000c] <unnamed> send -> after call
    ```
    
    注入成功。

6. snax热更新
    
    参考s2-hotfix.lua，该脚本用来对s2执行热更新，将response.echo的输出增加个前缀。在debug_console重新注入该脚本
    
    ```bash
    inject c hello-console/s2-hotfix.lua
    ```
    
    可以看到skynet有<em>[:0000000c] perform hotfix ...</em>的输出字样，下面我们重新注入s2-call.lua，看看skynet终端的输出：
    
    ```bash
    [:0000000c] <unnamed> send -> begin call
    [:0000000c] unnamed->hello, console!
    [:0000000c] <unnamed> send -> after call
    ```
    
    热更新确实成功了。

7. 退出skynet
    
    还需要退出？是的，命令控嘛！
    
    为了方便console调用（其实我是在atom里使用term），写了两个特殊的snlua服务，都放在根目录下：
    
    ```
    abort.lua        退出skynet
    cleancache.lua   清理skynet代码缓存，方便开发调试，功能同debug_console的cleancache命令
    ```
    
    下面知道该怎么做了吧？ 在skynet终端输入**../abort**（注意前面的../）。。。
