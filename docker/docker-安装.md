# docker安装

### 关闭防火墙

```shell
# 停止firewall
systemctl stop firewalld.service

# 禁止firewall开机启动
systemctl disable firewalld.service
```
### docker安装

> - 在线安装地址
>
> https://docs.docker.com/install/linux/docker-ce/centos/
>
> - 离线安装地址
>
> rpm包下载地址：https://download.docker.com/
>
> 安装教程：https://blog.csdn.net/h363659487/article/details/77159306

- 在线安装脚本

```Shell
# 卸载旧版本docker
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

# 安装yum-utils
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
 # 配置docker-ce.repo
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
# 安装docker-ce
sudo yum install docker-ce

# 启动docker
sudo systemctl start docker

# Docker守护进程自启动
sudo systemctl enable docker.service

# 显示docker版本
docker --version
```

# 设置docker中国镜像

```Shell
vi  /etc/docker/daemon.json
#添加后
{
    "registry-mirrors": ["https://registry.docker-cn.com"],
    "live-restore": true
}
```

# docker-compose 安装

```shell
#下载
sudo curl -L https://github.com/docker/compose/releases/download/1.20.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

#安装
chmod +x /usr/local/bin/docker-compose

# 显示docker-compose版本
docker-compose version
```

# 设置软件源(可选)

```shell
# 1、打开centos的yum文件夹
输入命令cd  /etc/yum.repos.d/

# 2、用wget下载repo文件
输入命令wget  http://mirrors.aliyun.com/repo/Centos-7.repo
如果wget命令不生效，说明还没有安装wget工具，输入yum -y install wget 回车进行安装。
当前目录是/etc/yum.repos.d/，刚刚下载的Centos-7.repo也在这个目录上

# 3、备份系统原来的repo文件
mv  CentOs-Base.repo CentOs-Base.repo.bak
即是重命名 CentOs-Base.repo -> CentOs-Base.repo.bak

# 4、替换系统原理的repo文件
mv Centos-7.repo CentOs-Base.repo
即是重命名 Centos-7.repo -> CentOs-Base.repo

# 5、执行yum源更新命令
yum clean all
yum makecache
yum update
依次执行上述三条命令即配置完毕。
```

