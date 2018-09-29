# 任务调度API接口

- 任务信息

| 字段                   | 类型   | 备注                                           | 必填|
| ---------------------- | ------ | ---------------------------------------------- |--------- |
| id                     | string | jobId，根据module自定义前缀                           | ✔️ |
| jobGroupName           | string | 执行器名称，对应appName                        | ✔️ |
| jobDesc                | string | 任务描述                                       | ❌ |
| executorRouteStrategy  | string | 执行器路由策略，详见执行器路由策略详情         | ✔️ |
| jobCron                | string | 任务执行CRON表达式 【base on quartz】          | ✔️ |
| glueType               | string | GLUE类型 #com.xxl.job.core.glue.GlueTypeEnum   | ✔️ |
| executorHandler        | string | 执行器，任务Handler名称                        | ✔️ |
| executorParam          | string | 执行器，任务参数                               | ❌ |
| childJobId             | string | 子任务ID，多个逗号分隔                         | ❌ |
| executorTimeout        | int    | 任务执行超时时间，单位秒                       | ❌ |
| executorBlockStrategy  | string | 阻塞处理策略，详见阻塞处理策略详情             | ✔️ |
| executorFailRetryCount | int    | 失败重试次数                                   | ❌ |
| alarmEmail             | string | 报警邮件，多个[，]分割                         | ❌ |
| author                 | string | 负责人                                   | ✔️ |
| glueRemark             | string | GLUE备注                                      | ✔️ |
| glueSource             | string | GLUE源代码（Java、nodejs、Python、php、shell | ❌ |

- 执行器路由策略详情

| 名称 | 枚举值 | 备注 |
| ---- | ---- | ---- |
|第一个|        FIRST       ||
|最后一个|      LAST        ||
|轮询|          ROUND       ||
|随机|          RANDOM      ||
|一致性HASH| CONSISTENT_HASH ||
|最不经常使用| LEAST_FREQUENTLY_USED ||
|最近最久未使用|LEAST_RECENTLY_USED            ||
|故障转移|      FAILOVER    ||
|忙碌转移|      BUSYOVER    ||
|分片广播| SHARDING_BROADCAST ||

- glueType 详细信息

| 名称             | 枚举值          | 备注 |
| ---------------- | --------------- | ---- |
| BEAN             | BEAN            |      |
| GLUE(Java)       | GLUE_GROOVY     |      |
| GLUE(Shell)      | GLUE_SHELL      |      |
| GLUE(Python)     | GLUE_PYTHON     |      |
| GLUE(PHP)        | GLUE_PHP        |      |
| GLUE(Nodejs)     | GLUE_NODEJS     |      |
| GLUE(PowerShell) | GLUE_POWERSHELL |      |

- 阻塞处理策略详情

| 名称         | 枚举值           | 备注 |
| ------------ | ---------------- | ---- |
| 单机串行     | SERIAL_EXECUTION |      |
| 丢弃后续调度 | DISCARD_LATER    |      |
| 覆盖之前调度 | COVER_EARLY      |      |



## 添加任务

POST：/api/job/

request：

```json
{
	"id":"task_test_001",
    "jobGroupName": "job-executor-sample",
    "jobDesc": "api-测试任务-001",
    "executorRouteStrategy": "FAILOVER",
    "jobCron": "0/5 * * * * ?",
    "glueType": "BEAN",
    "executorHandler": "demoJobHandler",
    "executorParam": "123",
    "childJobId": "",
    "executorTimeout": 0,
    "executorBlockStrategy": "SERIAL_EXECUTION",
    "executorFailRetryCount": 0,
    "alarmEmail": "",
    "author": "吴公子",
    "glueRemark": "GLUE代码初始化",
    "glueSource": ""
}
```

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```



## 删除任务

DELETE：/api/job/{id}

request：

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```

## 修改任务
PUT：/api/job/

request：

```json
{
	"id":"task_test_001",
    "jobGroupName": "job-executor-sample",
    "jobDesc": "api-测试任务-003",
    "executorRouteStrategy": "FAILOVER",
    "jobCron": "0/5 * * * * ?",
    "glueType": "BEAN",
    "executorHandler": "demoJobHandler",
    "executorParam": "123",
    "childJobId": "",
    "executorTimeout": 0,
    "executorBlockStrategy": "SERIAL_EXECUTION",
    "executorFailRetryCount": 0,
    "alarmEmail": "",
    "author": "吴公子",
    "glueRemark": "GLUE代码初始化",
    "glueSource": ""
}
```

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```

## 获取任务列表
GET：/api/job/

request：

| 字段            | 类型   | 备注           |
| --------------- | ------ | -------------- |
| start           | int    | 起始页，默认0  |
| length          | Int    | 页大小，默认10 |
| jobGroup        | Int    | 执行器主键ID   |
| jobDesc         | String | 任务描述       |
| executorHandler | String | 执行器名称     |
| filterTime      | String | 过滤时间       |

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```

## 暂停任务
POST：/api/job/pause/{id}

request：

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```

## 启动恢复任务
POST：/api/job/resume/{id}

request：

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```

## 触发任务
POST：/api/job/trigger/{id}

request：

response：

```json
{
    "code": 200,
    "msg": null,
    "content": null
}
```
