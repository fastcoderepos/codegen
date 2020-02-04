package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.any;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.AuthenticationClassesTemplateGenerator;
import com.fastcode.codegen.CodeGenerator;
import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.entitycodegen.AuthenticationInfo;
import com.fastcode.entitycodegen.AuthenticationType;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.RelationDetails;

@RunWith(SpringJUnit4ClassRunner.class)
public class AuthenticationClassesTemplateGeneratorTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private AuthenticationClassesTemplateGenerator authenticationClassesTemplateGenerator;

	@Mock
	private CodeGenerator mockedCodeGenerator;

	@Mock
	private CodeGeneratorUtils mockedCodeGeneratorUtils;

	private File destPath;
	String testValue = "abc";
	String packageName = "com.nfinity.demo";
	String entityName = "entity1";
	String moduleName = "entity-1";

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(authenticationClassesTemplateGenerator);
		destPath = folder.newFolder("tempFolder");

	}

	@After
	public void tearDown() throws Exception {

	}

	@Test 
	public void buildBackendRootMap_authenticationTableIsNotNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName); 
		root.put("Cache", true);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UserOnly",authenticationInfo.getUserOnly());
		root.put("AuthenticationType",AuthenticationType.DATABASE.getName());
		root.put("SchemaName",testValue);
		root.put("UserInput","true");
		root.put("AuthenticationTable",authenticationInfo.getAuthenticationTable());
		root.put("ClassName", entityName);
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());

		Assertions.assertThat(authenticationClassesTemplateGenerator.buildBackendRootMap(packageName, testValue,
				authenticationInfo, details, true)).isEqualTo(root);
	}

	@Test 
	public void buildBackendRootMap_authenticationTableIsNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
	
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName);
		root.put("Cache", true);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UserOnly",authenticationInfo.getUserOnly());
		root.put("AuthenticationType",AuthenticationType.DATABASE.getName());
		root.put("SchemaName",testValue);
		root.put("UserInput",null);
		root.put("AuthenticationTable","User");

		Assertions.assertThat(authenticationClassesTemplateGenerator.buildBackendRootMap(packageName, testValue,
				authenticationInfo, details, true)).isEqualTo(root);
	}

	@Test 
	public void generateAutheticationClasses_authenticationTableIsNotNull_returnMap()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();

		Mockito.doReturn(new HashMap<String, Object>()).when(authenticationClassesTemplateGenerator).buildBackendRootMap(anyString(), anyString(), any(AuthenticationInfo.class), any(HashMap.class), any(Boolean.class));
		Mockito.doNothing().when(authenticationClassesTemplateGenerator).generateBackendFiles(any(AuthenticationInfo.class),any(HashMap.class),anyString(), anyString());
		Mockito.doNothing().when(authenticationClassesTemplateGenerator).generateFrontendAuthorization(anyString(), anyString(),  any(AuthenticationInfo.class), any(HashMap.class));
		Mockito.doNothing().when(authenticationClassesTemplateGenerator).generateAppStartupRunner(any(HashMap.class), anyString(), any(HashMap.class));

		authenticationClassesTemplateGenerator.generateAutheticationClasses(destPath.getAbsolutePath(), packageName, true, testValue,authenticationInfo, details);

		Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).generateBackendFiles(Matchers.any(AuthenticationInfo.class),Matchers.<Map<String, Object>>any(), anyString(), anyString());
	    Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).generateFrontendAuthorization(anyString(), anyString(), Matchers.any(AuthenticationInfo.class), Matchers.<Map<String, Object>>any());
		Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).generateAppStartupRunner(any(HashMap.class), anyString(), any(HashMap.class));

	}
	
	@Test 
	public void generateBackendFiles_authenticationTypeIsDatabase_returnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		 Map<String, Object> templates = new HashMap<String, Object>();

		Mockito.doReturn(templates).when(authenticationClassesTemplateGenerator).getBackendAuthorizationFiles(anyString(), anyString(),any(AuthenticationType.class));
		Mockito.doReturn(templates).when(authenticationClassesTemplateGenerator).getBackendAuthorizationTestFiles(anyString(), anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
	       
		authenticationClassesTemplateGenerator. generateBackendFiles(authenticationInfo, new HashMap<String, Object>(), destPath.getAbsolutePath(), destPath.getAbsolutePath());

		Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).getBackendAuthorizationFiles(anyString(), anyString(), any(AuthenticationType.class));
	    Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).getBackendAuthorizationTestFiles(anyString(), anyString());
	    Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(2)).generateFiles(Matchers.<Map<String, Object>>any(), Matchers.<Map<String, Object>>any(), anyString(), anyString());

	}
	
	@Test 
	public void generateBackendFiles_authenticationTypeIsNotDatabase_returnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.LDAP);
		authenticationInfo.setUserOnly(false);
		 
		Map<String, Object> templates = new HashMap<String, Object>();

		Mockito.doReturn(templates).when(authenticationClassesTemplateGenerator).getAuthenticationTemplatesForUserGroupCase(anyString(), any(AuthenticationType.class));
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
	       
		authenticationClassesTemplateGenerator.generateBackendFiles(authenticationInfo, new HashMap<String, Object>(), destPath.getAbsolutePath(), destPath.getAbsolutePath());

		Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(2)).getAuthenticationTemplatesForUserGroupCase(anyString(), any(AuthenticationType.class));
		 Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(2)).generateFiles(Matchers.<Map<String, Object>>any(), Matchers.<Map<String, Object>>any(), anyString(), anyString());

	}
	
	@Test
	public void generateBackendAuthorizationFiles_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOutput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String, Object> templates = new HashMap<>();
		templates.put("/PermissionAppService.java.ftl", "/PermissionAppService.java");
		templates.put("/UserAppService.java.ftl", "/UserAppService.java");
		templates.put("/UserroleAppService.java.ftl", "/UserroleAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
       
		Assertions.assertThat(authenticationClassesTemplateGenerator.getBackendAuthorizationFiles(destPath.getAbsolutePath(), null, AuthenticationType.DATABASE)).isEqualTo(templates);
	
	}
	
	@Test
	public void getAuthenticationTemplatesForUserGroupCase_authenticationTypeIsDatabase_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOutput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String, Object> templates = new HashMap<>();
		templates.put("/GetCUOutput.java.ftl", "/GetCUOutput.java");
		templates.put("/PermissionAppService.java.ftl", "/PermissionAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
	//	Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		Assertions.assertThat(authenticationClassesTemplateGenerator.getAuthenticationTemplatesForUserGroupCase(destPath.getAbsolutePath(), AuthenticationType.DATABASE)).isEqualTo(templates);
	//	Mockito.verify(authenticationClassesTemplateGenerator,Mockito.times(1)).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateBackendAuthorizationFiles_authenticationTableIsNotNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOutput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String, Object> templates = new HashMap<>();
		templates.put("/GetCUOutput.java.ftl", "/Getentity1Output.java");
		templates.put("/UserroleAppService.java.ftl", "/entity1roleAppService.java");
		templates.put("/PermissionAppService.java.ftl", "/PermissionAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		Assertions.assertThat(authenticationClassesTemplateGenerator.getBackendAuthorizationFiles(destPath.getAbsolutePath(), entityName, AuthenticationType.DATABASE)).isEqualTo(templates);
		//Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);
	}

	@Test
	public void generateBackendAuthorizationTestFiles_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOutput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");
		
		Map<String, Object> templates = new HashMap<>();
		templates.put("/GetCUOutput.java.ftl", "/GetCUOutput.java");
		templates.put("/UserAppService.java.ftl", "/UserAppService.java");
		templates.put("/UserroleAppService.java.ftl", "/UserroleAppService.java");
		templates.put("/PermissionAppService.java.ftl", "/PermissionAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

	//	authenticationClassesTemplateGenerator.getBackendAuthorizationTestFiles(destPath.getAbsolutePath(), testValue);
		Assertions.assertThat(authenticationClassesTemplateGenerator.getBackendAuthorizationTestFiles(destPath.getAbsolutePath(), null)).isEqualTo(templates);
	//	Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateBackendAuthorizationTestFiles_authenticationTableIsNotNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOuput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.getBackendAuthorizationTestFiles(destPath.getAbsolutePath(), testValue);
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}
	 
	@Test
	public void generateFrontendAuthorization_authenticationTableIsNull_ReturnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl"); 

		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorization(destPath.getAbsolutePath(),testValue, authenticationInfo, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorization_authenticationTableIsNotNull_returnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorization(destPath.getAbsolutePath(),testValue, authenticationInfo, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorizationComponents_authenticationTableIsNull_ReturnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		List<String> filesList = new ArrayList<String>(); 
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorizationComponents(destPath.getAbsolutePath(),testValue, authenticationInfo, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorizationComponents_authenticationTableIsNotNull_returnNothing()
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(entityName);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);
		
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
		Mockito.doReturn(moduleName).when(mockedCodeGeneratorUtils).camelCaseToKebabCase(entityName);
	         
		authenticationClassesTemplateGenerator.generateFrontendAuthorizationComponents(destPath.getAbsolutePath(), testValue, authenticationInfo, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}
	
	@Test
	public void generateAppStartupRunner_parametersAreValid_returnNothing()
	{
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
		
		authenticationClassesTemplateGenerator.generateAppStartupRunner(details, destPath.getAbsolutePath(), new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

}
