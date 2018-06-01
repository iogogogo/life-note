# **1.下载MySQL Community Server** 

地址：http://dev.mysql.com/downloads/mysql/

选择Windows (x86, 64-bit), ZIP Archive进行下载。

现在最新版本是5.7.19，笔者这里是5.7.17

![img](https://upload-images.jianshu.io/upload_images/7779890-73ecf6d14210466b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 

下载mysql

# **2.配置mysql 环境变量**

我这里将下载好的mysql-5.7.17 解压到 C:\Program Files\mysql-5.7.17-winx64

配置

**MYSQL_HOME  —>  C:\Program Files\mysql-5.7.17-winx64**

**Path 环境变量中加入    %MYSQL_HOME%/bin;**

注意如果path最后一个没有; 记得自己手动添加;

![配置环境变量](https://upload-images.jianshu.io/upload_images/7779890-c82f23f38b84c1ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 



 ![img](https://upload-images.jianshu.io/upload_images/7779890-1ed35c42cf341d90.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 

![配置 MYSQL_HOME](https://upload-images.jianshu.io/upload_images/7779890-a0475d1295ec9ce4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![img](https://upload-images.jianshu.io/upload_images/7779890-7a4fd66e2b766afd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 

配置 Path

# **3. 修改mysql 配置文件** 

3.1.复制解压目录下的 my-default.ini 文件将名称修改为 my.ini 修改文件内容

 ![img](https://upload-images.jianshu.io/upload_images/7779890-a6de142ab813ad8a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

复制 my.ini 文件

3.2.打开 my.ini 修改文件内容

basedir = C:\Program Files\mysql-5.7.17-winx64

datadir = C:\Program Files\mysql-5.7.17-winx64\data

port = 3306

注意：去掉源文件上述三行前面的#

![img](https://upload-images.jianshu.io/upload_images/7779890-01482d69cb731a3c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

配置 my.ini 文件

# **4. 注册windows系统服务** 

以管理员权限打开cmd

执行

mysqld install MySQL --defaults-file="C:\Program Files\mysql-5.7.17-winx64\my.ini"

![img](https://upload-images.jianshu.io/upload_images/7779890-4b560979e280ef7e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

安装windows系统服务

注册表中查看ImagePath的值

我的为

"C:\Program Files\mysql-5.7.17-winx64\bin\mysqld" --defaults-file="C:\Program Files\mysql-5.7.17-winx64\my.ini" MySQL

其中包含了mysqld，就不修改了。

注册表位置为：

\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MySQL

 ![img](https://upload-images.jianshu.io/upload_images/7779890-764ad0cb56f7a1b4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

查看注册表 可省略

# **5. 执行mysqld --initialize进行初始化（生成data目录）** 

**执行 mysqld --initialize**

![img](https://upload-images.jianshu.io/upload_images/7779890-54c06e5e88d80d03.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

生成data目录

# 6. 启动 MySQL 服务 

执行 net start mysql

 ![img](https://upload-images.jianshu.io/upload_images/7779890-36b66e48a493be78.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

启动mysql服务

# 7.登录mysql 修改 root 账户默认密码 

默认密码保存在生成data目录下面的 .err 文件中 记事本打开以后查找初始化密码

A temporary password is generated for root@localhost: [密码]

我的为

![img](https://upload-images.jianshu.io/upload_images/7779890-f6105fb43d110ed3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

![img](https://upload-images.jianshu.io/upload_images/7779890-cee82bdbca026017.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

查看mysql默认密码

 

查看mysql默认密码

执行 mysql –uroot –p  复制刚刚上面的初始化密码完成登录

修改默认密码

执行 SET PASSWORD = PASSWORD('');  我这里将密码设置为空

执行完成以后退出mysql 就可以使用新密码进行登录了

 

使用默认密码登录mysql

![img](https://upload-images.jianshu.io/upload_images/7779890-2e1ff6ff641fc0a1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) 

修改root账户密码为空

![img](https://upload-images.jianshu.io/upload_images/7779890-78b583f159ef7e16.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 8.修改mysql 默认编码 

8.1.执行 show variables like 'character_set_%';  查看 mysql 编码

 ![img](https://upload-images.jianshu.io/upload_images/7779890-f980b405e8a7a985.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

查看mysql默认编码字符

8.2.修改 my.ini 文件

 ![img](https://upload-images.jianshu.io/upload_images/7779890-592115d4c335f4fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

修改配置mysql编码

8.3.重启mysql

 ![img](https://upload-images.jianshu.io/upload_images/7779890-b9fe603076e9cbb6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

重启mysql并且重新登录

8.4执行 show variables like 'character_set_%';  查看 mysql 编码

 ![img](https://upload-images.jianshu.io/upload_images/7779890-ce2989ab8b44781e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

查看修改以后的编码字符 utf8

注意：

网上很多资源都是在[mysqld]下添加

default-character-set=utf8

如果这样改会导致5.7版本mysql无法打开

所以要改为

character-set-server=utf8

改完后，要删除数据库中所有数据，才能使用。

 