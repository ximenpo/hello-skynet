
----------------------------------
--  局部变量
----------------------------------
local _root		= "./"
local _skynet	= _root.."skynet/"

----------------------------------
--  自定义参数
----------------------------------
app_name    	= "hello-world"
app_root    	= _root..app_name.."/"

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
cpath       = _skynet.."cservice/?.so"
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
lua_path    = _skynet.."lualib/?.lua;"..app_root.."/?.lua"
lua_cpath   = _skynet.."luaclib/?.so;"..app_root.."/?.so"
lualoader   = "skynet/lualib/loader.lua"
luaservice  = _skynet.."service/?.lua;"..app_root.."/?.lua"

--  采用snlua bootstrap启动hello-world模块
--[[
bootstrap   = "snlua bootstrap"
start       = "main"
--]]
