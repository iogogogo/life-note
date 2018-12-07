[TOC]

# Mac brew

https://juejin.im/post/5a561685f265da3e2b164fe7

# base-complete

- 安装epel 源

```shell
yum -y install epel-release
```

- 加快yum速度

```shell
yum -y install yum-plugin-fastestmirror
```

- 安装bash-completion

```shell
yum -y install bash-completion
# CentOS 7 再多安装一个
yum -y install bash-completion-extras 
```

- 立即生效

```shell
source /etc/profile.d/bash_completion.sh 
```




# 防火墙设置

https://www.cnblogs.com/moxiaoan/p/5683743.html

- firewalld的基本使用

```shell
启动： systemctl start firewalld

关闭： systemctl stop firewalld

查看状态： systemctl status firewalld 

开机禁用  ： systemctl disable firewalld

开机启用  ： systemctl enable firewalld
```

- systemctl是CentOS7的服务管理工具中主要的工具，它融合之前service和chkconfig的功能于一体。

```shell
启动一个服务：systemctl start firewalld.service

关闭一个服务：systemctl stop firewalld.service

重启一个服务：systemctl restart firewalld.service

显示一个服务的状态：systemctl status firewalld.service

在开机时启用一个服务：systemctl enable firewalld.service

在开机时禁用一个服务：systemctl disable firewalld.service

查看服务是否开机启动：systemctl is-enabled firewalld.service

查看已启动的服务列表：systemctl list-unit-files|grep enabled

查看启动失败的服务列表：systemctl --failed
```

- 配置firewalld-cmd

```shell
查看版本： firewall-cmd --version

查看帮助： firewall-cmd --help

显示状态： firewall-cmd --state

查看所有打开的端口： firewall-cmd --zone=public --list-ports

更新防火墙规则： firewall-cmd --reload

查看区域信息:  firewall-cmd --get-active-zones

查看指定接口所属区域： firewall-cmd --get-zone-of-interface=eth0

拒绝所有包：firewall-cmd --panic-on

取消拒绝状态： firewall-cmd --panic-off

查看是否拒绝： firewall-cmd --query-panic
```

- 开启一个端口 

```shell
# 添加（--permanent永久生效，没有此参数重启后失效）
firewall-cmd --zone=public --add-port=80/tcp --permanent    

# 重新载入
firewall-cmd --reload

# 查看
firewall-cmd --zone= public --query-port=80/tcp

# 删除
firewall-cmd --zone= public --remove-port=80/tcp --permanent
```





# 设置centos时区

- 查看当前时区设置

```shell
timedatectl  status或timedatectl  status |grep "Time zone"
```

- 设置时区

```shell
timedatectl set-timezone Asia/Shanghai
```

- 同步

```shell
ntpdate time.nist.gov
```



# docker 阿里云镜像配置

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://35m724jj.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```



# centos 配置 jdk

```shell
卸载openjdk
rpm -qa | grep openjdk  
yum -y remove java-1.7.0-openjdk-1.7.0.181-2.6.14.8.el7_5.x86_64
yum -y remove java-1.7.0-openjdk-headless-1.7.0.181-2.6.14.8.el7_5.x86_64
yum -y remove java-1.8.0-openjdk-1.8.0.171-8.b10.el7_5.x86_64

配置jdk环境变量sudo vim /etc/profile

export JAVA_HOME=/usr/local/jdk1.8.0_171
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
export PATH=$PATH:$JAVA_HOME/bin

source /etc/profile
```



# gradle 环境变量配置

```shell
vim /etc/profile
export GRADLE_HOME=/usr/local/gradle-4.5
export PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin:${GRADLE_HOME}/bin:${JAVA_HOME}:${PATH}
source /etc/profile 
```



# 安装 git

[CentOS-7-安装最新的-Git](https://ehlxr.me/2016/07/30/CentOS-7-%E5%AE%89%E8%A3%85%E6%9C%80%E6%96%B0%E7%9A%84-Git/)



* 卸载yum安装的git

  ```shell
  yum remove git
  ```

* 确保安装gcc、g++以及编译git所需要的包

  ```shell
  --安装gcc
  yum install gcc

  --安装g++
  yum install gcc-c++

  --安装编译所需的包
  yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
  yum install gcc perl-ExtUtils-MakeMaker
  ```

* 下载源码(*.tar.gz)到指定的目录

  ```shell
  wget /tmp https://github.com/git/git/archive/v2.16.1.tar.gz
  ```

* 切换到刚刚保存下载文件的目录并解压文件

  ```shell
  # 切换到指定目录
  cd /tmp

  # 解压源码包
  tar -zxvf git-2.15.1.tar.gz
  ```

* 进入解压目录

  ```shell
  mv git-2.15.1 /usr/local/
  cd /usr/local/git-2.15.1/
  ```

* 配置安装目录并编译和安装

  ```shell
  cd git-2.9.2
  make prefix=/usr/local/git all
  make prefix=/usr/local/git install
  ```

* 将编译好的git/bin目录添加到bashrc中，相当于添加全局变量

  ```shell
  echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
  source /etc/bashrc # 实时生效
  ```

* 查看git版本

  ```shell
  git --version
  ```
