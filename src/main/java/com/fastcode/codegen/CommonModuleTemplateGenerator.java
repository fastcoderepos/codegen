package com.fastcode.codegen;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class CommonModuleTemplateGenerator {

	private static final String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates/commonModuleTemplates/commonmodule";
	private static final String BACKEND_TEST_TEMPLATE_FOLDER = "/templates/backendTemplates/commonModuleTestTemplates/commonmodule";
	
	@Autowired
	private CodeGeneratorUtils generatorUtils;
	
	public void generateCommonModuleClasses(String destination, String packageName) {

		String backendAppFolder = destination + "/src/main/java/" + packageName.replace(".", "/") + "/commonmodule";
		String backendTestAppFolder = destination + "/src/test/java/" + packageName.replace(".", "/") + "/commonmodule";
		
		Map<String, Object> root = new HashMap<>();
		packageName = packageName.concat(".commonmodule");
		root.put("PackageName", packageName);
		generatorUtils.generateFiles(getTemplates(BACKEND_TEMPLATE_FOLDER), root, backendAppFolder, BACKEND_TEMPLATE_FOLDER);
		generatorUtils.generateFiles(getTemplates(BACKEND_TEST_TEMPLATE_FOLDER), root, backendTestAppFolder, BACKEND_TEST_TEMPLATE_FOLDER);

	}
	
	public Map<String, Object> getTemplates(String path) {
		List<String> filesList = generatorUtils.readFilesFromDirectory(path);
		filesList = generatorUtils.replaceFileNames(filesList, path);
		Map<String, Object> templates = new HashMap<>();
		
		for (String filePath : filesList) {
			templates.put(filePath, filePath.substring(0, filePath.lastIndexOf('.')));
		}
		
		return templates;
	}

}
