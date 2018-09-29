# 发布jar到nexus3私服

## 修改~/.m2/settings.xml 文件

- servers节点中设置nexus3用户和密码

```xml
<servers>
    <server>
        <id>releases</id>
        <username>admin</username>
        <password>admin</password>
    </server>
    <server>
        <id>snapshots</id>
        <username>admin</username>
        <password>admin</password>
    </server>
</servers>
```

- profiles节点中设置nexus3仓库信息

```xml
<profiles>
    <profile>
        <id>dev</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <properties>
             <releases.repo>http://192.168.31.230:18081/repository/releases</releases.repo>
             <snapshots.repo>http://192.168.31.230:18081/repository/snapshots</snapshots.repo>
        </properties>
     </profile>
  </profiles>

```

## 项目设置

- pom文件中添加

```xml
<!-- upload nexus3 server config -->
<distributionManagement>
    <repository>
        <!-- 这里的id和settings.xml文件中server节点中的id对应 -->
        <id>releases</id>
        <url>http://192.168.31.230:18081/repository/releases</url>
    </repository>
    <snapshotRepository>
        <id>snapshots</id>
        <url>http://192.168.31.230:18081/repository/snapshots</url>
        <!--<url>${snapshots.repo}</url>-->
    </snapshotRepository>
</distributionManagement>
```

- maven-deploy-plugin 可选插件，用来自定义上传模块信息

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-deploy-plugin</artifactId>
    <version>2.8.2</version>
    <configuration>
        <!-- 跳过 module -->
        <skip>true</skip>
    </configuration>
</plugin>
```

## 发布到nexus私服

执行deploy任务即可