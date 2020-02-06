package com.fastcode.entitycodegen;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.util.*;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.logging.LoggingHelper;

@Component
public class EntityGenerator {

	final static String TEMPLATE_FOLDER = "/templates";
	final static String ENTITIES_TEMPLATE_FOLDER = "/templates/backendTemplates/entities";

	@Autowired
	private BaseAppGen baseAppGen;

	@Autowired
	private ReverseMapping reverseMapping;

	@Autowired
	private CodeGeneratorUtils codeGeneratorUtils;

	@Autowired
	private EntityDetails entityDetails;

	@Autowired
	private EntityGeneratorUtils entityGeneratorUtils;

	@Autowired
	private UserInput userInput;

	@Autowired
	private CGenClassLoader loader;

	@Autowired
	private LoggingHelper logHelper;

	public Map<String, EntityDetails> generateEntities(Map<String,String> connectionProps, String schema,
			String packageName, String destination, AuthenticationInfo authenticationInfo) throws IllegalStateException, IOException, SQLException { 


		String entityPackage = packageName + ".domain.model";
		final String tempPackageName = entityPackage.concat(".Temp"); 
		destination = destination.replace('\\', '/');
		final String destinationPath = destination.concat("/src/main/java");
		final String targetPath = destination.concat("/target/classes");  

		reverseMapping.run(tempPackageName, destinationPath, schema, connectionProps);
		try { 
			Thread.sleep(280);
		} catch (InterruptedException e) {
			logHelper.getLogger().error("Error Occured : ", e.getMessage());
			System.exit(1);
		}

		try {
			baseAppGen.CompileApplication(destination);
			entityGeneratorUtils.deleteFile(destinationPath + "/orm.xml");
		} catch (Exception e) {
			logHelper.getLogger().error("Compilation Error ", e.getMessage());
		}

		Map<String, EntityDetails> entityDetailsMap = processAndGenerateRelevantEntities(targetPath, tempPackageName, schema, packageName, destinationPath, authenticationInfo);

		entityGeneratorUtils.deleteDirectory(destinationPath + "/" + tempPackageName.replaceAll("\\.", "/"));
		logHelper.getLogger().info("Exit");
		return entityDetailsMap;
	}

	public Map<String, EntityDetails> processAndGenerateRelevantEntities(String targetPath, String tempPackageName,String schema,String packageName, String destinationPath, AuthenticationInfo authenticationInfo) throws IllegalStateException
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

					entityDetailsMap.put(className, details);
					Map<String, Object> root =buildRootMap(details,className, packageName, schema, authenticationInfo);
					// Generate Entity based on template
					generateEntityAndIdClass(root, details, packageName, destinationPath,compositePrimaryKeyEntities);
				}
			}

			if(!entityDetailsMap.isEmpty())
			{

				if(authenticationInfo.getAuthenticationTable() !=null  && !authenticationInfo.getAuthenticationType().equals(AuthenticationType.NONE))
				{
					entityDetailsMap = validateAuthenticationTable(entityDetailsMap, authenticationInfo.getAuthenticationTable(), authenticationInfo.getAuthenticationType());
				}

				if(!authenticationInfo.getAuthenticationType().equals(AuthenticationType.NONE))
				{
					generateAutheticationEntities(entityDetailsMap, schema, packageName, destinationPath,authenticationInfo);
				}

			}
			else
			{

				throw new IllegalStateException("Invalid Schema");
			}

		} catch (ClassNotFoundException ex) {
			logHelper.getLogger().error("Exception : ", ex.getMessage());
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
		List<String> compositePrimaryKeyEntities= details.getCompositeKeyClasses();
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
				if(className.concat("Id") != details.getIdClass() && compositePrimaryKeyEntities.contains(details.getIdClass())) {
					details=updateJoinColumnName(details,entry.getValue());
				}

			}
			else if(entry.getValue().getRelation().equals("ManyToOne"))
			{
				if(!(descriptiveFieldEntities.containsKey(entry.getValue().geteName())))
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

		if(entityPrimaryKeys.size()>1)
		{
			for(JoinDetails jDetails : joinDetailsList)
			{
				if(relationEntityPrimaryKeys.contains(jDetails.getReferenceColumn()) && entityPrimaryKeys.contains(jDetails.getReferenceColumn()))
				{
					return true;
				}
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
				fieldDetails.setFieldName(str.getReferenceColumn());
				fieldsMap.put(str.getJoinColumn(), fieldDetails);
			}

		}

		return entityDetails;
	}

	public Map<String,EntityDetails> validateAuthenticationTable(Map<String,EntityDetails> entityDetailsMap, String authenticationTable, AuthenticationType authenticationType)
	{
		Boolean isTableExits=false;
		if(entityDetailsMap!=null)
		{
			if(entityDetailsMap.containsKey(authenticationTable)) {
				isTableExits=true;
			}
			if(!isTableExits)
			{
				logHelper.getLogger().error(" INVALID AUTHORIZATION SCHEMA ");
				throw new IllegalStateException("INVALID AUTHORIZATION SCHEMA");
			}

			return getAuthenticationTableFieldsMapping(entityDetailsMap, authenticationTable, authenticationType);
		}
		return entityDetailsMap;
	}

	public Map<String,FieldDetails> displayAuthFieldsAndGetMapping(Map<String,FieldDetails> authFields, List<FieldDetails> fieldsList)
	{
		for(Map.Entry<String,FieldDetails> authFieldsEntry: authFields.entrySet())
		{
			int index = 1;
			StringBuilder builder = new StringBuilder();
			for (FieldDetails f : fieldsList) {
				builder.append(MessageFormat.format("{0}.{1} ", index, f.getFieldName()));
				index++;
			}

			System.out.println("\n Select field you want to map on "+ authFieldsEntry.getKey() +" by typing its corresponding number : ");
			System.out.println(builder.toString());

			index= userInput.getFieldsInput(fieldsList.size());

			FieldDetails selected=fieldsList.get(index - 1);
			String type = "String";
			if(authFieldsEntry.getKey().equals("IsActive"))
			{
				type="Boolean";
			}
			while(!selected.getFieldType().equalsIgnoreCase(type) || !selected.getIsNullable())
			{
				System.out.println("Please choose valid required "+ type +" field");
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
		String[] types = {"long", "short", "integer", "double", "string", "timestamp", "boolean", "date" };
		List<FieldDetails> fieldsList = new ArrayList<>();
		for(Map.Entry<String,FieldDetails> fieldsEntry: details.getFieldsMap().entrySet())
		{
			if (Arrays.stream(types).anyMatch(fieldsEntry.getValue().getFieldType()::equalsIgnoreCase))
				fieldsList.add(fieldsEntry.getValue());
		}

		return fieldsList;
	}

	public Map<String,EntityDetails> getAuthenticationTableFieldsMapping(Map<String,EntityDetails> entityDetails, String authenticationTable, AuthenticationType authenticationType)
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
	
		if(authenticationType.equals(AuthenticationType.DATABASE))
		{
			authFields.put("IsActive", null);
			authFields.put("Password", null);
		}

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

	public Map<String, Object> getAuthenticationEntitiesTemplates(String templatePath, String authenticationTable) {

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
               
                if(!(outputFileName.toLowerCase().contains("user") && !(outputFileName.toLowerCase().contains(authenticationTable.toLowerCase().concat("permission"))
                		|| outputFileName.toLowerCase().contains(authenticationTable.toLowerCase().concat("role")))))
				{ 		
					templates.put(filePath, outputFileName);
				}
			}

		}

		return templates;
	}

	public Map<String, Object> getAuthenticationEntitiesTemplatesForUserGroupCase(String templatePath) {
		List<String> filesList = codeGeneratorUtils.readFilesFromDirectory(templatePath);
		filesList = codeGeneratorUtils.replaceFileNames(filesList, templatePath);

		Map<String, Object> templates = new HashMap<>();

		for (String filePath : filesList) {
			String outputFileName = filePath.substring(0, filePath.lastIndexOf('.'));

			if(!(outputFileName.toLowerCase().contains("user")))
			{ 		
				templates.put(filePath, outputFileName);
			}
		}

		return templates;
	}
	
    public void generateAutheticationEntities(Map<String,EntityDetails> details, String schemaName, String packageName,
            String destPath, AuthenticationInfo authenticationInfo) {
        
        Map<String, Object> root =buildRootMap(details.get(authenticationInfo.getAuthenticationTable()), authenticationInfo.getAuthenticationTable(), packageName, schemaName, authenticationInfo);
   			
        String destinationFolder = destPath + "/" + packageName.replaceAll("\\.", "/") + "/domain/model";
        Map<String, Object> templates = new HashMap<String, Object>();

        if(authenticationInfo.getAuthenticationType().equals(AuthenticationType.DATABASE) || 
                (!authenticationInfo.getAuthenticationType().equals(AuthenticationType.DATABASE) && authenticationInfo.getUserOnly()))
        {
            templates = getAuthenticationEntitiesTemplates(ENTITIES_TEMPLATE_FOLDER, authenticationInfo.getAuthenticationTable());

        }
        else if(!authenticationInfo.getAuthenticationType().equals(AuthenticationType.DATABASE) && !authenticationInfo.getUserOnly())
        {
            templates = getAuthenticationEntitiesTemplatesForUserGroupCase(ENTITIES_TEMPLATE_FOLDER);
        }
        codeGeneratorUtils.generateFiles(templates, root, destinationFolder,ENTITIES_TEMPLATE_FOLDER);

	}

	public Map<String, Object> buildRootMap(EntityDetails entityDetails,String className, String packageName, String schemaName, AuthenticationInfo authenticationInfo)
	{
		Map<String, Object> root = new HashMap<>();
		
		if(className !=null)
		{
		String entityClassName = className.concat("Entity");
		root.put("EntityClassName", entityClassName); 
		root.put("ClassName", className);
		} 
		
		root.put("PackageName", packageName);  
		root.put("CommonModulePackage", packageName.concat(".commonmodule"));
		root.put("SchemaName", schemaName);
		root.put("UserOnly", authenticationInfo.getUserOnly());
		root.put("AuthenticationType",authenticationInfo.getAuthenticationType().getName());
		if(authenticationInfo.getAuthenticationTable()!=null) {
			root.put("UserInput","true");
			root.put("AuthenticationTable", authenticationInfo.getAuthenticationTable());
		}
		else 
		{ 
			root.put("UserInput",null); 
			root.put("AuthenticationTable", "User");	
		}

		if(entityDetails != null)
		{
			root.put("IdClass", entityDetails.getIdClass());
			root.put("TableName", entityDetails.getEntityTableName());
			root.put("CompositeKeyClasses",entityDetails.getCompositeKeyClasses());
			root.put("Fields", entityDetails.getFieldsMap());
			root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
			root.put("Relationship", entityDetails.getRelationsMap());
			root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
			root.put("PrimaryKeys", entityDetails.getPrimaryKeys());
		}

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
