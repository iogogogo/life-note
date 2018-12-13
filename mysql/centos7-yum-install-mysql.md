# 卸载已安装程序

https://www.jianshu.com/p/e54ff5283f18

```shell
# 查看yum是否安装过mysql 如或显示了列表，说明系统中有MySQL
yum list installed mysql*

# yum卸载 根据列表上的名字
yum remove mysql-community-client mysql-community-common mysql-community-libs mysql-community-libs-compat mysql-community-server mysql57-community-release
rm -rf /var/lib/mysql  
rm /etc/my.cnf

# rpm查看安装
rpm -qa | grep -i mysql 
rpm -qa | grep mariadb

# rpm 卸载
rpm -e mysql57-community-release-el7-9.noarch
rpm -e mysql-community-server-5.7.17-1.el7.x86_64
rpm -e mysql-community-libs-5.7.17-1.el7.x86_64
rpm -e mysql-community-libs-compat-5.7.17-1.el7.x86_64
rpm -e mysql-community-common-5.7.17-1.el7.x86_64
rpm -e mysql-community-client-5.7.17-1.el7.x86_64
cd /var/lib/  
rm -rf mysql/

# 清除余项 删除所有的的文件夹
whereis mysql
mysql: /usr/bin/mysql /usr/lib64/mysql /usr/local/mysql /usr/share/mysql /usr/share/man/man1/mysql.1.gz
rm -rf /usr/bin/mysql /usr/lib64/mysql /usr/local/mysql /usr/share/mysql /usr/share/man/man1/mysql.1.gz

# 删除配置
rm –rf /usr/my.cnf
rm -rf /root/.mysql_sercret

# 剩余配置检查
chkconfig --list | grep -i mysql
chkconfig --del mysqld
```



# 通过yum方式安装

https://blog.csdn.net/error395/article/details/79820499

```shell
1.创建一个文件夹：mkdir /usr/local/mysql

2.进入文件夹 cd /usr/local/mysql，下载RPM：wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm

3.安装源：yum localinstall mysql57-community-release-el7-11.noarch.rpm

4.安装mysql：yum install -y mysql-community-server

5.启动服务：systemctl start mysqld

6.开机启动：systemctl enable mysqld; systemctl daemon-reload;

7.查看临时密码：grep 'temporary password' /var/log/mysqld.log;

8.mysql -uroot -p 登录mysql

9.设置新密码：update user set authentication_string=password('新密码，大写字母+数字+字符') where user='root';

10.遇到：You must reset your password using ALTER USER statement before executing this statement.

11. SET PASSWORD = PASSWORD('自己设置密码');

12. ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;

13.设置外部访问数据库：
use mysql; update user set Host='%' where User='root';select host,user from mysql.user;

14. flush privileges;

15.退出，重新登录。

16.查看进程是否存在：netstat -ntpul | grep 3306
```
- yum安装报错error: unpacking of archive failed on file /usr/bin/xxxx: cpio: open Failed

```shell
以前加固时给/usr/bin加了i权限

# lsattr /usr | grep bin ----i-----I-- /usr/bin
# chattr -i /usr/bin 
```

# 设置utf8编码 /etc/my.cnf

```shell
# For advice on how to change settings please see
# httr://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html
# r: unpacking of archive failed on file /usr/bin/mysql_upgrade: cpio: rename failed - Is a directory
#
#
#


[client]
port = 3306
socket = /var/lib/mysql/mysql.sock
default-character-set=utf8


[mysqld]
# 当插入或更新的数据比较大时
max_allowed_packet=20M

character-set-server = utf8

collation-server = utf8_general_ci
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

# 忘记密码找回

```shell
systemctl stop mysqld # redhat系 >=7 # 停止mysql服务
/usr/bin/mysqld_safe --skip-grant-tables # 跳过mysql权限表启动
mysql -uroot #无密码登陆
use mysql; 选择数据表
update user set authentication_string=password('xxxx') where user='root'; # 设置新密码
flush privileges; #刷新权限
```

