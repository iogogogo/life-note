## Gradle配置
deploy.gradle上传到nexus3私服的脚本



## 排除依赖的jar

```groovy
// 全局排除
configurations {
   compile.exclude group: 'org.slf4j', module: 'jcl-over-slf4j'
}

// 排除某个依赖下的模块
compile ("com.typesafe.akka:akka-http-jackson_${scalaBinaryVersion}:${akkaHttpVersion}") {
    exclude module: 'jackson-databind'
}
```

## 打包zip文件

```groovy
task copyToZip(type: Copy) {
    into "$buildDir/libs/zip/minicap"
    from "$projectDir/minicap"
}

task zip(type: Zip, dependsOn: jar) {
    from 'build/libs'
    into('tools') {
        from 'tools'
    }
    into('ios_local') {
        from 'ios_local'
    }
    version "1.0.0"
    baseName "life-demo"
}
```

## 打包配置

```groovy
def mainClassName = "com.xxx.MainApplication"
def jarName = "life-demo"
def jarVersion = 1.0

//清除上次的编译过的文件
task clearPrj(type: Delete) {
    delete 'build', 'target'
}

task copyJar(type: Copy) {
    from configurations.runtime
    into('build/libs/lib')
}

jar {
    baseName "${jarName}"
    version "${jarVersion}"
    String someString = ''
    // 遍历项目的所有依赖的jar包赋值给变量someString
    configurations.runtime.each { someString = someString + " lib/" + it.name }
    manifest {
        attributes 'Main-Class': "$mainClassName"
        attributes 'Class-Path': someString
    }
}.dependsOn(copyJar)


//把JAR复制到目标目录
task release(type: Copy, dependsOn: [build, copyJar, zip]) {
    // from 'conf'
    // into ('build/libs/eachend/conf') // 目标位置
}
```

## jcoco配置

```groovy
// 添加jcoco插件
apply plugin: "jacoco"

jacoco {
    toolVersion = "0.8.1"
}

jacocoTestReport {
    reports {
        xml.enabled false
        html.enabled true
    }
}

// code coverage
check.dependsOn jacocoTestReport
```

## 设置资源文件路径

```groovy
// 设置资源文件路径
sourceSets.main.resources.srcDirs = ["src/main/scala", "src/main/resources"]
sourceSets.test.resources.srcDirs = ["src/test/scala", "src/test/resources"]
```

