package com.fastcode.codegen;

import com.fastcode.entitycodegen.AuthenticationInfo;
import com.fastcode.entitycodegen.AuthenticationType;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.EntityGeneratorUtils;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.RelationDetails;
import com.fastcode.logging.LoggingHelper;

import java.io.File;
import java.io.FileNotFoundException;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.simple.JSONArray;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.apache.commons.io.FileUtils;

@Component
public class CodeGenerator {

	private static String TEMPLATE_FOLDER = "/templates";

	@Autowired
	CodeGeneratorUtils codeGeneratorUtils;

	@Autowired 
	JSONUtils jsonUtils;

	@Autowired
	EntityGeneratorUtils entityGeneratorUtils;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private FolderContentReader contentReader;

	//Build root map with all information required for templates
	public Map<String, Object> buildEntityInfo(String className,String packageName,
			EntityDetails details, AuthenticationInfo authenticationInfo,String schema,Boolean cache) {

		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		String customAuthTable = authenticationInfo.getAuthenticationTable();
		Boolean userOnly = authenticationInfo.getUserOnly();
      
        Map<String, Object> root = new HashMap<>();
		//String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		String instanceName = className.substring(0, 1).toLowerCase() + className.substring(1);
		String moduleName = codeGeneratorUtils.camelCaseToKebabCase(className);

		root.put("Schema", schema); 
		root.put("Cache", cache);
		root.put("ModuleName", moduleName);
		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("InstanceName", instanceName);
		root.put("CompositeKeyClasses",details.getCompositeKeyClasses());
		root.put("IdClass", details.getIdClass());
		root.put("DescriptiveField",details.getEntitiesDescriptiveFieldMap());
		root.put("AuthenticationFields",details.getAuthenticationFieldsMap());
		root.put("IEntity", "I" + className);
		root.put("IEntityFile", "i" + moduleName);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UserOnly", userOnly);
		root.put("AuthenticationType", authType.getName());
		root.put("ApiPath", className.substring(0, 1).toLowerCase() + className.substring(1));
		root.put("FrontendUrlPath", className.toLowerCase());

		if(customAuthTable != null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", customAuthTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}	

		if((customAuthTable != null && customAuthTable.equals(className)) && (authType.equals(AuthenticationType.OIDC) || authType.equals(AuthenticationType.LDAP))) {
			root.put("ExcludeUserNew", true);
		}
		else {
			root.put("ExcludeUserNew", false);
		}

		root.put("PrimaryKeys", details.getPrimaryKeys());
		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());

		return root;
	}

	//Method to generate all required modules for list of entities
	public List<String> generateAllModulesForEntities(Map<String,EntityDetails> details, String backEndRootFolder, String clientRootFolder,String sourcePackageName,Boolean cache,
			String destPath, String schema, AuthenticationInfo authenticationInfo)
	{
		// generate all modules for each entity
		List<String> entityNames=new ArrayList<String>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			//String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			entityNames.add(entry.getKey());
			generate(entry.getKey(), sourcePackageName, backEndRootFolder, clientRootFolder, sourcePackageName,
					destPath,entry.getValue(),authenticationInfo, cache, schema);
		}

		return entityNames;
	}

	// Generate all components of the desired application
	public void generateAll(String backEndRootFolder, String clientRootFolder, String sourcePackageName,
			Boolean cache, String destPath,Map<String,EntityDetails> details, String connectionString,
			String schema, AuthenticationInfo authenticationInfo) {

		String appName = sourcePackageName.substring(sourcePackageName.lastIndexOf(".") + 1);
		//to generate all modules for list of entities
		List<String> entityNames = generateAllModulesForEntities(details, backEndRootFolder, clientRootFolder, sourcePackageName, cache, destPath,schema, authenticationInfo);

		contentReader.copyFileFromJar("keystore.p12", destPath + "/" + backEndRootFolder + "/src/main/resources/keystore.p12");

		updateEntitiesJsonFile(destPath + "/" + appName + "Client/src/app/common/components/main-nav/entities.json",entityNames,authenticationInfo.getAuthenticationTable());

		Map<String,Object> propertyInfo = getInfoForApplicationPropertiesFile(destPath,sourcePackageName, connectionString, schema,authenticationInfo,cache);

		//generate configuration files for backend
		generateApplicationProperties(propertyInfo, destPath + "/" + backEndRootFolder + "/src/main/resources");
		generateBeanConfig(sourcePackageName,backEndRootFolder,destPath,authenticationInfo.getAuthenticationType(),details,cache,authenticationInfo.getAuthenticationTable());
		if(cache) {
			modifyMainClass(destPath + "/" + backEndRootFolder + "/src/main/java", sourcePackageName);
		}
	}

	//generate bean configuration file
	public void generateBeanConfig(String packageName,String backEndRootFolder, String destPath,AuthenticationType authenticationType,Map<String,EntityDetails> details,Boolean cache,String authenticationTable){

		String backendAppFolder = backEndRootFolder + "/src/main/java";

		Map<String, Object> root = getInfoForBeanConfig(details, packageName, authenticationType, authenticationTable);
		Map<String, Object> template = new HashMap<>();
		template.put("backendTemplates/BeanConfig.java.ftl", "BeanConfig.java");
		String destFolder = destPath + "/" + backendAppFolder + "/" + packageName.replace(".", "/");
		new File(destFolder).mkdirs();
		codeGeneratorUtils.generateFiles(template, root, destFolder,TEMPLATE_FOLDER);

	}

	// build root map for application properties
	public Map<String,Object> getInfoForApplicationPropertiesFile(String destPath, String appName, String connectionString, String schema,AuthenticationInfo authenticationInfo,Boolean cache){

		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", entityGeneratorUtils.parseConnectionString(connectionString));
		propertyInfo.put("appName", appName.substring(appName.lastIndexOf(".") + 1));
		propertyInfo.put("Schema", schema);
		propertyInfo.put("Cache", cache);
		propertyInfo.put("AuthenticationType",authenticationInfo.getAuthenticationType().getName());
		propertyInfo.put("LogonName",authenticationInfo.getLogonName());
		propertyInfo.put("AuthenticationSchema" ,authenticationInfo.getAuthenticationTable());
		propertyInfo.put("packageName",appName.replace(".", "/"));
		propertyInfo.put("packagePath", appName);

		return propertyInfo;
	}

	// build root map for bean configuration and audit controller
	public Map<String,Object> getInfoForBeanConfig(Map<String, EntityDetails> details,String packageName, AuthenticationType authenticationType,String authenticationTable) {

		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		//set details for each entity in root map
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
		root.put("AuthenticationType", authenticationType.getName());
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));

		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}	

		return root;
	}

	// generate all required code and layers against single entity
	public void generate(String entityName, String appName, String backEndRootFolder,String clientRootFolder,String packageName,
			String destPath, EntityDetails details, AuthenticationInfo authenticationInfo, Boolean cache,String schema) {

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		String clientAppFolder = clientRootFolder + "/src/app";
		Map<String, Object> root = buildEntityInfo(entityName,packageName,details,authenticationInfo,schema,cache);

		Map<String, Object> uiTemplate2DestMapping = getUITemplates(root.get("ModuleName").toString(), root.get("ClassName").toString(), authenticationInfo);

		String destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString(); // "/fcclient/src/app/"
		String testDest = destPath + "/" + backEndRootFolder + "/src/test/java" + "/" + appName.replace(".", "/");
		new File(destFolder).mkdirs();

		destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString();
		codeGeneratorUtils.generateFiles(uiTemplate2DestMapping, root, destFolder,TEMPLATE_FOLDER);
		destFolder = destPath +"/"+ backendAppFolder + "/" + appName.replace(".", "/");
		generateBackendFiles(root, destFolder,authenticationInfo);
		generateBackendUnitAndIntegrationTestFiles(root, testDest, authenticationInfo);
		generateRelationDto(details, root, destFolder,root.get("ClassName").toString(),authenticationInfo);

	}

	public void generateBackendFiles(Map<String, Object> root, String destPath, AuthenticationInfo authenticationInfo) {
		String className = root.get("ClassName").toString();
		String authSchema = authenticationInfo.getAuthenticationTable();
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		Boolean userOnly = authenticationInfo.getUserOnly();
		String destFolderBackend = destPath + "/application/" + className.toLowerCase();
		
		if((authType.equals(AuthenticationType.DATABASE) || userOnly) && className.equalsIgnoreCase(authSchema))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getApplicationTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/application/" + className.toLowerCase() + "/dto";
		if((authType.equals(AuthenticationType.DATABASE) || userOnly) && className.equalsIgnoreCase(authSchema))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase() + "/dto";
		}
		new File(destFolderBackend).mkdirs();
		Map<String,FieldDetails> authFields = (Map<String,FieldDetails>)root.get("AuthenticationFields");
		codeGeneratorUtils.generateFiles(getDtos(className,authenticationInfo,authFields), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/domain/" + className.toLowerCase();
		if((authType.equals(AuthenticationType.DATABASE) || userOnly) && className.equalsIgnoreCase(authSchema))
		{
			destFolderBackend = destPath + "/domain/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getDomainTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/domain/irepository";
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getRepositoryTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/restcontrollers";
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getControllerTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);
	}

	public void generateBackendUnitAndIntegrationTestFiles(Map<String, Object> root, String destPath, AuthenticationInfo authenticationInfo) {
		String className = root.get("ClassName").toString();
		String authSchema = authenticationInfo.getAuthenticationTable();
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		Boolean userOnly = authenticationInfo.getUserOnly();
		String destFolderBackend = destPath + "/restcontrollers";

		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getControllerTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/application/" + className.toLowerCase();
		if((authType.equals(AuthenticationType.DATABASE) || userOnly ) && className.equalsIgnoreCase(authSchema))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getApplicationTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/domain/" + className.toLowerCase();
		if((authType.equals(AuthenticationType.DATABASE) || userOnly ) && className.equalsIgnoreCase(authSchema))
		{
			destFolderBackend = destPath + "/domain/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getDomainTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

	}

	public Map<String, Object> getUITemplates(String moduleName, String className, AuthenticationInfo authenticationInfo) {
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		String customAuthTable = authenticationInfo.getAuthenticationTable();

		Map<String, Object> uiTemplate = new HashMap<>();
		uiTemplate.put("iitem.ts.ftl", "i" + moduleName + ".ts");
		uiTemplate.put("index.ts.ftl", "index.ts");
		uiTemplate.put("item.service.ts.ftl", moduleName + ".service.ts");

		uiTemplate.put("item-list.component.ts.ftl", moduleName + "-list.component.ts");
		uiTemplate.put("item-list.component.html.ftl", moduleName + "-list.component.html");
		uiTemplate.put("item-list.component.scss.ftl", moduleName + "-list.component.scss");
		uiTemplate.put("item-list.component.spec.ts.ftl", moduleName + "-list.component.spec.ts");

		// should not create new component if entity is custom user and auth type is either ldap or oidc
		if(!(className.equals(customAuthTable) && (authType.equals(AuthenticationType.OIDC) || authType.equals(AuthenticationType.LDAP)))) {
			uiTemplate.put("item-new.component.ts.ftl", moduleName + "-new.component.ts");
			uiTemplate.put("item-new.component.html.ftl", moduleName + "-new.component.html");
			uiTemplate.put("item-new.component.scss.ftl", moduleName + "-new.component.scss");
			uiTemplate.put("item-new.component.spec.ts.ftl", moduleName + "-new.component.spec.ts");
		}
		uiTemplate.put("item-details.component.ts.ftl", moduleName + "-details.component.ts");
		uiTemplate.put("item-details.component.html.ftl", moduleName + "-details.component.html");
		uiTemplate.put("item-details.component.scss.ftl", moduleName + "-details.component.scss");
		uiTemplate.put("item-details.component.spec.ts.ftl", moduleName + "-details.component.spec.ts");

		return uiTemplate;
	}

	public Map<String, Object> getApplicationTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/iappService.java.ftl", "I" + className + "AppService.java");
		backEndTemplate.put("backendTemplates/appService.java.ftl", className + "AppService.java");
		backEndTemplate.put("backendTemplates/mapper.java.ftl", className + "Mapper.java");

		return backEndTemplate;
	}
	public Map<String, Object> getApplicationTestTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/appServiceTest.java.ftl", className + "AppServiceTest.java");

		return backEndTemplate;
	}

	public Map<String, Object> getRepositoryTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/irepository.java.ftl", "I" + className + "Repository.java");

		return backEndTemplate;
	}

	public Map<String, Object> getControllerTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/controller.java.ftl", className + "Controller.java");

		return backEndTemplate;
	}

	public Map<String, Object> getControllerTestTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/ControllerTest.java.ftl", className + "ControllerTest.java");
		return backEndTemplate;
	}


	public Map<String, Object> getDomainTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/manager.java.ftl", className + "Manager.java");
		backEndTemplate.put("backendTemplates/imanager.java.ftl", "I" + className + "Manager.java");

		return backEndTemplate;
	}

	public Map<String, Object> getDomainTestTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/managerTest.java.ftl", className + "ManagerTest.java");

		return backEndTemplate;
	}

	public Map<String, Object> getDtos(String className,AuthenticationInfo authenticationInfo,Map<String,FieldDetails> authFields) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		String authSchema = authenticationInfo.getAuthenticationTable();
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		Boolean userOnly = authenticationInfo.getUserOnly();

		backEndTemplate.put("backendTemplates/Dto/createInput.java.ftl", "Create" + className + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/createOutput.java.ftl", "Create" + className + "Output.java");
		backEndTemplate.put("backendTemplates/Dto/updateInput.java.ftl", "Update" + className + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/updateOutput.java.ftl", "Update" + className + "Output.java");
		backEndTemplate.put("backendTemplates/Dto/findByIdOutput.java.ftl", "Find" + className + "ByIdOutput.java");
		
		if((authType.equals(AuthenticationType.DATABASE) ||
				userOnly) && 
				authSchema !=null && className.equalsIgnoreCase(authSchema))
		{
			if(authFields !=null && authFields.containsKey("UserName")) {
				backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserByNameOutput.java.ftl", "Find"+ authSchema +"By"+authFields.get("UserName").getFieldName().substring(0, 1).toUpperCase() + authFields.get("UserName").getFieldName().substring(1)+"Output.java");
			}
			else
				backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/FindUserByNameOutput.java.ftl", "Find"+ authSchema +"ByNameOutput.java");

			backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/GetRoleOutput.java.ftl", "GetRoleOutput.java");
			//	backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/LoginUserInput.java.ftl", "LoginUserInput.java");
			backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserWithAllFieldsByIdOutput.java.ftl", "Find"+ authSchema +"WithAllFieldsByIdOutput.java");
		}
		return backEndTemplate;
	}

	public void generateRelationDto(EntityDetails details,Map<String,Object> root, String destPath,String entityName,AuthenticationInfo authenticationInfo)
	{
		String destFolder = destPath + "/application/" + root.get("ClassName").toString().toLowerCase() + "/Dto";
		if((authenticationInfo.getAuthenticationType().equals(AuthenticationType.DATABASE) ||
				authenticationInfo.getUserOnly()) &&  authenticationInfo.getAuthenticationTable() !=null && root.get("ClassName").toString().equalsIgnoreCase(authenticationInfo.getAuthenticationTable()))
		{
			destFolder = destPath + "/application/authorization/" + root.get("ClassName").toString().toLowerCase() + "/dto";
		}

		new File(destFolder).mkdirs();

		Map<String,RelationDetails> relationDetails = details.getRelationsMap();

		for (Map.Entry<String, RelationDetails> entry : relationDetails.entrySet()) {
			if(entry.getValue().getRelation().equals("ManyToOne") || entry.getValue().getRelation().equals("OneToOne"))
			{
				List<FieldDetails> relationEntityFields= entry.getValue().getfDetails();

				root.put("RelationEntityFields",relationEntityFields);
				root.put("RelationEntityName", entry.getValue().geteName());

				Map<String, Object> template = new HashMap<>();
				template.put("backendTemplates/Dto/getOutput.java.ftl", "Get"+ entry.getValue().geteName() + "Output.java");
				codeGeneratorUtils.generateFiles(template, root, destFolder,TEMPLATE_FOLDER);
			}
		}
	}

	public void generateApplicationProperties(Map<String, Object> root, String destPath)
	{
		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/application.properties.ftl", "application.properties");
		backEndTemplate.put("backendTemplates/application-bootstrap.properties.ftl", "application-bootstrap.properties");
		backEndTemplate.put("backendTemplates/application-local.properties.ftl", "application-local.properties");
		backEndTemplate.put("backendTemplates/application-test.properties.ftl", "application-test.properties");
		new File(destPath).mkdirs();
		codeGeneratorUtils.generateFiles(backEndTemplate, root, destPath,TEMPLATE_FOLDER);
	}

	public void modifyMainClass(String destPath,String appName)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		sourceBuilder.append("import org.springframework.cache.annotation.EnableCaching;\n");
		sourceBuilder.append("\n@EnableCaching");

		String packageName = appName.replace(".", "/");
		String className = appName.substring(appName.lastIndexOf(".") + 1);
		className = className.substring(0, 1).toUpperCase() + className.substring(1) + "Application.java";
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + packageName + "/" + className),"UTF8");

			StringBuilder builder=new StringBuilder();

			builder.append(data);
			int index = builder.lastIndexOf("@");
			builder.insert(index - 1 , sourceBuilder.toString());


			File fileName = new File(destPath + "/" + packageName + "/" + className);

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				logHelper.getLogger().error("File Not Found Exception : ", e.getMessage());
			}

		} catch (Exception e) {
			logHelper.getLogger().error("Error Occured : ", e.getMessage());
		}
	}

	public void updateEntitiesJsonFile(String path, List<String> entityNames, String authenticationTable) {
		try {
			JSONArray entityArray = (JSONArray) jsonUtils.readJsonFile(path);
			for(String entityName: entityNames)
			{
				if(!entityName.equalsIgnoreCase(authenticationTable)) {
					entityArray.add(entityName.toLowerCase());
				}
			}

			String prettyJsonString = jsonUtils.beautifyJson(entityArray, "Array");
			jsonUtils.writeJsonToFile(path,prettyJsonString);

		} catch (FileNotFoundException e) {
			logHelper.getLogger().error("File Not Found Exception : ", e.getMessage());
		} catch (IOException e) {
			logHelper.getLogger().error("IOException : ", e.getMessage());
		} catch (ParseException e) {
			logHelper.getLogger().error("Parsing Exception: ", e.getMessage());
		}

	}


}
