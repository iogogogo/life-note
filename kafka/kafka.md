# kafka 操作

### 下载地址

```http
http://kafka.apache.org/downloads
```

### 安装步骤

> 解压下载文件到指定目录，比如 /usr/local
>
> tar -zxvf /usr/local/kafka_2.12-1.0.0.tgz

## 停止zookeeper与kafka

```shell
cd /usr/local
./bin/zookeeper-server-stop.sh
./bin/kafka-server-stop.sh
```



## 启动 zookeeper

```shell
cd /usr/local
./bin/zookeeper-server-start.sh -daemon  ./config/zookeeper.properties
```

> -daemon 表示后台运行

## 启动kafka

```shell
cd /usr/local
./bin/kafka-server-start.sh -daemon  ./config/server.properties
```

## 查看kafka与zookeeper是否运行

```
netstat -ntpul | grep 2181
netstat -ntpul | grep 9092
```

## 创建 topic

```shell
./bin/kafka-topics.sh --create --zookeeper 192.168.1.200:2181 --replication-factor 1 --partitions 1 --topic TOPIC_001
```

## 删除topic

> http://blog.csdn.net/fengzheku/article/details/50585972

```shell
./bin/kafka-topics.sh  --delete --zookeeper 192.168.1.200:2181  --topic TOPIC_001
```

## 查看已经存在的topic

```shell
./bin/kafka-topics.sh --list --zookeeper localhost:2181
```

## 查看topic的详细信息

```shell
./bin/kafka-topics.sh --describe --zookeeper 192.168.1.200:2181 --topic TOPIC_001
```

## 生产消息

```shell
./bin/kafka-console-producer.sh --broker-list 192.168.1.200:9092 --topic TOPIC_001
```

##  消费消息

```shell
./bin/kafka-console-consumer.sh --bootstrap-server 192.168.1.200:9092 --topic TOPIC_001 --from-beginning
```



# 解决kafka无法收发消息

> org.apache.kafka.common.errors.TimeoutException

https://www.jianshu.com/p/2db7abddb9e6

```shell
vim /usr/local/kafka/config/server.properties

加入以下配置然后重启zookeeper与kafka
advertised.host.name=192.168.1.200
advertised.port=9092
```