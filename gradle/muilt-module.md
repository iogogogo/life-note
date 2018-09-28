# gradle构建多模块项目

- 根gradle配置

```groovy
group = 'com.xxx'
version = '0.0.1-SNAPSHOT'

buildscript {
    ext {
        springBootVersion = '2.0.5.RELEASE'
        javaVersion = JavaVersion.VERSION_1_8
    }
    repositories {
        mavenLocal()
        maven { url 'http://maven.aliyun.com/nexus/content/groups/public/' }
        maven { url 'http://maven.aliyun.com/nexus/content/repositories/jcenter' }
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
    }
}

subprojects {

    apply plugin: 'java'
    // test 覆盖率
    apply plugin: "jacoco"
    apply plugin: 'org.springframework.boot'
    apply plugin: 'io.spring.dependency-management'

    sourceCompatibility = "${javaVersion}"
    targetCompatibility = "${javaVersion}"

    repositories {
        mavenLocal()
        maven { url 'http://maven.aliyun.com/nexus/content/groups/public/' }
        maven { url 'http://maven.aliyun.com/nexus/content/repositories/jcenter' }
        mavenCentral()
    }

    configurations.all {
        // check for updates every build
        resolutionStrategy.cacheChangingModulesFor 0, 'seconds'
    }

    // JavaDoc utf8
    tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
    }

    // 多模块打包需要配置
    jar.enabled = true

    jacoco {
        toolVersion = "0.8.1"
    }

    // code coverage param
    jacocoTestReport {
        reports {
            xml.enabled = false
            html.enabled = true
        }
    }

    // code coverage
    check.dependsOn jacocoTestReport

    configurations.all {
        // check for updates every build SNAPSHOT 变化实时获取
        resolutionStrategy.cacheChangingModulesFor 0, 'seconds'
    }

    // JavaDoc utf8
    tasks.withType(Javadoc) {
        options.addStringOption('Xdoclint:none', '-quiet')
        options.addStringOption('encoding', 'UTF-8')
        options.addStringOption('charSet', 'UTF-8')
    }

    apply from: '../gradle/common.gradle'

    dependencies {

    }
}
```

- 子模块gradle配置

```groovy
group 'com.xxx'
version '0.0.1-SNAPSHOT'
// 指定打包的jar名称
archivesBaseName = 'life-xxx'

// spring boot 打包生成的名字会有后缀，不设置会被jar任务覆盖，生成的jar不会有classpath信息
bootJar.classifier = "bootJar"

dependencies {
    // 引入依赖项目
    compile project(":common")
    // 引入其他依赖组件
    compile group: 'com.baomidou', name: 'mybatis-plus-boot-starter', version: '3.0.3'
    compile('mysql:mysql-connector-java')
}

// jar任务不会有classpath信息，以下配置为了打包classpath信息
String mainClassName = "com.xxx.MainApplication"

// copy jar target
task copyJar(type: Copy) {
    from configurations.runtime
    into('build/libs/lib')
}

jar {
    baseName "${archivesBaseName}"
    version "${version}"
    String someString = ''
    // 遍历项目的所有依赖的jar包赋值给变量someString
    configurations.runtime.each { someString = someString + " lib/" + it.name }
    manifest {
        attributes 'Main-Class': mainClassName
        attributes 'Class-Path': someString
    }
}.dependsOn(copyJar)

```

