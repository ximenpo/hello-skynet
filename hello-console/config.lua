
----------------------------------
--  局部变量
----------------------------------
local _root		= "./"
local _skynet	= _root.."skynet/"

----------------------------------
--  自定义参数
----------------------------------
app_name    	= "hello-console"
app_root    	= _root..app_name.."/"

----------------------------------
--  skynet用到的六个参数
----------------------------------
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
bootstrap   = "snlua bootstrap"

----------------------------------
--  snlua用到的参数
----------------------------------
lua_path    = _skynet.."lualib/?.lua;"..app_root.."?.lua"
lua_cpath   = _skynet.."luaclib/?.so;"..app_root.."?.so"
luaservice  = _skynet.."service/?.lua;"..app_root.."?.lua"
lualoader   = _skynet.."lualib/loader.lua"
start       = "main"

----------------------------------
--  snax用到的参数
----------------------------------
snax    = _skynet.."service/?.lua;"..app_root.."?.lua"
