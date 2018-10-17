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

