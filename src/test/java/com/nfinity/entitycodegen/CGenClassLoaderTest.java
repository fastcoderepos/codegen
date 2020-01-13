package com.nfinity.entitycodegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.FileVisitResult;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
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
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.nfinity.codegen.CommandUtils;

@RunWith(SpringJUnit4ClassRunner.class)
public class CGenClassLoaderTest {


	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	CGenClassLoader cGenClassLoader;

	@Mock
	CommandUtils mockedCommandUtils;

	File destPath;


	private static URLClassLoader classLoader;
	private static String path =".";
	//	private static URLClassLoader classLoader;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(cGenClassLoader);
		destPath = folder.newFolder("tempFolder");

	}

	@After
	public void tearDown() throws Exception {

	}

	@Test
	public void findClasses_pathIsValid_returnClassesList() throws ClassNotFoundException, IOException
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("com.nfin.test.domain.model.Temp.Addresses");
		filesList.add("com.nfin.test.domain.model.Temp.Users");

		String path = System.getProperty("user.dir").replace("\\", "/");
		
		URLClassLoader urlClassLoader = new URLClassLoader(new URL[]{new File(path).toURI().toURL()},Thread.currentThread().getContextClassLoader());
		ArrayList<Class<?>> classes = new ArrayList<Class<?>>();

		for (String fileName : filesList) {
			Class<?> cs = urlClassLoader.loadClass(fileName);
			classes.add(cs);
		}

		urlClassLoader.close();
		Map<String,String> classFiles= new HashMap<String, String>();
		classFiles.put("com.nfin.test.domain.model.Temp.Addresses","com.nfin.test.domain.model.Temp.Addresses");
		classFiles.put("com.nfin.test.domain.model.Temp.Users","com.nfin.test.domain.model.Temp.Users");
		cGenClassLoader.setPath(path);
		Mockito.doReturn(classFiles).when(cGenClassLoader).retrieveClasses(any(Path.class),anyString());
		Assertions.assertThat(cGenClassLoader.findClasses("com.nfin.test.domain.model.Temp")).isEqualTo(classes);

	}
	
	@Test(expected= ClassNotFoundException.class)
	public void findClasses_packageAndPathIsNotValid_classNotFoundException() throws ClassNotFoundException, IOException
	{
		List<String> filesList = new ArrayList<String>();
		filesList.add("com.nfin.test.domain.model.Temp.Addresses");
		filesList.add("com.nfin.test.domain.model.Temp.Users");

		String path = System.getProperty("user.dir").replace("\\", "/");
        ArrayList<Class<?>> classes = new ArrayList<Class<?>>();

		Map<String,String> classFiles= null;
	
		cGenClassLoader.setPath(path);
		Mockito.doReturn(classFiles).when(cGenClassLoader).retrieveClasses(any(Path.class),anyString());
		Assertions.assertThat(cGenClassLoader.findClasses("")).isEqualTo(classes);

	}
	
	
	@Test
	public void retrieveClasses_pathIsValid_returnClassesMap() throws ClassNotFoundException, IOException
	{
		String path = System.getProperty("user.dir").replace("\\", "/")+"/src/test/resources";
		Map<String,String> classFiles = new HashMap<String,String>();
		classFiles.put("com.nfin.test.domain.model.Temp.Addresses", path.concat("/com/nfin/test/domain/model/Temp/Addresses.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Books", path.concat("/com/nfin/test/domain/model/Temp/Books.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Checkouts", path.concat("/com/nfin/test/domain/model/Temp/Checkouts.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Cust", path.concat("/com/nfin/test/domain/model/Temp/Cust.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.CustId", path.concat("/com/nfin/test/domain/model/Temp/CustId.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Ord", path.concat("/com/nfin/test/domain/model/Temp/Ord.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Reviews", path.concat("/com/nfin/test/domain/model/Temp/Reviews.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Users", path.concat("/com/nfin/test/domain/model/Temp/Users.class"));
		
		Assertions.assertThat(cGenClassLoader.retrieveClasses(Paths.get(path),"com.nfin.test.domain.model.Temp")).isEqualTo(classFiles);
	}
	
	@Test(expected= NoSuchFileException.class)
	public void retrieveClasses_pathIsValid_throwsIOException() throws ClassNotFoundException, IOException
	{
		String path = System.getProperty("user.dir").replace("\\", "/") + "/src/java/resources";
		Map<String,String> classFiles = new HashMap<String,String>();
		classFiles.put("com.nfin.test.domain.model.Temp.Addresses", path.concat("/com/nfin/test/domain/model/Temp/Addresses.class"));
		classFiles.put("com.nfin.test.domain.model.Temp.Books", path.concat("/com/nfin/test/domain/model/Temp/Books.class"));
		
		Assertions.assertThat(cGenClassLoader.retrieveClasses(Paths.get(path),"com.test")).isEqualTo(classFiles);
	}

}
