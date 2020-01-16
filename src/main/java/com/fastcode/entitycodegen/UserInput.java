package com.fastcode.entitycodegen;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.common.base.CaseFormat;

@Component
public class UserInput {
	
	@Autowired
	EntityDetails entityDetails;
	
	String packageName;
	String groupArtifactId;
	String generationType;
	String destinationPath;
	String schemaName;
	String connectionStr;
	List<String> tablesList;
	Boolean cache=false;
	String authenticationType=null;
	String authenticationSchema=null;
	Boolean doUpgrade=false;

	public Boolean getCache() {
		return cache;
	}
	public void setCache(Boolean cache) {
		this.cache = cache;
	}
	public String getAuthenticationSchema() {
		return authenticationSchema;
	}
	public void setAuthenticationSchema(String authenticationSchema) {
		this.authenticationSchema = authenticationSchema;
	}
	public String getGroupArtifactId() {
		return groupArtifactId;
	}
	public void setGroupArtifactId(String groupArtifactId) {
		this.groupArtifactId = groupArtifactId;
	}
	public String getGenerationType() {
		return generationType;
	}
	public void setGenerationType(String generationType) {
		this.generationType = generationType;
	}
	
	public String getPackageName() {
		return packageName;
	}
	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}
	public String getDestinationPath() {
		return destinationPath;
	}
	public void setDestinationPath(String destinationPath) {
		this.destinationPath = destinationPath;
	}
	public String getSchemaName() {
		return schemaName;
	}
	public void setSchemaName(String schemaName) {
		this.schemaName = schemaName;
	}
	public String getConnectionStr() {
		return connectionStr;
	}
	public void setConnectionStr(String connectionStr) {
		this.connectionStr = connectionStr;
	}

	public List<String> getTablesList() {
		return tablesList;
	}
	public void setTablesList(List<String> tablesList) {
		this.tablesList = tablesList;
	}
	public String getAuthenticationType() {
		return authenticationType;
	}
	public void setAuthenticationType(String authenticationType) {
		this.authenticationType = authenticationType;
	}
	public Boolean getUpgrade() { return doUpgrade; }
	public void setUpgrade(Boolean doUpgrade) { this.doUpgrade = doUpgrade; }
	
	public String getInput(Scanner inputReader, String inputType) {

		System.out.print("Please enter value for " + inputType + ":");
		String value = inputReader.nextLine();
		return value;
	}
	
	public List<FieldDetails> getFilteredFieldsList(List<FieldDetails> fields)
	{
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (FieldDetails f : fields) {
			if (f.fieldType.equalsIgnoreCase("long") || f.fieldType.equalsIgnoreCase("integer") || f.fieldType.equalsIgnoreCase("double")
					|| f.fieldType.equalsIgnoreCase("short") || f.fieldType.equalsIgnoreCase("string") || f.fieldType.equalsIgnoreCase("boolean")
					|| f.fieldType.equalsIgnoreCase("timestamp") || f.fieldType.equalsIgnoreCase("date"))
				fieldsList.add(f);
		}
		return fieldsList;
	}
	
	public int getFieldsInput(int size)
	{
		System.out.print("\nPlease enter value between (1-" +size+ ") :");
		Scanner scanner = new Scanner(System.in);
		int index = scanner.nextInt();
		while (index < 1 || index > size) {
			System.out.println("\nInvalid Input \nEnter again :");
			index = scanner.nextInt();
		}
		return index;
	}
	
	public FieldDetails getEntityDescriptionField(String entityName, List<FieldDetails> fields) {
		int index = 1;
		StringBuilder builder = new StringBuilder(MessageFormat.format(
				"\nSelect a descriptive field of {0} entity by typing their corresponding number: ", entityName));

		List<FieldDetails> fieldsList = getFilteredFieldsList(fields);
		
		for (FieldDetails f : fieldsList) {
			builder.append(MessageFormat.format("{0}.{1} ", index, f.getFieldName()));
			index++;
		}
		System.out.println(builder.toString());
		index= getFieldsInput(fieldsList.size());

		FieldDetails selected = fieldsList.get(index - 1);
		return selected;
	}
	
	public UserInput composeInput(Map<String, String> root) {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);
		//System.out.println(" v " + root.get("c") + "\n ss " + root.get("s"));
		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode
		// /Users/getachew/fc/exer/root
		input.setUpgrade(root.get("upgrade") == null
				? false: (root.get("upgrade").toLowerCase().equals("true") ? true : false));
		input.setConnectionStr(root.get("conn") != null ? root.get("conn")
				: (getInput(scanner, "DB Connection String")));
		//input.setConnectionStr("jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode");
		
		input.setSchemaName(root.get("s") == null ? getInput(scanner, "Db schema") : root.get("s"));
		input.setDestinationPath(
				root.get("d") == null ? getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? getInput(scanner, "groupArtifactId") : root.get("a"));

		while((input.getGroupArtifactId().split("\\.").length)<2)
		{
			System.out.println("Invalid input");
			input.setGroupArtifactId(getInput(scanner, "groupArtifactId"));
		}
		
		input.setGenerationType(
				root.get("t") == null ? getInput(scanner, "generation type") : root.get("t"));
		input.setCache(root.get("c") == null ? (getInput(scanner, "cache").toLowerCase().equals("true") ? true : false)
		       : (root.get("c").toLowerCase().equals("true") ? true : false));

		input= getAuthenticationInput(input,scanner);
		
		return input;
	}
	
	public UserInput getAuthenticationInput(UserInput input,Scanner scanner)
	{
		System.out.print("\nSelect Authentication and Authorization method :");
		System.out.print("\n1. none");
		System.out.print("\n2. database");
		System.out.print("\n3. ldap");
		System.out.print("\n4. oidc");
		System.out.print("\nEnter 1,2,3 or 4 : ");
		
		int value = scanner.nextInt();
		while (value < 1 || value > 4) {
			System.out.println("\nInvalid Input \nEnter again :");
			value = scanner.nextInt();
		}
		if (value == 1) {
			input.setAuthenticationType("none");
		} 
		else if (value>1) {
			scanner.nextLine();
			
			System.out.print("\nDo you have your own user table? (y/n)");
			String str= scanner.nextLine();
			if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes"))
			{
				System.out.print("\nEnter table name :");
				str= scanner.nextLine();
				if(str.contains("_"))
				{
					str=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, str);
				}
				input.setAuthenticationSchema(str.substring(0, 1).toUpperCase() + str.substring(1));
			}

			if (value == 2) {
				input.setAuthenticationType("database");
			}
			else if (value == 3) {
				input.setAuthenticationType("ldap");
			}
			else if (value == 4) {
				input.setAuthenticationType("oidc");
			}
		}
		
		return input;

	}
}

