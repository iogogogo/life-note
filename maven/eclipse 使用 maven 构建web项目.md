# 环境准备
* apache-maven-3.3.9
  http://maven.apache.org/download.cgi
* apache-tomcat-8.5.20
  http://tomcat.apache.org/download-80.cgi
* eclipse-jee-neon-3
  https://www.eclipse.org/downloads/eclipse-packages/
* jdk1.8.0_131
  http://www.oracle.com/technetwork/java/javase/downloads/jdk-netbeans-jsp-142931.html

# Maven基本配置 修改 setting.xml 文件
apache-tomcat-8.5.20/conf/settings.xml

> 1.仓库本地存储位置 


![本地仓库位置](http://upload-images.jianshu.io/upload_images/7779890-c8fb765b2c991b72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 2.配置阿里云国内的中央仓库，提升下载速度  mirrors 节点内
```
<mirror>
        <!-- 配置 阿里云 maven 镜像仓库，提升国内下载速度 -->
        <id>alimaven</id>
            <mirrorOf>central</mirrorOf>
            <name>aliyun maven</name>
            <url>http://maven.aliyun.com/nexus/content/repositories/central/</url>
        </mirror>
    
        <mirror>
            <id>repo1</id>
            <mirrorOf>central</mirrorOf>
            <name>Human Readable Name for this Mirror.</name>
            <url>http://repo1.maven.org/maven2/</url>
        </mirror>
    
        <mirror>
            <id>repo2</id>
            <mirrorOf>central</mirrorOf>
            <name>Human Readable Name for this Mirror.</name>
            <url>http://repo2.maven.org/maven2/</url>
        </mirror>
  </mirrors>
```

![阿里云maven镜像](http://upload-images.jianshu.io/upload_images/7779890-fdbaf1e3853ed100.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 3.配置编译时的jdk版本，可以在这里配置全局，也可以根据项目配置  profiles 节点内

```
<profile>
    <!-- 配置全局的jdk -->
		<id>jdk1.8</id>    
		<activation>   
			<activeByDefault>true</activeByDefault>    
			<jdk>1.8</jdk>   
		</activation>    
		<properties>   
			<maven.compiler.source>1.8</maven.compiler.source>    
			<maven.compiler.target>1.8</maven.compiler.target>    
			<maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>   
		</properties> 
	</profile>
```

![全局的jdk版本配置](http://upload-images.jianshu.io/upload_images/7779890-e1f345185ced9580.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# eclipse 集成maven插件

![eclipse配置maven](http://upload-images.jianshu.io/upload_images/7779890-28a74e4a3f382413.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![配置全局参数](http://upload-images.jianshu.io/upload_images/7779890-88b11320dd52174c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 新建maven项目

![新建maven项目](http://upload-images.jianshu.io/upload_images/7779890-6604d11226479dcf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![新建maven项目](http://upload-images.jianshu.io/upload_images/7779890-997fc5ccae6f10b6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![新建maven项目](http://upload-images.jianshu.io/upload_images/7779890-99ce19045b39d6e4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![项目结构](http://upload-images.jianshu.io/upload_images/7779890-9909613ef55aadd9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 将项目转换成maven web 项目
右键打开项目设置

![修改项目结构](http://upload-images.jianshu.io/upload_images/7779890-ee1c890c8ecfe527.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![生成web.xml](http://upload-images.jianshu.io/upload_images/7779890-a498a41384ef79f0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![修改以后的项目结构](http://upload-images.jianshu.io/upload_images/7779890-20c12ea65ea902f5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 但是现在这个不是一个标准的web项目，继续修改项目结构，将WebContent目录下的文件拷贝到main/webapp目录下面，删除WebContent目录，结构如下

![删除WebContent目录以后](http://upload-images.jianshu.io/upload_images/7779890-bc62b88cce18515e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![删除WebContent](http://upload-images.jianshu.io/upload_images/7779890-6cd7c408aea55e6d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![指定 webapp 目录](http://upload-images.jianshu.io/upload_images/7779890-0589e69ddc98be2a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![选择 webapp ](http://upload-images.jianshu.io/upload_images/7779890-0c5d4e9d5aeecea0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![选择 webapp](http://upload-images.jianshu.io/upload_images/7779890-7d291661d94d9456.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![修改完成以后的目录结构](http://upload-images.jianshu.io/upload_images/7779890-6731709025e9acdf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![更新项目maven配置](http://upload-images.jianshu.io/upload_images/7779890-b47340bc89895406.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![提示更新](http://upload-images.jianshu.io/upload_images/7779890-1ec60f2529acf211.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![错误解决以后成为一个标准的web项目](http://upload-images.jianshu.io/upload_images/7779890-6a9678cfb6fa765a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


# 配置运行该项目

> 1. 在webapp右键新建一个html 文件

![新建 html 文件，编写内容](http://upload-images.jianshu.io/upload_images/7779890-081eca38dc3869be.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

> 2.配置 tomcat

![配置运行项目](http://upload-images.jianshu.io/upload_images/7779890-ebc8d197b81f8a55.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![选择tomcat对应的版本](http://upload-images.jianshu.io/upload_images/7779890-628a5eaeca05c239.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![选择 tomcat 安装路径](http://upload-images.jianshu.io/upload_images/7779890-97c2fb6d82f0dd12.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


> 3.运行

![运行项目](http://upload-images.jianshu.io/upload_images/7779890-ef7e7c1fcba3897b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# eclipse 集成 maven 构建 web 项目完成
## 最后推荐一篇文章：在 idea 中如何使用 maven 构建web项目
https://yq.aliyun.com/articles/111053