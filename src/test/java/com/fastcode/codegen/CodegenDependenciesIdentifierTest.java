package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;

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

import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class CodegenDependenciesIdentifierTest {
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private CodegenDependenciesIdentifier dependenciesIdentifier;

	@Mock
	private CommandUtils mockedCommandUtils;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
    File destPath;
    String testValue = "abc";
	String packageName = "com.nfinity.demo";
	String entityName = "entity1";
	String moduleName = "entity-1";
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(dependenciesIdentifier);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		doNothing().when(loggerMock).info(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void isSpringCliInstalled_springIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Spring CLI v2.1.8.RELEASE";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isSpringCliInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isSpringCliInstalled_springIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Spring CLI v1.4.8.RELEASE";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isSpringCliInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isSpringCliInstalled_springIsNotInstalled_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Assertions.assertThat(dependenciesIdentifier.isSpringCliInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isMavenInstalled_mavenIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Apache Maven 3.6.2 (40f52333136460af0dc0d7232c0dc0bcf0d";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isMavenInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isMavenInstalled_mavenIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Apache Maven 3.5.2 (40f52333136460af0dc0d7232c0dc0bcf0d";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isMavenInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isMavenInstalled_mavenIsNotInstalled_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Assertions.assertThat(dependenciesIdentifier.isMavenInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isJavaInstalled_javaIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
	
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isJavaInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isJavaInstalled_javaIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
	
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isJavaInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isNodeInstalled_nodeIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "v10.16.3";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isNodeInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isNodeInstalled_nodeIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "v10.16.3";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isNodeInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isNodeInstalled_nodeIsNotInstalled_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Assertions.assertThat(dependenciesIdentifier.isNodeInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isPsqlInstalled_psqlIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "psql (PostgreSQL) 10.10";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isPsqlInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isPsqlInstalled_psqlIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "psql (PostgreSQL) 10.10";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isPsqlInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isPsqlInstalled_psqlIsNotInstalled_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Assertions.assertThat(dependenciesIdentifier.isPsqlInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isAngularInstalled_angularIsInstalledAndVersionIsValid_returnTrue() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Angular CLI: 8.3.5";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isAngularInstalled()).isEqualTo(true);
	}
	
	@Test
	public void isAngularInstalled_angularIsInstalledAndVersionIsNotValid_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "Angular CLI: 8.3.5";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Mockito.doReturn(-1).when(mockedCommandUtils).versionCompare(anyString(), anyString());
		Assertions.assertThat(dependenciesIdentifier.isAngularInstalled()).isEqualTo(false);
	}
	
	@Test
	public void isAngularInstalled_angularIsNotInstalled_returnFalse() {
		
		dependenciesIdentifier.setDestinationPath(destPath.getAbsolutePath());
		String response = "";
	
		Mockito.doReturn(response).when(mockedCommandUtils).runProcess(anyString(),anyString());
		Assertions.assertThat(dependenciesIdentifier.isAngularInstalled()).isEqualTo(false);
	}
	
	@Test
	public void checkDependencies_dependenciesAreInstalled_returnTrue() {
		
		Mockito.doReturn(true).when(dependenciesIdentifier).isSpringCliInstalled();
		Mockito.doReturn(true).when(dependenciesIdentifier).isMavenInstalled();
		Mockito.doReturn(true).when(dependenciesIdentifier).isJavaInstalled();
		Mockito.doReturn(true).when(dependenciesIdentifier).isNodeInstalled();
		Mockito.doReturn(true).when(dependenciesIdentifier).isPsqlInstalled();
		Mockito.doReturn(true).when(dependenciesIdentifier).isAngularInstalled();
		
		Assertions.assertThat(dependenciesIdentifier.checkDependencies()).isEqualTo(true);
		
	}
	
	@Test
	public void checkDependencies_dependenciesAreNotInstalled_returnFalse() {
		
		Mockito.doReturn(true).when(dependenciesIdentifier).isSpringCliInstalled();
		Mockito.doReturn(false).when(dependenciesIdentifier).isMavenInstalled();
//		Mockito.doReturn(true).when(dependenciesIdentifier).isJavaInstalled();
//		Mockito.doReturn(true).when(dependenciesIdentifier).isNodeInstalled();
//		Mockito.doReturn(true).when(dependenciesIdentifier).isPsqlInstalled();
//		Mockito.doReturn(true).when(dependenciesIdentifier).isAngularInstalled();
//		
		Assertions.assertThat(dependenciesIdentifier.checkDependencies()).isEqualTo(false);
	}

//	public boolean checkDependencies()
//	{
//		if(!isSpringCliInstalled() || !isMavenInstalled() || !isJavaInstalled() || !isNodeInstalled() || !isPsqlInstalled() || !isAngularInstalled())
//		{
//			return false;
//		}
//		
//		return true;
//	}

}
