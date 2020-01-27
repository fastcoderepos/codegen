package com.fastcode.codegen;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.contrib.java.lang.system.ExpectedSystemExit;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Matchers;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.slf4j.Logger;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.AuthenticationClassesTemplateGenerator;
import com.fastcode.codegen.CodeGenerator;
import com.fastcode.codegen.CommonModuleTemplateGenerator;
import com.fastcode.codegen.FrontendBaseTemplateGenerator;
import com.fastcode.codegen.GitRepositoryManager;
import com.fastcode.codegen.ModulesGenerator;
import com.fastcode.codegen.PomFileModifier;
import com.fastcode.entitycodegen.AuthenticationConstants;
import com.fastcode.entitycodegen.BaseAppGen;
import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.EntityGenerator;
import com.fastcode.entitycodegen.UserInput;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class ModulesGeneratorTest {

	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@Rule
	public final ExpectedSystemExit exit = ExpectedSystemExit.none();

	@InjectMocks
	@Spy
	private ModulesGenerator modulesGenerator;
	
	@Mock
	UserInput mockedUserInput;
	
	@Mock
	private CommonModuleTemplateGenerator mockedCommonModule;
	
	@Mock
	private AuthenticationClassesTemplateGenerator mockedAuthClasses;
	
	@Mock
	private CodeGenerator mockedCodeGenerator;
	
	@Mock
    private EntityGenerator mockedEntityGenerator;
	
	@Mock
	private BaseAppGen mockedBaseAppGen;
	
	@Mock
	private FrontendBaseTemplateGenerator mockedFrontendGenerator;
	
	@Mock
	private GitRepositoryManager mockedGitRepositoryManager;
	
	@Mock
	private PomFileModifier mockedPomFileModifier;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(modulesGenerator);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		doNothing().when(loggerMock).info(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void generateCode_gitIsInstalledAndInitializedButHasUncommitedChanges_returnNothing() throws IOException
	{
		UserInput input = new UserInput();
		input.setDestinationPath(destPath.getAbsolutePath());
		input.setUpgrade(true);
		Mockito.doNothing().when(mockedGitRepositoryManager).setDestinationPath(anyString());
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInstalled();
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInitialized();
		Mockito.doReturn(true).when(mockedUserInput).getUpgrade();
		Mockito.doReturn(true).when(mockedGitRepositoryManager).hasUncommittedChanges();
		
		modulesGenerator.generateCode(input);
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(1)).hasUncommittedChanges();
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(0)).CopyGitFiles();
	
	}
	
	@Test
	public void generateCode_gitHasNotUncommitedChangesButUnableToCreateUpgradeBranch_returnNothing() throws IOException
	{ 
		UserInput input = new UserInput();
		input.setDestinationPath(destPath.getAbsolutePath());
		input.setUpgrade(true);

		Mockito.doNothing().when(mockedGitRepositoryManager).setDestinationPath(anyString());
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInstalled();
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInitialized();
		Mockito.doReturn(true).when(mockedUserInput).getUpgrade();
		Mockito.doReturn(false).when(mockedGitRepositoryManager).hasUncommittedChanges();
		Mockito.doReturn("test").when(mockedGitRepositoryManager).getCurrentBranch();
		Mockito.doReturn(false).when(mockedGitRepositoryManager).createUpgradeBranch();
		
		modulesGenerator.generateCode(input);
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(1)).createUpgradeBranch();
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(0)).CopyGitFiles();
	}
	
	@Test
	public void generateCode_gitUpgradeIsFalseCopyGitFilesAuthenticationTypeIsNone_returnNothing() throws IOException
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		//authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, entityName);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, "none");
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "false");
		
		UserInput input = new UserInput();
		input.setDestinationPath(destPath.getAbsolutePath());
		input.setUpgrade(false);
		input.setCache(true);
		input.setGroupArtifactId("com.nfinity.test");
		input.setAuthenticationMap(authenticationInputMap);
		input.setConnectionStr("test");
		input.setCache(false);
	
		Map<String, EntityDetails> details= new HashMap<String, EntityDetails>();
		Mockito.doNothing().when(mockedGitRepositoryManager).setDestinationPath(anyString());
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInstalled();
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInitialized();
		Mockito.doReturn(false).when(mockedUserInput).getUpgrade();
		Mockito.doNothing().when(mockedGitRepositoryManager).CopyGitFiles();
		Mockito.doNothing().when(mockedBaseAppGen).CreateBaseApplication(anyString(), anyString(),anyString(), anyString(), any(Boolean.class), anyString());
        Mockito.doReturn(details).when(mockedEntityGenerator).generateEntities(anyString(), anyString(), any(List.class),anyString(), anyString(),any(HashMap.class));
		Mockito.doNothing().when(mockedPomFileModifier).updatePomFile(anyString(), anyString(), any(Boolean.class));
		Mockito.doNothing().when(mockedCommonModule).generateCommonModuleClasses(anyString(),anyString());
        Mockito.doNothing().when(mockedBaseAppGen).CompileApplication(anyString());
        Mockito.doNothing().when(mockedFrontendGenerator).generate(anyString(), anyString(),anyString(), anyString());
        
        Mockito.doNothing().when(mockedCodeGenerator).generateAll(anyString(), anyString(), anyString(), any(Boolean.class), anyString(), any(HashMap.class), anyString(), anyString(), any(HashMap.class));
        Mockito.doNothing().when(mockedGitRepositoryManager).addToGitRepository(any(Boolean.class), anyString());
        
        exit.expectSystemExitWithStatus(1);
        modulesGenerator.generateCode(input);
    
        Mockito.verify(mockedCodeGenerator).generateAll(anyString(), anyString(), anyString(), any(Boolean.class),anyString(), Matchers.<Map<String, EntityDetails>>any(), anyString(), anyString(), Matchers.<Map<String, String>>any());
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(0)).createUpgradeBranch();
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(1)).CopyGitFiles();
		Mockito.verify(mockedFrontendGenerator,Mockito.times(1)).generate(anyString(), anyString(),anyString(), anyString());
	}
	
	@Test
	public void generateCode_gitUpgradeIsFalseCopyGitFilesAuthenticationTypeIsNotNone_returnNothing() throws IOException
	{
		Map<String,String> authenticationInputMap = new HashMap<String, String>();
		//authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_SCHEMA, entityName);
		authenticationInputMap.put(AuthenticationConstants.AUTHENTICATION_TYPE, "database");
		authenticationInputMap.put(AuthenticationConstants.USERS_ONLY, "false");
		
		UserInput input = new UserInput();
		input.setDestinationPath(destPath.getAbsolutePath());
		input.setUpgrade(false);
		input.setCache(true);
		input.setGroupArtifactId("com.nfinity.test");
		input.setAuthenticationMap(authenticationInputMap);
		input.setConnectionStr("test");
		input.setCache(false);
	
		Map<String, EntityDetails> details= new HashMap<String, EntityDetails>();
		Mockito.doNothing().when(mockedGitRepositoryManager).setDestinationPath(anyString());
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInstalled();
		Mockito.doReturn(true).when(mockedGitRepositoryManager).isGitInitialized();
		Mockito.doReturn(false).when(mockedUserInput).getUpgrade();
		Mockito.doNothing().when(mockedGitRepositoryManager).CopyGitFiles();
		Mockito.doNothing().when(mockedBaseAppGen).CreateBaseApplication(anyString(), anyString(),anyString(), anyString(), any(Boolean.class), anyString());
        Mockito.doReturn(details).when(mockedEntityGenerator).generateEntities(anyString(), anyString(), any(List.class),anyString(), anyString(),any(HashMap.class));
		Mockito.doNothing().when(mockedPomFileModifier).updatePomFile(anyString(), anyString(), any(Boolean.class));
		Mockito.doNothing().when(mockedCommonModule).generateCommonModuleClasses(anyString(),anyString());
        Mockito.doNothing().when(mockedBaseAppGen).CompileApplication(anyString());
        Mockito.doNothing().when(mockedFrontendGenerator).generate(anyString(), anyString(),anyString(), anyString());
        Mockito.doNothing().when(mockedAuthClasses).generateAutheticationClasses(anyString(), anyString(), any(Boolean.class),anyString(), any(HashMap.class), any(HashMap.class));
        Mockito.doNothing().when(mockedCodeGenerator).generateAll(anyString(), anyString(), anyString(), any(Boolean.class), anyString(), any(HashMap.class), anyString(), anyString(), any(HashMap.class));
        Mockito.doNothing().when(mockedGitRepositoryManager).addToGitRepository(any(Boolean.class), anyString());
        
        exit.expectSystemExitWithStatus(1); 
        modulesGenerator.generateCode(input);
      
        Mockito.verify(mockedCodeGenerator).generateAll(anyString(), anyString(), anyString(), any(Boolean.class), anyString(), Matchers.<Map<String, EntityDetails>>any(), anyString(), anyString(),Matchers.<Map<String, String>>any());
        Mockito.verify(mockedAuthClasses).generateAutheticationClasses(anyString(), anyString(), any(Boolean.class),anyString(), Matchers.<Map<String, String>>any(),Matchers.<Map<String, EntityDetails>>any());
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(0)).createUpgradeBranch();
		Mockito.verify(mockedGitRepositoryManager,Mockito.times(1)).CopyGitFiles();
		Mockito.verify(mockedFrontendGenerator,Mockito.times(1)).generate(anyString(), anyString(),anyString(), anyString());
	}

	
}
