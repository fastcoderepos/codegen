package com.fastcode.codegen;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.assertj.core.api.Assertions;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.codegen.CodeGenerator;
import com.fastcode.codegen.CodeGeneratorUtils;
import com.fastcode.codegen.JSONUtils;

@RunWith(SpringJUnit4ClassRunner.class)
public class JSONUtilsTest {
	
	@Rule
	public TemporaryFolder folder= new TemporaryFolder(new File(System.getProperty("user.dir").toString()));

	@InjectMocks
	private JSONUtils jsonUtils;
	
	@Mock
	private CodeGenerator mockedCodeGenerator;
	
	@Mock
	private CodeGeneratorUtils mockedUtils;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(jsonUtils);
	
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test 
	public void readJsonFile_PathIsValid_ReturnObject() throws IOException, ParseException
	{
		JSONParser parser = new JSONParser();
		File newFile = folder.newFile("appTest.json");
		FileUtils.writeStringToFile(newFile, "[]");
		Object obj =parser.parse("[]");
		Assertions.assertThat(jsonUtils.readJsonFile(newFile.getAbsolutePath())).isEqualTo(obj);

	}
	
	@Test
	public void beautifyJson_PathIsValid_ReturnString() throws IOException, ParseException
	{
		JSONParser parser = new JSONParser();
		Object obj =parser.parse("[]");
		JSONArray entityArray = (JSONArray) obj;
		
		Assertions.assertThat(jsonUtils.beautifyJson(entityArray, "Array")).isEqualTo("[]");
	}
	
	@Test
	public void writeJsonToFile_PathIsValid_ReturnNothing() throws IOException, ParseException
	{
	   File newFile = folder.newFile("appTest.json");
	   jsonUtils.writeJsonToFile(newFile.getAbsolutePath(), "[]");
	  
	   String str = FileUtils.readFileToString(newFile);
	   Assertions.assertThat(str).isEqualTo("[]");
	}

}
