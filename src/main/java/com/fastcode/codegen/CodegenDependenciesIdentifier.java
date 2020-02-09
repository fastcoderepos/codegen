package com.fastcode.codegen;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.logging.LoggingHelper;

@Component
public class CodegenDependenciesIdentifier {

	private static String SPRING_VERSION = "2.1.4";
	private static String MAVEN_VERSION = "3.5.4";
	private static String NODE_VERSION = "10.7.0";
	private static String PSQL_VERSION = "10.5"; 
	private static String ANGULAR_VERSION = "6.1.1";
	private static String JAVA_VERSION = "1.8";
	private static String destinationPath = null;
	private static String command = null;

	@Autowired
	private CommandUtils commandUtils;

	@Autowired
	private LoggingHelper logHelper;

	public void setDestinationPath(String path) {
		destinationPath = path;
	}

	public boolean isSpringCliInstalled() {
		command = "spring --version";

		String result = commandUtils.runProcess(command,destinationPath);
		
		if(result == "") { 
			logHelper.getLogger().error("SpringCli is not found on your computer.");
			return false;
		}
		
		String regex = "(?!\\.)(\\d+(\\.\\d+)+)(?:[-.][A-Z]+)?(?![\\d.])$";
		result =result.replaceAll(regex, "$1");
		result = result.replaceAll("[^\\d.]", "");
	
		if(commandUtils.versionCompare(result, SPRING_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Spring Cli "+ SPRING_VERSION);
			return false;
		}

		return true;
	}

	public boolean isMavenInstalled() {
		command = "mvn --version";

		String result = commandUtils.runProcess(command,destinationPath);
		
		if(result == "") {
			logHelper.getLogger().error("Maven is not found on your computer.");
			return false;
		}
		
		String arr[] = result.split("\\(");
		result = arr[0].replaceAll("[^\\d.]", "");

		if(commandUtils.versionCompare(result, MAVEN_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Maven "+ MAVEN_VERSION);
			return false;
		}

		return true;
	}

	public boolean isJavaInstalled() {
		String result =System.getProperty("java.specification.version");
		
		if(result == "") {
			logHelper.getLogger().error("Java is not found on your computer.");
			return false;
		}

		if(commandUtils.versionCompare(result, JAVA_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of JAVA "+ JAVA_VERSION);
			return false;
		}

		return true;
	}
	
	public boolean isNodeInstalled() {
		command = "node --version";

		String result = commandUtils.runProcess(command,destinationPath);
		
		if(result == "") {
			logHelper.getLogger().error("Node is not found on your computer.");
			return false;
		}
		result = result.replaceAll("[^\\d.]", "");
		
		if(commandUtils.versionCompare(result, NODE_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Node "+ NODE_VERSION);
			return false;
		}

		return true;
	}
	
	public boolean isPsqlInstalled() {
		command = "psql --version";

		String result = commandUtils.runProcess(command,destinationPath);
		
		if(result == "") {
			logHelper.getLogger().error("PSQL is not found on your computer.");
			return false;
		}
		result = result.replaceAll("[^\\d.]", "");
		
		if(commandUtils.versionCompare(result, PSQL_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of PSQL "+ PSQL_VERSION);
			return false;
		}

		return true;
	}

	public boolean isAngularInstalled() {
		command = "ng --version";

		String result = commandUtils.runProcess(command,destinationPath);
		
		if(result == "") {
			logHelper.getLogger().error("Angular is not found on your computer.");
			return false;
		}

		String arr[] = result.split("\\:");
		result = arr[1].replaceAll("[^\\d.]", "");
		
		if(commandUtils.versionCompare(result, ANGULAR_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Angular Cli "+ ANGULAR_VERSION);
			return false;
		}

		return true;
	}
	
	public boolean checkDependencies()
	{
		if(!isSpringCliInstalled() || !isMavenInstalled() || !isJavaInstalled() || !isNodeInstalled() || !isPsqlInstalled() || !isAngularInstalled())
		{
			return false;
		}
		
		return true;
	}

}
