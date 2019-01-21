# maven-assembly-plugin

主要用于归纳整理maven打包文件

## plugin配置

```xml
# 添加属性配置，用于生成归档文件的时间
<maven.build.timestamp.format>yyyyMMdd</maven.build.timestamp.format>
<build.timestamp>${maven.build.timestamp}</build.timestamp>

<plugin>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.1.0</version>
    <configuration>
        <descriptors>
            <descriptor>src/assembly/assembly-descriptor.xml</descriptor>
        </descriptors>
    </configuration>
    <executions>
        <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```

## assembly配置文件

```xml
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2
          http://maven.apache.org/xsd/assembly-1.1.2.xsd">
    <!-- Assembles a packaged version targeting OS installation. -->
    <id>${build.timestamp}</id>
    <formats>
        <format>tar.gz</format>
        <format>zip</format>
    </formats>
    <includeBaseDirectory>false</includeBaseDirectory>
    <fileSets>
        <fileSet>
            <directory>bin</directory>
            <outputDirectory/>
            <fileMode>0755</fileMode>
            <includes>
                <include>*.sh</include>
            </includes>
        </fileSet>

        <fileSet>
            <directory>target</directory>
            <includes>
                <include>life-flink-*.jar</include>
                <include>lib/*</include>
                <include>git-version.properties</include>
            </includes>
            <outputDirectory/>
        </fileSet>

        <fileSet>
            <directory>src/main/resources</directory>
            <outputDirectory/>
            <includes>
                <include>application.properties</include>
                <include>logback.xml</include>
            </includes>
        </fileSet>

    </fileSets>
</assembly>

```

