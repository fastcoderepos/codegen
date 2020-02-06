package com.fastcode.entitycodegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.entitycodegen.BaseAppGen;
import com.fastcode.entitycodegen.CGenClassLoader;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.EntityGenerator;
import com.fastcode.entitycodegen.EntityGeneratorUtils;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.JoinDetails;
import com.fastcode.entitycodegen.RelationDetails;
import com.fastcode.entitycodegen.ReverseMapping;
import com.fastcode.entitycodegen.UserInput;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class EntityGeneratorTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private EntityGenerator entityGenerator;

	@Mock
	private BaseAppGen mockedBaseAppGen;

	@Mock
	private ReverseMapping reverseMapping;

	@Mock
	private CodeGeneratorUtils mockedCodeGeneratorUtils;

	@Mock
	private EntityDetails mockedEntityDetails;

	@Mock
	private EntityGeneratorUtils mockedEntityGeneratorUtils;

	@Mock
	private UserInput mockedUserInput;

	@Mock
	private CGenClassLoader loader;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private File destPath;
	List<String> tableList= new ArrayList<String>();

	final static String SCHEMA_NAME = "demo";
	//final static String CONNECTION_STRING = "jdbc:postgresql://localhost:5432/Demo?username=postgres;password=fastcode";
	final static String PACKAGE_NAME = "com.nfinity.test";
	final static String AUTHENTICATION_TABLE = "user";
	//final static String AUTHENTICATION_TYPE = "database";

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(entityGenerator);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		doNothing().when(loggerMock).info(anyString());
		tableList.add("user");
		tableList.add("blog");
		tableList.add("tag");
	}

	@After
	public void tearDown() throws Exception {

	}

	@Test
	public void generateEntities_parametersAreValid_returnMap() throws SQLException, IOException
	{
		Mockito.doReturn(new HashMap<String, String>()).when(mockedEntityGeneratorUtils).parseConnectionString(anyString());
		Mockito.doNothing().when(reverseMapping).run(anyString(), anyString(), anyString(), any(HashMap.class));
		Mockito.doNothing().when(mockedBaseAppGen).CompileApplication(anyString());
		Mockito.doNothing().when(mockedEntityGeneratorUtils).deleteFile(anyString());
		Mockito.doReturn(new HashMap<String, EntityDetails>()).when(entityGenerator).processAndGenerateRelevantEntities(anyString(),anyString(),anyString(),anyString(),anyString(),any(AuthenticationInfo.class));
		Mockito.doNothing().when(mockedEntityGeneratorUtils).deleteDirectory(anyString());

		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(AUTHENTICATION_TABLE);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);

		entityGenerator.generateEntities(new HashMap<String,String>(), SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), authenticationInfo);
		Mockito.verify(mockedBaseAppGen,Mockito.times(1)).CompileApplication(anyString());
		Mockito.verify(entityGenerator,Mockito.times(1)).processAndGenerateRelevantEntities(anyString(),anyString(),anyString(),anyString(),anyString(),any(AuthenticationInfo.class));

	}

	@Test
	public void processAndGenerateRelevantEntities_authenticationTypeIsNotNone_returnMap() throws ClassNotFoundException
	{
		List<Class<?>> classList= new ArrayList<Class<?>>();
		Class<?> c1 = Class.forName("java.lang.String"); 
		Class<?> c2 = int.class; 
		classList.add(c1);
		classList.add(c2);

		List<String> compositePrimaryKeyEntities= new ArrayList<String>();
		compositePrimaryKeyEntities.add("User");

		Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setIdClass("blogId");
		entityDetails.setRelationsMap(new HashMap<String, RelationDetails>());
		entityDetails.setFieldsMap(new HashMap<String, FieldDetails>());
		entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);
		entityDetailsMap.put("user", entityDetails);

		Mockito.doNothing().when(loader).setPath(anyString());
		Mockito.doReturn(new ArrayList<Class<?>>()).when(loader).findClasses(anyString());
		Mockito.doReturn(classList).when(mockedEntityGeneratorUtils).filterOnlyRelevantEntities(any(ArrayList.class));
		Mockito.doReturn(compositePrimaryKeyEntities).when(mockedEntityGeneratorUtils).findCompositePrimaryKeyClasses(any(ArrayList.class));
		Mockito.doReturn(entityDetails).when(mockedEntityDetails).retreiveEntityFieldsAndRships(any(Class.class),anyString(),any(List.class));
		Mockito.doReturn(new HashMap<String,String>()).when(mockedEntityGeneratorUtils).getPrimaryKeysFromMap(any(HashMap.class));
		Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToManyJoinColFromChildEntity(any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToOneJoinColFromChildEntity(any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(any(HashMap.class),any(HashMap.class),any(EntityDetails.class),anyString());
		Mockito.doReturn(entityDetails).when(entityGenerator).updateFieldsListInRelationMap(any(EntityDetails.class));
		Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).buildRootMap(any(EntityDetails.class), anyString(), anyString(), anyString(), any(AuthenticationInfo.class));
		Mockito.doNothing().when(entityGenerator).generateEntityAndIdClass(any(HashMap.class), any(EntityDetails.class),anyString(), anyString(),any(List.class));
		Mockito.doReturn(entityDetailsMap).when(entityGenerator).validateAuthenticationTable(any(HashMap.class), anyString(), any(AuthenticationType.class));
		Mockito.doNothing().when(entityGenerator).generateAutheticationEntities(any(HashMap.class), anyString(), anyString(), anyString(), any(AuthenticationInfo.class));

		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(AUTHENTICATION_TABLE);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);

		Assertions.assertThat(entityGenerator.processAndGenerateRelevantEntities(destPath.getAbsolutePath(), PACKAGE_NAME, SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(),authenticationInfo)).isEqualTo(entityDetailsMap);
	}

	@Test
	public void processAndGenerateRelevantEntities_authenticationTypeIsNone_returnMap() throws ClassNotFoundException
	{
		List<Class<?>> classList= new ArrayList<Class<?>>();
		Class<?> c1 = Class.forName("java.lang.String"); 
		Class<?> c2 = int.class; 
		classList.add(c1);
		classList.add(c2);

		List<String> compositePrimaryKeyEntities= new ArrayList<String>();
		compositePrimaryKeyEntities.add("User");

		Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setIdClass("blogId");
		entityDetails.setRelationsMap(new HashMap<String, RelationDetails>());
		entityDetails.setFieldsMap(new HashMap<String, FieldDetails>());
		entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);
		entityDetailsMap.put("String", entityDetails);
		entityDetailsMap.put("int", entityDetails);

		Mockito.doNothing().when(loader).setPath(anyString());
		Mockito.doReturn(new ArrayList<Class<?>>()).when(loader).findClasses(anyString());
		Mockito.doReturn(classList).when(mockedEntityGeneratorUtils).filterOnlyRelevantEntities(any(ArrayList.class));
		Mockito.doReturn(compositePrimaryKeyEntities).when(mockedEntityGeneratorUtils).findCompositePrimaryKeyClasses(any(ArrayList.class));
		Mockito.doReturn(entityDetails).when(mockedEntityDetails).retreiveEntityFieldsAndRships(any(Class.class),anyString(),any(List.class));
		Mockito.doReturn(new HashMap<String,String>()).when(mockedEntityGeneratorUtils).getPrimaryKeysFromMap(any(HashMap.class));
		Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToManyJoinColFromChildEntity(any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails.getRelationsMap()).when(mockedEntityDetails).FindOneToOneJoinColFromChildEntity(any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(any(HashMap.class),any(HashMap.class),any(EntityDetails.class),anyString());
		Mockito.doReturn(entityDetails).when(entityGenerator).updateFieldsListInRelationMap(any(EntityDetails.class));
		Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).buildRootMap(any(EntityDetails.class), anyString(), anyString(), anyString(), any(AuthenticationInfo.class));
		Mockito.doNothing().when(entityGenerator).generateEntityAndIdClass(any(HashMap.class), any(EntityDetails.class),anyString(), anyString(),any(List.class));

		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(AUTHENTICATION_TABLE);
		authenticationInfo.setAuthenticationType(AuthenticationType.NONE);

		Assertions.assertThat(entityGenerator.processAndGenerateRelevantEntities(destPath.getAbsolutePath(), PACKAGE_NAME, SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), authenticationInfo)).isEqualTo(entityDetailsMap);
	}

	@Test
	public void findAndSetDescriptiveField_parametersAreValid_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("blog");

		Mockito.doReturn(details).when(mockedUserInput).getEntityDescriptionField(anyString(), any(List.class));
		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		details.setDescription("blogDescriptiveField");
		descriptiveFieldEntities.put("blog",details);
		Assertions.assertThat(entityGenerator.findAndSetDescriptiveField(new HashMap<String, FieldDetails>(), relationDetails)).isEqualTo(descriptiveFieldEntities);
	}

	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_parametersAreValid_returnMap()
	{

		FieldDetails details = new FieldDetails(); 
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");

		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setRelation("OneToOne");

		RelationDetails relationDetails1= new RelationDetails();
		relationDetails1.seteName("entry"); 
		relationDetails1.setcName("tag");
		relationDetails1.setRelation("ManyToOne");

		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		relationMap.put("entry-tag",relationDetails1);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setIdClass("userId");
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);

		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));

		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualToComparingFieldByFieldRecursively(entityDetails);

	}

	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_oneToOneCheckIsNotValid_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");

		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");

		RelationDetails relationDetails1= new RelationDetails();
		relationDetails1.seteName("entry");
		relationDetails1.setcName("tag");
		relationDetails1.setRelation("ManyToOne");

		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);
		relationMap.put("entry-tag",relationDetails1);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);

		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));

		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualToIgnoringNullFields(entityDetails);
	}

	@Test
	public void setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap_manyTonOneIsNotInList_returnMap()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");
		details.setDescription("blogDescriptiveField");

		Map<String,FieldDetails> descriptiveFieldEntities= new HashMap<String, FieldDetails>();
		descriptiveFieldEntities.put("blog",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.seteName("user");
		relationDetails.setcName("blog");
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");


		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setEntitiesDescriptiveFieldMap(descriptiveFieldEntities);

		Mockito.doReturn(true).when(entityGenerator).identifyOneToOneRelationContainsPrimaryKeys(any(List.class),any(HashMap.class), any(List.class));
		Mockito.doReturn(entityDetails).when(entityGenerator).updateJoinColumnName(any(EntityDetails.class), any(RelationDetails.class));
		Mockito.doReturn(descriptiveFieldEntities).when(entityGenerator).findAndSetDescriptiveField(any(HashMap.class), any(RelationDetails.class));

		Assertions.assertThat(entityGenerator.setDescriptiveFieldsAndJoinColumnsInEntityDetailsMap(descriptiveFieldEntities, relationMap, new EntityDetails(), "blog")).isEqualToIgnoringNullFields(entityDetails);

	}

	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_parametersAreValid_returnTrue()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");

		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");
		primaryKeysMap.put("userId", "Long");

		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetailsList.add(joinDetails);

		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(true);
	}

	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_entityPrimaryKeysNotContainJoinColumn_returnFalse()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");

		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");

		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetailsList.add(joinDetails);

		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(false);
	}

	@Test
	public void identifyOneToOneRelationContainsPrimaryKeys_listIsEmpty_returnFalse()
	{
		List<String> relationEntityPrimaryKeys = new ArrayList<>();
		relationEntityPrimaryKeys.add("userId");

		Map<String,String> primaryKeysMap= new HashMap<String, String>();
		primaryKeysMap.put("blogId", "Long");

		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();

		Mockito.doReturn(relationEntityPrimaryKeys).when(mockedEntityGeneratorUtils).getPrimaryKeysFromList(any(List.class));
		Assertions.assertThat(entityGenerator.identifyOneToOneRelationContainsPrimaryKeys(new ArrayList<FieldDetails>(), primaryKeysMap, joinDetailsList)).isEqualTo(false);
	}

	@Test
	public void updateFieldsListInRelationMap_fieldNameAndJoinColumnAreSame_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");

		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);

		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetails.setJoinColumn("blogId");

		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		joinDetailsList.add(joinDetails);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setfDetails(fDetails);
		relationDetails.setJoinDetails(joinDetailsList);

		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setRelationsMap(relationMap);
		Assertions.assertThat(entityGenerator.updateFieldsListInRelationMap(entityDetails)).isEqualTo(entityDetails);
	}

	@Test
	public void updateFieldsListInRelationMap_joinDetailsAreNull_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setfDetails(fDetails);

		Map<String, RelationDetails> relationMap= new HashMap<String, RelationDetails>();
		relationMap.put("user-blog", relationDetails);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setRelationsMap(relationMap);
		Assertions.assertThat(entityGenerator.updateFieldsListInRelationMap(entityDetails)).isEqualTo(entityDetails);
	}

	@Test
	public void updateJoinColumnName_joinColumnAndReferenceColumnAreNotSame_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogId");
		details.setFieldType("Long");
		details.setDescription("blogDescriptiveField");

		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details);


		JoinDetails joinDetails = new JoinDetails();
		joinDetails.setReferenceColumn("userId");
		joinDetails.setJoinColumn("blogId");

		List<JoinDetails> joinDetailsList = new ArrayList<JoinDetails>();
		joinDetailsList.add(joinDetails);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");
		relationDetails.setJoinDetails(joinDetailsList);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);

		Assertions.assertThat(entityGenerator.updateJoinColumnName(entityDetails, relationDetails)).isEqualTo(entityDetails);

	}

	@Test
	public void updateJoinColumnName_joinDetailsAreNull_returnEntityDetails()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogId");
		details.setFieldType("Long");
		details.setDescription("blogDescriptiveField");

		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details);

		RelationDetails relationDetails= new RelationDetails();
		relationDetails.setIsParent(true);
		relationDetails.setRelation("OneToOne");

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);

		Assertions.assertThat(entityGenerator.updateJoinColumnName(entityDetails, relationDetails)).isEqualTo(entityDetails);
	}

	@Test
	public void validateAuthenticationTable_entityDetailsMapIsNull_returnMap()
	{
		Assertions.assertThat(entityGenerator.validateAuthenticationTable(null, AUTHENTICATION_TABLE, AuthenticationType.DATABASE)).isEqualTo(null);
	}

	@Test
	public void validateAuthenticationTable_entityDetailsMapIsNotNull_returnMap()
	{
		Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
		entityDetailsMap.put("user", new EntityDetails());
		Mockito.doReturn(entityDetailsMap).when(entityGenerator).getAuthenticationTableFieldsMapping(any(HashMap.class),anyString(),any(AuthenticationType.class));
		Assertions.assertThat(entityGenerator.validateAuthenticationTable(entityDetailsMap, AUTHENTICATION_TABLE, AuthenticationType.DATABASE)).isEqualTo(entityDetailsMap);
	}

	@Test
	public void displayAuthFieldsAndGetMapping_entityDetailsMapIsNotNull_returnMap()
	{
		Map<String,FieldDetails> authFields=new HashMap<String, FieldDetails>();
		authFields.put("UserName", null);
		authFields.put("Password", null);

		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");

		FieldDetails details2 = new FieldDetails();
		details2.setFieldName("pass");
		details2.setFieldType("String");

		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details2);
		fDetails.add(details1);


		Map<String,FieldDetails> updated=new HashMap<String, FieldDetails>();
		updated.put("UserName", details);
		updated.put("Password", details2);

		Mockito.doReturn(3,1,1).when(mockedUserInput).getFieldsInput(any(Integer.class));
		Assertions.assertThat(entityGenerator.displayAuthFieldsAndGetMapping(authFields, fDetails)).isEqualTo(updated);

	}

	@Test
	public void getFieldsList_fieldsListIsNotEmpty_returnList()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("blogId");
		details1.setFieldType("Long");

		Map<String,FieldDetails> fieldDetailsMap= new HashMap<String, FieldDetails>();
		fieldDetailsMap.put("blogId",details1);
		fieldDetailsMap.put("blogName",details);

		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setFieldsMap(fieldDetailsMap);

		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);

		Assertions.assertThat(entityGenerator.getFieldsList(entityDetails)).isEqualTo(fDetails);
	}

	@Test
	public void getAuthenticationTableFieldsMapping_fieldsListIsNotEmpty_returnList()
	{
		FieldDetails details = new FieldDetails();
		details.setFieldName("blogName");
		details.setFieldType("String");

		FieldDetails details1 = new FieldDetails();
		details1.setFieldName("pass");
		details1.setFieldType("String");

		List<FieldDetails> fDetails = new ArrayList<FieldDetails>();
		fDetails.add(details);
		fDetails.add(details1);

		Map<String,FieldDetails> updated=new HashMap<String, FieldDetails>();
		updated.put("UserName", details);
		updated.put("Password", details1);

		Map<String,EntityDetails> entityDetailsMap= new HashMap<String, EntityDetails>();
		EntityDetails entityDetails = new EntityDetails();
		entityDetails.setAuthenticationFieldsMap(updated);
		entityDetailsMap.put("user", entityDetails);

		Mockito.doReturn(fDetails).when(entityGenerator).getFieldsList(any(EntityDetails.class));
		Mockito.doReturn(updated).when(entityGenerator).displayAuthFieldsAndGetMapping(any(HashMap.class), any(List.class));

		Assertions.assertThat(entityGenerator.getAuthenticationTableFieldsMapping(entityDetailsMap, AUTHENTICATION_TABLE, AuthenticationType.DATABASE)).isEqualTo(entityDetailsMap);
	}

	@Test
	public void generateAutheticationEntities_parametersAreValid_returnNothing()
	{
		String entityName = "entity";
		Map<String, EntityDetails> details = new HashMap<String,EntityDetails>();
		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName+2);

		details.put(entityName, entityDetails);
		Map<String, Object> root = new HashMap<>();

		root.put("PackageName", PACKAGE_NAME);
		root.put("Cache", true);
		root.put("CommonModulePackage" , PACKAGE_NAME.concat(".commonmodule"));
		root.put("AuthenticationType",AuthenticationType.DATABASE);
		root.put("SchemaName",SCHEMA_NAME);

		root.put("UserInput","true");
		root.put("AuthenticationTable", entityName);

		root.put("ClassName", entityName);
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());

		Mockito.doReturn(new HashMap<String, Object>()).when(entityGenerator).getAuthenticationEntitiesTemplates(anyString(), anyString(),any(AuthenticationType.class));
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(),  anyString());
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(AUTHENTICATION_TABLE);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		entityGenerator.generateAutheticationEntities(details,SCHEMA_NAME, PACKAGE_NAME, destPath.getAbsolutePath(), authenticationInfo);
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(),  anyString());
	}

	@Test
	public void getAuthenticationEntitiesTemplates_autenticationTableIsNotNull_returnTemplatesMap()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/UserpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Map<String,Object> expectedList = new HashMap<String,Object>();
		expectedList.put("/PermissionAppService.java.ftl","/PermissionAppService.java");
		expectedList.put("/UserpermissionAppService.java.ftl","/NewUserpermissionAppService.java");
		expectedList.put("/UserroleAppService.java.ftl","/NewUserroleAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());

		Assertions.assertThat(entityGenerator.getAuthenticationEntitiesTemplates(destPath.getAbsolutePath(), "NewUser", AuthenticationType.DATABASE)).isEqualTo(expectedList);
	}

	@Test
	public void getAuthenticationEntitiesTemplates_autenticationTableIsNull_returnTemplatesMap()
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("/UserpermissionAppService.java.ftl");
		filesList.add("/UserAppService.java.ftl");
		filesList.add("/UserroleAppService.java.ftl");
		filesList.add("/PermissionAppService.java.ftl");

		Map<String,Object> expectedList = new HashMap<String,Object>();
		expectedList.put("/PermissionAppService.java.ftl","/PermissionAppService.java");
		expectedList.put("/UserpermissionAppService.java.ftl","/UserpermissionAppService.java");
		expectedList.put("/UserAppService.java.ftl","/UserAppService.java");
		expectedList.put("/UserroleAppService.java.ftl","/UserroleAppService.java");

		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).readFilesFromDirectory(anyString());
		Mockito.doReturn(filesList).when(mockedCodeGeneratorUtils).replaceFileNames(any(List.class),anyString());

		Assertions.assertThat(entityGenerator.getAuthenticationEntitiesTemplates(destPath.getAbsolutePath(), null, AuthenticationType.DATABASE)).isEqualTo(expectedList);
	}

	@Test
	public void buildRootMap_autenticationTableIsNull_returnMap()
	{
		String entityName = "entity1";
		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(null);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);

		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName);

		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityName.concat("Entity"));
		root.put("ClassName", entityName);
		root.put("PackageName", PACKAGE_NAME);
		root.put("CommonModulePackage", PACKAGE_NAME.concat(".commonmodule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("TableName", entityDetails.getEntityTableName());
		root.put("SchemaName", SCHEMA_NAME);
		root.put("IdClass", entityDetails.getIdClass());
		root.put("UserInput", null);
		root.put("UserOnly", authenticationInfo.getUserOnly());
		root.put("AuthenticationType",AuthenticationType.DATABASE.getName());
		root.put("AuthenticationTable", "User");
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
 
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());

		Assertions.assertThat(entityGenerator.buildRootMap(entityDetails, entityName, PACKAGE_NAME, SCHEMA_NAME, authenticationInfo)).isEqualTo(root);
	}

	@Test
	public void buildRootMap_autenticationTableIsNotNull_returnMap()
	{
		String entityName = "entity1";

		AuthenticationInfo authenticationInfo = new AuthenticationInfo();
		authenticationInfo.setAuthenticationTable(AUTHENTICATION_TABLE);
		authenticationInfo.setAuthenticationType(AuthenticationType.DATABASE);
		authenticationInfo.setUserOnly(true);

		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, entityName+"id");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setEntityTableName(entityName);

		Map<String, Object> root = new HashMap<>();

		root.put("EntityClassName", entityName.concat("Entity"));
		root.put("ClassName", entityName);
		root.put("PackageName", PACKAGE_NAME);
		root.put("CommonModulePackage", PACKAGE_NAME.concat(".commonmodule"));
		root.put("CompositeKeyClasses", entityDetails.getCompositeKeyClasses());
		root.put("TableName", entityDetails.getEntityTableName());
		root.put("SchemaName", SCHEMA_NAME);
		root.put("IdClass", entityDetails.getIdClass());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("UserInput", "true");
		root.put("UserOnly", authenticationInfo.getUserOnly());
		root.put("AuthenticationType",AuthenticationType.DATABASE.getName());
		root.put("AuthenticationTable",authenticationInfo.getAuthenticationTable());
		root.put("AuthenticationFields", entityDetails.getAuthenticationFieldsMap());
		root.put("DescriptiveField", entityDetails.getEntitiesDescriptiveFieldMap());
		root.put("Fields", entityDetails.getFieldsMap());
		root.put("Relationship", entityDetails.getRelationsMap());
		root.put("PrimaryKeys", entityDetails.getPrimaryKeys());

		Assertions.assertThat(entityGenerator.buildRootMap(entityDetails, entityName, PACKAGE_NAME, SCHEMA_NAME, authenticationInfo)).isEqualTo(root);
	}

	@Test
	public void generateEntityAndIdClass_autenticationTableIsNotNull_returnMap()
	{
		List<String> compositePrimaryKeyEntities= new ArrayList<String>();
		compositePrimaryKeyEntities.add("user");

		EntityDetails entityDetails = new EntityDetails(new HashMap<String, FieldDetails>(), new HashMap<String, RelationDetails>(),SCHEMA_NAME, "userId");
		entityDetails.setEntitiesDescriptiveFieldMap(new HashMap<String, FieldDetails>());
		entityDetails.setIdClass("userId");
		entityDetails.setCompositeKeyClasses(compositePrimaryKeyEntities);

		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "user");
		Mockito.doNothing().when(entityGenerator).generateEntity(any(HashMap.class), any(String.class));
		Mockito.doNothing().when(entityGenerator).generateIdClass(any(HashMap.class), any(String.class));

		entityGenerator.generateEntityAndIdClass(root, entityDetails, PACKAGE_NAME, destPath.getAbsolutePath(), compositePrimaryKeyEntities);
		Mockito.verify(entityGenerator,Mockito.times(1)).generateEntity(any(HashMap.class), any(String.class));
		Mockito.verify(entityGenerator,Mockito.times(1)).generateIdClass(any(HashMap.class), any(String.class));
	}

	@Test
	public void generateEntity_parametersAreValid_returnNothing()
	{
		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "entity1");
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
		entityGenerator.generateEntity(root, destPath.getAbsolutePath());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(), anyString());
	}

	@Test
	public void generateIdClass_parametersAreValid_returnNothing()
	{
		Map<String, Object> root = new HashMap<>();
		root.put("ClassName", "entity1");
		Mockito.doNothing().when(mockedCodeGeneratorUtils).generateFiles(any(HashMap.class), any(HashMap.class), anyString(), anyString());
		entityGenerator.generateIdClass(root, destPath.getAbsolutePath());
		Mockito.verify(mockedCodeGeneratorUtils,Mockito.times(1)).generateFiles(any(HashMap.class), any(HashMap.class),  anyString(), anyString());
	}


}
