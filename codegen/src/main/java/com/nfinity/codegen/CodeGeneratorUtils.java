package com.nfinity.codegen;

import java.io.File;
import java.io.PrintWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nfinity.BeanConfig;

import freemarker.template.Configuration;
import freemarker.template.Template;
import net.minidev.json.writer.BeansMapper.Bean;

@Component
public class CodeGeneratorUtils {
	
	@Autowired 
	FolderContentReader folderContentReader= BeanConfig.getFolderContentReaderBean();

	@Autowired
	FreeMarkerConfiguration freeMarkerConfiguration = BeanConfig.getFreeMarkerConfigBean();
	
	public URL toURL(File file) {
		try {
			return file.toURI().toURL();
		} catch (MalformedURLException e) {
			throw new InternalError(e);
		}
	}

	public List<String> readFilesFromDirectory(String path)
	{
		List<String> filesList = folderContentReader.getFilesFromFolder(path);
		return filesList;
	}

	public List<String> replaceFileNames(List<String> filesList, String path)
	{
		List<String> updatedList = new ArrayList<String>();
		for (String filePath : filesList) {
			String p = filePath.replace("BOOT-INF/classes" + path,"");
			p = p.replace("\\", "/");
			p = p.replace(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources" + path,"");
			
			updatedList.add(p);
		}

		return updatedList;
	}

	//Convert String from camelCase to kebab-case
	public String camelCaseToKebabCase(String name)
	{
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(name);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);

		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		return StringUtils.join(splittedNames, "-");
	}

	public void generateFiles(Map<String, Object> templateFiles, Map<String, Object> root, String destPath, String templateFolderPath) {
		Configuration cfg = freeMarkerConfiguration.configure(templateFolderPath);

		for (Map.Entry<String, Object> entry : templateFiles.entrySet()) {
			try {
				Template template = cfg.getTemplate(entry.getKey());

				String entryPath = entry.getValue().toString();
				File fileName = new File(destPath + "/" + entry.getValue().toString());

				String dirPath = destPath;
				if(destPath.split("/").length > 1 && entryPath.split("/").length > 1) {
					dirPath = dirPath + entryPath.substring(0, entryPath.lastIndexOf('/'));
				}
				File dir = new File(dirPath);
				if(!dir.exists()) {
					dir.mkdirs();
				};
				System.out.println("file name " +fileName);
				PrintWriter writer = new PrintWriter(fileName);
				template.process(root, writer);
				writer.flush();
				writer.close();

			} catch (Exception e1) {
				e1.printStackTrace();

			}
		}
	}
}