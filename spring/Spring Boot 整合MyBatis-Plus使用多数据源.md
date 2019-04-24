# Spring Boot 整合MyBatis-Plus使用多数据源

项目中使用到了MySQL数据库存储配置数据，Vertica中存储指标数据，这样就有两个基于jdbc的数据源，所以需要做到动态配置与切换，并且项目采用了[mybatis-plus](https://mp.baomidou.com/)作为orm框架，所以使用mybatis-plus配置多数据源，这里提供一个配置思路与方案，仅供参考。通过查看mybatis-plus的源码发现，该框架目前连接Vertica时会提示一个警告⚠️ 表示不支持该数据库，实际使用时可以直接使用mybatis执行sql的功能即可。

```
2019-03-19 17:36:20.877  WARN 14103 --- [  restartedMain] c.b.m.extension.toolkit.JdbcUtils        : The jdbcUrl is jdbc:vertica://192.168.21.188:5433/vertica20190122001, Mybatis Plus Cannot Read Database type or The Database's Not Supported!
```

关于MySQL和Vertica的建库建表这边就不放了，直接贴上核心代码。

## pom 配置

```xml
<dependency>
  <groupId>com.baomidou</groupId>
  <artifactId>mybatis-plus-boot-starter</artifactId>
  <version>${mybatisplus.spring.version}</version>
</dependency>
<!-- jdbc driver 这是是官网下载，自己传到内网服务器的jdbc驱动 -->
<dependency>
  <groupId>com.iogogogo.vertica</groupId>
  <artifactId>vertica-jdbc</artifactId>
  <version>9.2.0</version>
</dependency>
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
</dependency>
</dependencies>
```



## 配置文件

```yaml
spring:
  application:
    name: example-dynamic-datasource
  datasource:
    mysql:
      driver-class-name: com.mysql.cj.jdbc.Driver
      hikari:
        auto-commit: true
        connection-test-query: SELECT 1
        connection-timeout: 30000
        idle-timeout: 30000
        max-lifetime: 1800000
        maximum-pool-size: 15
        minimum-idle: 5
        pool-name: MySQLHikariCP
      password: Root@123
      type: com.zaxxer.hikari.HikariDataSource
      jdbc-url: jdbc:mysql://192.168.21.111:3306/life-test?characterEncoding=utf8&useSSL=false
      username: root
    vertica:
      driver-class-name: com.vertica.jdbc.Driver
      hikari:
        auto-commit: true
        connection-test-query: SELECT 1
        connection-timeout: 30000
        idle-timeout: 30000
        max-lifetime: 1800000
        maximum-pool-size: 15
        minimum-idle: 5
        pool-name: VerticaHikariCP
      password: 123456
      type: com.zaxxer.hikari.HikariDataSource
      jdbc-url: jdbc:vertica://192.168.21.188:5433/vertica20190122001
      username: dbadmin

logging:
  home: ${user.dir}/logs
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
  type-aliases-package: com.iogogogo.entity

```

## MySQL数据源配置

```java
package com.iogogogo.datasource;

import com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

/**
 * Created by tao.zeng on 2019-03-19.
 */
@Configuration
@MapperScan(basePackages = "com.iogogogo.mapper.vertica", sqlSessionTemplateRef = "verticaSqlSessionTemplate")
public class VerticaDataSourceConfig {

    @Bean(name = "verticaDataSource")
    @ConfigurationProperties("spring.datasource.vertica")
    public DataSource vertica() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "verticaSqlSessionFactory")
    public SqlSessionFactory verticaSqlSessionFactory(@Qualifier("verticaDataSource") DataSource dataSource) throws Exception {
        MybatisSqlSessionFactoryBean bean = new MybatisSqlSessionFactoryBean();
        // 给MyBatis-Plus注入数据源
        bean.setDataSource(dataSource);
        return bean.getObject();
    }

    @Bean(name = "verticaTransactionManager")
    public DataSourceTransactionManager verticaTransactionManager(@Qualifier("verticaDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "verticaSqlSessionTemplate")
    public SqlSessionTemplate verticaSqlSessionTemplate(@Qualifier("verticaSqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
```



## Vertica数据源配置

```java
package com.iogogogo.datasource;

import com.baomidou.mybatisplus.extension.spring.MybatisSqlSessionFactoryBean;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

/**
 * Created by tao.zeng on 2019-03-19.
 */
@Configuration
@MapperScan(basePackages = "com.iogogogo.mapper.vertica", sqlSessionTemplateRef = "verticaSqlSessionTemplate")
public class VerticaDataSourceConfig {

    @Bean(name = "verticaDataSource")
    @ConfigurationProperties("spring.datasource.vertica")
    public DataSource vertica() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "verticaSqlSessionFactory")
    public SqlSessionFactory verticaSqlSessionFactory(@Qualifier("verticaDataSource") DataSource dataSource) throws Exception {
        MybatisSqlSessionFactoryBean bean = new MybatisSqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        return bean.getObject();
    }

    @Bean(name = "verticaTransactionManager")
    public DataSourceTransactionManager verticaTransactionManager(@Qualifier("verticaDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "verticaSqlSessionTemplate")
    public SqlSessionTemplate verticaSqlSessionTemplate(@Qualifier("verticaSqlSessionFactory") SqlSessionFactory sqlSessionFactory) {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
```

## Mapper

### MySQL

```java
package com.iogogogo.mapper.mysql;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.iogogogo.entity.SysUser;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by tao.zeng on 2019-03-19.
 */
@Repository
public interface SysUserMapper extends BaseMapper<SysUser> {

    @Insert("insert into sys_user values(#{x.id},#{x.name},#{x.birthday})")
    boolean save(@Param("x") SysUser user);

    @Select("select * from sys_user")
    List<SysUser> list();
}

```

### Vertica

```java
package com.iogogogo.mapper.vertica;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.iogogogo.entity.User;
import org.apache.ibatis.annotations.Select;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by tao.zeng on 2019-03-15.
 */
@Repository
public interface UserMapper extends BaseMapper<User> {

    @Select("select * from public.user")
    List<User> list();
}
```

可以发现只要数据源配置成功以后，两者已经没有任何区别了，就可以像正常写代码一样，需要注意的就是不同数据库的mapper需要放在指定的包下面，否则spring容器无法扫描。



## 测试

为了方便，直接就在项目启动以后查询两个数据库的数据就好了

```java
package com.iogogogo;

import com.iogogogo.entity.SysUser;
import com.iogogogo.entity.User;
import com.iogogogo.mapper.mysql.SysUserMapper;
import com.iogogogo.mapper.vertica.UserMapper;
import com.iogogogo.util.IdHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Created by tao.zeng on 2019-03-15.
 */
@Slf4j
@SpringBootApplication
public class DynamicDataSourceApplication implements CommandLineRunner {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private SysUserMapper sysUserMapper;


    public static void main(String[] args) {
        SpringApplication.run(DynamicDataSourceApplication.class, args);
    }

    @Override
    public void run(String... args) {

        int i = userMapper.insert(new User(IdHelper.id(), "小花脸-" + IdHelper.uuid(), "description-" + IdHelper.uuid()));
        // 使用自定义的查询方法
        List<User> list = userMapper.list();
        log.info("insert result:{} list.size:{}", i, list.size());


        boolean b = sysUserMapper.save(new SysUser(IdHelper.id(), "小花脸-" + IdHelper.uuid(), LocalDateTime.now()));
        // 使用MyBatis-Plus提供的查询方法
        List<SysUser> users = sysUserMapper.selectList(null);
        log.info("insert result:{} list.size:{}", b, users.size());
        users.forEach(x -> log.info(x.toString()));
    }
}
```

以上完整[代码](https://github.com/iogogogo/life-example)

