package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.mockito.ArgumentMatchers.any;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.assertj.core.api.Assertions;
import org.hamcrest.collection.IsIterableContainingInOrder;
import org.junit.After;
import org.junit.Assert;
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
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.fastcode.codegen.Dependency;
import com.fastcode.codegen.PomFileModifier;
import com.fastcode.entitycodegen.AuthenticationType;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class PomFileModifierTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private PomFileModifier pomFileModifier;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private File destPath;

	@Before 
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(pomFileModifier);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		doNothing().when(loggerMock).info(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}

	@Test
	public void updatePomFile_parametersAreValid_ReturnNothing() {

		Mockito.doNothing().when(pomFileModifier).addDependenciesAndPluginsToPom(anyString(),any(List.class));
		Mockito.doReturn(new ArrayList<Dependency>()).when(pomFileModifier).getDependenciesList(any(AuthenticationType.class),anyString(),any(Boolean.class));
		pomFileModifier.updatePomFile(destPath.getAbsolutePath(), AuthenticationType.DATABASE, "postgresql", true);

		Mockito.verify(pomFileModifier,Mockito.times(1)).addDependenciesAndPluginsToPom(anyString(),any(List.class));
	}

	@Test
	public void getDependenciesList_cacheIsFalse_AuthenticationTypeIsNone_ReturnList() {
		List<Dependency> dependencies = new ArrayList<Dependency>();

		Dependency mapstruct = new Dependency("org.mapstruct", "mapstruct", "1.2.0.Final");
		Dependency querydsljpa = new Dependency("com.querydsl", "querydsl-jpa", "4.2.1");
		Dependency querydslapt= new Dependency("com.querydsl", "querydsl-apt", "4.2.1");
		Dependency apache_commons = new Dependency("org.apache.commons", "commons-lang3", "3.8.1");
		Dependency h2 = new Dependency("com.h2database","h2","");  
		Dependency springFoxSwagger = new Dependency("io.springfox","springfox-swagger2","2.7.0");
		Dependency springFoxSwaggerUI = new Dependency("io.springfox","springfox-swagger-ui","2.7.0");
		Dependency springFoxDataRest = new Dependency("io.springfox","springfox-data-rest","2.8.0");
		Dependency httpComponents = new Dependency("org.apache.httpcomponents","httpclient","4.5");

		Dependency gson = new Dependency("com.google.code.gson","gson","2.8.5");

		dependencies.add(mapstruct);
		dependencies.add(querydsljpa);
		dependencies.add(querydslapt);
		dependencies.add(apache_commons);
		dependencies.add(h2);
		dependencies.add(springFoxSwagger);
		dependencies.add(springFoxSwaggerUI);
		dependencies.add(springFoxDataRest);
		dependencies.add(httpComponents);
		dependencies.add(gson);

		Mockito.doReturn(null).when(pomFileModifier).getDatabaseDependency(anyString());
		List<Dependency> actual = pomFileModifier.getDependenciesList(AuthenticationType.NONE, "abc", false);
		Assertions.assertThat(actual).size().isEqualTo(10);
        matchDependencies(actual, dependencies);

	}
	
	@Test
	public void getDependenciesList_cacheIsTrue_AuthenticationTypeIsNotNone_ReturnList() {
		List<Dependency> dependencies = new ArrayList<Dependency>();

		Dependency mapstruct = new Dependency("org.mapstruct", "mapstruct", "1.2.0.Final");
		Dependency querydsljpa = new Dependency("com.querydsl", "querydsl-jpa", "4.2.1");
		Dependency querydslapt= new Dependency("com.querydsl", "querydsl-apt", "4.2.1");
		Dependency apache_commons = new Dependency("org.apache.commons", "commons-lang3", "3.8.1");
		Dependency h2 = new Dependency("com.h2database","h2","");  
		Dependency springFoxSwagger = new Dependency("io.springfox","springfox-swagger2","2.7.0");
		Dependency springFoxSwaggerUI = new Dependency("io.springfox","springfox-swagger-ui","2.7.0");
		Dependency springFoxDataRest = new Dependency("io.springfox","springfox-data-rest","2.8.0");
		Dependency httpComponents = new Dependency("org.apache.httpcomponents","httpclient","4.5");
		Dependency gson = new Dependency("com.google.code.gson","gson","2.8.5");
		Dependency springDataRedis = new Dependency("org.springframework.data","spring-data-redis","2.1.9.RELEASE");
		Dependency redisClient = new Dependency("redis.clients","jedis","2.9.0","jar","compile");
		Dependency json_web_token =new Dependency("io.jsonwebtoken","jjwt","0.9.0");
		Dependency ldap_security = new Dependency("org.springframework.security","spring-security-ldap","5.1.1.RELEASE");
		Dependency nimbus= new Dependency("com.nimbusds","nimbus-jose-jwt","7.7");
		
		dependencies.add(springDataRedis);
		dependencies.add(redisClient);
		dependencies.add(json_web_token);
		dependencies.add(ldap_security);
		dependencies.add(nimbus);
		dependencies.add(mapstruct);
		dependencies.add(querydsljpa);
		dependencies.add(querydslapt);
		dependencies.add(apache_commons);
		dependencies.add(h2);
		dependencies.add(springFoxSwagger);
		dependencies.add(springFoxSwaggerUI);
		dependencies.add(springFoxDataRest);
		dependencies.add(httpComponents);
		dependencies.add(gson);
		dependencies.add(new Dependency("org.postgresql","postgresql","42.2.5"));
		
		Mockito.doReturn(new Dependency("org.postgresql","postgresql","42.2.5")).when(pomFileModifier).getDatabaseDependency(anyString());
		List<Dependency> actual = pomFileModifier.getDependenciesList(AuthenticationType.DATABASE, "postgresql", true);
		Assertions.assertThat(actual).size().isEqualTo(16);
        matchDependencies(actual, dependencies);

	}

	private void matchDependencies(List<Dependency> actual, List<Dependency> expected)
	{
		int i=0;

		for(Dependency d : actual)
		{
			Assertions.assertThat(expected.get(i).getArtifactId()).isEqualTo(d.getArtifactId());
			Assertions.assertThat(expected.get(i).getGroupId()).isEqualTo(d.getGroupId());
			Assertions.assertThat(expected.get(i).getVersion()).isEqualTo(d.getVersion());
			i++;
		}
	}

	@Test
	public void getDatabaseDependency_stringIsValid_ReturnPostgresDependency() {

		Assertions.assertThat(pomFileModifier.getDatabaseDependency("postgresql")).isEqualToComparingFieldByFieldRecursively(new Dependency("org.postgresql","postgresql","42.2.5"));
	}
	
	@Test
	public void getDatabaseDependency_stringIsValid_ReturnMySqlDependency() {

		Assertions.assertThat(pomFileModifier.getDatabaseDependency("mysql")).isEqualToComparingFieldByFieldRecursively(new Dependency("mysql","mysql-connector-java","8.0.15"));
	}
	
	@Test
	public void getDatabaseDependency_stringIsValid_ReturnOracleDependency() {

		Assertions.assertThat(pomFileModifier.getDatabaseDependency("oracle")).isEqualToComparingFieldByFieldRecursively(new Dependency("com.oracle","ojdbc8","19.3.0.0"));
	}


	@Test
	public void getDatabaseDependency_stringIsNotValid_ReturnNull() {

		Assertions.assertThat(pomFileModifier.getDatabaseDependency("abc")).isEqualTo(null);
	}

	@Test
	public void addDependenciesAndPluginsToPom_pathIsValid_returnNothing() throws IOException
	{
		File file1 = new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/testFiles/testPom.xml");
		File file = folder.newFile("pom.xml");
		FileUtils.copyFile(file1, file);

		List<Dependency> dependencies = new ArrayList<Dependency>();

		Dependency postgres = new Dependency("org.postgresql","postgresql","42.2.5");
		Dependency h2 = new Dependency("com.h2database","h2","");

		dependencies.add(postgres);
		dependencies.add(h2);

		Mockito.doReturn(new ArrayList<>()).when(pomFileModifier).getPlugins(any(Document.class));
		pomFileModifier.addDependenciesAndPluginsToPom(file.getAbsolutePath(), dependencies);
		Mockito.verify(pomFileModifier,Mockito.times(1)).getPlugins(any(Document.class));
	}

	@Test
	public void getMapStructPlugIn_docIsValid_returnElement() throws IOException, Exception
	{ 
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.newDocument();
		Element mapStruct = doc.createElement("plugin");

		Element elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.apache.maven.plugins"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("maven-compiler-plugin"));
		mapStruct.appendChild(elem);

		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("3.5.1"));
		mapStruct.appendChild(elem);

		Element configuration = doc.createElement("configuration");
		Element useIncrementalCompilation = doc.createElement("useIncrementalCompilation");
		useIncrementalCompilation.appendChild(doc.createTextNode("false"));
		Element source = doc.createElement("source");
		source.appendChild(doc.createTextNode("1.8"));
		Element target = doc.createElement("target");
		target.appendChild(doc.createTextNode("1.8"));

		Element annotationProcessorPaths = doc.createElement("annotationProcessorPaths");
		Element path = doc.createElement("path");
		elem = doc.createElement("groupId");
		elem.appendChild(doc.createTextNode("org.mapstruct"));
		path.appendChild(elem);
		elem = doc.createElement("artifactId");
		elem.appendChild(doc.createTextNode("mapstruct-processor"));
		path.appendChild(elem);
		elem = doc.createElement("version");
		elem.appendChild(doc.createTextNode("1.2.0.Final"));
		path.appendChild(elem);

		annotationProcessorPaths.appendChild(path);
		configuration.appendChild(useIncrementalCompilation);
		configuration.appendChild(source);
		configuration.appendChild(target);
		configuration.appendChild(annotationProcessorPaths);

		mapStruct.appendChild(configuration);


		Assertions.assertThat(pomFileModifier.getMapStructPlugIn(doc)).isEqualToComparingFieldByFieldRecursively(mapStruct); 
	}

	@Test
	public void getPlugins_docIsValid_returnElementList() throws IOException, Exception
	{
		List<Element> elemList = new ArrayList<Element>();
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.newDocument();
		Element element=doc.createElement("plugin");
		elemList.add(element);
		elemList.add(element);
		Mockito.doReturn(element).when(pomFileModifier).getMapStructPlugIn(doc);

		Assertions.assertThat(pomFileModifier.getPlugins(doc)).contains(element);
	}
}
