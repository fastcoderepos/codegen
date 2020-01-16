package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.codegen.FolderContentReader;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class FolderContentReaderTest {
	
	private static final String BACKEND_TEMPLATE_FOLDER = "/templates/testTemplates";
	
	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	FolderContentReader folderContentReader;
	
	@Mock
	CodeGeneratorUtils mockedUtils;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
    private File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(folderContentReader);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void getFilesFromFileSystem_PathIsValid_ReturnFilesCollection() throws IOException {
		File newTempFolder = folder.newFolder("tempFolder","testTemplates");
		File newFile = File.createTempFile("SearchUtils", ".java.ftl", newTempFolder);
		File newFile1 = File.createTempFile("SearchCriteria", ".java.ftl", newTempFolder);
	
		Collection<File> files = new ArrayList<File>();
		files.add(newTempFolder);
		files.add(newFile1);
		files.add(newFile);
		
		//File path = new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/"+ BACKEND_TEMPLATE_FOLDER);
		Assertions.assertThat(folderContentReader.getFilesFromFileSystem(newTempFolder)).isEqualTo(files);
	}
	
//	@Test
//	public void getFilesFromFolder_PathIsForGetFilesFromFileSystem_ReturnList() throws IOException, URISyntaxException {
//		File newTempFolder = folder.newFolder("tempFolder","testTemplates");
//		File newFile = File.createTempFile("SearchUtils", ".java.ftl", newTempFolder);
//		File newFile1 = File.createTempFile("SearchCriteria", ".java.ftl", newTempFolder);
//	
//		Collection<File> files = new ArrayList<File>();
//		files.add(newTempFolder);
//		files.add(newFile1);
//		files.add(newFile);
//		
//		List<String> filteredFiles= new ArrayList<String>();
//		filteredFiles.add(newFile1.getAbsolutePath());
//		filteredFiles.add(newFile.getAbsolutePath());
//		
//		//Class<?> clas= FolderContentReader.class.getClass();
//		//URL url = clas.getResource(newTempFolder.getAbsolutePath());
//		//System.out.println(" URL " + url.getPath()) ;
//		//URI uri = url.toURI();
//		//Mockito.doReturn(url).when(url.toURI());
//		//Mockito.doReturn(uri).when(clas.getResource(anyString()));
//		Mockito.doReturn(files).when(mockedFolderContentReader).getFilesFromFileSystem(any(File.class));
//		
//		//File path = new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/"+ BACKEND_TEMPLATE_FOLDER);
//		Assertions.assertThat(folderContentReader.getFilesFromFolder(BACKEND_TEMPLATE_FOLDER)).isEqualTo(filteredFiles);
//	}
//	

}
