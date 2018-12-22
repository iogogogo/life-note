# 安装marathon

```shell
rpm -ivh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum install marathon
```

# 修改marathon的配置

vim /etc/default/marathon

```shell
MARATHON_MASTER="zk://172.26.109.252:2181/mesos"
MARATHON_ZK="zk://172.26.109.252:2181/marathon"
MARATHON_MESOS_USER="root"
```

# 安装mesos

```shell
## 下载mesos.zip 安装包        192.168.31.45. /root/mesos.zip
yum localinstall *             （有依赖）

## 安装好之后修改配置文件：
vi /etc/mesos/zk    （配置zookeeper）
zk://172.26.109.252:2181,172.26.109.248:2181,172.26.109.255:2181/mesos

vi /etc/mesos-master/quorum    （配置集群数量）


启动：
master执行   systemctl start mesos-master.service
slave执行    systemctl start mesos-slave.service
systemctl status mesos-slave.service
```

# 启动marathon

systemctl start marathon

# 查看marathon状态

```shell
systemctl status marathon

## 如果报错用一下命令启动marathon 查看报错信息

nohup marathon --master zk://172.26.109.252:2181/mesos --zk zk://172.26.109.252:2181/marathon & >>nohup.out
## 如果含以下报错信息： 
$export MESOS_NATIVE_JAVA_LIBRARY=/usr/local/lib/libmesos.so
```

