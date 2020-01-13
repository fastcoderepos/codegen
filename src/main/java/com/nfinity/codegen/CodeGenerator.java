package com.nfinity.codegen;

import com.nfinity.entitycodegen.EntityDetails;
import com.nfinity.entitycodegen.EntityGeneratorUtils;
import com.nfinity.entitycodegen.FieldDetails;
import com.nfinity.entitycodegen.RelationDetails;

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
	
	public static String TEMPLATE_FOLDER = "/templates";
	
	@Autowired
	CodeGeneratorUtils codeGeneratorUtils;
	
	@Autowired 
	JSONUtils jsonUtils;
	
	@Autowired
	EntityGeneratorUtils entityGeneratorUtils;
	
	//Build root map with all information required for templates
	public Map<String, Object> buildEntityInfo(String entityName,String packageName,
			String type,EntityDetails details,String authenticationType,String schema,String authenticationTable,Boolean cache) {

		Map<String, Object> root = new HashMap<>();
		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
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
		root.put("AuthenticationType", authenticationType);
		root.put("ApiPath", className.substring(0, 1).toLowerCase() + className.substring(1));
		root.put("FrontendUrlPath", className.toLowerCase());
		
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}	

		root.put("PrimaryKeys", details.getPrimaryKeys());
		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());

		return root;
	}
	
	//Method to generate all required modules for list of entities
	public List<String> generateAllModulesForEntities(Map<String,EntityDetails> details, String backEndRootFolder, String clientRootFolder,String sourcePackageName,Boolean cache,
			String destPath, String type, String schema, String authenticationType,String authenticationTable)
	{
		// generate all modules for each entity
		List<String> entityNames=new ArrayList<String>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			entityNames.add(className);
			generate(entry.getKey(), sourcePackageName, backEndRootFolder, clientRootFolder, sourcePackageName,
							destPath, type, entry.getValue(), authenticationType,cache, schema,authenticationTable);
		}
		
		return entityNames;
	}

	// Generate all components of the desired application
	public void generateAll(String backEndRootFolder, String clientRootFolder, String sourcePackageName,
			Boolean cache, String destPath, String type,Map<String,EntityDetails> details, String connectionString,
			String schema,String authenticationType,String authenticationTable) throws IOException {

		String appName = sourcePackageName.substring(sourcePackageName.lastIndexOf(".") + 1);
		//to generate all modules for list of entities
		List<String> entityNames = generateAllModulesForEntities(details, backEndRootFolder, clientRootFolder, sourcePackageName, cache, destPath, type, schema, authenticationType, authenticationTable);
		FileUtils.copyFile(new File("src/main/resources/keystore.p12"), new File(destPath + "/" + backEndRootFolder + "/src/main/resources/keystore.p12"));

		// additional code needs to be added if history option is true
//		if(history) {
//			String appFolderPath = destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "Client/src/app/";
//			generateEntityHistoryComponent(appFolderPath, authenticationTable, details); //to generate entity History Component
//			addhistoryComponentsToAppModule(appFolderPath); // edit app module to add history components
//			addhistoryComponentsToAppRoutingModule(appFolderPath, authenticationType); // edit routing module to add history components
//			generateAuditorController(details, sourcePackageName,backEndRootFolder,destPath,authenticationType,authenticationTable,email,scheduler); // generate audit controller to maintain history of entities
//		}
		
//		if(email) {
//			new File(destPath + "/" + appName.substring(appName.lastIndexOf(".") + 1) + "/mjmlTemp").mkdirs();
//		}
		
		//update front end modules
		updateAppRouting(destPath,appName, entityNames, authenticationType);
		updateAppModule(destPath,appName, entityNames);
		updateEntitiesJsonFile(destPath + "/" + appName + "Client/src/app/common/components/main-nav/entities.json",entityNames,authenticationTable);

		Map<String,Object> propertyInfo = getInfoForApplicationPropertiesFile(destPath,sourcePackageName, connectionString, schema,authenticationType,cache);
        
		//generate configuration files for backend
		generateApplicationProperties(propertyInfo, destPath + "/" + backEndRootFolder + "/src/main/resources");
		generateBeanConfig(sourcePackageName,backEndRootFolder,destPath,authenticationType,details,cache,authenticationTable);
		if(cache) {
        modifyMainClass(destPath + "/" + backEndRootFolder + "/src/main/java", sourcePackageName);
		}
	}

	//generate bean configuration file
	public void generateBeanConfig(String packageName,String backEndRootFolder, String destPath,String authenticationType,Map<String,EntityDetails> details,Boolean cache,String authenticationTable){

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		
		Map<String, Object> root = getInfoForAuditControllerAndBeanConfig(details, packageName, authenticationType, authenticationTable);
		Map<String, Object> template = new HashMap<>();
		template.put("backendTemplates/BeanConfig.java.ftl", "BeanConfig.java");
		String destFolder = destPath + "/" + backendAppFolder + "/" + packageName.replace(".", "/");
		new File(destFolder).mkdirs();
		codeGeneratorUtils.generateFiles(template, root, destFolder,TEMPLATE_FOLDER);

	}

	// build root map for application properties
	public Map<String,Object> getInfoForApplicationPropertiesFile(String destPath, String appName, String connectionString, String schema,String authenticationType,Boolean cache){

		Map<String,Object> propertyInfo = new HashMap<String,Object>();

		propertyInfo.put("connectionStringInfo", entityGeneratorUtils.parseConnectionString(connectionString));
		propertyInfo.put("appName", appName.substring(appName.lastIndexOf(".") + 1));
		propertyInfo.put("Schema", schema);
		propertyInfo.put("Cache", cache);
		propertyInfo.put("AuthenticationType",authenticationType);
		propertyInfo.put("packageName",appName.replace(".", "/"));

		propertyInfo.put("packagePath", appName);
	

		return propertyInfo;
	}

	// build root map for bean configuration and audit controller
	public Map<String,Object> getInfoForAuditControllerAndBeanConfig(Map<String, EntityDetails> details,String packageName,String authenticationType,String authenticationTable) {
		
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
		root.put("AuthenticationType", authenticationType);
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
	
	// generate audit controller required to maintain history 
	public void generateAuditorController(Map<String, EntityDetails> details,String packageName,String backEndRootFolder, String destPath,String authenticationType,String authenticationTable ) {

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		
		Map<String, Object> root = getInfoForAuditControllerAndBeanConfig(details, packageName, authenticationType, authenticationTable);
		Map<String, Object> template = new HashMap<>();
		template.put("backendTemplates/AuditController.java.ftl", "AuditController.java");

		String destFolder = destPath + "/" + backendAppFolder + "/" + packageName.replace(".", "/") + "/restcontrollers";
		new File(destFolder).mkdirs();
		codeGeneratorUtils.generateFiles(template, root, destFolder,TEMPLATE_FOLDER);

	}

//	// generate frontend entity history component 
//	public void generateEntityHistoryComponent(String destFolder, String authenticationTable, Map<String,EntityDetails> details){
//		
//		Map<String, Object> root = new HashMap<>();
//		
//		if(authenticationTable!=null) {
//			root.put("AuthenticationTable", authenticationTable);
//			EntityDetails authTableDetails = details.get(authenticationTable);
//			Map<String, FieldDetails> descFieldMap = authTableDetails.getEntitiesDescriptiveFieldMap();
//			FieldDetails authTableDescField = descFieldMap.get(authenticationTable);
//			
//			if(authTableDescField !=null)
//			root.put("DescriptiveField", authTableDescField.getFieldName());
//			else
//		    root.put("DescriptiveField", "UserName");
//			
//			Map<String, FieldDetails> authFieldMap = authTableDetails.getAuthenticationFieldsMap();
//			root.put("UserNameField",authFieldMap.get("UserName").getFieldName());
//			
//			String moduleName = codeGeneratorUtils.camelCaseToKebabCase(authenticationTable);
//			
//			root.put("ModuleName", moduleName);
//			
//		}
//		else
//		{
//			root.put("UserNameField","userName");
//			root.put("AuthenticationTable", "User");
//			root.put("ModuleName", "user");
//		}	
//		
//		new File(destFolder + "/entity-history").mkdirs();
//		codeGeneratorUtils.generateFiles(getEntityHistoryTemplates(), root, destFolder + "/entity-history",TEMPLATE_FOLDER);
//
//		new File(destFolder + "/manage-entity-history").mkdirs();
//		codeGeneratorUtils.generateFiles(getManageEntityHistoryTemplates(), root, destFolder + "/manage-entity-history",TEMPLATE_FOLDER);
//
//	}
//	
//	// templates for front-end entity history component
//	public Map<String, Object> getEntityHistoryTemplates() {
//
//		Map<String, Object> template = new HashMap<>();
//		template.put("entityHistory/entity-history/entity-history.component.html.ftl", "entity-history.component.html");
//		template.put("entityHistory/entity-history/entity-history.component.scss.ftl", "entity-history.component.scss");
//		template.put("entityHistory/entity-history/entity-history.component.spec.ts.ftl", "entity-history.component.spec.ts");
//		template.put("entityHistory/entity-history/entity-history.component.ts.ftl", "entity-history.component.ts");
//		template.put("entityHistory/entity-history/entity-history.service.ts.ftl", "entity-history.service.ts");
//		template.put("entityHistory/entity-history/entityHistory.ts.ftl", "entityHistory.ts");
//		template.put("entityHistory/entity-history/filter-item.directive.ts.ftl", "filter-item.directive.ts");
//
//		return template;
//	}
//	
//	// templates for front-end entity history manager 
//	public Map<String, Object> getManageEntityHistoryTemplates() {
//
//		Map<String, Object> template = new HashMap<>();
//
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.html.ftl", "manage-entity-history.component.html");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.scss.ftl", "manage-entity-history.component.scss");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.spec.ts.ftl", "manage-entity-history.component.spec.ts");
//		template.put("entityHistory/manage-entity-history/manage-entity-history.component.ts.ftl", "manage-entity-history.component.ts");
//
//		return template;
//	}

//	// update app module file to add history components
//	public void addhistoryComponentsToAppModule(String destPath)
//	{
//		StringBuilder sourceBuilder=new StringBuilder();
//		sourceBuilder.setLength(0);
//		sourceBuilder.append("\n    " + "EntityHistoryComponent," );
//		sourceBuilder.append("\n    " + "ManageEntityHistoryComponent,");
//
//		String data = " ";
//		try {
//			System.out.println(" AA  " + destPath + "/app.module.ts");
//			data = FileUtils.readFileToString(new File(destPath + "/app.module.ts"),"UTF8");
//
//			StringBuilder builder = new StringBuilder();
//
//			builder.append("import { EntityHistoryComponent } from './entity-history/entity-history.component';" + "\n");
//			builder.append("import { ManageEntityHistoryComponent } from './manage-entity-history/manage-entity-history.component';" + "\n");
//
//			builder.append(data);
//			int index = builder.lastIndexOf("declarations");
//			index = builder.indexOf("[", index);
//			builder.insert(index + 1 , sourceBuilder.toString());
//			File fileName = new File(destPath + "/app.module.ts");
//
//			try (PrintWriter writer = new PrintWriter(fileName)) {
//				writer.println(builder.toString());
//			} catch (FileNotFoundException e) {
//				e.printStackTrace();
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

//	// update app routing module to add history components
//	public void addhistoryComponentsToAppRoutingModule(String destPath, String authenticationType, Boolean flowable)
//	{
//		StringBuilder sourceBuilder=new StringBuilder();
//		sourceBuilder.setLength(0);
//
//		if(authenticationType == "none") {
//			sourceBuilder.append("\n  " + " { path: 'entityHistory', component: EntityHistoryComponent},");
//			sourceBuilder.append("\n  " + " { path: 'manageEntityHistory', component: ManageEntityHistoryComponent},");
//		}
//		else {
//			sourceBuilder.append("\n  " + " { path: 'entityHistory', component: EntityHistoryComponent ,canActivate: [ AuthGuard ]},");
//			sourceBuilder.append("\n  " + " { path: 'manageEntityHistory', component: ManageEntityHistoryComponent ,canActivate: [ AuthGuard ]},");
//		}
//
//		String data = " ";
//		try {
//			data = FileUtils.readFileToString(new File(destPath + "/app.routing.ts"),"UTF8");
//
//			StringBuilder builder = new StringBuilder();
//
//			builder.append("import { EntityHistoryComponent } from './entity-history/entity-history.component';" + "\n");
//			builder.append("import { ManageEntityHistoryComponent } from './manage-entity-history/manage-entity-history.component';" + "\n");
//			builder.append(data);
//
//			int index = builder.lastIndexOf("{");
//			if(flowable) {
//				final String output = builder.substring(0, index);
//				index = output.lastIndexOf("{");
//			}
//			builder.insert(index - 1, sourceBuilder.toString());
//			File fileName = new File(destPath + "/app.routing.ts");
//
//			try (PrintWriter writer = new PrintWriter(fileName)) {
//				writer.println(builder.toString());
//			} catch (FileNotFoundException e) {
//				e.printStackTrace();
//			}
//
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//	}

	// generate all required code and layers against single entity
	public void generate(String entityName, String appName, String backEndRootFolder,String clientRootFolder,String packageName,
             String destPath, String type,EntityDetails details,String authenticationType, Boolean cache,String schema,String authenticationTable) {

		String backendAppFolder = backEndRootFolder + "/src/main/java";
		String clientAppFolder = clientRootFolder + "/src/app";
		Map<String, Object> root = buildEntityInfo(entityName,packageName,type,details,authenticationType,schema,authenticationTable, cache);

		Map<String, Object> uiTemplate2DestMapping = getUITemplates(root.get("ModuleName").toString());

		try {
			String destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString(); // "/fcclient/src/app/"
			String testDest = destPath + "/" + backEndRootFolder + "/src/test/java" + "/" + appName.replace(".", "/");
			new File(destFolder).mkdirs();
			
			if (type.equalsIgnoreCase("ui"))
				codeGeneratorUtils.generateFiles(uiTemplate2DestMapping, root, destFolder,TEMPLATE_FOLDER);
			else if (type == "backend") {
				destFolder = destPath + "/" + backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder,authenticationTable);
				generateBackendUnitAndIntegrationTestFiles(root, testDest,authenticationTable);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString(),authenticationTable);
			} else if (type.equalsIgnoreCase("all")) {
				destFolder = destPath +"/"+ clientAppFolder + "/" + root.get("ModuleName").toString();
				codeGeneratorUtils.generateFiles(uiTemplate2DestMapping, root, destFolder,TEMPLATE_FOLDER);
				destFolder = destPath +"/"+ backendAppFolder + "/" + appName.replace(".", "/");
				generateBackendFiles(root, destFolder,authenticationTable);
				generateBackendUnitAndIntegrationTestFiles(root, testDest, authenticationTable);
				generateRelationDto(details, root, destFolder,root.get("ClassName").toString(),authenticationTable);
				
			}
			
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
	}

	public void generateBackendFiles(Map<String, Object> root, String destPath,String authenticationTable) {
		String className = root.get("ClassName").toString();
		String destFolderBackend = destPath + "/application/" + className.toLowerCase();
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getApplicationTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/application/" + className.toLowerCase() + "/dto";
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase() + "/dto";
		}
		new File(destFolderBackend).mkdirs();
		Map<String,FieldDetails> authFields = (Map<String,FieldDetails>)root.get("AuthenticationFields");
		codeGeneratorUtils.generateFiles(getDtos(className,authenticationTable,authFields), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/domain/" + className.toLowerCase();
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
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
	
	public void generateBackendUnitAndIntegrationTestFiles(Map<String, Object> root, String destPath, String authenticationTable) {
		String className = root.get("ClassName").toString();
		String destFolderBackend = destPath + "/restcontrollers";
	
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getControllerTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);
		
		destFolderBackend = destPath + "/application/" + className.toLowerCase();
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/application/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getApplicationTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

		destFolderBackend = destPath + "/domain/" + className.toLowerCase();
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			destFolderBackend = destPath + "/domain/authorization/" + className.toLowerCase();
		}
		new File(destFolderBackend).mkdirs();
		codeGeneratorUtils.generateFiles(getDomainTestTemplates(className), root, destFolderBackend,TEMPLATE_FOLDER);

	}

	public Map<String, Object> getUITemplates(String moduleName) {
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

		return uiTemplate;
	}

	public Map<String, Object> getApplicationTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/iappService.java.ftl", "I" + className + "AppService.java");
		backEndTemplate.put("backendTemplates/appService.java.ftl", className + "AppService.java");
		backEndTemplate.put("backendTemplates/mapper.java.ftl", className + "Mapper.java");
	//	backEndTemplate.put("backendTemplates/appServiceTest.java.ftl", className + "AppServiceTest.java");

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
	//	backEndTemplate.put("backendTemplates/managerTest.java.ftl", className + "ManagerTest.java");

		return backEndTemplate;
	}
	
	public Map<String, Object> getDomainTestTemplates(String className) {

		Map<String, Object> backEndTemplate = new HashMap<>();
		backEndTemplate.put("backendTemplates/managerTest.java.ftl", className + "ManagerTest.java");

		return backEndTemplate;
	}

	public Map<String, Object> getDtos(String className,String authenticationTable,Map<String,FieldDetails> authFields) {

		Map<String, Object> backEndTemplate = new HashMap<>();

		backEndTemplate.put("backendTemplates/Dto/createInput.java.ftl", "Create" + className + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/createOutput.java.ftl", "Create" + className + "Output.java");
		backEndTemplate.put("backendTemplates/Dto/updateInput.java.ftl", "Update" + className + "Input.java");
		backEndTemplate.put("backendTemplates/Dto/updateOutput.java.ftl", "Update" + className + "Output.java");
		backEndTemplate.put("backendTemplates/Dto/findByIdOutput.java.ftl", "Find" + className + "ByIdOutput.java");
		if(authenticationTable !=null && className.equalsIgnoreCase(authenticationTable))
		{
			if(authFields !=null && authFields.containsKey("UserName")) {
				backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserByNameOutput.java.ftl", "Find"+authenticationTable+"By"+authFields.get("UserName").getFieldName().substring(0, 1).toUpperCase() + authFields.get("UserName").getFieldName().substring(1)+"Output.java");
			}
			else
				backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/FindUserByNameOutput.java.ftl", "Find"+authenticationTable+"ByNameOutput.java");

			backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/GetRoleOutput.java.ftl", "GetRoleOutput.java");
		//	backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/GetPermissionOutput.java.ftl", "GetPermissionOutput.java");
			backEndTemplate.put("backendTemplates/authenticationTemplates/application/authorization/user/dto/LoginUserInput.java.ftl", "LoginUserInput.java");
			backEndTemplate.put("backendTemplates/Dto/customUserDto/userDto/FindCustomUserWithAllFieldsByIdOutput.java.ftl", "Find"+authenticationTable+"WithAllFieldsByIdOutput.java");
		}
		return backEndTemplate;
	}

	public void generateRelationDto(EntityDetails details,Map<String,Object> root, String destPath,String entityName,String authenticationTable)
	{
		String destFolder = destPath + "/application/" + root.get("ClassName").toString().toLowerCase() + "/Dto";
		if(authenticationTable !=null && root.get("ClassName").toString().equalsIgnoreCase(authenticationTable))
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
	
	public void updateAppModule(String destPath,String appName,List<String> entityName)
	{
		StringBuilder sourceBuilder=new StringBuilder();
		sourceBuilder.setLength(0);

		for(String str: entityName)
		{
			sourceBuilder.append("\n    " + str + "ListComponent," );
			sourceBuilder.append("\n    " + str + "DetailsComponent,");
			sourceBuilder.append("\n    " + str + "NewComponent,");
		}
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + appName + "Client/src/app/app.module.ts"),"UTF8");

			StringBuilder builder = addImports(entityName);

			builder.append(data);
			int index = builder.lastIndexOf("declarations");
			index = builder.indexOf("[", index);
			builder.insert(index + 1 , sourceBuilder.toString());
			File fileName = new File(destPath + "/" + appName + "Client/src/app/app.module.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateAppRouting(String destPath,String appName, List<String> entityName, String authenticationType)
	{
		StringBuilder sourceBuilder = new StringBuilder();

		for(String str: entityName)
		{
			String listComp,newComp,detailsComp;
			if(authenticationType == "none") {
				listComp = "\n  " +" { path: '" + str.toLowerCase() + "', component: " + str + "ListComponent, canDeactivate: [CanDeactivateGuard] },";
				newComp = "\n  " + " { path: '" + str.toLowerCase() + "/new', component: " + str + "NewComponent },";
				detailsComp = "\n  " + " { path: '" + str.toLowerCase() + "/:id', component: " +str + "DetailsComponent, canDeactivate: [CanDeactivateGuard] }," + "\n";
			}
			else {
				listComp = "\n  " +" { path: '" + str.toLowerCase() + "', component: " + str + "ListComponent, canActivate: [ AuthGuard ], canDeactivate: [CanDeactivateGuard] },";
				newComp = "\n  " + " { path: '" + str.toLowerCase() + "/new', component: " + str + "NewComponent ,canActivate: [ AuthGuard ]  },";
				detailsComp = "\n  " + " { path: '" + str.toLowerCase() + "/:id', component: " +str + "DetailsComponent ,canActivate: [ AuthGuard ], canDeactivate: [CanDeactivateGuard] },"+ "\n";
			}

			sourceBuilder.append(listComp);
			sourceBuilder.append(newComp);
			sourceBuilder.append(detailsComp);
		}
		String data = " ";
		try {
			data = FileUtils.readFileToString(new File(destPath + "/" + appName + "Client/src/app/app.routing.ts"),"UTF8");

			StringBuilder builder = addImports(entityName);

			builder.append(data);
			int index = builder.lastIndexOf("{");
			
			builder.insert(index - 1, sourceBuilder.toString());
			File fileName = new File(destPath + "/" + appName + "Client/src/app/app.routing.ts");

			try (PrintWriter writer = new PrintWriter(fileName)) {
				writer.println(builder.toString());
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public StringBuilder addImports(List<String> entityName)
	{
		StringBuilder builder=new StringBuilder();
		for(String str: entityName)
		{
			String moduleName = codeGeneratorUtils.camelCaseToKebabCase(str);
			builder.append("import { " + str + "ListComponent , " + str + "DetailsComponent, " + str + "NewComponent } from './" + moduleName + "/index';" + "\n");
		}

		return builder;
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
				e.printStackTrace();
			}

		} catch (Exception e) {
			e.printStackTrace();
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
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}

	}


}
