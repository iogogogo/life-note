## 运行zookeeper
docker-compose -f docker-zk.yml up -d

## 运行kafka
docker-compose -f docker-kafka.yml  up -d

## 创建 topic
./bin/kafka-topics.sh --create --zookeeper 192.168.0.116:2181 --replication-factor 1 --partitions 1 --topic test

## 查看topic列表
./bin/kafka-topics.sh --list --zookeeper 192.168.0.116:2181

## 生产消息
./bin/kafka-console-producer.sh --broker-list 192.168.0.116:9092 --topic test

## 消费消息
./bin/kafka-console-consumer.sh --bootstrap-server 192.168.0.116:9092 --topic test --from-beginning