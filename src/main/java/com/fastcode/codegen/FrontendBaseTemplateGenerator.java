package com.fastcode.codegen;

import java.io.FileNotFoundException;
import java.io.IOException;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;

@Component
public class FrontendBaseTemplateGenerator {

	private static final String FRONTEND_BASE_TEMPLATE_FOLDER = "/templates/frontendBaseTemplate";

	@Autowired
	private CodeGeneratorUtils codeGeneratorUtils;
	
	@Autowired
	private CommandUtils commandUtils;
	
	@Autowired
	private JSONUtils jsonUtils;
	
	@Autowired
	private LoggingHelper logHelper;

	public void generate(String destination, String appName, String authenticationType, String authenticationTable) {

		String clientSubfolder = appName + "Client";
		String command = "ng new " + clientSubfolder + " --skipInstall=true";
		commandUtils.runProcess(command, destination);
		editAngularJsonFile(destination + "/" + clientSubfolder + "/angular.json", clientSubfolder);

		Map<String, Object> root = buildRootMap(appName, authenticationType, authenticationTable);
		codeGeneratorUtils.generateFiles(getTemplates(FRONTEND_BASE_TEMPLATE_FOLDER),root, destination + "/"+ clientSubfolder,FRONTEND_BASE_TEMPLATE_FOLDER);
		
	}
	
	public Map<String, Object> buildRootMap(String appName, String authenticationType, String authenticationTable)
	{
		Map<String, Object> root = new HashMap<>();
		root.put("AppName", appName);
		root.put("AuthenticationType",authenticationType);
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

}

