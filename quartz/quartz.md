# Spring Boot 设置定时任务

- 任务配置

```java
@Slf4j
@Component
public class ScheduledTask {
    
    @Scheduled(fixedRate = 5000)
    // 表示每隔5000ms，Spring scheduling会调用一次该方法，不论该方法的执行时间是多少
    public void reportCurrentTime() throws InterruptedException {
		log.info(new Date());
    }

    @Scheduled(fixedDelay = 5000)
    // 表示当方法执行完毕5000ms后，Spring scheduling会再次调用该方法
    public void reportCurrentTimeAfterSleep() throws InterruptedException {
        log.info(new Date());
    }

    @Scheduled(cron = "0 0 1 * * *")
    // 提供了一种通用的定时任务表达式，这里表示每隔5秒执行一次，更加详细的信息可以参考cron表达式。
    public void reportCurrentTimeCron() throws InterruptedException {
        log.info(new Date());
    }
}

```

- 启动

```java
@SpringBootApplication
@EnableScheduling
// 告诉Spring创建一个task executor，如果我们没有这个标注，所有@Scheduled标注都不会执行
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }
}
```

## Spring Boot 结合 Quartz 实现动态设置定时任务

- 需要spring boot版本大于2.x
- http://www.quartz-scheduler.org/

### 添加依赖配置

```groovy
implementation 'org.quartz-scheduler:quartz:2.3.0'
implementation 'org.quartz-scheduler:quartz-jobs:2.3.0'
implementation 'org.springframework.boot:spring-boot-starter-quartz'
```

### 配置 quartzJobFactory 和 scheduler 对象

```java
package com.iogogogo.quartz.configure;

import org.quartz.Scheduler;
import org.quartz.spi.TriggerFiredBundle;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.AutowireCapableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.AdaptableJobFactory;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.stereotype.Component;

/**
 * Created by tao.zeng on 2019/1/18.
 */
@Configuration
public class QuartzConfiguration {

    /**
     * 解决Job中注入Spring Bean为null的问题
     */
    @Component("quartzJobFactory")
    private class QuartzJobFactory extends AdaptableJobFactory {
        // 这个对象Spring会帮我们自动注入进来,也属于Spring技术范畴.
        @Autowired
        private AutowireCapableBeanFactory capableBeanFactory;

        protected Object createJobInstance(TriggerFiredBundle bundle) throws Exception {
            // 调用父类的方法
            Object jobInstance = super.createJobInstance(bundle);
            // 进行注入,这属于Spring的技术,不清楚的可以查看Spring的API.
            capableBeanFactory.autowireBean(jobInstance);
            return jobInstance;
        }
    }

    /**
     * 注入scheduler到spring，在下面quartzManege会用到
     *
     * @param quartzJobFactory
     * @return
     * @throws Exception
     */
    @Bean(name = "scheduler")
    public Scheduler scheduler(QuartzJobFactory quartzJobFactory) throws Exception {
        SchedulerFactoryBean factoryBean = new SchedulerFactoryBean();
        factoryBean.setJobFactory(quartzJobFactory);
        factoryBean.afterPropertiesSet();
        Scheduler scheduler = factoryBean.getScheduler();
        scheduler.start();
        return scheduler;
    }
}
```

### 新建一个bean对象，用来保存基本的job信息

```java
package com.iogogogo.quartz.bean;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Created by tao.zeng on 2019/1/18.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuartzJob {

    public static final Integer STATUS_RUNNING = 1;
    public static final Integer STATUS_NOT_RUNNING = 0;
    public static final Integer CONCURRENT_IS = 1;
    public static final Integer CONCURRENT_NOT = 0;

    private String jobId;

    /**
     * cron 表达式
     */
    private String cronExpression;

    /**
     * 任务调用的方法名
     */
    private String methodName;

    /**
     * 任务是否有状态
     */
    private Integer isConcurrent;

    /**
     * 描述
     */
    private String description;

    /**
     * 任务执行时调用哪个类的方法 包名+类名，完全限定名
     */
    private String beanName;

    /**
     * 触发器名称
     */
    private String triggerName;

    /**
     * 任务状态
     */
    private Integer jobStatus;

    /**
     * 任务名
     */
    private String jobName;
}
```

### 新建一个统一的QuartzManager，用来统一管理job

```java
package com.iogogogo.quartz.configure;

import com.iogogogo.quartz.bean.QuartzJob;
import lombok.extern.slf4j.Slf4j;
import org.quartz.*;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

/**
 * Created by tao.zeng on 2019/1/18.
 */
@Slf4j
@Component
public class QuartzManager {

    @Resource(name = "scheduler")
    private Scheduler scheduler;

    public void addJob(QuartzJob job) throws SchedulerException, ClassNotFoundException, IllegalAccessException, InstantiationException {
        // 通过类名获取实体类，即要执行的定时任务的类
        Class<?> clazz = Class.forName(job.getBeanName());
        Job jobEntity = (Job) clazz.newInstance();
        // 通过实体类和任务名创建 JobDetail
        JobDetail jobDetail = newJob(jobEntity.getClass())
                .withIdentity(job.getJobName()).build();
        // 通过触发器名和cron 表达式创建 Trigger
        Trigger cronTrigger = newTrigger()
                .withIdentity(job.getTriggerName())
                .startNow()
                .withSchedule(CronScheduleBuilder.cronSchedule(job.getCronExpression()))
                .build();
        // 执行定时任务
        scheduler.scheduleJob(jobDetail, cronTrigger);
    }

    /**
     * 更新job cron表达式
     *
     * @param quartzJob
     * @throws SchedulerException
     */
    public void updateJobCron(QuartzJob quartzJob) throws SchedulerException {
        TriggerKey triggerKey = TriggerKey.triggerKey(quartzJob.getJobName());
        CronTrigger trigger = (CronTrigger) scheduler.getTrigger(triggerKey);
        CronScheduleBuilder scheduleBuilder = CronScheduleBuilder.cronSchedule(quartzJob.getCronExpression());
        trigger = trigger.getTriggerBuilder().withIdentity(triggerKey).withSchedule(scheduleBuilder).build();
        scheduler.rescheduleJob(triggerKey, trigger);
    }

    /**
     * 删除一个job
     *
     * @param quartzJob
     * @throws SchedulerException
     */
    public void deleteJob(QuartzJob quartzJob) throws SchedulerException {
        JobKey jobKey = JobKey.jobKey(quartzJob.getJobName());
        scheduler.deleteJob(jobKey);
    }

    /**
     * 恢复一个job
     *
     * @param quartzJob
     * @throws SchedulerException
     */
    public void resumeJob(QuartzJob quartzJob) throws SchedulerException {
        JobKey jobKey = JobKey.jobKey(quartzJob.getJobName());
        scheduler.resumeJob(jobKey);
    }

    /**
     * 立即执行job
     *
     * @param quartzJob
     * @throws SchedulerException
     */
    public void runAJobNow(QuartzJob quartzJob) throws SchedulerException {
        JobKey jobKey = JobKey.jobKey(quartzJob.getJobName());
        scheduler.triggerJob(jobKey);
    }

    /**
     * 暂停一个job
     *
     * @param quartzJob
     * @throws SchedulerException
     */
    public void pauseJob(QuartzJob quartzJob) throws SchedulerException {
        JobKey jobKey = JobKey.jobKey(quartzJob.getJobName());
        scheduler.pauseJob(jobKey);
    }
}
```

### 新建job任务，实现org.quartz.Job接口

```java
package com.iogogogo.quartz.schedule;

import lombok.extern.slf4j.Slf4j;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Created by tao.zeng on 2019/1/18.
 */
@Slf4j
@Component
public class ScheduleTask implements Job {
    
    @Override
    public void execute(JobExecutionContext context) {
        log.info("execute task:{}", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss", Locale.CHINA)));
    }
}
```

### 启动类配置

```java
package com.iogogogo.quartz;

import com.iogogogo.quartz.bean.QuartzJob;
import com.iogogogo.quartz.configure.QuartzManager;
import org.quartz.SchedulerException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Created by tao.zeng on 2019/1/18.
 */
@SpringBootApplication
public class QuartzSchedulerApplication implements CommandLineRunner {

    @Autowired
    private QuartzManager quartzManager;

    public static void main(String... args) {
        SpringApplication.run(QuartzSchedulerApplication.class, args);
    }

    @Override
    public void run(String... args) {
        try {
            String scheduleTask = "com.iogogogo.quartz.schedule.ScheduleTask";
            QuartzJob job = new QuartzJob(scheduleTask,
                    "*/1 * * * * ?",
                    scheduleTask,
                    1,
                    scheduleTask,
                    scheduleTask,
                    scheduleTask,
                    QuartzJob.STATUS_NOT_RUNNING,
                    scheduleTask);
            quartzManager.addJob(job);
        } catch (SchedulerException | ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            e.printStackTrace();
        }
    }
}
```

