package com.fastcode.codegen;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.entitycodegen.AuthenticationConstants;
import com.fastcode.entitycodegen.EntityDetails;

@Component
public class AuthenticationClassesTemplateGenerator {

	@Autowired 
	private CodeGenerator codeGenerator;

	@Autowired
	private CodeGeneratorUtils codeGeneratorUtils;

	private static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	private static final String AUTHORIZATION_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTemplates";
	private static final String FRONTEND_AUTHORIZATION_TEMPLATE_FOLDER = "/templates/frontendAuthorization";
	private static final String AUTHORIZATION_TEST_TEMPLATE_FOLDER = "/templates/backendTemplates/authenticationTestTemplates";

	public void generateAutheticationClasses(String destination, String packageName, Boolean cache,String schemaName,Map<String, String> authenticationInputMap,Map<String,EntityDetails> details) {

		String backendAppFolder = destination + "/" + packageName.substring(packageName.lastIndexOf(".") + 1) + "/src/main/java/" + packageName.replace(".", "/");
		String backendTestFolder = destination + "/" + packageName.substring(packageName.lastIndexOf(".") + 1) + "/src/test/java/" + packageName.replace(".", "/");

		Map<String, Object> root = buildBackendRootMap(packageName,schemaName, authenticationInputMap, details, cache);

		generateBackendFiles(authenticationInputMap,root,backendAppFolder,backendTestFolder);
		generateFrontendAuthorization(destination, packageName,authenticationInputMap, root);
		generateAppStartupRunner(details, backendAppFolder,root);
	}
	
	public void generateBackendFiles(Map<String, String> authenticationInputMap, Map<String, Object> root,String backendAppFolder, String backendTestFolder )
	{
		
        Map<String, Object> templates = new HashMap<String, Object>();
        Map<String, Object> testTemplates = new HashMap<String, Object>();
		
		if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("database") || 
				(!authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("database") && authenticationInputMap.get(AuthenticationConstants.USERS_ONLY).equals("true")))
		{
			templates=getBackendAuthorizationFiles(AUTHORIZATION_TEMPLATE_FOLDER,authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA),authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
			testTemplates=getBackendAuthorizationTestFiles(AUTHORIZATION_TEST_TEMPLATE_FOLDER,authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA));

		}
		else if(!authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("database") && authenticationInputMap.get(AuthenticationConstants.USERS_ONLY).equals("false"))
		{
			templates = getAuthenticationTemplatesForUserGroupCase(AUTHORIZATION_TEMPLATE_FOLDER,authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
			testTemplates = getAuthenticationTemplatesForUserGroupCase(AUTHORIZATION_TEST_TEMPLATE_FOLDER, authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		}

		codeGeneratorUtils.generateFiles(templates, root, backendAppFolder,AUTHORIZATION_TEMPLATE_FOLDER);
		codeGeneratorUtils.generateFiles(testTemplates, root, backendTestFolder,AUTHORIZATION_TEST_TEMPLATE_FOLDER);
	}

	public Map<String,Object> buildBackendRootMap(String packageName,String schemaName,Map<String, String> authenticationInputMap,Map<String,EntityDetails> details, Boolean cache)
	{
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("Cache", cache);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UsersOnly",authenticationInputMap.get(AuthenticationConstants.USERS_ONLY));
		root.put("AuthenticationType",authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		root.put("SchemaName",schemaName);
		if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA));
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");
		}

		for(Map.Entry<String,EntityDetails> entry : details.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)!=null)
			{
				if(className.equalsIgnoreCase(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)))
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

	public Map<String, Object> getAuthenticationTemplatesForUserGroupCase(String templatePath, String authenticationType) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			if(!(outputFileName.toLowerCase().contains("user") && !((outputFileName.contains("UserDetailsServiceImpl") && authenticationType == "database") || outputFileName.contains("LoginUser"))))
			{ 	
                if(!(outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc")))
                {
				templates.put(filePath, outputFileName);
                }
			}
		}

		return templates;
	}

	public Map<String, Object> getBackendAuthorizationFiles(String templatePath, String authenticationTable, String authenticationType) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(authenticationTable==null)
			{
				if(!outputFileName.contains("GetCU") && !((outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc")) || (outputFileName.contains("UserDetailsServiceImpl") && !authenticationType.equals("database"))))
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
			
				if(!(outputFileName.toLowerCase().contains("user") && !((outputFileName.contains("UserDetailsServiceImpl") && authenticationType == "database") || outputFileName.contains("LoginUser") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 	
					if(!outputFileName.contains("GetUser") && !(outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc"))  )
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

		return templates;
	}

	public Map<String, Object> getBackendAuthorizationTestFiles(String templatePath, String authenticationTable) {
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

		return templates;
	}

	public void generateFrontendAuthorization(String destPath, String packageName, Map<String,String> authenticationInputMap, Map<String, Object> root) {

		String appName =packageName.substring(packageName.lastIndexOf(".") + 1);
		String appFolderPath = destPath + "/" + appName + "Client/src/app/";
		List<String> authorizationEntities = new ArrayList<String>();

		authorizationEntities.add("role");
		authorizationEntities.add("permission");
		authorizationEntities.add("rolepermission");

		List<String> entityList = new ArrayList<String>();
		entityList.add("Role");
		entityList.add("Permission");
		entityList.add("Rolepermission");

		codeGenerator.updateAppModule(destPath, appName, entityList);
		codeGenerator.updateAppRouting(destPath, appName, entityList, authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));

		if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE) == "oidc") {
			authorizationEntities.add("callback");
			generateSilentRefreshFile(destPath + "/" + appName + "Client/src/assets/");
		}
		else {
			authorizationEntities.add("login");	
		}
		authorizationEntities.add("core");

		if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("database") || 
				(!authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE).equals("database") && authenticationInputMap.get(AuthenticationConstants.USERS_ONLY).equals("true")))
		{
			if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) == null) {
				authorizationEntities.add("user");
				entityList.add("User");
				entityList.add("Userpermission");
				entityList.add("Userrole");
			} else {
				entityList.add(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) + "permission");
				entityList.add(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) + "role");
			}

			authorizationEntities.add("userpermission");
			authorizationEntities.add("userrole");

		}

		for(String entity: authorizationEntities) {
			String entityPath = FRONTEND_AUTHORIZATION_TEMPLATE_FOLDER + "/" + entity;
			if(entity == "userpermission" && authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) != null ) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)) + "permission", entityPath, authenticationInputMap, root);
			}
			else if(entity == "userrole" && authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) != null ) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)) + "role", entityPath, authenticationInputMap, root);
			}
			else 
			{
				generateFrontendAuthorizationComponents(appFolderPath + entity, entityPath, authenticationInputMap, root);
			}
		}

	}

	public void generateFrontendAuthorizationComponents(String destination, String templatePath, Map<String,String> authenticationInputMap, Map<String,Object> root) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if(outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole"))
				{
					outputFileName = outputFileName.replace("user", codeGeneratorUtils.camelCaseToKebabCase(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)));
				}

				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA).toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA).toLowerCase()+"role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}
		}

		if(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA) != null) {
			root.put("moduleName", codeGeneratorUtils.camelCaseToKebabCase(authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA)));
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
	
	public void generateSilentRefreshFile(String destination){
		
		Map<String, Object> template = new HashMap<>();
		template.put("silent-refresh.html.ftl", "silent-refresh.html");
		new File(destination).mkdirs();
		codeGeneratorUtils.generateFiles(template, null, destination, FRONTEND_AUTHORIZATION_TEMPLATE_FOLDER);

	}

}
