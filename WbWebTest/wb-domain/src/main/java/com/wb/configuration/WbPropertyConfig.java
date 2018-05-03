package com.wb.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;

@Configuration
@PropertySource(value = {"classpath:wb-${spring.profiles.active:local}.xml"}, ignoreResourceNotFound = true)
public class WbPropertyConfig {

    @Bean
    public static PropertySourcesPlaceholderConfigurer wbPropertyConfigurer(){
        PropertySourcesPlaceholderConfigurer configurer = new PropertySourcesPlaceholderConfigurer();

//        String activeProfile = System.getProperty("spring.profiles.active", "local");
//        String propertiesFilename = "wb-" + activeProfile + ".xml";
//        configurer.setLocation(new ClassPathResource(propertiesFilename));

        return configurer;
    }

}
