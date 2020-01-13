package com.nfinity.entitycodegen;

import java.io.File;
import java.text.MessageFormat;
import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.nfinity.BeanConfig;
import com.nfinity.codegen.CodeGeneratorUtils;

@Component
public class EntityGenerator {

	final static String TEMPLATE_FOLDER = "/templates";
	final static String ENTITIES_TEMPLATE_FOLDER = "/templates/backendTemplates/entities";
	
	@Autowired
	BaseAppGen baseAppGen;
	
	@Autowired
	ReverseMapping reverseMapping;
	
	@Autowired
	CodeGeneratorUtils codeGeneratorUtils;
	
	@Autowired
	EntityDetails entityDetails;
	
	@Autowired
	EntityGeneratorUtils entityGeneratorUtils;
	
	@Autowired
	UserInput userInput;
	
	@Autowired
	CGenClassLoader loader= BeanConfig.getCGenClassLoaderBean();

	public String buildTablesStringFromList(List<String> tableList, String schema)
	{
		String tables = "";
		if (tableList != null) {
			for (int i = 0; i < tableList.size(); i++) {
				if (!tableList.get(i).isEmpty()) {
					if (i < tableList.size() - 1)
						tables = tables + schema.concat("." + tableList.get(i) + ",");
					else
						tables = tables + schema.concat("." + tableList.get(i));
				}
			}
		}
		
		return tables;
	}
	
	public Map<String, EntityDetails> generateEntities(String connectionString, String schema,
			List<String> tableList, String packageName, String destination, String authenticationTable, String authenticationType) { 
		Map<String, String> connectionProps = entityGeneratorUtils.parseConnectionString(connectionString);
		String entityPackage = packageName + ".domain.model";
		final String tempPackageName = entityPackage.concat(".Temp");
		destination = destination.replace('\\', '/');
		final String destinationPath = destination.concat("/src/main/java");
		final String targetPath = destination.concat("/target/classes");
		String tables = buildTablesStringFromList(tableList,schema);
		
		if (!tables.isEmpty()) {
			reverseMapping.run(tempPackageName, destinationPath, tables, connectionProps);
		} else
			reverseMapping.run(tempPackageName, destinationPath, schema, connectionProps);
		try {
			Thread.sleep(280);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		try {
			baseAppGen.CompileApplication(destination);
			entityGeneratorUtils.deleteFile(destinationPath + "/orm.xml");
		} catch (Exception e) {
			System.out.println("Compilation Error");
			e.printStackTrace();
		}
		
		Map<String, EntityDetails> entityDetailsMap = processAndGenerateRelevantEntities(targetPath, tempPackageName, schema, packageName, destinationPath, authenticationType, authenticationTable);
		entityGeneratorUtils.deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		System.out.println(" exit ");

		return entityDetailsMap;
	}
	
	
	public Map<String, EntityDetails> processAndGenerateRelevantEntities(String targetPath, String tempPackageName,String schema,String packageName, String destinationPath, String authenticationType, String authenticationTable)
	{
		loader.setPath(targetPath);

		ArrayList<Class<?>> entityClasses;
		Map<String, EntityDetails> entityDetailsMap = new HashMap<>();
		Map<String,FieldDetails> descriptiveFieldEntities = new HashMap<>();
		List<String> compositePrimaryKeyEntities = new ArrayList<String>();
		try {
			entityClasses = loader.findClasses(tempPackageName);

			List<Class<?>> classList = entityGeneratorUtils.filterOnlyRelevantEntities(entityClasses);// classDetails.getClassesList();
			compositePrimaryKeyEntities=entityGeneratorUtils.findCompositePrimaryKeyClasses(entityClasses);			

			for (Class<?> currentClass : classList) {
				String entityName = currentClass.getName();
				String className = entityName.substring(entityName.lastIndexOf(".") + 1);
               
				// process each entities except many to many association entities
				if (!entityName.endsWith("Id")) {

					EntityDetails details = entityDetails.retreiveEntityFieldsAndRships(currentClass, entityName, classList);// GetEntityDetails.getDetails(currentClass,
					
					Map<String, RelationDetails> relationMap = details.getRelationsMap();
					details.setCompositeKeyClasses(compositePrimaryKeyEntities);
					details.setPrimaryKeys(entityGeneratorUtils.getPrimaryKeysFromMap(details.getFieldsMap()));
					relationMap = entityDetails.FindOneToManyJoinColFromChildEntity(relationMap, classList);
					relationMap = entityDetails.FindOneToOneJoinColFromChildEntity(relationMap, classList);
				
					//get descriptive fields
					details=setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities,relationMap,details, className);
					details.setRelationsMap(relationMap);
					if(className.concat("Id") != details.getIdClass()) {
						details=updateFieldsListInRelationMap(details);
						details.setPrimaryKeys(entityGeneratorUtils.getPrimaryKeysFromMap(details.getFieldsMap()));
					}
					
					entityDetailsMap.put(entityName.substring(entityName.lastIndexOf(".") + 1), details);
					Map<String, Object> root =buildRootMap(details,entityName, packageName, schema, authenticationTable, authenticationType);
					// Generate Entity based on template
					
					generateEntityAndIdClass(root, details, packageName, destinationPath,compositePrimaryKeyEntities);

				}
			}

			if(authenticationTable !=null  && authenticationType != "none")
			{
				entityDetailsMap=validateAuthenticationTable(entityDetailsMap, authenticationTable);
			}
			
			if(authenticationType !="none")
			{
				generateAutheticationEntities(entityDetailsMap, schema, packageName, destinationPath,authenticationTable,authenticationType);
			}

		} catch (ClassNotFoundException ex) {
			ex.printStackTrace();
		}

		return entityDetailsMap;
	}
	
	public Map<String,FieldDetails> findAndSetDescriptiveField(Map<String,FieldDetails> descriptiveFieldEntities, RelationDetails relationDetails) {
		FieldDetails descriptiveField = null;

		descriptiveField = userInput.getEntityDescriptionField(relationDetails.geteName(), relationDetails.getfDetails());
		descriptiveField.setDescription(relationDetails.geteName().concat("DescriptiveField"));
		descriptiveFieldEntities.put(relationDetails.geteName(),descriptiveField);

		return descriptiveFieldEntities;
	}
	
	public EntityDetails setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(Map<String,FieldDetails> descriptiveFieldEntities,Map<String, RelationDetails> relationMap,EntityDetails details,String className)
	{
		//Map<String,FieldDetails> descriptiveFieldEntities = new HashMap<>();
		
		// Get parent descrptive fields from user
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {

			if(entry.getValue().getRelation().equals("OneToOne") && !entry.getValue().getIsParent())
			{
                   
				if(identifyOneToOneRelationContainsPrimaryKeys(entry.getValue().getfDetails(),details.getPrimaryKeys(),entry.getValue().getJoinDetails())) {
					details.setIdClass(entry.getValue().geteName()+"Id");
				}
				
				//get and set descriptive field
				if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName()))){
					descriptiveFieldEntities = findAndSetDescriptiveField(descriptiveFieldEntities,entry.getValue());
				}
				
				//if child id class not exists update join columns
				if(className.concat("Id") != details.getIdClass()) {
					details=updateJoinColumnName(details,entry.getValue());
				}

			}
			else if(entry.getValue().getRelation().equals("ManyToOne"))
			{
				if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName()) || descriptiveFieldEntities.containsKey(entry.getValue().getcName())))
				{
					descriptiveFieldEntities = findAndSetDescriptiveField(descriptiveFieldEntities,entry.getValue());
				}
			}
		}

		details.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);
		return details;
	}

	public boolean identifyOneToOneRelationContainsPrimaryKeys(List<FieldDetails> fDetails, Map<String,String> primaryKeysMap,List<JoinDetails> joinDetailsList)
	{
		List<String> relationEntityPrimaryKeys = entityGeneratorUtils.getPrimaryKeysFromList(fDetails);
		List<String> entityPrimaryKeys = new ArrayList<String>();
		for(String key: primaryKeysMap.keySet()) {
			entityPrimaryKeys.add(key);
		}
		for(JoinDetails jDetails : joinDetailsList)
		{
			if(relationEntityPrimaryKeys.contains(jDetails.getReferenceColumn()) && entityPrimaryKeys.contains(jDetails.getReferenceColumn()))
			{
				return true;
			}
		}

		return false;
	}
	
	public EntityDetails updateFieldsListInRelationMap(EntityDetails entityDetails)
	{
		Map<String, RelationDetails> relationMap= entityDetails.getRelationsMap();
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) {

			if(entry.getValue().getRelation().equals("OneToOne") && entry.getValue().getIsParent())
			{
				for(JoinDetails jdetail : entry.getValue().getJoinDetails())
				{
					if(entry.getValue().getfDetails().size() >1)
					{
						for(FieldDetails fdetail : entry.getValue().getfDetails()) {
							if(fdetail.getFieldName().equalsIgnoreCase(jdetail.getJoinColumn()))
							{
								fdetail.setFieldName(jdetail.getReferenceColumn());
							}
						}
					}

				}
			}
		}

		return entityDetails;
	}

	public EntityDetails updateJoinColumnName(EntityDetails entityDetails, RelationDetails relationdetails)
	{
		Map<String, FieldDetails> fieldsMap= entityDetails.getFieldsMap();

		for(JoinDetails str : relationdetails.getJoinDetails())
		{
			if(fieldsMap.containsKey(str.getJoinColumn()) && !str.getJoinColumn().equalsIgnoreCase(str.getReferenceColumn()))
			{
				FieldDetails fieldDetails = fieldsMap.get(str.getJoinColumn());
				fieldDetails.setrelationFieldName(fieldDetails.getFieldName());
			//	fieldDetails.setFieldName(str.getReferenceColumn());
				fieldsMap.put(str.getJoinColumn(), fieldDetails);
			}

		}

		return entityDetails;
	}

	public Map<String,EntityDetails> validateAuthenticationTable(Map<String,EntityDetails> entityDetailsMap, String authenticationTable)
	{
		Boolean isTableExits=false;
		if(entityDetailsMap!=null)
		{
			if(entityDetailsMap.containsKey(authenticationTable)) {
				isTableExits=true;
			}
			if(!isTableExits)
			{
				System.out.println(" INVALID AUTHORIZATION SCHEMA ");
				System.exit(0);
			}

			return getAuthenticationTableFieldsMapping(entityDetailsMap, authenticationTable);
		}
		return entityDetailsMap;
	}
	
	
	public Map<String,FieldDetails> displayAuthFieldsAndGetMapping(Map<String,FieldDetails> authFields, List<FieldDetails> fieldsList)
	{
		for(Map.Entry<String,FieldDetails> authFieldsEntry: authFields.entrySet())
		{
			int index = 1;
			StringBuilder b = new StringBuilder();
			for (FieldDetails f : fieldsList) {
				b.append(MessageFormat.format("{0}.{1} ", index, f.getFieldName()));
				index++;
			}
			System.out.println("\n Select field you want to map on "+ authFieldsEntry.getKey()+" by typing its corresponding number : ");
			System.out.println(b.toString());
			index= userInput.getFieldsInput(fieldsList.size());
	
			FieldDetails selected=fieldsList.get(index - 1);
			while(!selected.getFieldType().equalsIgnoreCase("String"))
			{
				System.out.println("Please choose valid string field : ");
				index= userInput.getFieldsInput(fieldsList.size());
				selected=fieldsList.get(index - 1);
			}
			fieldsList.remove(index-1);
			authFields.replace(authFieldsEntry.getKey(), selected);
		}
		return authFields;
	}

	public List<FieldDetails> getFieldsList(EntityDetails details)
	{
		List<FieldDetails> fieldsList = new ArrayList<>();
		for(Map.Entry<String,FieldDetails> fieldsEntry: details.getFieldsMap().entrySet())
		{
			if (fieldsEntry.getValue().fieldType.equalsIgnoreCase("long") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("integer") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("double")
					|| fieldsEntry.getValue().fieldType.equalsIgnoreCase("short") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("string") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("boolean")
					|| fieldsEntry.getValue().fieldType.equalsIgnoreCase("timestamp") || fieldsEntry.getValue().fieldType.equalsIgnoreCase("date"))
				fieldsList.add(fieldsEntry.getValue());
		}
		
		return fieldsList;
	}

	public Map<String,EntityDetails> getAuthenticationTableFieldsMapping(Map<String,EntityDetails> entityDetails, String authenticationTable)
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
		authFields.put("Password", null);

		for(Map.Entry<String,EntityDetails> entry: entityDetails.entrySet())
		{
			if(entry.getKey().equals(authenticationTable))
			{
				List<FieldDetails> fieldsList = getFieldsList(entry.getValue());
				authFields= displayAuthFieldsAndGetMapping(authFields, fieldsList);
				entry.getValue().setAuthenticationFieldsMap(authFields);
			}
		}

		return entityDetails;
	}

	public void generateAutheticationEntities(Map<String,EntityDetails> entityDetails, String schemaName, String packageName,
			String destPath, String authenticationTable,String authenticationType) {
		Map<String, Object> root = new HashMap<>();
		root.put("PackageName", packageName);
		root.put("CommonModulePackage" , packageName.concat(".commonmodule"));
		root.put("AuthenticationType",authenticationType);
		root.put("SchemaName",schemaName);
		if(authenticationTable!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationTable);
		}
		else
		{
			root.put("UserInput",null);
			root.put("AuthenticationTable", "User");	
		}

		for(Map.Entry<String,EntityDetails> entry : entityDetails.entrySet())
		{
			String className=entry.getKey().substring(entry.getKey().lastIndexOf(".") + 1);
			if(className.equalsIgnoreCase(authenticationTable))
			{
				root.put("ClassName", className);
				root.put("IdClass", entry.getValue().getIdClass());
				root.put("TableName", entry.getValue().getEntityTableName());
				root.put("CompositeKeyClasses",entry.getValue().getCompositeKeyClasses());
				root.put("Fields", entry.getValue().getFieldsMap());
				root.put("AuthenticationFields", entry.getValue().getAuthenticationFieldsMap());
				root.put("PrimaryKeys", entry.getValue().getPrimaryKeys());
			}
		}

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		codeGeneratorUtils.generateFiles(getAuthenticationEntitiesTemplates(ENTITIES_TEMPLATE_FOLDER,authenticationType,authenticationTable), root, destinationFolder,ENTITIES_TEMPLATE_FOLDER);
	}
	
	public Map<String, Object> getAuthenticationEntitiesTemplates(String templatePath, String authenticationType, String authenticationTable) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);
		
		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(authenticationTable==null)
			{
				templates.put(filePath, outputFileName);
			}
			else
			{
				if((outputFileName.toLowerCase().contains("userpermission") || outputFileName.toLowerCase().contains("userrole")))
				{
					outputFileName = outputFileName.replace("User", authenticationTable);
					outputFileName = outputFileName.replace("user", authenticationTable.toLowerCase());
				}

				if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"permission") || outputFileName.toLowerCase().contains(authenticationTable.toLowerCase()+"role"))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}

		}

		return templates;
	}
	
	public Map<String, Object> buildRootMap(EntityDetails details,String entityName, String packageName, String schemaName, String authenticationTable,String authenticationType)
	{
		String className = entityName.substring(entityName.lastIndexOf(".") + 1);
		String entityClassName = className.concat("Entity");
		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityClassName);
		root.put("ClassName", className);
		root.put("PackageName", packageName);
		root.put("CommonModulePackage", packageName.concat(".commonmodule"));
		root.put("CompositeKeyClasses", details.getCompositeKeyClasses());
		root.put("TableName", details.getEntityTableName());
		root.put("SchemaName", schemaName);
		root.put("IdClass", details.getIdClass());
		root.put("AuthenticationType",authenticationType);
		if(authenticationTable !=null)
			root.put("AuthenticationTable", authenticationTable);
		else
			root.put("AuthenticationTable", "User");
		root.put("AuthenticationFields", details.getAuthenticationFieldsMap());

	//	Map<String, FieldDetails> actualFieldNames = details.getFieldsMap();
	//	Map<String, RelationDetails> relationMap = details.getRelationsMap();

		root.put("Fields", details.getFieldsMap());
		root.put("Relationship", details.getRelationsMap());
		root.put("PrimaryKeys", details.getPrimaryKeys());
		
		return root;
	}
	
	public void generateEntityAndIdClass(Map<String, Object> root, EntityDetails details, String packageName,
			String destPath, List<String> compositePrimaryKeyEntities) {

		String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";

		generateEntity(root, destinationFolder);

		String idClassName = details.getIdClass().substring(0,details.getIdClass().indexOf("Id"));
		if (compositePrimaryKeyEntities.contains(idClassName) && root.get("ClassName").toString().equals(idClassName)) {
			generateIdClass(root, destinationFolder);
		}

	}

	public void generateEntity(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		codeGeneratorUtils.generateFiles(entityGeneratorUtils.getEntityTemplate(root.get("ClassName").toString()), root, destPath,TEMPLATE_FOLDER);
	}

	public void generateIdClass(Map<String, Object> root, String destPath) {
		new File(destPath).mkdirs();
		codeGeneratorUtils.generateFiles(entityGeneratorUtils.getIdClassTemplate(root.get("ClassName").toString()), root, destPath,TEMPLATE_FOLDER);
	}

}
