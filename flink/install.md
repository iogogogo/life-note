# 本地安装教程

## 下载并启动flink

Flink可在**Linux，Mac OS X和Windows上运行**。为了能够运行Flink，唯一的要求是安装一个有效的**Java 8.x.** Windows用户，请查看[Windows](https://ci.apache.org/projects/flink/flink-docs-release-1.7/tutorials/flink_on_windows.html)上的[Flink](https://ci.apache.org/projects/flink/flink-docs-release-1.7/tutorials/flink_on_windows.html)指南，该指南介绍了如何在Windows上运行Flink以进行本地设置。

### 启动本地Flink群集

```bash
$ ./bin/start-cluster.sh  # Start Flink
```

您还可以通过检查`logs`目录中的日志文件来验证系统是否正在运行：

```shell
$ tail log/flink-*-standalonesession-*.log
INFO ... - Rest endpoint listening at localhost:8081
INFO ... - http://localhost:8081 was granted leadership ...
INFO ... - Web frontend listening at http://localhost:8081.
INFO ... - Starting RPC endpoint for StandaloneResourceManager at akka://flink/user/resourcemanager .
INFO ... - Starting RPC endpoint for StandaloneDispatcher at akka://flink/user/dispatcher .
INFO ... - ResourceManager akka.tcp://flink@localhost:6123/user/resourcemanager was granted leadership ...
INFO ... - Starting the SlotManager.
INFO ... - Dispatcher akka.tcp://flink@localhost:6123/user/dispatcher was granted leadership ...
INFO ... - Recovering all persisted jobs.
INFO ... - Registering TaskManager ... under ... at the SlotManager.
```

### 安装nc、netstat等工具

```bash
yum install -y nc  # nc
yum install -y net-tools  # netstat
```

# Examples wordCount 

- 通过**netcat**启动本地服务

```bash
nc -l 9000
```

- 提交job给flink

```bash
$ ./bin/flink run examples/streaming/SocketWindowWordCount.jar --port 9000
Starting execution of program
```

- 停止flink

```bash
$ ./bin/stop-cluster.sh
```



- 单词在5秒的时间窗口（处理时间，翻滚窗口）中计算并打印到`stdout`。监视TaskManager的输出文件并写入一些文本`nc`（输入在点击后逐行发送到Flink）：

```bash
$ nc -l 9000
lorem ipsum
ipsum ipsum ipsum
bye
```

该`.out`文件将在每个时间窗口结束时，只要打印算作字浮在，例如：

```bash
$ tail -f log/flink-*-taskexecutor-*.out
lorem : 1
bye : 1
ipsum : 4
```