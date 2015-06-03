# hello-skynet

skynet学习例子

# 列表

### `hello-world`
打印"hello, world!"并退出, 有两种启动方式

* 直接启动lua服务
* 用bootstrap启动lua服务[skynet缺省]

### `hello-slave`
建立一个master节点，每次有新slave连上来的时候，就给这个slave发送一条“hello, slave{{slaveid}}!”的消息，其中{{slaveid}}为新连上来slave的slaveid。

* master/slave模式
* uniqueservice/name
* send

### `hello-slaves`
在hello-slave基础上, 当有新的slave连接上来时，给所有的slave（包括新连接上来这个），发送“hello, slaveN!”的消息

* datacenter
* multicast

### `hello-console`
把skynet当成虚拟机,用控制台来操控

* console服务
* debug_console服务

### `hello-socket`

### `hello-socketchannel`
socketchannel应用.在hello-socket基础上, 服务端不变, 客户端从socket改为socketchannel方式.

### `hello-gateserver`
gateserver应用, 这里采用watchdog模式.

### `hello-cluster`
cluster应用, 采用snlua服务.

### `hello-cluster-snax`
cluster应用, 采用snax服务.
