# maven-assembly-plugin

主要用于归纳整理maven打包文件

## plugin配置

```xml
<!-- assembly build zip -->
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>3.1.0</version>
    <executions>
        <execution>
            <!-- 在package任务以后执行 -->
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
            <configuration>
                <!-- 生产压缩包名称 -->
                <finalName>${project.artifactId}-${project.version}</finalName>
                <appendAssemblyId>false</appendAssemblyId>
                <!-- assembly配置文件 -->
                <descriptors>
                    <descriptor>src/assembly/assembly-descriptor.xml</descriptor>
                </descriptors>
            </configuration>
        </execution>
    </executions>
</plugin>
```

## assembly配置文件

```xml
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.3"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.3 http://maven.apache.org/xsd/assembly-1.1.3.xsd">
    <id>xxx-assembly</id>
    <formats>
        <!-- 输出文件格式 -->
        <format>zip</format>
    </formats>
    <includeBaseDirectory>false</includeBaseDirectory>
    <fileSets>
        <!--scripts -->
        <fileSet>
            <!-- 基于某个目录进行归纳 -->
            <directory>./</directory>
            <!-- 输出文件夹路径 -->
            <outputDirectory/>
            <!-- 需要归纳包含的额内容 -->
            <includes>
                <include>*.sh</include>
                <include>Dockerfile</include>
            </includes>
            <fileMode>0755</fileMode>
            <lineEnding>unix</lineEnding>
        </fileSet>
        <fileSet>
            <directory>target</directory>
            <includes>
                <include>xxx-*.jar</include>
            </includes>
            <outputDirectory/>
            <fileMode>0755</fileMode>
        </fileSet>
        <fileSet>
            <directory>src/main/resources</directory>
            <outputDirectory/>
            <includes>
                <include>*.properties</include>
                <include>logback.xml</include>
            </includes>
        </fileSet>
    </fileSets>
</assembly>

```

