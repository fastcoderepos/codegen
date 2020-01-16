package com.fastcode.codegen;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.entitycodegen.EntityDetails;

@Component
public class AuthenticationClassesTemplateGenerator {

	@Autowired 
	private CodeGenerator codeGenerator;

	@Autowired
	private CodeGeneratorUtils codeGeneratorUtils;
	
	private static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	private static final String AUTHORIZATION_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTemplates";
	private static final String AUTHORIZATION_TEST_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTestTemplates";

	public void generateAutheticationClasses(String destination, String packageName, Boolean cache,String authenticationType
			,String schemaName,String authenticationTable,Map<String,EntityDetails> details) {

		String backendAppFolder = destination + "/" + packageName.substring(packageName.lastIndexOf(".") + 1) + "/src/main/java/" + packageName.replace(".", "/");
		String backendTestFolder = destination + "/" + packageName.substring(packageName.lastIndexOf(".") + 1) + "/src/test/java/" + packageName.replace(".", "/");
		
		Map<String, Object> root = buildBackendRootMap(packageName, authenticationType, schemaName, authenticationTable, details, cache);
		
		generateBackendAuthorizationFiles(backendAppFolder, AUTHORIZATION_TEMPLATE_FOLDER, authenticationTable, root);
		generateBackendAuthorizationTestFiles(backendTestFolder, AUTHORIZATION_TEST_TEMPLATE_FOLDER, authenticationTable, root);
		generateFrontendAuthorization(destination, packageName, authenticationType, authenticationTable, root);
		generateAppStartupRunner(details, backendAppFolder,root);
	}
	
	public Map<String,Object> buildBackendRootMap(String packageName,String authenticationType,String schemaName,String authenticationTable,Map<String,EntityDetails> details, Boolean cache)
	{
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("Cache", cache);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("AuthenticationType",authenticationType);
		root.put("SchemaName",schemaName);
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");
		}

		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(authenticationTable!=null)
			{
				if(className.equalsIgnoreCase(authenticationTable))
				{
					root.put("ClassName", className);
					root.put("CompositeKeyClasses",entry.getValue().getCompositeKeyClasses());
					root.put("Fields", entry.getValue().getFieldsMap());
					root.put("AuthenticationFields", entry.getValue().getAuthenticationFieldsMap());
					root.put("DescriptiveField", entry.getValue().getEntitiesDescriptiveFieldMap());
					root.put("PrimaryKeys", entry.getValue().getPrimaryKeys());
				}
			}

		}
		
		return root;
	}
	
	public void generateBackendAuthorizationFiles(String destination, String templatePath, String authenticationTable, Map<String,Object> root) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);
		
		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(authenticationTable==null)
			{
				
				if(!outputFileName.contains("GetCU"))
				{
					templates.put(filePath, outputFileName);
				}
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authenticationTable);
					outputFileName = outputFileName.replace("user", authenticationTable.toLowerCase());
				}
			
				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.contains("UserDetailsServiceImpl")  || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 	

					if(!outputFileName.contains("GetUser"))
					{
						if(outputFileName.contains("GetCU"))
						{
							outputFileName = outputFileName.replace("CU", authenticationTable);
						}
						
						templates.put(filePath, outputFileName);
					}
					
				}
			}
		}
		codeGeneratorUtils.generateFiles(templates, root, destination,templatePath);
	}

	public void generateBackendAuthorizationTestFiles(String destination, String templatePath, String authenticationTable, Map<String,Object> root) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);
		
		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			if(authenticationTable==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authenticationTable);
					outputFileName = outputFileName.replace("user", authenticationTable.toLowerCase());
				}

				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}

		}
		
		codeGeneratorUtils.generateFiles(templates, root, destination,templatePath);
	}


	public void generateFrontendAuthorization(String destPath, String packageName, String authenticationType, String authenticationTable, Map<String, Object> root) {

		String appName =packageName.substring(packageName.lastIndexOf(".") + 1);
		String appFolderPath = destPath + "/" + appName + "Client/src/app/";
		List<String> authorizationEntities = new ArrayList<String>();
		String authorizationPath = "/templates/frontendAuthorization/";

		authorizationEntities.add("role");
		authorizationEntities.add("permission");
		authorizationEntities.add("rolepermission");

		List<String> entityList = new ArrayList<String>();
		entityList.add("Role");
		entityList.add("Permission");
		entityList.add("Rolepermission");

		if(authenticationTable == null) {
			authorizationEntities.add("user");
			entityList.add("User");
			entityList.add("Userpermission");
			entityList.add("Userrole");
		} else {
			entityList.add(authenticationTable + "permission");
			entityList.add(authenticationTable + "role");
		}
		authorizationEntities.add("userpermission");
		authorizationEntities.add("userrole");

		codeGenerator.updateAppModule(destPath, appName, entityList);
		codeGenerator.updateAppRouting(destPath, appName, entityList, authenticationType);

		authorizationEntities.add("login");
		authorizationEntities.add("core");
		authorizationEntities.add("oauth");

		for(String entity: authorizationEntities) {
			if(entity == "userpermission" && authenticationTable != null) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(authenticationTable) + "permission", authorizationPath + entity, authenticationTable, root);
			}
			else if(entity == "userrole" && authenticationTable != null) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(authenticationTable) + "role", authorizationPath + entity, authenticationTable, root);
			}
			else {
				generateFrontendAuthorizationComponents(appFolderPath + entity, authorizationPath + entity, authenticationTable, root);
			}
		}

	}

	public void generateFrontendAuthorizationComponents(String destination, String templatePath, String authenticationTable, Map<String,Object> root) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);
		
		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			
			if(authenticationTable==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if(outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole"))
				{
					outputFileName = outputFileName.replace("user", codeGeneratorUtils.camelCaseToKebabCase(authenticationTable));
				}

				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}

		}

		if(authenticationTable != null) {
			root.put("moduleName", codeGeneratorUtils.camelCaseToKebabCase(authenticationTable));
		}
		else {
			root.put("moduleName", "user");
		}

		codeGeneratorUtils.generateFiles(templates, root, destination,templatePath);
	}

	public void generateAppStartupRunner(Map<String, EntityDetails> details, String backEndRootFolder,Map<String, Object> root){

		Map<String, Object> entitiesMap = new HashMap<String,Object>();
		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			Map<String, String> entityMap = new HashMap<String,String>();
			String key = entry.getKey();
			String name = key.substring(key.lastIndexOf(".") + 1);

			entityMap.put("entity" , name + "Entity");
			entityMap.put("requestMapping" , "/" + name.toLowerCase());
			entityMap.put("method" , "get" + name + "Changes");
			entitiesMap.put(name, entityMap);
		}

		root.put("entitiesMap", entitiesMap);
		
		Map<String, Object> template = new HashMap<>();
		template.put("AppStartupRunner.java.ftl", "AppStartupRunner.java");

		new File(backEndRootFolder).mkdirs();
		codeGeneratorUtils.generateFiles(template, root, backEndRootFolder,BACKEND_TEMPLATE_FOLDER);

	}

}
