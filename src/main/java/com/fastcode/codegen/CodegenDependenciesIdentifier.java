package com.fastcode.codegen;

import java.util.Scanner;

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
		String regex = "(?!\\.)(\\d+(\\.\\d+)+)(?:[-.][A-Z]+)?(?![\\d.])$";

		result =result.replaceAll(regex, "$1");
		result = result.replaceAll("[^\\d.]", "");
		System.out.println(" Spring VERSION  " + result);

		if(result == "") {
			logHelper.getLogger().error("SpringCli is not found on your computer.");
			return false;
		}

		if(versionCompare(result, SPRING_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Spring Cli "+ SPRING_VERSION);
			return false;
		}

		return true;
	}

	public boolean isMavenInstalled() {
		command = "mvn --version";

		String result = commandUtils.runProcess(command,destinationPath);
		String arr[] = result.split("\\(");
		result = arr[0].replaceAll("[^\\d.]", "");
		System.out.println(" Maven VERSION  " + result);

		if(result == "") {
			logHelper.getLogger().error("Maven is not found on your computer.");
			return false;
		}

		if(versionCompare(result, MAVEN_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Maven "+ MAVEN_VERSION);
			return false;
		}

		return true;
	}

	public boolean isJavaInstalled() {
		String result =System.getProperty("java.specification.version");
		System.out.println(" JAVA VERSION  " + result);
		if(versionCompare(result, JAVA_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of JAVA "+ JAVA_VERSION);
			return false;
		}

		return true;
	}
	
	public boolean isNodeInstalled() {
		command = "node --version";

		String result = commandUtils.runProcess(command,destinationPath);
		result = result.replaceAll("[^\\d.]", "");
		System.out.println(" Node VERSION  " + result);

		if(result == "") {
			logHelper.getLogger().error("Node is not found on your computer.");
			return false;
		}

		if(versionCompare(result, NODE_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Node "+ NODE_VERSION);
			return false;
		}

		return true;
	}
	
	public boolean isPsqlInstalled() {
		command = "psql --version";

		String result = commandUtils.runProcess(command,destinationPath);
		result = result.replaceAll("[^\\d.]", "");
		System.out.println(" PSQL VERSION  " + result);

		if(result == "") {
			logHelper.getLogger().error("PSQL is not found on your computer.");
			return false;
		}

		if(versionCompare(result, PSQL_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of PSQL "+ PSQL_VERSION);
			return false;
		}

		return true;
	}

	public boolean isAngularInstalled() {
		command = "ng --version";

		String result = commandUtils.runProcess(command,destinationPath);
		String arr[] = result.split("\\:");
		result = arr[1].replaceAll("[^\\d.]", "");
		System.out.println(" Angular VERSION " + result);
		if(result == "") {
			logHelper.getLogger().error("Angular is not found on your computer.");
			return false;
		}

		if(versionCompare(result, ANGULAR_VERSION)== -1)
		{
			logHelper.getLogger().error("Update to the minimum required version of Angular Cli "+ ANGULAR_VERSION);
			return false;
		}

		return true;
	}
	public int versionCompare(String str1, String str2) {
		try (Scanner s1 = new Scanner(str1);
				Scanner s2 = new Scanner(str2);) {
			s1.useDelimiter("\\.");
			s2.useDelimiter("\\.");

			while (s1.hasNextInt() && s2.hasNextInt()) {
				int v1 = s1.nextInt();
				int v2 = s2.nextInt();
				if (v1 < v2) {
					return -1;
				} else if (v1 > v2) {
					return 1;
				}
			}

			if (s1.hasNextInt() && s1.nextInt() != 0)
				return 1; //str1 has an additional lower-level version number
			if (s2.hasNextInt() && s2.nextInt() != 0)
				return -1; //str2 has an additional lower-level version

			return 0;
		} // end of try-with-resources
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
