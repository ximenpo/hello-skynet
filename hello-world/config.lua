
----------------------------------
--  自定义参数
----------------------------------
app_root    = "./"
app_name    = "hello-world"

----------------------------------
--  skynet用到的六个参数
----------------------------------
--[[
	config.thread      = optint("thread",8);
	config.module_path = optstring("cpath","./cservice/?.so");
	config.harbor      = optint("harbor", 1);
	config.bootstrap   = optstring("bootstrap","snlua bootstrap");
	config.daemon      = optstring("daemon", NULL);
	config.logger      = optstring("logger", NULL);
--]]
--  工作线程数
thread      = 2
--  服务模块路径（.so)
cpath       = app_root.."skynet/cservice/?.so"
--  港湾ID，用于分布式系统，0表示没有分布
harbor      = 0
--  后台运行用到的 pid 文件
daemon      = nil
--  日志文件
logger      = nil
--  初始启动的模块
bootstrap   = "snlua hello-world"

----------------------------------
--  snlua用到的参数
----------------------------------
lua_path    = nil
lua_cpath   = nil
lualoader   = "skynet/lualib/loader.lua"
luaservice  = app_root.."skynet/service/?.lua;"..app_root..app_name.."/?.lua"
