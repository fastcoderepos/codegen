package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.mockito.ArgumentMatchers.any;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.assertj.core.api.Assertions;
import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
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
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.CodeGenerator;
import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.codegen.JSONUtils;
import com.fastcode.entitycodegen.AuthenticationConstants;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.EntityGeneratorUtils;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.RelationDetails;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class CodeGeneratorTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private CodeGenerator codeGenerator;
	
	@Mock
	private EntityGeneratorUtils mockEntityGeneratorUtils;
	
	@Mock
	private CodeGeneratorUtils mockedUtils;
	
	@Mock
	private JSONUtils jsonUtils;
	
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
		MockitoAnnotations.initMocks(codeGenerator);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test 
	public void buildEntityInfo_authenticationTableIsNotNull_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, testValue);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		EntityDetails details = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		Map<String, Object> root = new HashMap<>();
		root.put("Schema", testValue);
		root.put("Cache", true);
		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityName+"Entity");
		root.put("ClassName", entityName);
		root.put("PackageName", packageName);
		root.put("InstanceName", entityName);
		root.put("CompositeKeyClasses",details.getCompositeKeyClasses());
		root.put("IdClass", details.getIdClass());
		root.put("DescriptiveField",details.getEntitiesDescriptiveFieldMap());
		root.put("AuthenticationFields",details.getAuthenticationFieldsMap());
		root.put("IEntity", "I" + entityName);
		root.put("IEntityFile", "i" + moduleName);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UsersOnly", authenticationInputMap.get(AuthenticationConstants.USERS_ONLY));
		root.put("AuthenticationType", authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		root.put("ApiPath", entityName);
		root.put("FrontendUrlPath", entityName.toLowerCase());
	    root.put("UserInput","true");
	    root.put("AuthenticationTable", authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA));
		root.put("PrimaryKeys", details.getPrimaryKeys());
		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());
		
		Mockito.doReturn(moduleName).when(mockedUtils).camelCaseToKebabCase(anyString());
		Assertions.assertThat(codeGenerator.buildEntityInfo(entityName,packageName,details, authenticationInputMap
				,testValue,true)).isEqualTo(root);
	}
	
	@Test 
	public void buildEntityInfo_authenticationTableIsNull_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, null);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		EntityDetails details = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),testValue, testValue);
		Map<String, Object> root = new HashMap<>();
		root.put("Schema", testValue);
		root.put("Cache", true);
		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityName+"Entity");
		root.put("ClassName", entityName);
		root.put("PackageName", packageName);
		root.put("InstanceName", entityName);
		root.put("CompositeKeyClasses",details.getCompositeKeyClasses());
		root.put("IdClass", details.getIdClass());
		root.put("DescriptiveField",details.getEntitiesDescriptiveFieldMap());
		root.put("AuthenticationFields",details.getAuthenticationFieldsMap());
		root.put("IEntity", "I" + entityName); 
		root.put("IEntityFile", "i" + moduleName);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UsersOnly", authenticationInputMap.get(AuthenticationConstants.USERS_ONLY));
		root.put("AuthenticationType", authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		root.put("ApiPath", entityName);
		root.put("FrontendUrlPath", entityName.toLowerCase());
	    root.put("UserInput",null);
	    root.put("AuthenticationTable", "User");
		root.put("PrimaryKeys", details.getPrimaryKeys());
		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());
		 
		Mockito.doReturn(moduleName).when(mockedUtils).camelCaseToKebabCase(anyString());
		Assertions.assertThat(codeGenerator.buildEntityInfo(entityName,packageName,details, authenticationInputMap
				,testValue,true)).isEqualTo(root);
	}
	
	@Test
	public void generateAllModulesForEntities_detailsMapIsNotEmpty_ReturnList()
	{
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		details.put("com.fastcode.Entity1",new EntityDetails());
		details.put("com.fastcode.Entity2",new EntityDetails());
		
		List<String> entityNames = new ArrayList<String>();
		entityNames.add("Entity2");
		entityNames.add("Entity1");

		Mockito.doNothing().when(codeGenerator).generate(anyString(), anyString(), anyString(), anyString(), anyString(),anyString(), any(EntityDetails.class), any(HashMap.class), any(Boolean.class), anyString());
		Assertions.assertThat(codeGenerator.generateAllModulesForEntities(details, testValue, testValue, packageName, true, destPath.getAbsolutePath(), testValue, new HashMap<String,String>())).isEqualTo(entityNames);
	}
	
	@Test
	public void generateAll_parametersAreValid_ReturnList() throws IOException
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, "Entity1");
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		FieldDetails fieldDetails= new FieldDetails();
		fieldDetails.setFieldName("UserName");
		Map<String, FieldDetails> authMap = new HashMap<String, FieldDetails>();
		authMap.put("UserName", fieldDetails);
		entityDetails.setAuthenticationFieldsMap(authMap);
		details.put("Entity1",entityDetails);
		details.put("Entity2",new EntityDetails());
		
		List<String> list = new ArrayList<String>();
		list.add("Entity1");
		list.add("Entity2");
		
		String connStr="jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
	
		Mockito.when(mockEntityGeneratorUtils.parseConnectionString(anyString())).thenReturn(new HashMap<String, String>());
		
		Mockito.doReturn(list).when(codeGenerator).generateAllModulesForEntities(any(HashMap.class), anyString(), anyString(), anyString(), any(Boolean.class),anyString(),anyString(),any(HashMap.class));
		Mockito.doNothing().when(codeGenerator).updateAppRouting(anyString(),anyString(), any(List.class), anyString());
		Mockito.doNothing().when(codeGenerator).updateAppModule(anyString(),anyString(), any(List.class));
		Mockito.doNothing().when(codeGenerator).updateEntitiesJsonFile(anyString(),any(List.class),anyString());

		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getInfoForApplicationPropertiesFile(anyString(),anyString(), anyString(), anyString(),any(HashMap.class), any(Boolean.class));
		Mockito.doNothing().when(codeGenerator).generateApplicationProperties(any(HashMap.class), anyString());
		Mockito.doNothing().when(codeGenerator).generateBeanConfig(anyString(),anyString(),anyString(),anyString(),any(HashMap.class),any(Boolean.class),anyString());
		Mockito.doNothing().when(codeGenerator).modifyMainClass(anyString(),anyString());
		
		codeGenerator.generateAll(testValue, testValue, packageName, true,destPath.getAbsolutePath(),details, connStr, testValue, authenticationInputMap);
		
		Mockito.verify(codeGenerator).generateAllModulesForEntities( Matchers.<Map<String, EntityDetails>>any(),anyString(), anyString(), anyString(), any(Boolean.class), anyString(), anyString(), Matchers.<Map<String, String>>any());
        Mockito.verify(codeGenerator).generateApplicationProperties( Matchers.<Map<String, Object>>any(),anyString() );
		
		Mockito.verify(codeGenerator).modifyMainClass(anyString(),anyString());
		
	}
	
	@Test
	public void generateBeanConfig_parametersAreValid_ReturnNothing()
	{ 
		
	   Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	
	   codeGenerator.generateBeanConfig(packageName, testValue,destPath.getAbsolutePath(), testValue, new HashMap<String, EntityDetails>(), true, testValue);
	   Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	
	}
	
	@Test 
	public void getInfoForApplicationPropertiesFile_parameterListIsValid_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, "Entity1");
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.LOGON_NAME, testValue);
		
		String connStr="jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
		
		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", new HashMap<String, String>());
		propertyInfo.put("appName", testValue);
		propertyInfo.put("Schema", testValue);
		propertyInfo.put("Cache", true);
		propertyInfo.put("AuthenticationType",authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		propertyInfo.put("LogonName",authenticationInputMap.get(AuthenticationConstants.LOGON_NAME));
		propertyInfo.put("AuthenticationSchema" ,authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA));
		propertyInfo.put("packageName",testValue);
		propertyInfo.put("packagePath", testValue);
		
		Mockito.when(mockEntityGeneratorUtils.parseConnectionString(anyString())).thenReturn(new HashMap<String, String>());
		Assertions.assertThat(codeGenerator.getInfoForApplicationPropertiesFile(destPath.getAbsolutePath(),testValue,connStr,
				testValue, authenticationInputMap,true)).isEqualTo(propertyInfo);
	}
	
	@Test 
	public void getInfoForAuditControllerAndBeanConfig_parameterListIsValid_ReturnMap()
	{
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		details.put("com.fastcode.Entity1",new EntityDetails());
		details.put("com.fastcode.Entity2",new EntityDetails());
		
		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			Map<String, String> entityMap = new HashMap<String,String>();
			
			String key = entry.getKey();
			String name = key.substring(key.lastIndexOf(".") + 1);

			entityMap.put("entity" , name + "Entity");
			entityMap.put("importPkg" , packageName + ".domain.model." + name + "Entity");
			entityMap.put("requestMapping" , "/" + name.toLowerCase());
			entityMap.put("method" , "get" + name + "Changes");

			entitiesMap.put(name, entityMap);
		}
		
		Map<String, Object> root = new HashMap<>();
		
		root.put("entitiesMap", entitiesMap);
		root.put("PackageName", packageName);
		root.put("AuthenticationType", testValue);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		
		root.put("UserInput","true");
		root.put("AuthenticationTable", testValue);
		
		Assertions.assertThat(codeGenerator.getInfoForAuditControllerAndBeanConfig(details,packageName,testValue,testValue)
				).isEqualTo(root);
	}
	
	@Test
	public void generateAuditorController_parametersAreValid_ReturnNothing()
	{ 
	   Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		
	   codeGenerator.generateAuditorController(new HashMap<String, EntityDetails>(),packageName, testValue,destPath.getAbsolutePath(), testValue, testValue);
	   Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	}
	
	@Test 
	public void getUITemplates_parameterListIsValid_ReturnMap()
	{
		String moduleName= "entity-1";
		Map<String, Object> uiTemplate = new HashMap<>();
		uiTemplate.put("iitem.ts.ftl", "i" + moduleName + ".ts");
		uiTemplate.put("index.ts.ftl", "index.ts");
		uiTemplate.put("item.service.ts.ftl", moduleName + ".service.ts");

		uiTemplate.put("item-list.component.ts.ftl", moduleName + "-list.component.ts");
		uiTemplate.put("item-list.component.html.ftl", moduleName + "-list.component.html");
		uiTemplate.put("item-list.component.scss.ftl", moduleName + "-list.component.scss");
		uiTemplate.put("item-list.component.spec.ts.ftl", moduleName + "-list.component.spec.ts");

		uiTemplate.put("item-new.component.ts.ftl", moduleName + "-new.component.ts");
		uiTemplate.put("item-new.component.html.ftl", moduleName + "-new.component.html");
		uiTemplate.put("item-new.component.scss.ftl", moduleName + "-new.component.scss");
		uiTemplate.put("item-new.component.spec.ts.ftl", moduleName + "-new.component.spec.ts");

		uiTemplate.put("item-details.component.ts.ftl", moduleName + "-details.component.ts");
		uiTemplate.put("item-details.component.html.ftl", moduleName + "-details.component.html");
		uiTemplate.put("item-details.component.scss.ftl", moduleName + "-details.component.scss");
		uiTemplate.put("item-details.component.spec.ts.ftl", moduleName + "-details.component.spec.ts");
		Assertions.assertThat(codeGenerator.getUITemplates(moduleName)).isEqualTo(uiTemplate);
	}
	
	@Test 
	public void getApplicationTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/iappService.java.ftl", "I" + entityName + "AppService.java");
		backEndTemplate.put("backendTemplates/appService.java.ftl", entityName + "AppService.java");
		backEndTemplate.put("backendTemplates/mapper.java.ftl", entityName + "Mapper.java");
		Assertions.assertThat(codeGenerator.getApplicationTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getApplicationTestTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/appServiceTest.java.ftl", entityName + "AppServiceTest.java");

		Assertions.assertThat(codeGenerator.getApplicationTestTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getRepositoryTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/irepository.java.ftl", "I" + entityName + "Repository.java");
		Assertions.assertThat(codeGenerator.getRepositoryTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getControllerTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/controller.java.ftl", entityName + "Controller.java");
		Assertions.assertThat(codeGenerator.getControllerTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getControllerTestTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/ControllerTest.java.ftl", entityName + "ControllerTest.java");
		Assertions.assertThat(codeGenerator.getControllerTestTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getDomainTemplates_parameterListIsValid_ReturnMap()
	{
		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/manager.java.ftl", entityName + "Manager.java");
		backEndTemplate.put("backendTemplates/imanager.java.ftl", "I" + entityName + "Manager.java");
	
		Assertions.assertThat(codeGenerator.getDomainTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getDomainTestTemplates_parameterListIsValid_ReturnMap()
	{

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/managerTest.java.ftl", entityName + "ManagerTest.java");

		Assertions.assertThat(codeGenerator.getDomainTestTemplates(entityName)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getDtos_parameterListIsValid_ReturnMap()
	{
		
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, entityName);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		FieldDetails fieldDetails= new FieldDetails();
		fieldDetails.setFieldName("UserName");
		Map<String, FieldDetails> authMap = new HashMap<String, FieldDetails>();
		authMap.put("UserName", fieldDetails);
		
		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/Dto/createInput.java.ftl", "Create" + entityName + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/createOutput.java.ftl", "Create" + entityName + "Output.java");
		backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserByNameOutput.java.ftl", "Find" + entityName + "ByUserNameOutput.java");
		backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserWithAllFieldsByIdOutput.java.ftl", "Find"+entityName+"WithAllFieldsByIdOutput.java");
		backEndTemplate.put("backendTemplates/Dto/findByIdOutput.java.ftl", "Find" + entityName + "ByIdOutput.java");
		
		backEndTemplate.put("backendTemplates/Dto/updateInput.java.ftl", "Update" + entityName + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/updateOutput.java.ftl", "Update" + entityName + "Output.java");
		
	    backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/GetRoleOutput.java.ftl", "GetRoleOutput.java");
		
		Assertions.assertThat(codeGenerator.getDtos(entityName,authenticationInputMap,authMap)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getRelationDto_parameterListIsValid_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, testValue);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		FieldDetails fieldDetails= new FieldDetails();
		fieldDetails.setFieldName("UserName");
		Map<String, FieldDetails> authMap = new HashMap<String, FieldDetails>();
		authMap.put("UserName", fieldDetails);
		entityDetails.setAuthenticationFieldsMap(authMap);
		RelationDetails relationDetails = new RelationDetails();
		relationDetails.setRelation("ManyToOne");
		relationDetails.setfDetails(new ArrayList<FieldDetails>());
		relationDetails.seteName("Entity2");
		Map<String, RelationDetails> relationMap = new HashMap<String, RelationDetails>();
		relationMap.put("Entity1", relationDetails);
        entityDetails.setRelationsMap(relationMap);
		details.put("Entity1",entityDetails);
		details.put("Entity2",new EntityDetails());
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", "entity1");
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		codeGenerator.generateRelationDto(entityDetails,root,destPath.getAbsolutePath(), entityName,authenticationInputMap);
		Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	}
	
	@Test 
	public void generateBackendFiles_parameterListIsValid_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, entityName);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);
		
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getApplicationTemplates(anyString());
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getDtos(anyString(),any(HashMap.class),any(HashMap.class));
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getDomainTemplates(anyString());
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getRepositoryTemplates(anyString());
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getControllerTemplates(anyString());
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());

		codeGenerator.generateBackendFiles(root,destPath.getAbsolutePath(), authenticationInputMap);
		Mockito.verify(mockedUtils,Mockito.times(5)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	}
	
	@Test 
	public void generate_parameterListIsValid_ReturnMap()
	{
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);
		root.put("ModuleName", moduleName);
		
		Mockito.doReturn(root).when(codeGenerator).buildEntityInfo(anyString(), anyString(), any(EntityDetails.class), any(HashMap.class), anyString(), any(Boolean.class));
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getUITemplates(anyString());
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		Mockito.doNothing().when(codeGenerator).generateBackendFiles(any(HashMap.class), anyString(), any(HashMap.class));
		Mockito.doNothing().when(codeGenerator).generateBackendUnitAndIntegrationTestFiles(any(HashMap.class), anyString(), any(HashMap.class));
		Mockito.doNothing().when(codeGenerator).generateRelationDto(any(EntityDetails.class), any(HashMap.class),anyString(),anyString(), any(HashMap.class));
		
		codeGenerator.generate(entityName, testValue, destPath.getAbsolutePath(), destPath.getAbsolutePath(), packageName, destPath.getAbsolutePath(), new EntityDetails(), new HashMap<String,String>() , false, testValue);

	}
	
	@Test 
	public void generateBackendIntegrationTestFiles_parameterListIsValid_ReturnMap()
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, entityName);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, testValue);
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "true");
		
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);

		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getApplicationTestTemplates(anyString());
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getDomainTestTemplates(anyString());
		Mockito.doReturn(new HashMap<String, Object>()).when(codeGenerator).getControllerTestTemplates(anyString());
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		codeGenerator.generateBackendUnitAndIntegrationTestFiles(root,destPath.getAbsolutePath(),authenticationInputMap);
		Mockito.verify(mockedUtils,Mockito.times(3)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	}
	
	@Test 
	public void generateApplicationProperties_parameterListIsValid_ReturnMap()
	{
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		codeGenerator.generateApplicationProperties(root,destPath.getAbsolutePath());
		Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(Matchers.<Map<String, Object>>any(),Matchers.<Map<String, Object>>any(),anyString(),anyString());
	}
	
	@Test 
	public void addImports_parameterListIsValid_ReturnStringBuilder()
	{
		String moduleName = "entity-1"; 
		StringBuilder builder=new StringBuilder();
		builder.append("import { " + entityName + "ListComponent , " + entityName + "DetailsComponent, " + entityName + "NewComponent } from './" + moduleName + "/index';" + "\n");
		List<String> entities = new ArrayList<>();
		entities.add(entityName);
		
		Mockito.doReturn(moduleName).when(mockedUtils).camelCaseToKebabCase(anyString());
		Assertions.assertThat(codeGenerator.addImports(entities)).isEqualToIgnoringNewLines(builder);
	}

	@Test 
	public void modifyMainClass_parameterListIsValid_ReturnNothing() throws IOException
	{
		String className = "DemoApplication.java";
		File newTempFolder = folder.newFolder("tempFolder","com","nfinity","Demo");
		File tempFile = File.createTempFile("DemoApplication", ".java", newTempFolder);
		File newFile = new File(newTempFolder.getAbsolutePath()+ "/" + className);
		tempFile.renameTo(newFile);
	
		codeGenerator.modifyMainClass(destPath.getAbsolutePath(),packageName);
		Mockito.verify(codeGenerator,Mockito.times(1)).modifyMainClass(destPath.getAbsolutePath(),packageName);
		
	}
	
	@Test 
	public void modifyMainClass_pathIsNotValid_ThrowException() throws IOException
	{
		codeGenerator.modifyMainClass(destPath.getAbsolutePath(),packageName);
		Mockito.verify(codeGenerator,Mockito.times(1)).modifyMainClass(destPath.getAbsolutePath(),packageName);
	}
	
	@Test 
	public void updateAppModule_parameterListIsValid_ReturnNothing() throws IOException
	{
		String className = "app.module.ts";
		File newTempFolder = folder.newFolder("tempFolder","fAppClient","src","app");
		File tempFile = File.createTempFile("app.module", ".ts", newTempFolder);
		File newFile = new File(newTempFolder.getAbsolutePath()+ "/" + className);
		tempFile.renameTo(newFile);
		List<String> entities = new ArrayList<>();
		entities.add(entityName);
		
		codeGenerator.updateAppModule(destPath.getAbsolutePath(),"fApp",entities);
	}
	
	@Test 
	public void updateAppRouting_parameterListIsValid_ReturnNothing() throws IOException
	{
		String className = "app.routing.ts";
		File newTempFolder = folder.newFolder("tempFolder","fAppClient","src","app");
		File tempFile = File.createTempFile("app.routing", ".ts", newTempFolder);
		File newFile = new File(newTempFolder.getAbsolutePath()+ "/" + className);
		tempFile.renameTo(newFile);
		List<String> entities = new ArrayList<>();
		entities.add(entityName);
		
		codeGenerator.updateAppRouting(destPath.getAbsolutePath(),"fApp",entities,entityName);
	}
	
	@Test 
	public void updateEntitiesJsonFile_parameterListIsValid_ReturnStringBuilder() throws IOException, ParseException
	{
		String className = "entities.json";
		File newTempFolder = folder.newFolder("tempFolder","fAppClient","src","app","common","components","main-nav");
	
		File tempFile = File.createTempFile("entities", ".json", newTempFolder);
		File newFile = new File(newTempFolder.getAbsolutePath()+ "/" + className);
		tempFile.renameTo(newFile);
		FileUtils.writeStringToFile(newFile, "[]");
		
		String path = destPath.getAbsolutePath()+"\\fAppClient\\src\\app\\common\\components\\main-nav\\entities.json";
		JSONArray entityArray = mock(JSONArray.class);
		String jsonString = "[entity2]";
		Mockito.doReturn(entityArray).when(jsonUtils).readJsonFile(path);
		Mockito.doReturn(jsonString).when(jsonUtils).beautifyJson(entityArray, "Array");
		Mockito.doNothing().when(jsonUtils).writeJsonToFile(path, jsonString);
		List<String> entities = new ArrayList<>();
		entities.add(entityName);
		entities.add("entity2");
		
		codeGenerator.updateEntitiesJsonFile(path,entities,entityName);
		Mockito.verify(jsonUtils).readJsonFile(anyString());
		Mockito.verify(codeGenerator).updateEntitiesJsonFile(path,entities,entityName);
	}
	 
	@Test 
	public void updateEntitiesJsonFile_parameterListIsNotValid_ThrowIOException() throws IOException, ParseException
	{
		String className = "entities.json";
		File newTempFolder = folder.newFolder("tempFolder","fAppClient","src","app","common","components","main-nav");
	
		File tempFile = File.createTempFile("entities", ".json", newTempFolder);
		File newFile = new File(newTempFolder.getAbsolutePath()+ "/" + className);
		tempFile.renameTo(newFile);
		FileUtils.writeStringToFile(newFile, "[]");
		
		String path = destPath.getAbsolutePath()+"\\fAppClient\\src\\app\\common\\components\\main-nav\\entities.json";

		Mockito.doThrow(new IOException()).when(jsonUtils).readJsonFile(path);

		List<String> entities = new ArrayList<>();
		entities.add(entityName);
		entities.add("entity2");
		
		codeGenerator.updateEntitiesJsonFile(path,entities,entityName);
		Mockito.verify(jsonUtils).readJsonFile(anyString());

	}
	
	
}
