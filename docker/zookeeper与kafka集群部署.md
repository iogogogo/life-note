# zookeeper集群部署

```shell
version: '3.1'

services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    ports:
      - 2184:2181
    volumes:
      - "~/share/docker/compose-data/zookeeper/zoo1/data:/data"
      - "~/share/docker/compose-data/zookeeper/zoo1/datalog:/datalog"
      - "~/share/docker/compose-data/zookeeper/zoo1/conf:/conf"
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    ports:
      - 2182:2181
    volumes:
      - "~/share/docker/compose-data/zookeeper/zoo2/data:/data"
      - "~/share/docker/compose-data/zookeeper/zoo2/datalog:/datalog"
      - "~/share/docker/compose-data/zookeeper/zoo2/conf:/conf"
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zoo3:2888:3888

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    ports:
      - 2183:2181
    volumes:
      - "~/share/docker/compose-data/zookeeper/zoo3/data:/data"
      - "~/share/docker/compose-data/zookeeper/zoo3/datalog:/datalog"
      - "~/share/docker/compose-data/zookeeper/zoo3/conf:/conf"
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=0.0.0.0:2888:3888
```

# kafka集群部署

```shell
version: '3.1'

services:
  kafka:
    image: wurstmeister/kafka
    restart: always
    hostname: kafka
    ports:
      - 9092:9092
    volumes:
      - "~/share/docker/compose-data/kafka/kafka-9092/docker.sock:/var/run/docker.sock"
      - "~/share/docker/compose-data/kafka/kafka-9092:/kafka"
    environment:
      KAFKA_VERSION: 1.1.0
      KAFKA_ADVERTISED_HOST_NAME: 192.168.1.6
      KAFKA_ADVERTISED_PORT: 9092
      KAFKA_ZOOKEEPER_CONNECT: 192.168.1.6:2182,192.168.1.6:2183,192.168.1.6:2184

# 集群启动方式,注意提前修改文件中的端口,否则会端口冲突,详细文件均在compose/kafka目录
docker-compose -f docker-compose-9093.yml up -d
docker-compose -f docker-compose-9094.yml scale kafka=2
docker-compose -f docker-compose-9095.yml scale kafka=3
```

# kafka-manager

```shell
version: '3.1'

services:
  kafka-manager:
    container_name: kafka-manager
    image: sheepkiller/kafka-manager
    restart: always
    ports:
      - 9000:9000
    environment:
      KM_VERSION: 1.3.3.17
      ZK_HOSTS: 192.168.1.6:2184,192.168.1.6:2182,192.168.1.6:2183
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