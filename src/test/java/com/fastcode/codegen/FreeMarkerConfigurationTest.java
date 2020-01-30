package com.fastcode.codegen;

import java.io.File;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.CodegenApplication;
import com.fastcode.codegen.FreeMarkerConfiguration;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.MultiTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;

@RunWith(SpringJUnit4ClassRunner.class)
public class FreeMarkerConfigurationTest {
	
	@InjectMocks
	private FreeMarkerConfiguration freeMarkerConfiguration;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(freeMarkerConfiguration);
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void configure_folderPathIsValid_ReturnConfiguration()
	{ 
	    Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
		ClassTemplateLoader ctl1 = new ClassTemplateLoader(CodegenApplication.class, "/templates/backendTemplates/");// "/templates/backendTemplates/"); 
		MultiTemplateLoader mtl = new MultiTemplateLoader(new TemplateLoader[] { ctl1 }); 

		cfg.setInterpolationSyntax(Configuration.SQUARE_BRACKET_INTERPOLATION_SYNTAX); 
		cfg.setDefaultEncoding("UTF-8"); 
		cfg.setTemplateLoader(mtl); 
		Assertions.assertThat(freeMarkerConfiguration.configure("/templates/backendTemplates")).isEqualToComparingFieldByFieldRecursively(cfg);
	}

}
