package org.b104.alfredo.config;

import org.quartz.SchedulerException;

import org.quartz.spi.JobFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

import java.util.HashMap;
import java.util.Map;

@Configuration
public class QuartzConfig {

    @Autowired
    private ApplicationContext applicationContext;

    @Bean
    public JobFactory jobFactory() {
        AutowiringSpringBeanJobFactory jobFactory = new AutowiringSpringBeanJobFactory();
        jobFactory.setApplicationContext(applicationContext);
        return jobFactory;
    }

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() throws SchedulerException {
        SchedulerFactoryBean schedulerFactoryBean = new SchedulerFactoryBean();

        // Ensure that the ApplicationContext is correctly placed in the Scheduler context
        Map<String, Object> schedulerContextAsMap = new HashMap<>();
        schedulerContextAsMap.put("appContext", applicationContext);
        schedulerFactoryBean.setSchedulerContextAsMap(schedulerContextAsMap);

        schedulerFactoryBean.setJobFactory(jobFactory());

        return schedulerFactoryBean;
    }
}
