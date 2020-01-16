package com.fastcode.entitycodegen;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.any;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

import org.assertj.core.api.Assertions;
import org.junit.After;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.contrib.java.lang.system.TextFromStandardInputStream;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.mockito.Spy;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.fastcode.entitycodegen.EntityDetails;
import com.fastcode.entitycodegen.FieldDetails;
import com.fastcode.entitycodegen.UserInput;


@RunWith(SpringJUnit4ClassRunner.class)
public class UserInputTest {

	@Rule
	public final TextFromStandardInputStream systemInMock = TextFromStandardInputStream.emptyStandardInputStream();

	@InjectMocks
	@Spy
	UserInput userInput;
	
	@Mock
	EntityDetails mockedEntityDetails;
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(userInput);
	}

	@After
	public void tearDown() throws Exception {

	}
	
	@Test
	public void getInput_parametersAreValid_returnStrin()
	{
		systemInMock.provideLines("user");
	    Scanner scanner = new Scanner(System.in);
	    Assertions.assertThat(userInput.getInput(scanner, "authentication table")).isEqualTo("user");
		scanner.close();
		
	}
	
	@Test
	public void getFieldsInput_parametersAreValid_returnString()
	{
		systemInMock.provideLines("2");
	    Scanner scanner = new Scanner(System.in);
		Assertions.assertThat(userInput.getFieldsInput(3)).isEqualTo(2);
		scanner.close();
	}
	
	@Test
	public void getFilteredFieldsList_fieldsListIsNotEmpty_returnList()
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
		
		Assertions.assertThat(userInput.getFilteredFieldsList(fDetails)).isEqualTo(fDetails);
	}
	
	@Test
	public void getEntityDescriptionField_parametersAreValid_returnSelectedFieldDetails()
	{
		List<FieldDetails> fieldsList= new ArrayList<FieldDetails>();
		FieldDetails details = new FieldDetails();
		details.setFieldName("UserName");
		details.setFieldType("String");
		fieldsList.add(details);
		
		FieldDetails details1 = new FieldDetails();details = new FieldDetails();
		details1.setFieldName("UserId");
		details1.setFieldType("Long");
		fieldsList.add(details1);
		
		Mockito.doReturn(fieldsList).when(userInput).getFilteredFieldsList(fieldsList);
		Mockito.doReturn(1).when(userInput).getFieldsInput(2);
		Assertions.assertThat(userInput.getEntityDescriptionField("User", fieldsList)).isEqualToIgnoringNullFields(details);
	}
	
	@Test
	public void composeInput_rootMapHasNullValues_takeMandatoryValuesFromUserAndSetDefaultValuesForOptionalFieldsAndReturnUserInput()
	{
		Map<String, String> root = new HashMap<String, String>();
		
		
		UserInput userInputDto = new UserInput();
		userInputDto.setAuthenticationSchema("testValue");
		userInputDto.setGenerationType("all");
		userInputDto.setCache(false);
		userInputDto.setGroupArtifactId("com.nfin");
		userInputDto.setConnectionStr("testValue");
		userInputDto.setDestinationPath("testValue");
		
		Mockito.doReturn(userInputDto.getConnectionStr(),userInputDto.getSchemaName(),userInputDto.getDestinationPath(),userInputDto.getGroupArtifactId(),userInputDto.getGenerationType()).when(userInput).getInput(any(Scanner.class), anyString());
		Mockito.doReturn(userInputDto).when(userInput).getAuthenticationInput(any(UserInput.class),any(Scanner.class));
		
		Assertions.assertThat(userInput.composeInput(root)).isEqualTo(userInputDto);
	}
	
	@Test
	public void composeInput_rootMapIsNotNull_ReturnUserInput()
	{
		Map<String, String> root = new HashMap<String, String>();
		root.put("upgrade", "true");
		root.put("conn", "testValue");
		root.put("a", "com.nfin");
		root.put("t", "all");
		root.put("d", "testValue");
		root.put("s", "testValue");
		root.put("c", "true");
		
		UserInput userInputDto = new UserInput();
		userInputDto.setAuthenticationSchema("testValue");
		//userInputDto.setAuthenticationType("none");
		userInputDto.setGenerationType("all");
		userInputDto.setCache(false);
		userInputDto.setGroupArtifactId("com.nfin");
		userInputDto.setConnectionStr("testValue");
		userInputDto.setDestinationPath("testValue");
		
	//	Mockito.doReturn(userInputDto.getConnectionStr(),userInputDto.getSchemaName(),userInputDto.getDestinationPath(),userInputDto.getGroupArtifactId(),userInputDto.getGenerationType()).when(userInput).getInput(any(Scanner.class), anyString());
		Mockito.doReturn(userInputDto).when(userInput).getAuthenticationInput(any(UserInput.class),any(Scanner.class));
		//systemInMock.provideLines("1");
		
		
		Assertions.assertThat(userInput.composeInput(root)).isEqualTo(userInputDto);
	}
	
	@Test
	public void getAuthenticationInput_userInputIsValidAndAuthenticationTypeIsNone_ReturnUserInput()
	{
		systemInMock.provideLines("1");
	    Scanner scanner = new Scanner(System.in);
		UserInput userInputDto = new UserInput();
		userInputDto.setAuthenticationSchema("testValue");
		userInputDto.setAuthenticationType("none");

		Assertions.assertThat(userInput.getAuthenticationInput(userInputDto, scanner)).isEqualTo(userInputDto);
	}
	
	@Test
	public void getAuthenticationInput_userInputIsValid_ReturnUserInput()
	{
		systemInMock.provideLines("2","y","user");
	    Scanner scanner = new Scanner(System.in);
		UserInput userInputDto = new UserInput();
		userInputDto.setAuthenticationSchema("User");
		userInputDto.setAuthenticationType("database");
		userInputDto.setGenerationType("all");
		userInputDto.setCache(false);
		userInputDto.setGroupArtifactId("com.nfin");
		userInputDto.setConnectionStr("testValue");
		userInputDto.setDestinationPath("testValue");
		
	 //  Mockito.doReturn(userInputDto).when(userInput).getAuthenticationInput(any(UserInput.class),any(Scanner.class));
	
		
		Assertions.assertThat(userInput.getAuthenticationInput(userInputDto, scanner)).isEqualTo(userInputDto);
	}
	

//		System.out.print("\nSelect Authentication and Authorization method :");
//		System.out.print("\n1. none");
//		System.out.print("\n2. database");
//		System.out.print("\n3. ldap");
//		System.out.print("\n4. oidc");
//		System.out.print("\nEnter 1,2,3 or 4 : ");
//		
//		int value = scanner.nextInt();
//		while (value < 1 || value > 4) {
// 
//			System.out.println("\nInvalid Input \nEnter again :");
//			value = scanner.nextInt();
//		}
//		if (value == 1) {
//			input.setAuthenticationType("none");
//			input.setFlowable(false);
//		} 
//		else if (value>1) {
//			scanner.nextLine();
//			
//			System.out.print("\nDo you have your own user table? (y/n)");
//			String str= scanner.nextLine();
//			if(str.equalsIgnoreCase("y") || str.equalsIgnoreCase("yes"))
//			{
//				System.out.print("\nEnter table name :");
//				str= scanner.nextLine();
//				if(str.contains("_"))
//				{
//					str=CaseFormat.LOWER_UNDERSCORE.to(CaseFormat.LOWER_CAMEL, str);
//				}
//				input.setAuthenticationSchema(str.substring(0, 1).toUpperCase() + str.substring(1));
//			}
//
//			if (value == 2) {
//				input.setAuthenticationType("database");
//			}
//			else if (value == 3) {
//				input.setAuthenticationType("ldap");
//			}
//			else if (value == 4) {
//				input.setAuthenticationType("oidc");
//			}
//		}
//
//		return input;
//	}
	
}
