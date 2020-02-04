package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import org.apache.commons.io.FileUtils;
import org.assertj.core.api.Assertions;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.codegen.CommandUtils;
import com.fastcode.codegen.FrontendBaseTemplateGenerator;
import com.fastcode.codegen.JSONUtils;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class FrontendBaseTemplateGeneratorTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private FrontendBaseTemplateGenerator frontendBaseTemplateGenerator;
	
	@Mock
	private CodeGeneratorUtils mockedUtils;
	
	@Mock
	private CommandUtils mockedCommandUtils;
	
	@Mock
	private JSONUtils mockedJsonUtils;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
    File destPath;
    String testValue = "abc";
	String packageName = "com.nfinity.demo";
	String entityName = "entity1";
	String moduleName = "entity-1";
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(frontendBaseTemplateGenerator);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void generate_ParametersAreValid_ReturnNothing() {
	
		Mockito.doNothing().when(frontendBaseTemplateGenerator).editTsConfigJsonFile(anyString());
		Mockito.doNothing().when(frontendBaseTemplateGenerator).editAngularJsonFile(anyString(),anyString());
		
		Mockito.doReturn("").when(mockedCommandUtils).runProcess(anyString(), anyString());
		Mockito.when(frontendBaseTemplateGenerator.buildRootMap(anyString(), anyString(), anyString())).thenReturn(new HashedMap());
        Mockito.doReturn(new HashedMap()).when(frontendBaseTemplateGenerator).getTemplates(anyString());
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashedMap.class), any(HashedMap.class), anyString(), anyString());
		
		frontendBaseTemplateGenerator.generate(destPath.getAbsolutePath(), testValue, testValue, entityName);
		
	}

   @Test
   public void buildRootMap_authenticationTableIsNotNull_returnMap()
   {
	   Map<String, Object> root = new HashMap<>();
		root.put("AppName", testValue);
		root.put("AuthenticationType",testValue);
		root.put("UserInput","true");
		root.put("AuthenticationTable", testValue);
		
		Assertions.assertThat(frontendBaseTemplateGenerator.buildRootMap(testValue, testValue, testValue)).isEqualTo(root);
		
   }
   
   @Test
   public void buildRootMap_authenticationTableIsNull_returnMap()
   {
	   Map<String, Object> root = new HashMap<>();
		root.put("AppName", testValue);
		root.put("AuthenticationType",testValue);
		root.put("UserInput",null);
		root.put("AuthenticationTable", "User");
		
		Assertions.assertThat(frontendBaseTemplateGenerator.buildRootMap(testValue, testValue, null)).isEqualTo(root);
		
   }
   
   @Test
   public void getTemplates_pathIsValid_returnMap()
   {
	   List<String> filesList = new ArrayList<String>();
       filesList.add("/SearchUtils.java.ftl");
       filesList.add("/SearchFields.java.ftl");

       Mockito.doReturn(filesList).when(mockedUtils).readFilesFromDirectory(anyString());
       Mockito.doReturn(filesList).when(mockedUtils).replaceFileNames(any(List.class),anyString());
       
       
		Map<String, Object> templates = new HashMap<>();
		templates.put("/SearchUtils.java.ftl", "/SearchUtils.java");
		templates.put("/SearchFields.java.ftl", "/SearchFields.java");
		Assert.assertEquals(frontendBaseTemplateGenerator.getTemplates("/templates/testTemplates").keySet(), templates.keySet());

   }
   
//   @Test
//   public void getNestedFolders_pathIsValid_returnFile() throws IOException
//   {
//	   File newTempFolder = folder.newFolder("tempFolder","testTemplates");
//
//	   File[] folderArray = new File[1];
//	   List<File> list = new ArrayList<File>();
//	   list.add(newTempFolder);
//	   folderArray =list.toArray(folderArray);
//
//	   Assertions.assertThat(frontendBaseTemplateGenerator.getNestedFolders(destPath.getAbsolutePath())).isEqualTo(folderArray);
//    }
   
   @Test
   public void getFastCodeCoreProjectNode_noParameterRequired_returnJsonObject() throws IOException, ParseException
   {
	   JSONParser parser = new JSONParser();
		JSONObject fccore = (JSONObject) parser.parse("{\r\n" + 
				"      \"root\": \"projects/fast-code-core\",\r\n" + 
				"      \"sourceRoot\": \"projects/fast-code-core/src\",\r\n" + 
				"      \"projectType\": \"library\",\r\n" + 
				"      \"prefix\": \"lib\",\r\n" + 
				"      \"architect\": {\r\n" + 
				"        \"build\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-ng-packagr:build\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"tsConfig\": \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
				"            \"project\": \"projects/fast-code-core/ng-package.json\"\r\n" + 
				"          },\r\n" + 
				"          \"configurations\": {\r\n" + 
				"            \"production\": {\r\n" + 
				"              \"project\": \"projects/fast-code-core/ng-package.prod.json\"\r\n" + 
				"            }\r\n" + 
				"          }\r\n" + 
				"        },\r\n" + 
				"        \"test\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-angular:karma\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"main\": \"projects/fast-code-core/src/test.ts\",\r\n" + 
				"            \"tsConfig\": \"projects/fast-code-core/tsconfig.spec.json\",\r\n" + 
				"            \"karmaConfig\": \"projects/fast-code-core/karma.conf.js\"\r\n" + 
				"          }\r\n" + 
				"        },\r\n" + 
				"        \"lint\": {\r\n" + 
				"          \"builder\": \"@angular-devkit/build-angular:tslint\",\r\n" + 
				"          \"options\": {\r\n" + 
				"            \"tsConfig\": [\r\n" + 
				"              \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
				"              \"projects/fast-code-core/tsconfig.spec.json\"\r\n" + 
				"            ],\r\n" + 
				"            \"exclude\": [\r\n" + 
				"              \"**/node_modules/**\"\r\n" + 
				"            ]\r\n" + 
				"          }\r\n" + 
				"        }\r\n" + 
				"      }\r\n" + 
				"    }");
	 
	Assertions.assertThat(frontendBaseTemplateGenerator.getFastCodeCoreProjectNode()).isEqualTo(fccore);
   }
   
   @Test
   public void editAngularJsonFile_pathIsValid_returnNothing() throws IOException, ParseException
   {
	   File newTempFolder = folder.newFile("angular.json");
	   String data=  "{\r\n" + 
	   		"  \"projects\": {\r\n" + 
	   		"    \"exampleClient\": {\r\n" + 
	   		"      \"sourceRoot\": \"src\",\r\n" + 
	   		"      \"prefix\": \"app\",\r\n" + 
	   		"      \"root\": \"\",\r\n" + 
	   		"      \"schematics\": {},\r\n" + 
	   		"      \"architect\": {\r\n" + 
	   		"        \"lint\": {\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:tslint\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"tsConfig\": [\r\n" + 
	   		"              \"src/tsconfig.app.json\",\r\n" + 
	   		"              \"src/tsconfig.spec.json\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"exclude\": [\r\n" + 
	   		"              \"**/node_modules/**\"\r\n" + 
	   		"            ]\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"test\": {\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:karma\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"assets\": [\r\n" + 
	   		"              \"src/favicon.ico\",\r\n" + 
	   		"              \"src/assets\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"karmaConfig\": \"src/karma.conf.js\",\r\n" + 
	   		"            \"tsConfig\": \"src/tsconfig.spec.json\",\r\n" + 
	   		"            \"polyfills\": \"src/polyfills.ts\",\r\n" + 
	   		"            \"main\": \"src/test.ts\",\r\n" + 
	   		"            \"styles\": [\r\n" + 
	   		"              \"src/styles.css\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"scripts\": []\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"build\": {\r\n" + 
	   		"          \"configurations\": {\r\n" + 
	   		"            \"production\": {\r\n" + 
	   		"              \"buildOptimizer\": true,\r\n" + 
	   		"              \"optimization\": true,\r\n" + 
	   		"              \"sourceMap\": false,\r\n" + 
	   		"              \"aot\": true,\r\n" + 
	   		"              \"fileReplacements\": [\r\n" + 
	   		"                {\r\n" + 
	   		"                  \"with\": \"src/environments/environment.prod.ts\",\r\n" + 
	   		"                  \"replace\": \"src/environments/environment.ts\"\r\n" + 
	   		"                }\r\n" + 
	   		"              ],\r\n" + 
	   		"              \"extractCss\": true,\r\n" + 
	   		"              \"namedChunks\": false,\r\n" + 
	   		"              \"vendorChunk\": false,\r\n" + 
	   		"              \"outputHashing\": \"all\",\r\n" + 
	   		"              \"extractLicenses\": true\r\n" + 
	   		"            }\r\n" + 
	   		"          },\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:browser\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"assets\": [\r\n" + 
	   		"              \"src/favicon.ico\",\r\n" + 
	   		"              \"src/assets\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"outputPath\": \"dist/example184Client\",\r\n" + 
	   		"            \"tsConfig\": \"src/tsconfig.app.json\",\r\n" + 
	   		"            \"index\": \"src/index.html\",\r\n" + 
	   		"            \"polyfills\": \"src/polyfills.ts\",\r\n" + 
	   		"            \"main\": \"src/main.ts\",\r\n" + 
	   		"            \"styles\": [\r\n" + 
	   		"              \"src/styles/styles.scss\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"scripts\": []\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"extract-i18n\": {\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:extract-i18n\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"browserTarget\": \"example184Client:build\"\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"serve\": {\r\n" + 
	   		"          \"configurations\": {\r\n" + 
	   		"            \"production\": {\r\n" + 
	   		"              \"browserTarget\": \"example184Client:build:production\"\r\n" + 
	   		"            }\r\n" + 
	   		"          },\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:dev-server\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"proxyConfig\": \"proxy.conf.json\",\r\n" + 
	   		"            \"browserTarget\": \"example184Client:build\"\r\n" + 
	   		"          }\r\n" + 
	   		"        }\r\n" + 
	   		"      },\r\n" + 
	   		"      \"projectType\": \"application\"\r\n" + 
	   		"    },\r\n" + 
	   		"    \"fastCodeCore\": {\r\n" + 
	   		"      \"sourceRoot\": \"projects/fast-code-core/src\",\r\n" + 
	   		"      \"prefix\": \"lib\",\r\n" + 
	   		"      \"root\": \"projects/fast-code-core\",\r\n" + 
	   		"      \"architect\": {\r\n" + 
	   		"        \"lint\": {\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:tslint\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"tsConfig\": [\r\n" + 
	   		"              \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
	   		"              \"projects/fast-code-core/tsconfig.spec.json\"\r\n" + 
	   		"            ],\r\n" + 
	   		"            \"exclude\": [\r\n" + 
	   		"              \"**/node_modules/**\"\r\n" + 
	   		"            ]\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"test\": {\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-angular:karma\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"karmaConfig\": \"projects/fast-code-core/karma.conf.js\",\r\n" + 
	   		"            \"tsConfig\": \"projects/fast-code-core/tsconfig.spec.json\",\r\n" + 
	   		"            \"main\": \"projects/fast-code-core/src/test.ts\"\r\n" + 
	   		"          }\r\n" + 
	   		"        },\r\n" + 
	   		"        \"build\": {\r\n" + 
	   		"          \"configurations\": {\r\n" + 
	   		"            \"production\": {\r\n" + 
	   		"              \"project\": \"projects/fast-code-core/ng-package.prod.json\"\r\n" + 
	   		"            }\r\n" + 
	   		"          },\r\n" + 
	   		"          \"builder\": \"@angular-devkit/build-ng-packagr:build\",\r\n" + 
	   		"          \"options\": {\r\n" + 
	   		"            \"tsConfig\": \"projects/fast-code-core/tsconfig.lib.json\",\r\n" + 
	   		"            \"project\": \"projects/fast-code-core/ng-package.json\"\r\n" + 
	   		"          }\r\n" + 
	   		"        }\r\n" + 
	   		"      },\r\n" + 
	   		"      \"projectType\": \"library\"\r\n" + 
	   		"    }\r\n" + 
	   		"  },\r\n" + 
	   		"  \"$schema\": \"./node_modules/@angular/cli/lib/config/schema.json\",\r\n" + 
	   		"  \"defaultProject\": \"example184Client\",\r\n" + 
	   		"  \"version\": 1,\r\n" + 
	   		"  \"newProjectRoot\": \"projects\"\r\n" + 
	   		"}";
	   FileUtils.writeStringToFile(newTempFolder, data);
	   JSONParser parser = new JSONParser();
	   FileReader fr = new FileReader(newTempFolder.getAbsolutePath());
	   Object obj = parser.parse(fr);
	   fr.close();
	  
	   Mockito.doReturn(obj).when(mockedJsonUtils).readJsonFile(anyString());
       Mockito.doNothing().when(mockedJsonUtils).writeJsonToFile(anyString(), anyString());
       frontendBaseTemplateGenerator.editAngularJsonFile(newTempFolder.getAbsolutePath(), "exampleClient");
   }
   
}
