package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.FileNotFoundException;
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
import com.fastcode.entitycodegen.AuthenticationInfo;
import com.fastcode.entitycodegen.AuthenticationType;
import com.fastcode.entitycodegen.EntityDetails;
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

		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);

		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		details.put("Entity1",new EntityDetails());
		details.put("Entity2",new EntityDetails());
		Mockito.doNothing().when(frontendBaseTemplateGenerator).editTsConfigJsonFile(anyString());
		Mockito.doNothing().when(frontendBaseTemplateGenerator).editAngularJsonFile(anyString(),anyString());

		Mockito.doReturn("").when(mockedCommandUtils).runProcess(anyString(), anyString());
		Mockito.doReturn(new HashedMap()).when(frontendBaseTemplateGenerator).buildRootMap(anyString(), any(AuthenticationInfo.class), any(List.class));
		Mockito.doReturn(new HashedMap()).when(frontendBaseTemplateGenerator).getTemplates(anyString());
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashedMap.class), any(HashedMap.class), anyString(), anyString());

		frontendBaseTemplateGenerator.generate(destPath.getAbsolutePath(), testValue, authenticationInfo, details);

	}

	@Test
	public void buildRootMap_authenticationTableIsNotNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(testValue);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);

		Map<String, Object> root = new HashMap<>();
		root.put("AppName", testValue);
		root.put("AuthEntityList",new ArrayList<String>());
		root.put("EntityList", new ArrayList<String>());
		root.put("UserOnly", authenticationInfo.getUserOnly());
		root.put("AuthenticationType","database");
		root.put("UserInput","true");
		root.put("AuthenticationTable", testValue);
		root.put("EntityNames", new HashMap());
		root.put("ExcludeRoleNew", false);
		root.put("ExcludeUserNew", false);

		Mockito.doReturn(new HashMap()).when(frontendBaseTemplateGenerator).getEntityNamesList(any(List.class),any(AuthenticationInfo.class));
		Mockito.doReturn(new ArrayList<String>()).when(frontendBaseTemplateGenerator).getAuthEntitiesNamesList(authenticationInfo);
		Assertions.assertThat(frontendBaseTemplateGenerator.buildRootMap(testValue,authenticationInfo, new ArrayList<String>())).isEqualTo(root);
	}

	@Test
	public void buildRootMap_authenticationTableIsNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(false);
		
		Map<String, Object> root = new HashMap<>();
		root.put("AppName", testValue);
		root.put("AuthEntityList",new ArrayList<String>());
		root.put("EntityList", new ArrayList<String>());
		root.put("UserOnly", authenticationInfo.getUserOnly());
		root.put("AuthenticationType", "database");
		root.put("UserInput",null);
		root.put("AuthenticationTable", "User");
		root.put("EntityNames", new HashMap());
		root.put("ExcludeRoleNew", false);
		root.put("ExcludeUserNew", false);
	
		Mockito.doReturn(new HashMap()).when(frontendBaseTemplateGenerator).getEntityNamesList(any(List.class),any(AuthenticationInfo.class));
		Mockito.doReturn(new ArrayList<String>()).when(frontendBaseTemplateGenerator).getAuthEntitiesNamesList(authenticationInfo);
		
		Assertions.assertThat(frontendBaseTemplateGenerator.buildRootMap(testValue, authenticationInfo, new ArrayList<String>())).isEqualTo(root);

	} 
	
	@Test
	public void getEntityNamesList_authenticationTypeIsNoneAndAuthenticationTableIsNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(false);
		
		List<String> list = new ArrayList<String>();
		list.add("entity1");
		list.add("entity2");
		
		Map<String, String> entityNamesList = new HashMap<String, String>();
		entityNamesList.put("entity-1", "entity1");
		entityNamesList.put("entity-2", "entity2");
		
		Mockito.doReturn("entity-1", "entity-2").when(mockedUtils).camelCaseToKebabCase(anyString());
	    Mockito.doReturn(new ArrayList<String>()).when(frontendBaseTemplateGenerator).getAuthEntitiesNamesList(authenticationInfo);
		Assertions.assertThat(frontendBaseTemplateGenerator.getEntityNamesList(list, authenticationInfo)).isEqualTo(entityNamesList);
	}
	  
	@Test
	public void getEntityNamesList_authenticationTypeIsDatabaseAndAuthenticationTableIsNotNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable("entity1");
		authenticationInfo.setAuthenticationType(AuthenticationType.LDAP);
		authenticationInfo.setUserOnly(true);
		
		List<String> list = new ArrayList<String>();
		list.add("entity1");
		list.add("entity2");
		
		List<String> authList = new ArrayList<String>();
		authList.add("Role");
		authList.add("Permission");
		authList.add("Rolepermission");
		
		Map<String, String> entityNamesList = new HashMap<String, String>();
		entityNamesList.put("entity-2", "entity2");
		entityNamesList.put("role", "Role");
		entityNamesList.put("permission", "Permission");
		entityNamesList.put("role-permission", "Rolepermission");

		Mockito.doReturn("entity-2","role", "permission", "role-permission").when(mockedUtils).camelCaseToKebabCase(anyString());
		Mockito.doReturn(authList).when(frontendBaseTemplateGenerator).getAuthEntitiesNamesList(authenticationInfo);
		Assertions.assertThat(frontendBaseTemplateGenerator.getEntityNamesList(list, authenticationInfo)).isEqualTo(entityNamesList);
	
	}
	
	@Test
	public void getAuthEntitiesNamesList_authenticationTypeIsNone_returnList()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.NONE);
		authenticationInfo.setUserOnly(false);
		
		List<String> authList = new ArrayList<String>();
		
		Assertions.assertThat(frontendBaseTemplateGenerator.getAuthEntitiesNamesList(authenticationInfo)).isEqualTo(authList);
		
	}
	
	@Test
	public void getAuthEntitiesNamesList_authenticationTypeIsDatabaseAndAuthenticationTableIsNotNull_returnList()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable("Entity1");
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(false);
		
		List<String> authList = new ArrayList<String>();
		authList.add("Role");
		authList.add("Permission");
		authList.add("Rolepermission");
		authList.add("Entity1");
		authList.add("Entity1permission");
		authList.add("Entity1role");
		
		Assertions.assertThat(frontendBaseTemplateGenerator.getAuthEntitiesNamesList(authenticationInfo)).isEqualTo(authList);
		
	}
	
	@Test
	public void getAuthEntitiesNamesList_authenticationTypeIsDatabaseAndAuthenticationTableIsNull_returnList()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.LDAP);
		authenticationInfo.setUserOnly(true);
		
		List<String> authList = new ArrayList<String>();
		authList.add("Role");
		authList.add("Permission");
		authList.add("Rolepermission");
		authList.add("User");
		authList.add("Userpermission");
		authList.add("Userrole");
		
		Assertions.assertThat(frontendBaseTemplateGenerator.getAuthEntitiesNamesList(authenticationInfo)).isEqualTo(authList);
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
		String data=  getAngularJsonData();
		FileUtils.writeStringToFile(newTempFolder, data);
		JSONParser parser = new JSONParser();
		FileReader fr = new FileReader(newTempFolder.getAbsolutePath());
		Object obj = parser.parse(fr);
		fr.close();

		Mockito.doReturn(obj).when(mockedJsonUtils).readJsonFile(anyString());
		Mockito.doNothing().when(mockedJsonUtils).writeJsonToFile(anyString(), anyString());
		frontendBaseTemplateGenerator.editAngularJsonFile(newTempFolder.getAbsolutePath(), "exampleClient");
	}
	
	@Test
	public void editAngularJsonFile_pathIsNotValid_throwIOException() throws IOException, ParseException
	{
		Mockito.doThrow(new IOException()).when(mockedJsonUtils).readJsonFile(anyString());
		frontendBaseTemplateGenerator.editAngularJsonFile("", "exampleClient");
	}
	
	
	@Test
	public void editTsConfigJsonFile_pathIsNotValid_throwIOException() throws IOException, ParseException
	{

		Mockito.doThrow(new IOException()).when(mockedJsonUtils).readJsonFile(anyString());
		frontendBaseTemplateGenerator.editTsConfigJsonFile("");
	}
	
	@Test
	public void editTsConfigJsonFile_pathIsValid_returnNothing() throws IOException, ParseException
	{
		File newTempFolder = folder.newFile("tsconfig.json");
		String data=  getTsConfigData();
		FileUtils.writeStringToFile(newTempFolder, data);
		JSONParser parser = new JSONParser();
		FileReader fr = new FileReader(newTempFolder.getAbsolutePath());
		Object obj = parser.parse(fr);
		fr.close();

		Mockito.doReturn(obj).when(mockedJsonUtils).readJsonFile(anyString());
		Mockito.doNothing().when(mockedJsonUtils).writeJsonToFile(anyString(), anyString());
		frontendBaseTemplateGenerator.editTsConfigJsonFile(newTempFolder.getAbsolutePath());
	}
	
	private String getTsConfigData()
	{
		return "{\r\n" + 
				"  \"compileOnSave\": false,\r\n" + 
				"  \"angularCompilerOptions\": {\r\n" + 
				"    \"fullTemplateTypeCheck\": true,\r\n" + 
				"    \"strictInjectionParameters\": true\r\n" + 
				"  },\r\n" + 
				"  \"compilerOptions\": {\r\n" + 
				"    \"experimentalDecorators\": true,\r\n" + 
				"    \"lib\": [\r\n" + 
				"      \"es2018\",\r\n" + 
				"      \"dom\"\r\n" + 
				"    ],\r\n" + 
				"    \"sourceMap\": true,\r\n" + 
				"    \"module\": \"esnext\",\r\n" + 
				"    \"importHelpers\": true,\r\n" + 
				"    \"typeRoots\": [\r\n" + 
				"      \"node_modules/@types\"\r\n" + 
				"    ],\r\n" + 
				"    \"declaration\": false,\r\n" + 
				"    \"outDir\": \"./dist/out-tsc\",\r\n" + 
				"    \"target\": \"es2015\",\r\n" + 
				"    \"downlevelIteration\": true,\r\n" + 
				"    \"baseUrl\": \"./\",\r\n" + 
				"    \"moduleResolution\": \"node\"\r\n" + 
				"  }\r\n" + 
				"}";
	}
	
	private String getAngularJsonData()
	{
		return "{\r\n" + 
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
	}

}
