package com.nfinity.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
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
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGenerator;
import com.nfinity.entitycodegen.EntityGeneratorUtils;
import com.nfinity.entitycodegen.FieldDetails;
import com.nfinity.entitycodegen.RelationDetails;


@RunWith(SpringJUnit4ClassRunner.class)
public class CodeGeneratorTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	CodeGenerator codeGenerator;
	
	@Mock
	CodeGenerator mockedCodeGenerator;
	
	@Mock
	EntityGeneratorUtils mockEntityGeneratorUtils;
	
	@Mock
	CodeGeneratorUtils mockedUtils;
	
	@Mock
	JSONUtils jsonUtils;
	
	File destPath;
	String testValue = "abc";
	String packageName = "com.nfinity.demo";
	String entityName = "entity1";
	String moduleName = "entity-1";
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(codeGenerator);
		destPath = folder.newFolder("tempFolder");
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test 
	public void buildEntityInfo_parameterListIsValid_ReturnMap()
	{
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
		root.put("AuthenticationType", testValue);
		root.put("ApiPath", entityName);
		root.put("FrontendUrlPath", entityName.toLowerCase());
	    root.put("UserInput","true");
	    root.put("AuthenticationTable", testValue);
		root.put("PrimaryKeys", details.getPrimaryKeys());
		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());
		
		Mockito.doReturn(moduleName).when(mockedUtils).camelCaseToKebabCase(anyString());
		Assertions.assertThat(codeGenerator.buildEntityInfo(entityName,packageName,testValue, details
				,testValue,testValue,testValue,true)).isEqualTo(root);
	}
	
	@Test
	public void generateAllModulesForEntities_detailsMapIsNotEmpty_ReturnList()
	{
		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
		details.put("com.fastcode.Entity1",new EntityDetails());
		details.put("com.fastcode.Entity2",new EntityDetails());
		
		Mockito.doNothing().when(codeGenerator).generate(anyString(), anyString(), anyString(), anyString(), anyString(), anyString(),anyString(), any(EntityDetails.class), anyString(), any(Boolean.class),  anyString(), anyString());
		
		Assertions.assertThat(codeGenerator.generateAllModulesForEntities(details, testValue, testValue, packageName, true, destPath.getAbsolutePath(), testValue, testValue, testValue, testValue).size()).isEqualTo(2);
	}
	
	@Test
	public void generateAll_parametersAreValid_ReturnList() throws IOException
	{
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
	//	EntityGeneratorUtils eGenerator = mock(EntityGeneratorUtils.class);
		
		Mockito.when(mockEntityGeneratorUtils.parseConnectionString(anyString())).thenReturn(new HashMap<String, String>());
		
		Mockito.doReturn(list).when(codeGenerator).generateAllModulesForEntities(any(HashMap.class), anyString(), anyString(), anyString(), any(Boolean.class),anyString(), anyString(),anyString(),anyString(), anyString());
	//	Mockito.doNothing().when(codeGenerator).generateEntityHistoryComponent(anyString(), anyString(), any(HashMap.class));
	//	Mockito.doNothing().when(codeGenerator).addhistoryComponentsToAppModule(anyString());
	//	Mockito.doNothing().when(codeGenerator).addhistoryComponentsToAppRoutingModule(anyString(), anyString(),any(Boolean.class));
	//	Mockito.doNothing().when(codeGenerator).generateAuditorController(any(HashMap.class), anyString(),anyString(),anyString(),anyString(),anyString(),any(Boolean.class),any(Boolean.class));

		Mockito.doNothing().when(codeGenerator).updateAppRouting(anyString(),anyString(), any(List.class), anyString());
		Mockito.doNothing().when(codeGenerator).updateAppModule(anyString(),anyString(), any(List.class));
	//	Mockito.doNothing().when(mockedCodeGenerator).updateTestUtils(anyString(),anyString(), any(List.class));
		Mockito.doNothing().when(codeGenerator).updateEntitiesJsonFile(anyString(),any(List.class),anyString());

		Mockito.when(codeGenerator.getInfoForApplicationPropertiesFile(anyString(),anyString(), anyString(), anyString(),anyString(), any(Boolean.class))).thenReturn(new HashMap<String, Object>());

		Mockito.doNothing().when(codeGenerator).generateApplicationProperties(any(HashMap.class), anyString());
		Mockito.doNothing().when(codeGenerator).generateBeanConfig(anyString(),anyString(),anyString(),anyString(),any(HashMap.class),any(Boolean.class),anyString());
		
		Mockito.doNothing().when(codeGenerator).modifyMainClass(anyString(),anyString());
		
		codeGenerator.generateAll(testValue, testValue, packageName, true,destPath.getAbsolutePath(), testValue, details, connStr, testValue, testValue,"Entity1");
	   
	}
	
	@Test
	public void generateBeanConfig_parametersAreValid_ReturnNothing()
	{ 
		
	   Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	
	   codeGenerator.generateBeanConfig(packageName, testValue,destPath.getAbsolutePath(), testValue, new HashMap<String, EntityDetails>(), true, testValue);
	   Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	
	}
	
	@Test 
	public void getInfoForApplicationPropertiesFile_parameterListIsValid_ReturnMap()
	{
		String connStr="jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
		//EntityGeneratorUtils eGenerator = mock(EntityGeneratorUtils.class);
		
		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", new HashMap<String, String>());
		propertyInfo.put("appName", testValue);
		propertyInfo.put("Schema", testValue);
		propertyInfo.put("Cache", true);
		propertyInfo.put("AuthenticationType",testValue);
		propertyInfo.put("packageName",testValue);
		propertyInfo.put("packagePath", testValue);
		
		
		Mockito.when(mockEntityGeneratorUtils.parseConnectionString(anyString())).thenReturn(new HashMap<String, String>());
		Assertions.assertThat(codeGenerator.getInfoForApplicationPropertiesFile(destPath.getAbsolutePath(),testValue,connStr,
				testValue, testValue,true)).isEqualTo(propertyInfo);
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
	   Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	}
	
//	@Test
//	public void generateEntityHistoryComponent_parametersAreValid_ReturnNothing()
//	{ 
//		Map<String,EntityDetails> details = new HashMap<String, EntityDetails>();
//		EntityDetails entityDetails = new EntityDetails();
//		FieldDetails fieldDetails= new FieldDetails();
//		fieldDetails.setFieldName("UserName");
//		Map<String, FieldDetails> authMap = new HashMap<String, FieldDetails>();
//		authMap.put("UserName", fieldDetails);
//		entityDetails.setAuthenticationFieldsMap(authMap);
//		details.put("Entity1",entityDetails);
//		details.put("Entity2",new EntityDetails());
//		
//		Mockito.doReturn(moduleName).when(mockedUtils).camelCaseToKebabCase(anyString());
//		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
//		
//		codeGenerator.generateEntityHistoryComponent(destPath.getAbsolutePath(), "Entity1",details);
//		Mockito.verify(mockedUtils, Mockito.times(2)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
//	
//	}
	
//	@Test 
//	public void getEntityHistoryTemplates_parameterListIsValid_ReturnMap()
//	{
//		Map<String, Object> template = new HashMap<>();
//		template.put("entityHistory/entity-history/entity-history.component.html.ftl", "entity-history.component.html");
//		template.put("entityHistory/entity-history/entity-history.component.scss.ftl", "entity-history.component.scss");
//		template.put("entityHistory/entity-history/entity-history.component.spec.ts.ftl", "entity-history.component.spec.ts");
//		template.put("entityHistory/entity-history/entity-history.component.ts.ftl", "entity-history.component.ts");
//		template.put("entityHistory/entity-history/entity-history.service.ts.ftl", "entity-history.service.ts");
//		template.put("entityHistory/entity-history/entityHistory.ts.ftl", "entityHistory.ts");
//		template.put("entityHistory/entity-history/filter-item.directive.ts.ftl", "filter-item.directive.ts");
//		Assertions.assertThat(codeGenerator.getEntityHistoryTemplates()).isEqualTo(template);
//	}
	
//	@Test 
//	public void getManageEntityHistoryTemplates_parameterListIsValid_ReturnMap()
//	{
//		Map<String, Object> template = new HashMap<>();
//
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.html.ftl", "manage-entity-history.component.html");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.scss.ftl", "manage-entity-history.component.scss");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.spec.ts.ftl", "manage-entity-history.component.spec.ts");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.ts.ftl", "manage-entity-history.component.ts");
//
//		Assertions.assertThat(codeGenerator.getManageEntityHistoryTemplates()).isEqualTo(template);
//	}
	
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
	//	backEndTemplate.put("backendTemplates/appServiceTest.java.ftl", entityName + "AppServiceTest.java");
		Assertions.assertThat(codeGenerator.getApplicationTemplates(entityName)).isEqualTo(backEndTemplate);
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
	//	backEndTemplate.put("backendTemplates/managerTest.java.ftl", entityName + "ManagerTest.java");
		
		Assertions.assertThat(codeGenerator.getDomainTemplates(entityName)).isEqualTo(backEndTemplate);
		
	}
	
	@Test 
	public void getDtos_parameterListIsValid_ReturnMap()
	{
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
		backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/LoginUserInput.java.ftl", "LoginUserInput.java");
		
		
		Assertions.assertThat(codeGenerator.getDtos(entityName,entityName,authMap)).isEqualTo(backEndTemplate);
	}
	
	@Test 
	public void getRelationDto_parameterListIsValid_ReturnMap()
	{
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
		codeGenerator.generateRelationDto(entityDetails,root,destPath.getAbsolutePath(), entityName,testValue);
		Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	}
	
//	@Test 
//	public void addhistoryComponentsToAppModule_parameterListIsValid_ReturnMap() throws IOException
//	{
//	
//	    File file = folder.newFile("app.module.ts");
//		String filePath = file.getAbsolutePath().replace('\\', '/');
//	    String fileDest = filePath.substring(0,filePath.lastIndexOf("/"));
//	
//		codeGenerator.addhistoryComponentsToAppModule(fileDest);
//	}
	
//	@Test 
//	public void addhistoryComponentsToAppRoutingModule_parameterListIsValid_ReturnMap() throws IOException
//	{
//	
//		File file = folder.newFile("app.routing.ts");
//		String filePath = file.getAbsolutePath().replace('\\', '/');
//		String fileDest = filePath.substring(0,filePath.lastIndexOf("/"));
//	
//		codeGenerator.addhistoryComponentsToAppRoutingModule(fileDest,entityName,false);
//	}
	
	@Test 
	public void generateBackendFiles_parameterListIsValid_ReturnMap()
	{
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);
		
		Mockito.when(mockedCodeGenerator.getApplicationTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getDtos(anyString(),anyString(),any(HashMap.class))).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getDomainTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getRepositoryTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getControllerTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());

		codeGenerator.generateBackendFiles(root,destPath.getAbsolutePath(), entityName);
	//	System.out.println(" PAth " + destPath.getAbsolutePath());
		Mockito.verify(mockedUtils,Mockito.times(5)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	}
	
	@Test 
	public void generateBackendIntegrationTestFiles_parameterListIsValid_ReturnMap()
	{
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);

		Mockito.when(mockedCodeGenerator.getApplicationTestTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getDomainTestTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		Mockito.when(mockedCodeGenerator.getControllerTestTemplates(anyString())).thenReturn(new HashMap<String, Object>());
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		codeGenerator.generateBackendUnitAndIntegrationTestFiles(root,destPath.getAbsolutePath(),entityName);
		Mockito.verify(mockedUtils,Mockito.times(3)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
	}
	
	@Test 
	public void generateApplicationProperties_parameterListIsValid_ReturnMap()
	{
		Map<String,Object> root= new HashMap<String, Object>();
		root.put("ClassName", entityName);
		
		Mockito.doNothing().when(mockedUtils).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
		codeGenerator.generateApplicationProperties(root,destPath.getAbsolutePath());
		Mockito.verify(mockedUtils,Mockito.times(1)).generateFiles(any(HashMap.class),any(HashMap.class),anyString(),anyString());
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
	}
	
	
}
