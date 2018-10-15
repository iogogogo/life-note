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
