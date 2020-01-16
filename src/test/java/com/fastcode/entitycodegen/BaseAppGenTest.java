package com.fastcode.entitycodegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;

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

import com.fastcode.codegen.CommandUtils;
import com.fastcode.entitycodegen.BaseAppGen;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class BaseAppGenTest {

	@Rule
    public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private BaseAppGen baseAppGen;
	
	@Mock
	private CommandUtils mockedCommandUtils;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
    File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(baseAppGen);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void CompileApplication_pathIsNotNull_ReturnNothing()
	{
		Mockito.doReturn("").when(mockedCommandUtils).runProcess(any(String[].class), anyString(),any(Boolean.class));
	    baseAppGen.CompileApplication(destPath.getAbsolutePath());
	    Mockito.verify(mockedCommandUtils,Mockito.times(2)).runProcess(any(String[].class), anyString(),any(Boolean.class));
	}
	
	@Test
	public void CreateBaseApplication_directoryIsNotEmpty_ReturnNothing()
	{
		Mockito.doReturn("").when(mockedCommandUtils).runProcess(any(String[].class), anyString(),any(Boolean.class));
	    Mockito.doNothing().when(baseAppGen).CompileApplication(anyString());
	    baseAppGen.CreateBaseApplication(destPath.getAbsolutePath(), "demo", "com.nfinity", "web", true, "");
	    Mockito.verify(mockedCommandUtils,Mockito.times(1)).runProcess(any(String[].class), anyString(),any(Boolean.class));
	    Mockito.verify(baseAppGen,Mockito.times(1)).CompileApplication(anyString());
	    
	}

}
