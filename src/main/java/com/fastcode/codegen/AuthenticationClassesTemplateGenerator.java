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

		String authSchema = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA);
		String authType = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE);
		Boolean usersOnly = authenticationInputMap.get(AuthenticationConstants.USERS_ONLY) == "true"; 

		Map<String, Object> templates = new HashMap<String, Object>();
		Map<String, Object> testTemplates = new HashMap<String, Object>();

		if(authType.equals("database") || (!authType.equals("database") && usersOnly))
		{
			templates=getBackendAuthorizationFiles(AUTHORIZATION_TEMPLATE_FOLDER, authSchema, authType);
			testTemplates=getBackendAuthorizationTestFiles(AUTHORIZATION_TEST_TEMPLATE_FOLDER,authSchema);

		}
		else
		{
			templates = getAuthenticationTemplatesForUserGroupCase(AUTHORIZATION_TEMPLATE_FOLDER, authType);
			testTemplates = getAuthenticationTemplatesForUserGroupCase(AUTHORIZATION_TEST_TEMPLATE_FOLDER, authType);
		}

		codeGeneratorUtils.generateFiles(templates, root, backendAppFolder,AUTHORIZATION_TEMPLATE_FOLDER);
		codeGeneratorUtils.generateFiles(testTemplates, root, backendTestFolder,AUTHORIZATION_TEST_TEMPLATE_FOLDER);
	}

	public Map<String,Object> buildBackendRootMap(String packageName,String schemaName,Map<String, String> authenticationInputMap,Map<String,EntityDetails> details, Boolean cache)
	{
		String authSchema = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA);

		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("Cache", cache);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("UsersOnly",authenticationInputMap.get(AuthenticationConstants.USERS_ONLY));
		root.put("AuthenticationType",authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE));
		root.put("SchemaName",schemaName);
		if(authSchema !=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authSchema);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");
		}

		EntityDetails entityDetails = details.get(authSchema);
		if(entityDetails!=null)
		{
			root.put("ClassName",authSchema);
			root.put("CompositeKeyClasses",entityDetails.getCompositeKeyClasses());
			root.put("Fields", entityDetails.getFieldsMap());
			root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
			root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
			root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		}

		return root;
	}

	public Map<String, Object> getAuthenticationTemplatesForUserGroupCase(String templatePath, String authenticationType) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			Boolean includeTemplates = (outputFileName.contains("UserDetailsServiceImpl") && authenticationType.equals("database")) || outputFileName.contains("LoginUser");
			if(!(outputFileName.toLowerCase().contains("user") && !includeTemplates))
			{ 	
				if(!(outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc")))
				{
					templates.put(filePath, outputFileName);
				}
			}
		}

		return templates;
	}

	public Map<String, Object> getBackendAuthorizationFiles(String templatePath, String authTable, String authType) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(authTable==null)
			{
				if(shouldIncludeTemplatesIfDefaultUser(outputFileName, authType))
				{
					templates.put(filePath, outputFileName);
				}
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authTable);
					outputFileName = outputFileName.replace("user", authTable.toLowerCase());
				}

				//				if(!(outputFileName.toLowerCase().contains("user") && !((outputFileName.contains("UserDetailsServiceImpl") && authenticationType == "database") || outputFileName.contains("LoginUser") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				//				{ 	
				//					if(!outputFileName.contains("GetUser") && !(outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc"))  )
				//					{
				if(shouldIncludeTemplatesIfCustomUser(outputFileName, authType, authTable))
				{
					if(outputFileName.contains("GetCU"))
					{
						outputFileName = outputFileName.replace("CU", authTable);
					}

					templates.put(filePath, outputFileName);
				}

				//				}
			}
		}

		return templates;
	}
	public Boolean shouldIncludeTemplatesIfDefaultUser(String outputFileName, String authType)
	{
		//!outputFileName.contains("GetCU") && !((outputFileName.contains("JWTAuthentication") && authType.equals("oidc")) || (outputFileName.contains("UserDetailsServiceImpl") && !authType.equals("database"))))
		Boolean isUserRelationDto = outputFileName.contains("GetCU");
//		Boolean isRequiredFile = outputFileName.contains("LoginUser") || outputFileName.toLowerCase().contains(authTable.toLowerCase().concat("permission")) || outputFileName.toLowerCase().contains(authTable.toLowerCase().concat("role"));
		Boolean isDatabaseUserImplClass = outputFileName.contains("UserDetailsServiceImpl") && !authType.equals("database");
		Boolean excludeFileIfOidc = outputFileName.contains("JWTAuthentication") && authType.equals("oidc");
		
		return !isUserRelationDto && !(excludeFileIfOidc || isDatabaseUserImplClass);
	   
	}
	public Boolean shouldIncludeTemplatesIfCustomUser(String outputFileName, String authType, String authTable)
	{
		Boolean isUserFile = outputFileName.toLowerCase().contains("user");
		Boolean isUserRelationDto = outputFileName.contains("GetUser");
		Boolean isRequiredFile = outputFileName.contains("LoginUser") || outputFileName.toLowerCase().contains(authTable.toLowerCase().concat("permission")) || outputFileName.toLowerCase().contains(authTable.toLowerCase().concat("role"));
		Boolean isDatabaseUserImplClass = outputFileName.contains("UserDetailsServiceImpl") && authType.equals("database");
		Boolean excludeFileIfOidc = outputFileName.contains("JWTAuthentication") && authType.equals("oidc");
	   
		//	if(!outputFileName.contains("GetUser") && !(outputFileName.contains("JWTAuthentication") && authenticationType.equals("oidc"))  )
		//			{
		Boolean excludeUserFiles = isUserFile && !(isDatabaseUserImplClass || isRequiredFile);

		return !excludeUserFiles || (!isUserRelationDto && !excludeFileIfOidc);
		//return true;
	}

	public Map<String, Object> getBackendAuthorizationTestFiles(String templatePath, String authTable) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			if(authTable==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authTable);
					outputFileName = outputFileName.replace("user", authTable.toLowerCase());
				}
                String fName = outputFileName.toLowerCase();
				if( !fName.contains("user") && (fName.contains(authTable.toLowerCase().concat("permission")) 
						|| fName.contains(authTable.toLowerCase().concat("role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}
		}

		return templates;
	}

	public void generateFrontendAuthorization(String destPath, String packageName, Map<String,String> authenticationInputMap, Map<String, Object> root) {

		String customUser = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA);
		String authType = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_TYPE);
		Boolean usersOnly = authenticationInputMap.get(AuthenticationConstants.USERS_ONLY).equals("true");

		root.put("ExcludeRoleNew", !authType.equals("database") && !usersOnly);
		root.put("ExcludeUserNew", !authType.equals("database"));

		String appName =packageName.substring(packageName.lastIndexOf(".") + 1);
		String appFolderPath = destPath + "/" + appName + "Client/src/app/";
	
		List<String> authorizationEntities = getAuthorizatonEntities(destPath, appName, authType, usersOnly);
		
		for(String entity: authorizationEntities) {
			String entityPath = FRONTEND_AUTHORIZATION_TEMPLATE_FOLDER + "/" + entity;
			if(entity.equals("userpermission") && customUser != null ) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(customUser) + "permission", entityPath, authenticationInputMap, root);
			}
			else if(entity.equals("userrole") && customUser != null ) {
				generateFrontendAuthorizationComponents(appFolderPath + codeGeneratorUtils.camelCaseToKebabCase(customUser) + "role", entityPath, authenticationInputMap, root);
			}
			else 
			{
				generateFrontendAuthorizationComponents(appFolderPath + entity, entityPath, authenticationInputMap, root);
			}
		}

	}

	public List<String> getAuthorizatonEntities(String destPath, String appName,String authType, Boolean usersOnly)
	{
		List<String> authorizationEntities = new ArrayList<String>();

		authorizationEntities.add("role");
		authorizationEntities.add("permission");
		authorizationEntities.add("rolepermission");

		if(authType.equals("oidc")) {
			authorizationEntities.add("callback");
			generateSilentRefreshFile(destPath + "/" + appName + "Client/src/assets/");
		}
		else {
			authorizationEntities.add("login");	
		}
		authorizationEntities.add("core");

		if(authType.equals("database") || (!authType.equals("database") && usersOnly) )
		{
			authorizationEntities.add("userpermission");
			authorizationEntities.add("userrole");
		}
		
		return authorizationEntities;
	}
	public void generateFrontendAuthorizationComponents(String destination, String templatePath, Map<String,String> authenticationInputMap, Map<String,Object> root) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);
		String customUser = authenticationInputMap.get(AuthenticationConstants.AUTHENTICATION_SCHEMA);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));
			if(shouldExcludeFrontendTemplate(outputFileName, authenticationInputMap)){		
				continue;
			}

			if(customUser != null && (outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
			{
				outputFileName = outputFileName.replace("user", codeGeneratorUtils.camelCaseToKebabCase( customUser ));
			}

			templates.put(filePath, outputFileName);
		}

		if(customUser != null) { 
			root.put("moduleName", codeGeneratorUtils.camelCaseToKebabCase(customUser));
		}
		else {
			root.put("moduleName", "user");
		}

		codeGeneratorUtils.generateFiles(templates, root, destination,templatePath);
	}

	public Boolean shouldExcludeFrontendTemplate(String outputFileName, Map<String,String> authenticationInputMap ) {
		String authType = authenticationInputMap.get("authenticationType");
		Boolean usersOnly = authenticationInputMap.get("usersOnly") == "true";

		Boolean isUserNewFile = outputFileName.contains("user-new");
		Boolean isRoleNewFile = outputFileName.startsWith("/role-new");

		Boolean excludeRoleNew = !authType.equals("database") && !usersOnly && isRoleNewFile;
		Boolean excludeUserNew = !authType.equals("database") && isUserNewFile;

		return excludeRoleNew || excludeUserNew;
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
