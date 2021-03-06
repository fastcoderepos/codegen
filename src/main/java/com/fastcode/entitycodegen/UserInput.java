package com.fastcode.entitycodegen;

import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.apache.openjpa.lib.util.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.google.common.base.CaseFormat;

@Component
public class UserInput {

	@Autowired
	EntityDetails entityDetails;

	@Autowired
	EntityGeneratorUtils entityGeneratorUtils;

	String packageName;
	String groupArtifactId;
	String destinationPath;
	String schemaName;
	String connectionStr;
	List<String> tablesList;
	Boolean cache=false;
	Boolean doUpgrade=false;
	Boolean usersOnly = false;
	String logonName;
	AuthenticationInfo authenticationInfo = new AuthenticationInfo();

	public AuthenticationInfo getAuthenticationInfo() {
		return authenticationInfo;
	}
	public void setAuthenticationInfo(AuthenticationInfo authenticationInfo) {
		this.authenticationInfo = authenticationInfo;
	}
	public String getLogonName() {
		return logonName;
	}
	public void setLogonName(String logonName) {
		this.logonName = logonName;
	}
	public Boolean getUsersOnly() {
		return usersOnly;
	}
	public void setUsersOnly(Boolean usersOnly) {
		this.usersOnly = usersOnly; 
	}
	public Boolean getCache() {
		return cache;
	}
	public void setCache(Boolean cache) {
		this.cache = cache;
	}
	public String getGroupArtifactId() {
		return groupArtifactId;
	}
	public void setGroupArtifactId(String groupArtifactId) {
		this.groupArtifactId = groupArtifactId;
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
	public Boolean getUpgrade() { return doUpgrade; }
	public void setUpgrade(Boolean doUpgrade) { this.doUpgrade = doUpgrade; }

	public String getInput(Scanner inputReader, String inputType) {

		System.out.print("\nPlease enter value for " + inputType + ":");
		String value = inputReader.nextLine();
		return value;
	}

	public List<FieldDetails> getFilteredFieldsList(List<FieldDetails> fields)
	{
		String[] types = {"long", "short", "integer", "double", "string", "timestamp", "boolean", "date" };
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (FieldDetails f : fields) {
			if(Arrays.stream(types).anyMatch(f.getFieldType()::equalsIgnoreCase))
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
		
		while(!selected.getFieldType().equalsIgnoreCase("String") || selected.getIsNullable())
		{
			System.out.println("Please choose valid required String field");
			index= getFieldsInput(fieldsList.size());
			selected=fieldsList.get(index - 1);
		}
		return selected;
	}

	public UserInput composeInput(Map<String, String> root) {
		UserInput input = new UserInput();
		Scanner scanner = new Scanner(System.in);

		// jdbc:postgresql://localhost:5432/FCV2Db?username=postgres;password=fastcode
		// jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode
		input.setUpgrade(root.get("upgrade") == null  
				? false: (root.get("upgrade").toLowerCase().equals("true") ? true : false));
		input.setConnectionStr(root.get("conn") != null ? root.get("conn") : null);
		input = validateConnectionStringAndSetSchema(input, root.get("s"), scanner);
		input.setDestinationPath(
				root.get("d") == null ? getInput(scanner, "destination folder") : root.get("d"));
		input.setGroupArtifactId(
				root.get("a") == null ? getInput(scanner, "groupArtifactId") : root.get("a"));

		while((input.getGroupArtifactId().split("\\.").length)<2)
		{
			System.out.println("Invalid input");
			input.setGroupArtifactId(getInput(scanner, "groupArtifactId"));
		}

		input.setCache(root.get("c") == null ? (getInput(scanner, "cache").toLowerCase().equals("true") ? true : false)
				: (root.get("c").toLowerCase().equals("true") ? true : false));

		input= getAuthenticationInput(input,scanner);

		return input;
	}

	public UserInput validateConnectionStringAndSetSchema(UserInput input, String schemaName,Scanner scanner)
	{
		if(input.getConnectionStr() == null)
		{
			System.out.print("\nDo you want to use sample schema for code generation ? (y/n) ");
			String sampleSchemaOption = scanner.nextLine();

			if(sampleSchemaOption.equalsIgnoreCase("y") || sampleSchemaOption.equalsIgnoreCase("yes"))
			{
				input.setConnectionStr("jdbc:h2:mem:testdb?username=sa;password=sa");
				input.setSchemaName("sample");
			}
			else
			{
				input.setConnectionStr(getInput(scanner, "DB Connection String"));
				input.setSchemaName(schemaName == null ? getInput(scanner, "Db schema") : schemaName);
			}
		}
		else
			input.setSchemaName(schemaName == null ? getInput(scanner, "Db schema") : schemaName);

		while(entityGeneratorUtils.parseConnectionString(input.getConnectionStr())==null)
		{
			System.out.println("Invalid Connection String");
			input.setConnectionStr(getInput(scanner, "Connection String"));
		}

		return input;
	}

	public UserInput getAuthenticationInput(UserInput input,Scanner scanner)
	{
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
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
			authenticationInfo.setAuthenticationType(AuthenticationType.NONE);
			authenticationInfo.setUserOnly(false);
		} 
		else {
			scanner.nextLine();
			authenticationInfo.setAuthenticationType(value == 2 ? AuthenticationType.DATABASE : value == 3 ? AuthenticationType.LDAP : AuthenticationType.OIDC);

			if (value == 3 || value == 4) {

				System.out.print("\nWhich one of the following do you store in " + authenticationInfo.getAuthenticationType() + " for your application?");
				System.out.print("\n1. User Information");
				System.out.print("\n2. User and Group Information");
				System.out.print("\nEnter 1 or 2 : ");
				int choice = scanner.nextInt();
				while (choice < 1 || choice > 2) {
					System.out.println("\nInvalid Input \nEnter again :");
					choice = scanner.nextInt(); 
				}

				authenticationInfo.setUserOnly(choice == 1 ? true : false);

				scanner.nextLine();
				if(value == 3 && choice == 2)
				{
					System.out.print("\nWhat is the User Logon Name you are using? ");
					String logonName = scanner.nextLine();
					authenticationInfo.setLogonName(logonName);
				}
			}
			else {
				authenticationInfo.setUserOnly(false);
			}

			System.out.print("\nDo you have a User table in your data model? (y/n)");
			String str= scanner.nextLine();
			if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes"))
			{
				System.out.print("\nEnter table name :");
				str= scanner.nextLine();
				str = str.contains("_") ? CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, str) : str;
				authenticationInfo.setAuthenticationTable(str.substring(0, 1).toUpperCase() + str.substring(1));
			}

		}
		input.setAuthenticationInfo(authenticationInfo);
		return input;
	}
}

