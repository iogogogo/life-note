# bootJar

```shell
#!/bin/sh

# kill旧项目，删除旧项目，启动新项目，备份老项目。

DATE=$(date +%s)

cd "$(dirname "$0")"

DIR=$(pwd)

echo $DIR

JARFILE=life-xxx-0.0.1-SNAPSHOT-bootJar.jar

if [ ! -d $DIR/backup ];then
   mkdir -p $DIR/backup
fi
cd $DIR

ps -ef | grep $JARFILE | grep -v grep | awk '{print $2}' | xargs kill -9
cp $JARFILE backup/$JARFILE$DATE

java -jar -Xmx512m -Xss512k $(pwd)/$JARFILE > restart.log &
sleep 5

# if [ $? = 0 ];then
#        sleep 5
#        tail -n 50 restart.log
# fi

cd backup/
ls -lt|awk 'NR>5{print $NF}'|xargs rm -rf

jps

```

# jar 指定classpath

java -cp 需要指定classpath的完全路径【$(pwd)/xxx.jar】，否则进程名称为jar

```shell
#!/bin/sh

cd "$(dirname "$0")"

DIR=$(pwd)

export JAVA_TOOL_OPTIONS="$JAVA_TOOL_OPTIONS -Dfile.encoding=UTF-8"

classPath=$DIR/life-xxx-0.0.1-SNAPSHOT.jar

mainClass=com.xxx.MainApplication

shLogPath=$DIR/restart.log

jps | grep MainApplication | awk "{print \$1}" | xargs kill -9 >/dev/null 2>&1

nohup java -cp "$classPath" "$mainClass" -Xmx4096m -Dfile.encoding=UTF-8 >"$shLogPath" &

jps

```

