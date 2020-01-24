package com.fastcode;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.fastcode.codegen.FolderContentReader;
import com.fastcode.codegen.FreeMarkerConfiguration;
import com.fastcode.entitycodegen.CGenClassLoader;

@Configuration
public class BeanConfig {
	
	@Bean
	public static FreeMarkerConfiguration getFreeMarkerConfigBean() {
		return new FreeMarkerConfiguration();
	}
	
//	@Bean
//	public static FolderContentReader getFolderContentReaderBean() {
//		return new FolderContentReader();
//	}
	
//	@Bean
//	public static CGenClassLoader getCGenClassLoaderBean() {
//		return new CGenClassLoader();
//	}
	
	
//	@Bean
//	public static FreeMarkerConfiguration freeMarkerConfig() {
//		return new FreeMarkerConfiguration();
//	}
//	
//	@Bean
//	public static FreeMarkerConfiguration freeMarkerConfig() {
//		return new FreeMarkerConfiguration();
//	}


}
