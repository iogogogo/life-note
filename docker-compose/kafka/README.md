## kafka 集群创建

```shell
# 集群启动方式
docker-compose -f docker-compose-9093.yml up -d
docker-compose -f docker-compose-9094.yml scale kafka=2
docker-compose -f docker-compose-9095.yml scale kafka=3
```

## kafka 消息生产与消费

```Shell
# 进入kafka容器
docker exec -it [container-name] /bin/bash
# 进入安装目录
cd /opt/kafka/

## 创建 topic
./bin/kafka-topics.sh --create --zookeeper 192.168.1.6:2182 --replication-factor 1 --partitions 1 --topic test

## 查看topic列表
./bin/kafka-topics.sh --list --zookeeper 192.168.1.6:2183

## 生产消息
./bin/kafka-console-producer.sh --broker-list 192.168.1.6:9093 --topic test

## 消费消息
./bin/kafka-console-consumer.sh --bootstrap-server 192.168.1.6:9095 --topic test --from-beginning
```

## 关于 *KAFKA_ADVERTISED_HOST_NAME* 属性
https://www.jianshu.com/p/2db7abddb9e6