package com.fastcode.codegen;


import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;

import java.io.File;
import java.io.IOException;

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
import com.fastcode.codegen.CommandUtils;
import com.fastcode.logging.LoggingHelper;

@RunWith(SpringJUnit4ClassRunner.class)
public class CommandUtilsTest {
	
	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	@Spy
	private CommandUtils commandUtils;
	
	@Mock
	private CommandUtils mockedCommandUtils;
	
	@Mock
	private CodeGeneratorUtils mockedUtils;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
    private File destPath;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(commandUtils);
		destPath = folder.newFolder("tempFolder");
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void runProcess_CommandAndPathIsValid_WriteOuputIsTrue_ReturnString() throws IOException {
		String response ="CREATE Cl/angular.json (3561 bytes)"
				+ "\nCREATE Cl/package.json (1276 bytes)"
				+ "\nCREATE Cl/README.md (1019 bytes)"
				+ "\nCREATE Cl/tsconfig.json (543 bytes)"
				+ "\nCREATE Cl/tslint.json (1988 bytes)"
				+ "\nCREATE Cl/.editorconfig (246 bytes)"
				+ "\nCREATE Cl/.gitignore (631 bytes)"
				+ "\nCREATE Cl/browserslist (429 bytes)"
				+ "\nCREATE Cl/karma.conf.js (1014 bytes)"
				+ "\nCREATE Cl/tsconfig.app.json (270 bytes)"
				+ "\nCREATE Cl/tsconfig.spec.json (270 bytes)"
				+ "\nCREATE Cl/src/favicon.ico (948 bytes)"
				+ "\nCREATE Cl/src/index.html (288 bytes)"
				+ "\nCREATE Cl/src/main.ts (372 bytes)"
				+ "\nCREATE Cl/src/polyfills.ts (2838 bytes)"
				+ "\nCREATE Cl/src/styles.css (80 bytes)"
				+ "\nCREATE Cl/src/test.ts (642 bytes)"
				+ "\nCREATE Cl/src/assets/.gitkeep (0 bytes)"
				+ "\nCREATE Cl/src/environments/environment.prod.ts (51 bytes)"
				+ "\nCREATE Cl/src/environments/environment.ts (662 bytes)"
				+ "\nCREATE Cl/src/app/app.module.ts (314 bytes)"
				+ "\nCREATE Cl/src/app/app.component.html (25498 bytes)"
				+ "\nCREATE Cl/src/app/app.component.spec.ts (969 bytes)"
				+ "\nCREATE Cl/src/app/app.component.ts (206 bytes)"
				+ "\nCREATE Cl/src/app/app.component.css (0 bytes)"
				+ "\nCREATE Cl/e2e/protractor.conf.js (810 bytes)"
				+ "\nCREATE Cl/e2e/tsconfig.json (214 bytes)"
				+ "\nCREATE Cl/e2e/src/app.e2e-spec.ts (635 bytes)"
				+ "\nCREATE Cl/e2e/src/app.po.ts (262 bytes)"
				+ "\n    Directory is already under version control. Skipping initialization of git.";
		
		String command = "ng new " + "Cl" + " --skipInstall=true";
		String[] builderCommand = new String[] { "cmd.exe", "/c", command };
		
		Assertions.assertThat(commandUtils.runProcess(builderCommand,destPath.getAbsolutePath(),true)).isEqualToIgnoringNewLines(response);
	}
	@Test
	public void runProcess_CommandAndPathIsValid_ReturnString() throws IOException {
		String response ="abc";
		
		String command = "ng new " + "Cl" + " --skipInstall=true";
		String[] builderCommand = new String[] { "cmd.exe", "/c", command };
		Mockito.doReturn(builderCommand).when(commandUtils).getBuilderCommand(anyString());
		Mockito.doReturn(response).when(commandUtils).runProcess(any(String[].class),anyString(), any(Boolean.class));
		
		Assertions.assertThat(commandUtils.runProcess(command,destPath.getAbsolutePath())).isEqualToIgnoringNewLines(response);
	}
	
	@Test
	public void runGitProcess_CommandIsValid_ReturnCommandBuilder() throws IOException {
		String response = "Initialized empty Git repository in "+ destPath.getAbsolutePath().replace("\\","/")+"/.git/" ;
		String command = "init";
		
		String[] builderCommand = new String[] { "cmd.exe", "/c", command };
		Mockito.doReturn(builderCommand).when(commandUtils).getBuilderCommand(anyString());
		Mockito.doReturn(response).when(commandUtils).runProcess(any(String[].class),anyString(), any(Boolean.class));
		
		Assertions.assertThat(commandUtils.runGitProcess(command,destPath.getAbsolutePath())).isEqualTo(response);
	}
	
	@Test
	public void getBuilderCommand_CommandIsValid_ReturnCommandBuilder() throws IOException {
		String command = "init";
		String[] builderCommand = new String[] { "cmd.exe", "/c", command };
		
		Assertions.assertThat(commandUtils.getBuilderCommand(command)).isEqualTo(builderCommand);
	}
	
	@Test
	public void versionCompare_str1HasLowerVersion_returnString() {
	
		Assertions.assertThat(commandUtils.versionCompare("2.23.0","2.23.1")).isEqualTo(-1);
	}
	
	@Test
	public void versionCompare_str2HasLowerVersion_returnString() {
	
		Assertions.assertThat(commandUtils.versionCompare("2.23.1","2.23.0")).isEqualTo(1);
	}
	
	@Test
	public void versionCompare_bothVersionsAreEqual_returnString() {
	
		Assertions.assertThat(commandUtils.versionCompare("2.23.0","2.23.0")).isEqualTo(0);
	}
	
//	public String runProcess(String command, String path) {
//        String[] builderCommand = getBuilderCommand(command);
//        return runProcess(builderCommand, path, true);
//    }


}
