package com.fastcode.codegen;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.io.FileUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.entitycodegen.AuthenticationInfo;
import com.fastcode.entitycodegen.AuthenticationType;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.logging.LoggingHelper;

@Component
public class FrontendBaseTemplateGenerator {

	private static final String FRONTEND_BASE_TEMPLATE_FOLDER = "/templates/frontendBaseTemplate";
	private static final String FRONTEND_ASSETS = "/src/main/resources/frontend_static/assets/";

	@Autowired
	private CodeGeneratorUtils codeGeneratorUtils;
	
	@Autowired
	private CommandUtils commandUtils;
	
	@Autowired
	private JSONUtils jsonUtils; 
	
	@Autowired
	private LoggingHelper logHelper;
	
	@Autowired
	FolderContentReader contentReader;

	public void generate(String destination, String appName, AuthenticationInfo authenticationInfo, Map<String, EntityDetails> entityDetails) {
 
		String clientSubfolder = appName + "Client";
		String command = "ng new " + clientSubfolder + " --skipInstall=true";
		commandUtils.runProcess(command, destination);
		editAngularJsonFile(destination + "/" + clientSubfolder + "/angular.json", clientSubfolder);
	//	contentReader.copyDirectoryFromJar("frontend_static/assets", destination + "/"+ clientSubfolder + "/src/assets");

		editTsConfigJsonFile(destination + "/" + clientSubfolder + "/tsconfig.json");
		Map<String, Object> root = buildRootMap(appName, authenticationInfo, entityDetails.keySet().stream().collect(Collectors.toList()));

		codeGeneratorUtils.generateFiles(getTemplates(FRONTEND_BASE_TEMPLATE_FOLDER),root, destination + "/"+ clientSubfolder,FRONTEND_BASE_TEMPLATE_FOLDER);
		copyAssets(destination + "/"+ clientSubfolder + "/src/assets");
	}
	
	public Map<String, Object> buildRootMap(String appName, AuthenticationInfo authenticationInfo, List<String> entityList)
	{
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		String customTable = authenticationInfo.getAuthenticationTable();
		Boolean userOnly = authenticationInfo.getUserOnly();
		
		Map<String, Object> root = new HashMap<>();
		root.put("AppName", appName);
		root.put("EntityNames", getEntityNamesList(entityList, authenticationInfo));
		root.put("AuthEntityList", getAuthEntitiesNamesList(authenticationInfo));
		root.put("EntityList", entityList);
		root.put("AuthenticationType", authType.getName());
		root.put("UserOnly", userOnly);
		root.put("ExcludeRoleNew", !authType.equals(AuthenticationType.DATABASE) && !userOnly);
		root.put("ExcludeUserNew", !authType.equals(AuthenticationType.DATABASE));
		
		if(customTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", customTable);
		}
		else {
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");
		}	
		
		return root;
	}
	
	public Map<String, String> getEntityNamesList(List<String> entityList, AuthenticationInfo authenticationInfo){

		String customUser = authenticationInfo.getAuthenticationTable();
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		
		Map<String, String> entityNamesList = new HashMap<String, String>();
		for(String entity: entityList) {
			String className = entity.substring(entity.lastIndexOf(".") + 1);
			if(!className.equalsIgnoreCase(customUser)) {
				entityNamesList.put(codeGeneratorUtils.camelCaseToKebabCase(className), className);
			}
		}
  
		if(!authType.equals(AuthenticationType.NONE)) {  
			List<String> authEntitiesList = getAuthEntitiesNamesList(authenticationInfo);
			for(String authEntity: authEntitiesList) {
				entityNamesList.put(codeGeneratorUtils.camelCaseToKebabCase(authEntity), authEntity);
			}
		} 
		
		
		return entityNamesList;
	}
	
	public List<String> getAuthEntitiesNamesList(AuthenticationInfo authenticationInfo){
		List<String> entityNamesList = new ArrayList<String>();
		
		String customUser = authenticationInfo.getAuthenticationTable();
		AuthenticationType authType = authenticationInfo.getAuthenticationType();
		Boolean userOnly = authenticationInfo.getUserOnly();

		if(!authType.equals(AuthenticationType.NONE)) {
			entityNamesList.add("Role");
			entityNamesList.add("Permission");
			entityNamesList.add("Rolepermission");
			if(customUser != null) {
				entityNamesList.add(customUser);
			}

			if(authType.equals(AuthenticationType.DATABASE) || (!authType.equals(AuthenticationType.DATABASE) && userOnly) )
			{
				if(customUser == null) {
					entityNamesList.add("User");
					entityNamesList.add("Userpermission");
					entityNamesList.add("Userrole");
				} else {
					entityNamesList.add(customUser + "permission");
					entityNamesList.add(customUser + "role");
				}
			}
		}
		
		
		return entityNamesList;
	}
	
	public Map<String, Object> getTemplates(String path) {   
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(path);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, path);
		Map<String, Object> templates = new HashMap<>();
		
		for (String filePath : filesList) {
			templates.put(filePath, filePath.substring(0, filePath.lastIndexOf('.')));
		}
		
		return templates;
	}

	public void editAngularJsonFile(String path, String clientSubfolder) {

		try {

			JSONObject jsonObject = (JSONObject) jsonUtils.readJsonFile(path);

			JSONObject projects = (JSONObject) jsonObject.get("projects");
			JSONObject project = (JSONObject) projects.get(clientSubfolder);
			JSONObject architect = (JSONObject) project.get("architect");
			
			JSONObject serve = (JSONObject) architect.get("serve");
			JSONObject serveOptions = (JSONObject) serve.get("options");
			serveOptions.put("proxyConfig", "proxy.conf.json");
		
			JSONObject build = (JSONObject) architect.get("build");
			JSONObject options = (JSONObject) build.get("options");
			JSONArray styles = (JSONArray) options.get("styles");
			JSONArray assets = (JSONArray) options.get("assets");
			styles.clear();

			styles.add("src/styles/styles.scss");

			projects.put("fastCodeCore",getFastCodeCoreProjectNode());
			String prettyJsonString = jsonUtils.beautifyJson(jsonObject, "Object"); 
			jsonUtils.writeJsonToFile(path,prettyJsonString);


		} catch (FileNotFoundException e) {
			logHelper.getLogger().error("FileNotFoundException Occured : ", e.getMessage());
		} catch (IOException e) {
			logHelper.getLogger().error("IOException Occured : ", e.getMessage());
		} catch (ParseException e) {
			logHelper.getLogger().error("ParseException : ", e.getMessage());
		}

	}

	public JSONObject getFastCodeCoreProjectNode() throws ParseException {
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
		
		
		return fccore;
	}
	
  public void editTsConfigJsonFile(String path) {

      try {
          JSONObject jsonObject = (JSONObject) jsonUtils.readJsonFile(path);
          JSONObject compilerOptions = (JSONObject) jsonObject.get("compilerOptions");

      //    compilerOptions.put("resolveJsonModule",true);
          compilerOptions.put("esModuleInterop",true);
          compilerOptions.put("allowSyntheticDefaultImports",true);

          String prettyJsonString = jsonUtils.beautifyJson(jsonObject,"Object"); 
          jsonUtils.writeJsonToFile(path,prettyJsonString);

      } catch (FileNotFoundException e) {
          e.printStackTrace();
      } catch (IOException e) {
          e.printStackTrace();
      } catch (ParseException e) {
          e.printStackTrace();
      }

  }

	private void copyAssets(String dest) {
		try {
			FileUtils.copyDirectory(new File(System.getProperty("user.dir").replace("\\", "/") + FRONTEND_ASSETS), new File(dest));
		} catch (IOException e) {
			logHelper.getLogger().error("FileNotFoundException Occured : ", e.getMessage());
		}
	}
}


