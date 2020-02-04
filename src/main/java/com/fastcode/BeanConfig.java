package com.fastcode;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fastcode.codegen.FreeMarkerConfiguration;

@Configuration
public class BeanConfig {
	
	@Bean
	public static FreeMarkerConfiguration getFreeMarkerConfigBean() {
		return new FreeMarkerConfiguration();
	}

}
