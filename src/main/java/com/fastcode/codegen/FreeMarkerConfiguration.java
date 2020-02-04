package com.fastcode.codegen;

import org.springframework.stereotype.Component;

import com.fastcode.CodegenApplication;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;

@Component
public class FreeMarkerConfiguration {
	
	public static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);

	public Configuration configure(String folderPath)
	{
		
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, folderPath + "/");// "/templates/backendTemplates/"); 
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8");  
		cfg.setTemplateLoader(mtl); 
		
		return cfg;
	}

}
