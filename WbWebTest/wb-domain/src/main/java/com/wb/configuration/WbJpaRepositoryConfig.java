package com.wb.configuration;

import org.apache.commons.dbcp2.BasicDataSource;
import org.hibernate.jpa.HibernatePersistenceProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;

import javax.sql.DataSource;

/**
 * Created by huangwenbo on 4/17/18.
 */

@Configuration
@EnableJpaRepositories("com.wb.domain")
public class WbJpaRepositoryConfig {

    private String ENTITYMANAGER_PACKAGES_TO_SCAN = "com/wb/domain";

    @Autowired
    private Environment environment;

    @Value("${wbwebtest.mysql.jdbc.url}")
    private String url;

    @Value("${wbwebtest.mysql.jdbc.username}")
    private String userName;

    @Value("${wbwebtest.mysql.jdbc.password}")
    private String password;

    @Bean(name = "wbDatasource")
    public DataSource dataSource() {
        BasicDataSource bs = new BasicDataSource();

        bs.setDriverClassName("com.mysql.jdbc.Driver");
        bs.setUrl(url);
        bs.setUsername(userName);
        bs.setPassword(password);
        bs.setDefaultAutoCommit(true);
        bs.setInitialSize(3);
        bs.setMaxWaitMillis(5);
        bs.setMaxIdle(3000);

        return bs;
    }

    @Bean(name = "myWebTestJdbcTemplate")
    public JdbcTemplate myWebTestJdbcTemplate() {
        return new JdbcTemplate(this.dataSource());
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        LocalContainerEntityManagerFactoryBean entityManagerFactoryBean =
                new LocalContainerEntityManagerFactoryBean();
        entityManagerFactoryBean.setDataSource(dataSource());
        entityManagerFactoryBean.setPersistenceProviderClass(HibernatePersistenceProvider.class);
        entityManagerFactoryBean.setPackagesToScan(ENTITYMANAGER_PACKAGES_TO_SCAN);
//        entityManagerFactoryBean.setPackagesToScan(environment.getRequiredProperty(ENTITYMANAGER_PACKAGES_TO_SCAN));
//        entityManagerFactoryBean.setJpaProperties(hibProperties());
        return entityManagerFactoryBean;
    }

    @Bean
    public JpaTransactionManager transactionManager() {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory().getObject());
        return transactionManager;
    }
}
