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
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.AuthenticationClassesTemplateGenerator;
import com.fastcode.codegen.CodeGenerator;
import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.RelationDetails;

@RunWith(SpringJUnit4ClassRunner.class)
public class AuthenticationClassesTemplateGeneratorTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	private AuthenticationClassesTemplateGenerator authenticationClassesTemplateGenerator;

	@Mock
	private AuthenticationClassesTemplateGenerator mockedAuthenticationClassesTemplateGenerator;

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
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName);
		root.put("Cache", true);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("AuthenticationType",testValue);
		root.put("SchemaName",testValue);

		root.put("UserInput","true");
		root.put("AuthenticationTable", entityName);


		root.put("ClassName", entityName);
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());

		Assertions.assertThat(authenticationClassesTemplateGenerator.buildBackendRootMap(packageName, testValue,
				testValue, entityName, details, true)).isEqualTo(root);
	}

	@Test 
	public void buildBackendRootMap_authenticationTableIsNull_returnMap()
	{
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", packageName);
		root.put("Cache", true);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("AuthenticationType",testValue);
		root.put("SchemaName",testValue);
		root.put("UserInput",null);
		root.put("AuthenticationTable","User");

		Assertions.assertThat(authenticationClassesTemplateGenerator.buildBackendRootMap(packageName, testValue,
				testValue, null, details, true)).isEqualTo(root);
	}

	@Test 
	public void generateAutheticationClasses_authenticationTableIsNotNull_returnMap()
	{
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();

		Mockito.doReturn(new HashMap<String, Object>()).when(mockedAuthenticationClassesTemplateGenerator).buildBackendRootMap(anyString(), anyString(), anyString(), anyString(), any(HashMap.class), any(Boolean.class));
		Mockito.doNothing().when(mockedAuthenticationClassesTemplateGenerator).generateBackendAuthorizationFiles(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.doNothing().when(mockedAuthenticationClassesTemplateGenerator).generateBackendAuthorizationTestFiles(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.doNothing().when(mockedAuthenticationClassesTemplateGenerator).generateFrontendAuthorization(anyString(), anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.doNothing().when(mockedAuthenticationClassesTemplateGenerator).generateAppStartupRunner(any(HashMap.class), anyString(), any(HashMap.class));

		authenticationClassesTemplateGenerator.generateAutheticationClasses(destPath.getAbsolutePath(), packageName, true, testValue, testValue, entityName, details);

		Mockito.verify(mockedAuthenticationClassesTemplateGenerator,Mockito.never()).generateBackendAuthorizationFiles(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.verify(mockedAuthenticationClassesTemplateGenerator,Mockito.never()).generateBackendAuthorizationTestFiles(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.verify(mockedAuthenticationClassesTemplateGenerator,Mockito.never()).generateFrontendAuthorization(anyString(), anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.verify(mockedAuthenticationClassesTemplateGenerator,Mockito.never()).generateAppStartupRunner(any(HashMap.class), anyString(), any(HashMap.class));

	}

	@Test
	public void generateBackendAuthorizationFiles_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOuput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
       
		authenticationClassesTemplateGenerator.generateBackendAuthorizationFiles(destPath.getAbsolutePath(), testValue, null, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateBackendAuthorizationFiles_authenticationTableIsNotNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOuput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateBackendAuthorizationFiles(destPath.getAbsolutePath(), testValue, testValue, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateBackendAuthorizationTestFiles_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/GetCUOuput.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateBackendAuthorizationTestFiles(destPath.getAbsolutePath(), testValue, null, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

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

		authenticationClassesTemplateGenerator.generateBackendAuthorizationTestFiles(destPath.getAbsolutePath(), testValue, testValue, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}
	
	@Test
	public void generateFrontendAuthorization_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doNothing().when(mockedCodeGenerator).updateAppModule(anyString(), anyString(), any(List.class));
		Mockito.doNothing().when(mockedCodeGenerator).updateAppRouting(anyString(), anyString(), any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorization(destPath.getAbsolutePath(),testValue, null,testValue, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorization_authenticationTableIsNotNull_returnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doNothing().when(mockedCodeGenerator).updateAppModule(anyString(), anyString(), any(List.class));
		Mockito.doNothing().when(mockedCodeGenerator).updateAppRouting(anyString(), anyString(), any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorization(destPath.getAbsolutePath(),testValue, entityName,testValue, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorizationComponents_authenticationTableIsNull_ReturnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());

		authenticationClassesTemplateGenerator.generateFrontendAuthorizationComponents(destPath.getAbsolutePath(),testValue, null, new HashMap<String, Object>());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.never()).generateFiles(new HashMap<String, Object>(), new HashMap<String, Object>(), destPath.getAbsolutePath(), testValue);

	}

	@Test
	public void generateFrontendAuthorizationComponents_authenticationTableIsNotNull_returnNothing()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/userpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/userroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
		Mockito.doReturn(moduleName).when(mockedCodeGeneratorUtils).camelCaseToKebabCase(entityName);
	         
		authenticationClassesTemplateGenerator.generateFrontendAuthorizationComponents(destPath.getAbsolutePath(), testValue, entityName, new HashMap<String, Object>());
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
