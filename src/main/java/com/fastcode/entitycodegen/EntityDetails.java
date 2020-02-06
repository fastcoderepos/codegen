package com.fastcode.entitycodegen;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import javax.persistence.Column;
import javax.persistence.JoinColumn;
import javax.persistence.JoinColumns;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.lang.annotation.Annotation;
import java.lang.reflect.Field;

import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.logging.LoggingHelper;
import com.google.common.base.CaseFormat;

@Component
public class EntityDetails {

	//	@Autowired
	//	private CodeGeneratorUtils codeGeneratorUtils;

	@Autowired
	private LoggingHelper logHelper; 

	Map<String, FieldDetails> fieldsMap = new HashMap<>();
	Map<String, RelationDetails> relationsMap = new HashMap<>();
	List<String> compositeKeyClasses = new ArrayList<>();
	Map<String,String> primaryKeys = new HashMap<>();

	Map<String, FieldDetails> entitiesDescriptiveFieldMap = new HashMap<>();
	Map<String, FieldDetails> authenticationFieldsMap = null;
	String entityTableName;
	String idClass;

	public String getIdClass() {
		return idClass;
	}

	public void setIdClass(String idClass) {
		this.idClass = idClass;
	}


	public Map<String, String> getPrimaryKeys() {
		return primaryKeys;
	}

	public void setPrimaryKeys(Map<String, String> primaryKeys) {
		this.primaryKeys = primaryKeys;
	}

	public String getEntityTableName() {
		return entityTableName;
	}

	public void setEntityTableName(String entityTableName) {
		this.entityTableName = entityTableName;
	}

	public Map<String, FieldDetails> getAuthenticationFieldsMap() {
		return authenticationFieldsMap;
	}

	public void setAuthenticationFieldsMap(Map<String, FieldDetails> authenticationFieldsMap) {
		this.authenticationFieldsMap = authenticationFieldsMap;
	}

	public Map<String, FieldDetails> getEntitiesDescriptiveFieldMap() {
		return entitiesDescriptiveFieldMap;
	}

	public void setEntitiesDescriptiveFieldMap(Map<String, FieldDetails> entitiesDescriptiveFieldMap) {
		this.entitiesDescriptiveFieldMap = entitiesDescriptiveFieldMap;
	}

	public EntityDetails()
	{

	}
	public EntityDetails(Map<String, FieldDetails> fieldsMap, Map<String, RelationDetails> relationsMap,String tableName,String idClass) {
		super();
		this.fieldsMap = fieldsMap;
		this.relationsMap = relationsMap;
		this.entityTableName = tableName;
		this.idClass = idClass;
	}

	public Map<String, FieldDetails> getFieldsMap() {
		return fieldsMap;
	}

	public void setFieldsMap(Map<String, FieldDetails> fieldsMap) {
		this.fieldsMap = fieldsMap;
	}

	public Map<String, RelationDetails> getRelationsMap() {
		return relationsMap;
	}

	public void setRelationsMap(Map<String, RelationDetails> relationsMap) {
		this.relationsMap = relationsMap;
	}

	public List<String> getCompositeKeyClasses() {
		return compositeKeyClasses;
	}

	public void setCompositeKeyClasses(List<String> compositeKeyClasses) {
		this.compositeKeyClasses = compositeKeyClasses;
	}

	public String getTableName(Annotation[] classAnnotations)
	{
		String tableName = null;
		for (Annotation ann : classAnnotations) {
			if(ann.annotationType().toString().equals("interface javax.persistence.Table"))
			{
				javax.persistence.Table tableAnn =(javax.persistence.Table)ann;
				tableName= tableAnn.name();
			}
		}

		return tableName;
	}

	public String camelCaseToKebabCase(String name)
	{
		String[] splittedNames = StringUtils.splitByCharacterTypeCamelCase(name);
		splittedNames[0] = StringUtils.lowerCase(splittedNames[0]);

		for (int i = 0; i < splittedNames.length; i++) {
			splittedNames[i] = StringUtils.lowerCase(splittedNames[i]);
		}
		return StringUtils.join(splittedNames, "-");
	}
	public EntityDetails retreiveEntityFieldsAndRships(Class<?> entityClass, String entityName,
			List<Class<?>> classList) {

		Map<String, FieldDetails> fieldsMap = new HashMap<>();
		Map<String, RelationDetails> relationsMap = new HashMap<>();

		String className = entityName.substring(entityName.lastIndexOf(".") + 1);

		String tableName=null;
		String idClass=className+"Id";
		try {

			Class<?> myClass = entityClass;
			Object classObj = (Object) myClass.newInstance();
			Annotation[] classAnnotations=classObj.getClass().getAnnotations();
			tableName=getTableName(classAnnotations);

			Field[] fields = classObj.getClass().getDeclaredFields();

			for (Field field : fields) { 
				FieldDetails details = new FieldDetails();
				RelationDetails relation = new RelationDetails();
				List<JoinDetails> joinDetailsList= new ArrayList<JoinDetails>();
				JoinDetails joinDetails=new JoinDetails();
				String str = field.getType().toString();
				int index = str.lastIndexOf(".") + 1;
                details.setIsNullable(true);
				details.setFieldName(field.getName());
				String fieldType=str.substring(index);
				if(fieldType.equals("int"))
				{
					fieldType="Integer";
				}
				fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);
				details.setFieldType(fieldType);
				Annotation[] annotations = field.getAnnotations();
				relation.setcName(className);
				for (Annotation a : annotations) {

					if (a.annotationType().toString().equals("interface javax.persistence.Column")) {
						
						Column column=(javax.persistence.Column) a;
						if(!details.getIsPrimaryKey()){
							details.setIsNullable(column.nullable());
						}

						details.setLength(column.length());
						String colDef=column.columnDefinition();
						if(colDef.equalsIgnoreCase("bigserial") || colDef.equalsIgnoreCase("serial"))
						{
							details.setIsAutogenerated(true);
						}
					}
					if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
						details.setIsPrimaryKey(true);
						details.setIsNullable(false);
					}
					if (a.annotationType().toString().equals("interface javax.persistence.ManyToOne")) {
						relation.setRelation("ManyToOne");
						relation.setfName(details.getFieldName());
						relation.seteName(details.getFieldType());
						relation.seteModuleName(camelCaseToKebabCase(details.getFieldType()));

						joinDetails.setJoinEntityName(details.getFieldType());
					}
					if (a.annotationType().toString().equals("interface javax.persistence.OneToOne")) {
						relation.setRelation("OneToOne");
						OneToOne oneToOne= (javax.persistence.OneToOne) a;
						relation.setfName(details.getFieldName());
						relation.seteName(details.getFieldType());
						relation.seteModuleName(camelCaseToKebabCase(details.getFieldType()));
						joinDetails.setJoinEntityName(details.getFieldType());

						String mappedBy = oneToOne.mappedBy();

						if(!mappedBy.isEmpty())
						{
							relation.setIsParent(true);	
						}

						joinDetails.setMappedBy(mappedBy);
					}

					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumns")) {

						JoinColumns joinColumnsAnnotation = (javax.persistence.JoinColumns) a;
						JoinColumn[] joinColumnArray = joinColumnsAnnotation.value();
						for (JoinColumn j : joinColumnArray) {

							joinDetails=new JoinDetails();
							joinDetails.setJoinEntityName(details.getFieldType());
							String referenceCol=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, j.referencedColumnName()); 
							String name=CaseFormat.LOWER_UNDERSCORE .to(CaseFormat.LOWER_CAMEL, j.name());

							if(referenceCol.isEmpty())
							{
								joinDetails.setReferenceColumn(name); 
							}
							else
								joinDetails.setReferenceColumn(referenceCol);
							joinDetails.setJoinColumn(name); 

							joinDetails.setIsJoinColumnOptional(j.nullable());

							String columnType = j.columnDefinition();
							if (columnType.equals("bigserial") || columnType.equals("int8"))
								joinDetails.setJoinColumnType("Long");
							else if(columnType.equals("serial") || columnType.equals("int4"))
								joinDetails.setJoinColumnType("Integer");
							else if(columnType.equals("int2"))
								joinDetails.setJoinColumnType("Short");
							else if(columnType.equals("decimal") || columnType.equals("numeric"))
								joinDetails.setJoinColumnType("Double");
							else
								joinDetails.setJoinColumnType("String");

							joinDetailsList.add(joinDetails);
						}
					}

					if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) {

						JoinColumn joinCol= (javax.persistence.JoinColumn) a;
						
						joinDetails.setJoinColumn(
								CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, joinCol.name()));
						joinDetails.setIsJoinColumnOptional(joinCol.nullable());

						String columnType = joinCol.columnDefinition();
						if (columnType.equals("bigserial") || columnType.equals("int8"))
							joinDetails.setJoinColumnType("Long");
						else if(columnType.equals("serial") || columnType.equals("int4"))
							joinDetails.setJoinColumnType("Integer");
						else if(columnType.equals("int2"))
							joinDetails.setJoinColumnType("Short");
						else if(columnType.equals("decimal") || columnType.equals("numeric"))
							joinDetails.setJoinColumnType("Double");
						else
							joinDetails.setJoinColumnType("String");

						if (joinDetails.getJoinColumn() != null) {
							String entity = StringUtils.substringBeforeLast(entityName, ".");
							Map<String, String> pKeyMap = findPrimaryKey(
									entity.concat("." + relation.geteName()), classList);

							for(Map.Entry<String, String> pk : pKeyMap.entrySet())
							{
								String referenceColumn = pk.getKey();
								if(columnType.isEmpty())
									joinDetails.setJoinColumnType(pk.getValue());
								if (!referenceColumn.isEmpty())
									joinDetails.setReferenceColumn(referenceColumn);
							}

						}
					}
					if (a.annotationType().toString().equals("interface javax.persistence.OneToMany")) {
						String relationalEntity = a.toString();
						OneToMany oneToMany=(javax.persistence.OneToMany) a;

						String entityPackage = null;
						String[] word = relationalEntity.split("[\\(,//)]");
						for (String s : word) {
							if (s.contains("targetEntity")) {
								String[] value = s.split(" ");
								if(value.length>1)
								{
									entityPackage = value[1];
								}
							}

						}
						String targetEntity = entityPackage.substring(entityPackage.lastIndexOf(".") + 1);
						relation.setRelation("OneToMany");
						details.setFieldName(targetEntity.toLowerCase());
						details.setFieldType(targetEntity);
						relation.seteName(targetEntity);
						relation.seteModuleName(camelCaseToKebabCase(targetEntity));
						relation.setfName(targetEntity.toLowerCase());

						joinDetails.setJoinEntityName(details.getFieldType());

						String mappedBy = oneToMany.mappedBy();
						joinDetails.setMappedBy(mappedBy);
					}

				}

				if (relation.geteName() != null) {
					if(joinDetailsList.isEmpty())
						joinDetailsList.add(joinDetails);

					joinDetailsList.sort( (u1, u2) -> { 
						return u1.getReferenceColumn().compareTo(u2.getReferenceColumn());}); 
					relation.setJoinDetails(joinDetailsList);
					relation.setfDetails(getFields(relation.geteName(), classList));
					relationsMap.put(className + "-" + relation.geteName(), relation);
				}

				//details.setFieldName(details.getFieldName());
				fieldsMap.put(details.getFieldName(), details);

			}
		} catch (InstantiationException e) {
			logHelper.getLogger().error("InstantiationException : ", e.getMessage());
		} catch (IllegalAccessException e) {
			logHelper.getLogger().error("IllegalAccessException : ", e.getMessage());
		}
		Map<String, FieldDetails> sortedMap = new TreeMap<>(fieldsMap);

		return new EntityDetails(sortedMap, relationsMap,tableName,idClass);
	}

	public Map<String,String> findPrimaryKey(String entityPackage, List<Class<?>> classList) {
		String primaryKey = null;
		
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName();
			if (entityName.equals(entityPackage)) {
				try {
					Class<?> myClass = currentClass;
					Object classObj = (Object) myClass.newInstance();
					Field[] fields = classObj.getClass().getDeclaredFields();
					for (Field field : fields) {
						Annotation[] annotations = field.getDeclaredAnnotations();

						for (Annotation a : annotations) {
							if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
								primaryKey = field.getName();
								String str = field.getType().toString();
								int index = str.lastIndexOf(".") + 1;
								String fieldType=str.substring(index);
								if(fieldType.equals("int"))
								{
									fieldType="Integer";
								}
								fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);
								Map<String,String> pKeyMap = new HashMap<String,String>();
								pKeyMap.put(primaryKey,fieldType);
								return pKeyMap;

							}
						}
					}
				} catch (InstantiationException e) {
					logHelper.getLogger().error("InstantiationException : ", e.getMessage());
				} catch (IllegalAccessException e) {
					logHelper.getLogger().error("IllegalAccessException : ", e.getMessage());
				}

			}
		}
		return null;
	}

	public List<FieldDetails> getFields(String relationEntityName, List<Class<?>> classList) {
		List<FieldDetails> fieldsList = new ArrayList<>();
		for (Class<?> currentClass : classList) {
			String entityName = currentClass.getName().substring(currentClass.getName().lastIndexOf(".") + 1);
			if (entityName.equals(relationEntityName)) {
				try {
					Class<?> myClass = currentClass;
					Object classObj = (Object) myClass.newInstance();
					Field[] fields = classObj.getClass().getDeclaredFields();
					for (Field field : fields) {
						FieldDetails details = new FieldDetails();
						String str = field.getType().toString();
						int index = str.lastIndexOf(".") + 1;
						details.setFieldName(field.getName());

						String fieldType=str.substring(index);
						if(fieldType.equals("int"))
						{
							fieldType="Integer";
						}
						fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);
						details.setFieldType(fieldType);
						Annotation[] annotations = field.getAnnotations();
						for (Annotation a : annotations) {
							if (a.annotationType().toString().equals("interface javax.persistence.Id")) {
								details.setIsPrimaryKey(true);
							}
						}

						fieldsList.add(details);

					}

				} catch (InstantiationException e) {
					logHelper.getLogger().error("InstantiationException : ", e.getMessage());
				} catch (IllegalAccessException e) {
					logHelper.getLogger().error("IllegalAccessException : ", e.getMessage());
				}
			}
		}

		return fieldsList;

	}

	public Map<String, RelationDetails> FindOneToManyJoinColFromChildEntity( 
			Map<String, RelationDetails> relationMap, List<Class<?>> classList) { 
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) { 
			if (entry.getValue().getRelation() == "OneToMany") { 

				for (Class<?> currentClass : classList) { 
					String entityName = currentClass.getName().substring(currentClass.getName().lastIndexOf(".") + 1); 
					if (entityName.equals(entry.getValue().geteName())) {

						try { 
							Class<?> myClass = currentClass; 
							Object classObj = (Object) myClass.newInstance(); 
							Field[] fields = classObj.getClass().getDeclaredFields(); 
							List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
							for (Field field : fields) { 
								JoinDetails joinDetails = new JoinDetails();

								String str = field.getType().toString();
								int index = str.lastIndexOf(".") + 1;
								String fieldname=field.getName();
								String fieldType=str.substring(index);
								if(fieldType.equals("int"))
								{
									fieldType="Integer";
								}
								fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);

								Annotation[] annotations = field.getAnnotations(); 

								for (Annotation a : annotations) { 

									if (a.annotationType().toString().equals("interface javax.persistence.JoinColumns")) {

										JoinColumns joinColumnsAnnotation = (javax.persistence.JoinColumns) a;
										JoinColumn[] joinColumnArray = joinColumnsAnnotation.value();

										for (JoinColumn jCol : joinColumnArray) {
											joinDetails=new JoinDetails();

											joinDetails.setJoinEntityName(entry.getValue().geteName());

											String referenceCol=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, jCol.referencedColumnName()); 
											String name=CaseFormat.LOWER_UNDERSCORE .to(CaseFormat.LOWER_CAMEL, jCol.name());

											if(referenceCol.isEmpty())
											{
												joinDetails.setReferenceColumn(name); 
											}
											else
												joinDetails.setReferenceColumn(referenceCol);

											joinDetails.setJoinColumn(CaseFormat.LOWER_UNDERSCORE 
													.to(CaseFormat.LOWER_CAMEL, jCol.name())); 

											joinDetails.setIsJoinColumnOptional(jCol.nullable());

											String columnType =jCol.columnDefinition();
											if (columnType.equals("bigserial") || columnType.equals("int8"))
												joinDetails.setJoinColumnType("Long");
											else if(columnType.equals("serial") || columnType.equals("int4") )
												joinDetails.setJoinColumnType("Integer");
											else if(columnType.equals("int2"))
												joinDetails.setJoinColumnType("Short");
											else if(columnType.equals("decimal") || columnType.equals("numeric"))
												joinDetails.setJoinColumnType("Double");
											else
												joinDetails.setJoinColumnType("String");

											joinDetailsList.add(joinDetails);

										}
										entry.getValue().setJoinDetails(joinDetailsList);

									}
									if (a.annotationType().toString().equals("interface javax.persistence.JoinColumn")) { 

										JoinColumn joinCol =  (javax.persistence.JoinColumn) a;
										joinDetails.setJoinEntityName(entry.getValue().geteName());

										if (fieldname.equalsIgnoreCase(entry.getValue().getcName()))
											joinDetails.setJoinColumn(CaseFormat.LOWER_UNDERSCORE 
													.to(CaseFormat.LOWER_CAMEL, joinCol.name())); 

										joinDetails.setIsJoinColumnOptional(joinCol.nullable()); 

										String columnType = joinCol.columnDefinition(); 
										if (columnType.equals("bigserial") || columnType.equals("int8"))
											joinDetails.setJoinColumnType("Long");
										else if(columnType.equals("serial") || columnType.equals("int4"))
											joinDetails.setJoinColumnType("Integer");
										else if(columnType.equals("int2"))
											joinDetails.setJoinColumnType("Short");
										else if(columnType.equals("decimal") || columnType.equals("numeric"))
											joinDetails.setJoinColumnType("Double");
										else 
											joinDetails.setJoinColumnType("String"); 

										if (joinDetails.getJoinColumn() != null) {

											String entity = StringUtils.substringBeforeLast(currentClass.getName(), ".");
											Map<String, String> pKeyMap = findPrimaryKey(
													entity.concat("." + entry.getValue().geteName()), classList);

											for(Map.Entry<String, String> pk : pKeyMap.entrySet())
											{
												String referenceColumn = pk.getKey();
												if(columnType.isEmpty())
													joinDetails.setJoinColumnType(pk.getValue());
												if (!referenceColumn.isEmpty())
													joinDetails.setReferenceColumn(referenceColumn);
											}


											joinDetailsList.add(joinDetails);

											entry.getValue().setJoinDetails(joinDetailsList);
										}
									} 
								} 
							} 

						} catch (InstantiationException e) { 
							logHelper.getLogger().error("InstantiationException : ", e.getMessage()); 
						} catch (IllegalAccessException e) { 
							logHelper.getLogger().error("IllegalAccessException : ", e.getMessage());
						} 
					} 
				} 
			} 
		} 
		return relationMap; 
	} 

	public Map<String, RelationDetails> FindOneToOneJoinColFromChildEntity( 
			Map<String, RelationDetails> relationMap, List<Class<?>> classList) { 
		for (Map.Entry<String, RelationDetails> entry : relationMap.entrySet()) { 
			if (entry.getValue().getRelation() == "OneToOne" && entry.getValue().getIsParent()) { 
				for (Class<?> currentClass : classList) { 
					String entityName = currentClass.getName().substring(currentClass.getName().lastIndexOf(".") + 1); 
					if (entityName.equals(entry.getValue().geteName())) {

						try { 
							Class<?> myClass = currentClass; 
							Object classObj = (Object) myClass.newInstance(); 
							Field[] fields = classObj.getClass().getDeclaredFields(); 
							List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
							List<JoinDetails> childJoinDetailsList=entry.getValue().getJoinDetails();
							for (Field field : fields) { 
								JoinDetails joinDetails = new JoinDetails();

								String mappedBy=null;

								String str = field.getType().toString();
								int index = str.lastIndexOf(".") + 1;
								String fieldname=field.getName();
								String fieldType=str.substring(index);
								if(fieldType.equals("int"))
								{
									fieldType="Integer";
								}
								fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);

								for(JoinDetails jd: childJoinDetailsList)
								{
									if(jd.getJoinEntityName()==fieldname)
									{
										mappedBy=jd.getMappedBy();
									}
								}

								fieldType=fieldType.substring(0, 1).toUpperCase() + fieldType.substring(1);
								Annotation[] annotations = field.getAnnotations(); 

								for (Annotation a : annotations) { 
									if (a.annotationType().toString().equals("interface javax.persistence.JoinColumns")) {

										JoinColumns joinColumnsAnnotation = (javax.persistence.JoinColumns) a;
										JoinColumn[] joinColumnArray = joinColumnsAnnotation.value();

										for (JoinColumn j : joinColumnArray) {
											joinDetails=new JoinDetails();

											joinDetails.setJoinEntityName(entry.getValue().geteName());
											String referenceCol=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, j.referencedColumnName()); 
											String name=CaseFormat.LOWER_UNDERSCORE .to(CaseFormat.LOWER_CAMEL, j.name());

											if(referenceCol.isEmpty())
											{
												joinDetails.setReferenceColumn(name); 
											}
											else
												joinDetails.setReferenceColumn(referenceCol);

											joinDetails.setJoinColumn(CaseFormat.LOWER_UNDERSCORE 
													.to(CaseFormat.LOWER_CAMEL,j.name())); 
											joinDetails.setIsJoinColumnOptional(j.nullable());
											String columnType = j.columnDefinition();
											if (columnType.equals("bigserial") || columnType.equals("int8"))
												joinDetails.setJoinColumnType("Long");
											else if(columnType.equals("serial") || columnType.equals("int4"))
												joinDetails.setJoinColumnType("Integer");
											else if(columnType.equals("int2"))
												joinDetails.setJoinColumnType("Short");
											else if(columnType.equals("decimal") || columnType.equals("numeric"))
												joinDetails.setJoinColumnType("Double");
											else
												joinDetails.setJoinColumnType("String");

											joinDetailsList.add(joinDetails);

										}
										entry.getValue().setJoinDetails(joinDetailsList);

									}
									if (a.annotationType().toString() .equals("interface javax.persistence.JoinColumn")) { 
										JoinColumn joinCol=(javax.persistence.JoinColumn) a;

										joinDetails.setJoinEntityName(entry.getValue().geteName());

										if (fieldname.equalsIgnoreCase(entry.getValue().getcName()))
											joinDetails.setJoinColumn(CaseFormat.LOWER_UNDERSCORE 
													.to(CaseFormat.LOWER_CAMEL, joinCol.name())); 

										joinDetails.setIsJoinColumnOptional(joinCol.nullable()); 

										String columnType = joinCol.columnDefinition(); 
										if (columnType.equals("bigserial") || columnType.equals("int8"))
											joinDetails.setJoinColumnType("Long");
										else if(columnType.equals("serial") || columnType.equals("int4"))
											joinDetails.setJoinColumnType("Integer");
										else if(columnType.equals("int2"))
											joinDetails.setJoinColumnType("Short");
										else if(columnType.equals("decimal") || columnType.equals("numeric"))
											joinDetails.setJoinColumnType("Double");
										else 
											joinDetails.setJoinColumnType("String"); 


										if (joinDetails.getJoinColumn() != null) {

											String entity = StringUtils.substringBeforeLast(currentClass.getName(), ".");
											if(mappedBy!=null)
												joinDetails.setMappedBy(mappedBy);
											Map<String, String> pKeyMap = findPrimaryKey(
													entity.concat("." + entry.getValue().geteName()), classList);

											for(Map.Entry<String, String> pk : pKeyMap.entrySet())
											{
												String referenceColumn = pk.getKey();
												if(columnType.isEmpty())
													joinDetails.setJoinColumnType(pk.getValue());
												if (!referenceColumn.isEmpty())
													joinDetails.setReferenceColumn(referenceColumn);
											}
											joinDetailsList.add(joinDetails);

											entry.getValue().setJoinDetails(joinDetailsList);
										}
									} 
								} 
							} 
						} catch (InstantiationException e) { 
							logHelper.getLogger().error("InstantiationException : ", e.getMessage());
						} catch (IllegalAccessException e) { 
							logHelper.getLogger().error("IllegalAccessException : ", e.getMessage());
						} 

					} 
				} 

			} 
		} 
		return relationMap; 
	} 
}
