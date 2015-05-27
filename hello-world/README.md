# hello-world

功能如下：
>
> 打印“hello, world!”，并退出
>

具体步骤如下：

1. 新建git库，将skynet作为子模块放到根目录下的skynet文件

2. 进入skynet目录，编译skynet，参考<a href="https://github.com/cloudwu/skynet/wiki/Build" target="_blank">Build</a>

3. 新建hello-world目录，并添加 config.lua 和 hello-world.lua 两个文件(具体可参考注释)

4. 进入git库根目录，敲入代码测试：
    ```bash
    study-skynet simple$ skynet/skynet hello-world/config.lua
    ```
    
    如果一切正常的话，屏幕上将会出现类似下面的文字
    ```bash
    study-skynet simple$ skynet/skynet hello-world/config.lua 
    [:00000001] LAUNCH logger 
    [:00000002] LAUNCH snlua hello-world
    [:00000002] hello, world!
    study-skynet simple$
    ```
    
5. 内容说明

    ```bash
      *   输出错误信息：          skynet.error(...)
      *   获取本地服务句柄方式：  skynet.localname(...)
      *   设置定时器方式：        skynet.timeout(...)
      *   skynet强制退出方式：    skyname.abort()
      *   服务开始方式：          skynet.start(...)
      *   服务注销方式：          skynet.exit()
      *   发送原始文本消息方式：  skynet.core.send(...)
    ```

6. 思考

这里的采用的是直接 snlua hello-world 方式，即hello-world.lua作为第一个启用的服务。你可以尝试换成缺省的 snlua bootstrap 方式，观察下输出有什么不同，为什么？

`备注：取消 config.lua 最后一段的注释。`
