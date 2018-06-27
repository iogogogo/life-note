# 镜像拉取

```Shell
sudo docker pull ubuntu:16.04
sudo docker pull centos:7
sudo docker pull redis:4.0.6
sudo docker pull sonatype/nexus3
sudo docker pull memcached:1.5.4
sudo docker pull mongo:3.6.1
sudo docker pull mysql:5.7.20
sudo docker pull jenkins:2.60.3
sudo docker pull nginx:1.13.8
sudo docker pull rabbitmq:3.7.2
sudo docker pull rabbitmq:3.7.2-management
sudo docker pull mobz/elasticsearch-head:5
sudo docker pull elasticsearch:5.6.5
sudo docker pull logstash:5.6.5
sudo docker pull kibana:5.6.5
sudo docker pull zookeeper:3.4.12
sudo docker pull wurstmeister/kafka
```

# docker常用软件部署脚本

### 常见问题

```Shell
# 在centos下映射系统时间
-v /etc/localtime:/etc/localtime \

# 设置docker容器启动时自动启动容器
--restart=always \

# linux下注意需要自己创建文件夹以及授权,mac os用户目录不需要
sudo mkdir -p [dir-name]
sudo chmod -R 777 [dir-name]
```

### docker网络准备

```shell
sudo docker network create -d bridge docker-network
```

### MySQL
```shell
sudo mkdir -p ~/share/docker/data/mysql/data
sudo mkdir -p ~/share/docker/data/mysql/log

sudo chmod 777 -R ~/share/docker/data/mysql/data
sudo chmod 777 -R ~/share/docker/data/mysql/log

sudo docker run  -dit --restart=always --name mysql \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_USER=test -e MYSQL_PASSWORD=123456 \
-v ~/share/docker/data/mysql/data:/var/lib/mysql \
-v ~/share/docker/data/mysql/log:/var/log/mysql \
-v ~/share/docker/data/mysql/config/mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
-p 3306:3306 \
mysql:5.7.20 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci --explicit-defaults-for-timestamp=1

sudo docker network connect docker-network mysql
```

### Redis

```shell
sudo mkdir -p ~/share/docker/data/redis/data

sudo chmod 777 -R ~/share/docker/data/redis/data

sudo docker run  -d  --restart=always --name redis \
-v ~/share/docker/data/redis/data:/data \
-p 6379:6379 \
redis:4.0.6 redis-server --requirepass "redis" --appendonly yes

# requirepass 设置redis密码
# appendonly 保存aof文件

sudo docker network connect docker-network redis
```

### Mongodb

```shell
sudo mkdir -p ~/share/docker/data/mongo/db
sudo mkdir -p ~/share/docker/data/mongo/configdb

sudo chmod 777 -R ~/share/docker/data/mongo/db
sudo chmod 777 -R ~/share/docker/data/mongo/configdb

docker run  -dit --name mongo \
-v ~/share/docker/data/mongo/db:/data/db \
-v ~/share/docker/data/mongo/configdb:/data/configdb \
-p 10300:27017 \
mongo:3.6.1 --storageEngine wiredTiger

docker network connect docker-network mongo
```

### RabbitMQ

```shell
sudo mkdir -p ~/share/docker/data/rabbitmq

sudo chmod -R 777 ~/share/docker/data/rabbitmq

docker run -dit  --name rabbitmq \
--hostname rabbitmq \
--memory 512m \
-e RABBITMQ_VM_MEMORY_HIGH_WATERMARK=0.8 \
-e RABBITMQ_DEFAULT_USER=rabbitmq \
-e RABBITMQ_DEFAULT_PASS=rabbitmq \
-v ~/share/docker/data/rabbitmq:/var/lib/rabbitmq \
-p 4369:4369 \
-p 5671:5671 \
-p 5672:5672 \
-p 15671:15671 \
-p 15672:15672 \
-p 25672:25672 \
rabbitmq:3.7.2-management

docker network connect docker-network rabbitmq

管理端口=>15672
TCP端口=>5672
```

### Nexus3

```shell
sudo mkdir -p ~/share/docker/data/nexus3

sudo chmod -R 777 ~/share/docker/data/nexus3

docker run -dit --name nexus3 \
-v ~/share/docker/data/nexus3:/nexus-data \
-p 8081:8081 \
sonatype/nexus3

默认用户名与密码：admin/admin123
```

### Jenkins

```shell
sudo mkdir -p ~/share/docker/data/jenkins

sudo chmod -R 777 ~/share/docker/data/jenkins

docker run -dit --name jenkins \
-v /etc/localtime:/etc/localtime \
# 设置Jenkins时区
-e JAVA_OPTS=-Duser.timezone=Asia/Shanghai \
-v ~/share/docker/data/jenkins:/var/jenkins_home \
# 映射容器中的基本环境
-v /usr/local/jdk1.8.0_171:/usr/local/jdk1.8.0_171 \
-v /usr/local/apache-maven-3.5.3:/usr/local/apache-maven-3.5.3 \
-v /usr/local/gradle-4.5:/usr/local/gradle-4.5 \
-p 18000:8080 \
-p 50000:50000 \
jenkins:2.60.3

docker network connect docker-network jenkins

jenkis用户名密码：jenkis/jenkis
```

### nginx

```shell
# 运行临时容器
docker run -dit --rm --name some-nginx nginx

# 复制Nginx文件
docker cp some-nginx:/etc/nginx/ ~/share/docker/data/

# 停止临时容器
docker stop some-nginx

# 运行Nginx容器
docker run -dit --name nginx \
-v ~/share/docker/data/nginx/logs:/var/log/nginx \
-v ~/share/docker/data/nginx:/etc/nginx \
-p 80:80 \
-p 443:443 \
nginx
```

# elk 部署脚本

### 启动顺序

```shell
Redis～elasticsearch～logstash～kibana

docker start elk-redis
docker start elk-es
docker start elk-logstash
docker start elk-kibana
```

### 部署前期配置-宿主机准备工作

```shell
## ES启动需要
sudo echo "* soft nofile 65536" >> /etc/security/limits.conf
sudo echo "* hard nofile 65536" >> /etc/security/limits.conf
sudo echo "* soft memlock unlimited" >> /etc/security/limits.conf
sudo echo "* hard memlock unlimited" >> /etc/security/limits.conf
sudo echo "vm.max_map_count = 262144" >> /etc/sysctl.conf
```

### elk-redis

```shell
sudo mkdir -p ~/share/docker/data/elk/redis/data

sudo chmod -R 777 ~/share/docker/data/elk/redis/data

sudo docker run  -d --name elk-redis \
-v ~/share/docker/data/elk/redis/data:/data \
-p 6379:6379 \
redis:4.0.6 redis-server --appendonly yes

sudo docker network connect docker-network elk-redis
```

### elk-es

```shell
sudo mkdir -p ~/share/docker/data/elk/es/config
sudo mkdir -p ~/share/docker/data/elk/es/data

sudo chmod -R 777 ~/share/docker/data/elk/es/config
sudo chmod -R 777 ~/share/docker/data/elk/es/data

# 拷贝配置文件
cd ~/tmp
git clone https://github.com/docker-library/elasticsearch.git
cp  ~/tmp/elasticsearch/5/config/elasticsearch.yml ~/share/docker/data/elk/es/config/elasticsearch.yml
rm -rf ~/tmp/elasticsearch
# 修改配置文件
echo -e "network.host: 0.0.0.0\nhttp.cors.enabled: true\nhttp.cors.allow-origin: \"*\"">> ~/share/docker/data/elk/es/config/elasticsearch.yml

docker run -dit --name elk-es \
-v ~/share/docker/data/elk/es/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml \
-v ~/share/docker/data/elk/es/data:/usr/share/elasticsearch/data \
-p 9200:9200 \
-p 9300:9300 \
elasticsearch:5.6.5

sudo docker network connect docker-network elk-es
```

### elk-logstash

```shell
sudo mkdir -p ~/share/docker/data/elk/logstash/config

sudo chmod -R 777 ~/share/docker/data/elk/logstash/config

touch ~/share/docker/data/elk/logstash/config/redis_to_es.conf
echo -e "input {\n\tredis {\n\t\thost => \"192.168.1.6\"\n\t\tdata_type => \"list\"\n\t\tport => \"6379\"\n\t\tkey => \"elk:file:log\"\n\t\tdb => 2\n\t\tthreads => 5\n\t}\n}\noutput {\n\telasticsearch {\n\t\thosts => [\"elk-es:9200\"]\n\t\tcodec=>\"rubydebug\"\n\t\tindex => \"%{type}-%{+YYYY-MM.dd}\"\n\t}\n}\n" >~/share/docker/data/elk/logstash/config/redis_to_es.conf

docker run -dit --name elk-logstash \
--net=docker-network \
-v ~/share/docker/data/elk/logstash/config:/config-dir \
logstash:5.6.5 -f /config-dir/redis_to_es.conf
```

### elk-kibana

```Shell
sudo mkdir -p ~/share/docker/data/elk/kibana/plugins

sudo chmod -R 777 ~/share/docker/data/elk/kibana/plugins

docker run -dit --name elk-kibana \
--net=docker-network \
# 启动时指定连接的es服务器，不适用后面修改es地址
# -e ELASTICSEARCH_URL=http://192.168.1.6:9200 \
# 直接映射配置文件，需要将容器中的配置文件cp出来，建议使用该方式
-v ~/share/docker/data/elk/kibana/config/kibana.yml:/etc/kibana/kibana.yml \
-v ~/share/docker/data/elk/kibana/plugins:/data/kibana/plugins \
-p 5601:5601 \
kibana:5.6.5 --plugins /data/kibana/plugins

# 后期修改es地址，可使用如下方式
# 拷贝容器配置文件
docker cp elk-kibana:/etc/kibana/kibana.yml ~/share/docker/data/elk/kibana/config/kibana.yml

# 修改配置文件中es地址(elasticsearch.url:)
vim ~/share/docker/data/elk/kibana/config/kibana.yml

# 将修改好的配置文件拷贝到容器(配置文件已经映射，可不进行以下处理)
# docker cp ~/share/docker/data/elk/kibana/config/kibana.yml \
# elk-kibana:/etc/kibana/kibana.yml

# 重启容器
docker restart elk-kibana

# 查看启动日志
docker logs -f --tail 200 elk-kibana
```

# zookeeper与kafka

### zookeeper

```shell
sudo mkdir -p ~/share/docker/data/zookeeper/data
sudo mkdir -p ~/share/docker/data/zookeeper/log
sudo mkdir -p ~/share/docker/data/zookeeper/config

sudo chmod -R 777 ~/share/docker/data/zookeeper/data
sudo chmod -R 777 ~/share/docker/data/zookeeper/config
sudo chmod -R 777 ~/share/docker/data/zookeeper/log

docker run -dit --name zookeeper \
-v ~/share/docker/data/zookeeper/data:/data \
-v ~/share/docker/data/zookeeper/config:/conf \
-v ~/share/docker/data/zookeeper/log:/datalog \
-p 2888:2888 \
-p 3888:3888 \
-p 2181:2181 \
zookeeper:3.4.12

docker network connect docker-network zookeeper
```

### kafka

```shell
sudo mkdir -p ~/share/docker/data/kafka
sudo mkdir -p ~/share/docker/data/kafka/docker.sock

sudo chmod -R 777 ~/share/docker/data/kafka
sudo chmod -R 777 ~/share/docker/data/kafka/docker.sock

docker run -d --name kafka \
--publish 9092:9092 \
--net=docker-network \
--link zookeeper \
--env KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
--env KAFKA_ADVERTISED_HOST_NAME=192.168.1.6 \
--env KAFKA_ADVERTISED_PORT=9092 \
-v ~/share/docker/data/kafka:/kafka \
-v ~/share/docker/data/kafka/docker.sock:/var/run/docker.sock \
wurstmeister/kafka
```

