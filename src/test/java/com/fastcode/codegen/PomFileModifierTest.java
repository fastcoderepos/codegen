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
import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.fastcode.codegen.Dependency;
import com.fastcode.codegen.PomFileModifier;
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
	public void updatePomFile_parametersAreValid_ReturnNothing() throws IOException {
		
		Mockito.doNothing().when(pomFileModifier).addDependenciesAndPluginsToPom(anyString(),any(List.class));
		Mockito.doReturn(new Dependency("", "", "")).when(pomFileModifier).getDatabaseDependency(anyString());
		pomFileModifier.updatePomFile(destPath.getAbsolutePath(), "database", "postgresql", true);
		
		Mockito.verify(pomFileModifier,Mockito.times(1)).addDependenciesAndPluginsToPom(anyString(),any(List.class));

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
