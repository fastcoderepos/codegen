package com.nfinity.codegen;

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

@Component
public class FrontendBaseTemplateGenerator {
//	static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	static final String FRONTEND_BASE_TEMPLATE_FOLDER = "/templates/frontendBaseTemplate";

	@Autowired
	CodeGeneratorUtils codeGeneratorUtils;
	
	@Autowired
	CommandUtils commandUtils;
	
	@Autowired
	JSONUtils jsonUtils;

	public void generate(String destination, String appName, String authenticationType, String authenticationTable) {

		String clientSubfolder = appName + "Client";
		String command = "ng new " + clientSubfolder + " --skipInstall=true";
		commandUtils.runProcess(command, destination);
	//	editTsConfigJsonFile(destination + "/" + clientSubfolder + "/tsconfig.json");
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

//	public File[] getNestedFolders(String folderPath) {
//		File dir = new File(folderPath);
//		File[] files = dir.listFiles();
//
//		ArrayList<File> folderList = new ArrayList<File>();
//
//		for (File file : files) {
//			if (file.isDirectory()) {
//				folderList.add(file);
//			}
//		}
//
//		File[] folderArray = new File[folderList.size()];
//		folderArray = folderList.toArray(folderArray);
//		return folderArray;
//	}

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

			JSONObject input = new JSONObject();
			input.put("input", "src/styles/lightgreen-amber.scss");

			styles.add(input);
			styles.add("src/styles/styles.scss");

			projects.put("fastCodeCore",getFastCodeCoreProjectNode());
			String prettyJsonString = jsonUtils.beautifyJson(jsonObject, "Object"); 
			jsonUtils.writeJsonToFile(path,prettyJsonString);


		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
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

//	public void editTsConfigJsonFile(String path) {
//
//		try {
//			JSONObject jsonObject = (JSONObject) jsonUtils.readJsonFile(path);
//			JSONObject compilerOptions = (JSONObject) jsonObject.get("compilerOptions");
//
//			JSONArray fccore = new JSONArray();
//			fccore.add("dist/fast-code-core");
//			JSONArray fccore1 = new JSONArray();
//			fccore1.add("dist/fast-code-core/*");
//
//
//			JSONObject paths = new JSONObject();
//			paths.put("fastCodeCore",fccore);
//			paths.put("fastCodeCore/*",fccore1);
//
//			compilerOptions.put("paths",paths);
//			compilerOptions.put("resolveJsonModule",true);
//			compilerOptions.put("esModuleInterop",true);
//			compilerOptions.put("allowSyntheticDefaultImports",true);
//
//
//			String prettyJsonString = jsonUtils.beautifyJson(jsonObject,"Object"); 
//			jsonUtils.writeJsonToFile(path,prettyJsonString);
//
//		} catch (FileNotFoundException e) {
//			e.printStackTrace();
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (ParseException e) {
//			e.printStackTrace();
//		}
//
//	}

//	public JSONObject readJsonFile(String path) throws IOException, ParseException {
//
//		JSONParser parser = new JSONParser();
//		FileReader fr = new FileReader(path);
//		Object obj = parser.parse(fr);
//		fr.close();
//		return (JSONObject) obj;
//	}
//
//	public String beautifyJson(JSONObject jsonObject)  {
//		Gson gson = new GsonBuilder().setPrettyPrinting().create();
//		JsonParser jp = new JsonParser();
//		JsonElement je = jp.parse(jsonObject.toJSONString());
//		return gson.toJson(je);
//	}
//
//	public void writeJsonToFile(String path, String jsonString) throws IOException {
//		FileWriter file = new FileWriter(path);
//		file.write(jsonString);
//		file.close();
//	}
}


