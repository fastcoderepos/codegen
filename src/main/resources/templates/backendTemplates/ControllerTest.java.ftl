package [=PackageName].restcontrollers;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.List;
import java.util.Date;
import java.util.Map;
import java.util.HashMap;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;
import javax.annotation.PostConstruct;
import javax.persistence.EntityManager;
<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
import javax.persistence.EntityExistsException;
</#if>

import org.junit.AfterClass;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
<#if Cache!false>
import org.springframework.cache.CacheManager;
</#if>
import org.springframework.data.web.SortHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import [=CommonModulePackage].logging.LoggingHelper;
import [=PackageName].application<#if AuthenticationType != "none" && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].[=ClassName]AppService;
import [=PackageName].application<#if AuthenticationType != "none" && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto.*;
import [=PackageName].domain.irepository.I[=ClassName]Repository;
import [=PackageName].domain.model.[=ClassName]Entity;
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
<#if relationValue.isParent==false>
import [=PackageName].domain.irepository.I[=relationValue.eName?cap_first]Repository;
import [=PackageName].domain.model.[=relationValue.eName?cap_first]Entity;
</#if> 
</#if> 
</#list>
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
import [=PackageName].application<#if AuthenticationType != "none" && relationValue.eName == AuthenticationTable>.authorization</#if>.[=relationValue.eName?lower_case].[=relationValue.eName]AppService;    
</#if>
</#list>
<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
import org.springframework.security.crypto.password.PasswordEncoder;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Find[=AuthenticationTable]roleByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Find[=AuthenticationTable]permissionByIdOutput;
</#if>
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class [=ClassName]ControllerTest {
	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private I[=ClassName]Repository [=ClassName?uncap_first]_repository;
	
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
	<#if relationValue.isParent==false>
	@Autowired 
	private I[=relationValue.eName?cap_first]Repository [=relationValue.eName?uncap_first]Repository;
	
	</#if> 
	</#if> 
	</#list>
	@SpyBean
	private [=ClassName]AppService [=ClassName?uncap_first]AppService;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @SpyBean
	private [=relationValue.eName]AppService [=relationValue.eName?uncap_first]AppService;
    </#if>
    </#list>
    <#if AuthenticationType != "none" && ClassName == AuthenticationTable>
    
	@SpyBean
    private PasswordEncoder pEncoder;

	@SpyBean
    private [=AuthenticationTable]permissionAppService [=AuthenticationTable?uncap_first]permissionAppService;
    
    @SpyBean
    private [=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService;
    </#if> 

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;

	private [=ClassName]Entity [=ClassName?uncap_first];

	private MockMvc mvc;
	
	@Autowired
	EntityManagerFactory emf;
	
    static EntityManagerFactory emfs;
	
	@PostConstruct
	public void init() {
	this.emfs = emf;
	}

	@AfterClass
	public static void cleanup() {
		EntityManager em = emfs.createEntityManager();
		em.getTransaction().begin();
		em.createNativeQuery("drop table [=Schema].[=ClassName?replace("[A-Z]", "_$0", 'r')?lower_case?substring(1)] CASCADE").executeUpdate();
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		em.createNativeQuery("drop table [=Schema].[=relationValue.eName?replace("[A-Z]", "_$0", 'r')?lower_case?substring(1)] CASCADE").executeUpdate();
		</#if> 
		</#if> 
		</#list>
		em.getTransaction().commit();
	}

    <#if Cache!false>
	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()) {
			cacheManager.getCache(name).clear(); 
		} 
	}
	</#if>

	public [=ClassName]Entity createEntity() {
	    <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = create[=relationValue.eName?cap_first]Entity();
		if([=relationValue.eName?uncap_first]Repository.findAll().isEmpty())
		{
			[=relationValue.eName?uncap_first]=[=relationValue.eName?uncap_first]Repository.save([=relationValue.eName?uncap_first]);
		}
		</#if> 
		</#if> 
		</#list>
	
		[=ClassName]Entity [=ClassName?uncap_first] = new [=ClassName]Entity();
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](1);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first]((short)1);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](1D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=value.fieldName?cap_first]("1");
		</#if> 
		</#if> 
		</#list>
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=ClassName?uncap_first].set[=relationValue.eName?cap_first]([=relationValue.eName?uncap_first]);
		</#if> 
		</#if> 
		</#list>
		
		return [=ClassName?uncap_first];
	}

	public Create[=ClassName]Input create[=ClassName]Input() {
	
	    Create[=ClassName]Input [=ClassName?uncap_first] = new Create[=ClassName]Input();
	    <#list Fields as key,value>
		<#if value.isAutogenerated== false && value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](2L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](2);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first]((short)2);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](2D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=value.fieldName?cap_first]("2");
		</#if> 
		</#if> 
		</#list>
	    
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName?cap_first]Entity();
		<#list relationValue.fDetails as value>
		<#if value.fieldType?lower_case == "long">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](2L);
		<#elseif value.fieldType?lower_case == "integer">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](2);
		<#elseif value.fieldType?lower_case == "short">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]((short)2);
		<#elseif value.fieldType?lower_case == "double">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](2D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]("2");
		</#if> 
		</#list>
		[=relationValue.eName?uncap_first]=[=relationValue.eName?uncap_first]Repository.save([=relationValue.eName?uncap_first]);
		<#list relationValue.joinDetails as joinDetails>
		<#list relationValue.fDetails as value>
		<#if value.fieldName==joinDetails.referenceColumn>
		[=ClassName?uncap_first].set[=joinDetails.joinColumn?cap_first]([=relationValue.eName?uncap_first].get[=joinDetails.referenceColumn?cap_first]());
		</#if>
		</#list>
		</#list>
		</#if> 
		</#if> 
		
		</#list>
		
		return [=ClassName?uncap_first];
	}

	public [=ClassName]Entity createNewEntity() {
		[=ClassName]Entity [=ClassName?uncap_first] = new [=ClassName]Entity();
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](3L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](3);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first]((short)3);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](3D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=value.fieldName?cap_first]("3");
		</#if> 
		</#if> 
		</#list>
		return [=ClassName?uncap_first];
	}
	
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
	<#if relationValue.isParent==false>
	public [=relationValue.eName?cap_first]Entity create[=relationValue.eName?cap_first]Entity() {
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName?cap_first]Entity();
  		<#list relationValue.fDetails as value>
		<#if value.fieldType?lower_case == "long">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](1);
		<#elseif value.fieldType?lower_case == "short">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]((short)1);
		<#elseif value.fieldType?lower_case == "double">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](1D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]("1");
		</#if> 
		</#list>
		return [=relationValue.eName?uncap_first];
		 
	}
	</#if> 
	</#if> 
	</#list>

	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);
        <#if Cache!false>
		evictAllCaches();
		</#if>
		final [=ClassName]Controller [=ClassName?uncap_first]Controller = new [=ClassName]Controller([=ClassName?uncap_first]AppService,<#list Relationship as relationKey,relationValue><#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">[=relationValue.eName?uncap_first]AppService,</#if></#list>
	<#if AuthenticationType != "none" && ClassName == AuthenticationTable>pEncoder, [=AuthenticationTable?uncap_first]permissionAppService,[=AuthenticationTable?uncap_first]roleAppService,</#if>logHelper);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

		this.mvc = MockMvcBuilders.standaloneSetup([=ClassName?uncap_first]Controller)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();
	}

	@Before
	public void initTest() {

		[=ClassName?uncap_first]= createEntity();
		List<[=ClassName]Entity> list= [=ClassName?uncap_first]_repository.findAll();
		if(list.isEmpty()) {
		   [=ClassName?uncap_first]_repository.save([=ClassName?uncap_first]);
		}

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
	
		mvc.perform(get("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:1<#sep>,</#list><#else><#list PrimaryKeys as key,value>1</#list></#if>")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:111<#sep>,</#list><#else><#list PrimaryKeys as key,value>111</#list></#if>")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    
	
	<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
	public void Create[=AuthenticationTable]_[=AuthenticationTable]DoesNotExist_ReturnStatusOk() throws Exception {
	    <#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        Mockito.doReturn(null).when([=ClassName?uncap_first]AppService).FindBy[=authValue.fieldName?cap_first](anyString());
	    <#break>
	    </#if> 
	    </#list>
	    </#if>
	  
		Create[=AuthenticationTable]Input [=ClassName?uncap_first] = create[=AuthenticationTable]Input();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);
		
		mvc.perform(post("/[=ClassName?uncap_first]").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
		 
		 [=ClassName?uncap_first]_repository.delete(createNewEntity());
	}  

	@Test
	public void Create[=ClassName]_[=ClassName]AlreadyExists_ThrowEntityExistsException() throws Exception {
	    Find[=ClassName]By<#if AuthenticationFields??>[=AuthenticationFields["UserName"].fieldName?cap_first]</#if>Output output= new Find[=ClassName]By<#if AuthenticationFields??>[=AuthenticationFields["UserName"].fieldName?cap_first]</#if>Output();
	    <#list Fields as key,value>
		<#if value.isNullable==false>
		<#if !(AuthenticationFields?? && AuthenticationFields.Password.fieldName == value.fieldName)>
		<#if value.fieldType?lower_case == "long">
		output.set[=key?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer">
		output.set[=key?cap_first](1);
		<#elseif value.fieldType?lower_case == "short">
		output.set[=key?cap_first]((short)1);
		<#elseif value.fieldType?lower_case == "double">
		output.set[=key?cap_first](1D);
		<#elseif value.fieldType?lower_case == "boolean">
		output.set[=key?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		output.set[=key?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		output.set[=key?cap_first]("1");
		</#if> 
		</#if> 
		</#if>
		</#list>

        <#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        Mockito.doReturn(output).when([=ClassName?uncap_first]AppService).FindBy[=authValue.fieldName?cap_first](anyString());
	    Create[=ClassName]Input [=ClassName?uncap_first] = create[=ClassName]Input();
	    ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);
       
        org.assertj.core.api.Assertions.assertThatThrownBy(() -> mvc.perform(post("/[=ClassName?uncap_first]")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())).hasCause(new EntityExistsException("There already exists a [=ClassName?uncap_first] with [=authValue.fieldName?cap_first] =" + [=ClassName?uncap_first].get[=authValue.fieldName?cap_first]()));
	    <#break>
	    </#if> 
	    </#list>
	    </#if>
	} 
	<#else>
	@Test
	public void Create[=ClassName]_[=ClassName]DoesNotExist_ReturnStatusOk() throws Exception {
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		<#assign count =1>
		<#assign relationEntity = relationValue.eName>
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName && count==1>
        <#if relationEntity == joinDetails.joinEntityName>
        <#assign count = count + 1>
        </#if>
        <#if joinDetails.joinColumn??>
		<#if joinDetails.isJoinColumnOptional==false>
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName?cap_first]Entity();
		<#list relationValue.fDetails as value>
		<#if value.isAutogenerated == false && value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5L);
		<#elseif value.fieldType?lower_case == "integer">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5);
		<#elseif value.fieldType?lower_case == "short">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]((short)5);
		<#elseif value.fieldType?lower_case == "double">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]("5");
		</#if> 
		</#if> 
		</#list>
		[=relationValue.eName?uncap_first]Repository.save([=relationValue.eName?uncap_first]);
		</#if>
        </#if>
        </#if>
        </#list>
		</#if>
        </#if>
		</#list>
		Create[=ClassName]Input [=ClassName?uncap_first] = create[=ClassName]Input();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);

		mvc.perform(post("/[=ClassName?uncap_first]").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}     
    </#if>
    <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
        <#assign i=relationValue.joinDetails?size>
        <#if i==1>
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
		<#if joinDetails.isJoinColumnOptional==false>
	@Test
	public void Create[=ClassName?cap_first]_[=relationValue.eName?uncap_first]DoesNotExists_ThrowEntityNotFoundException() throws Exception {

		Create[=ClassName?cap_first]Input [=ClassName?uncap_first] = create[=ClassName?cap_first]Input();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->
		mvc.perform(post("/[=ClassName?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk())
				).hasCause(new EntityNotFoundException("No record found"));

	}    
		</#if>
        </#if>
        </#if>
        </#list>
        <#else>
	@Test
	public void Create[=ClassName?cap_first]_[=relationValue.eName?uncap_first]DoesNotExists_ThrowEntityNotFoundException() throws Exception {

		Create[=ClassName?cap_first]Input [=ClassName?uncap_first] = create[=ClassName?cap_first]Input();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->
		mvc.perform(post("/[=ClassName?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk())
				).hasCause(new EntityNotFoundException("No record found"));

	}    
		</#if>
		</#if>
        </#if>
	</#list>

	@Test
	public void Delete[=ClassName]_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

        <#if CompositeKeyClasses?seq_contains(ClassName)>
        doReturn(null).when([=ClassName?uncap_first]AppService).FindById(new [=ClassName]Id(<#list PrimaryKeys as key,value><#if value?lower_case == "long">111L<#elseif value?lower_case == "integer" || value?lower_case == "short">111<#elseif value?lower_case == "double">111D<#elseif value?lower_case == "string">"111"</#if><#sep>, </#list>));
        <#else>
        doReturn(null).when([=ClassName?uncap_first]AppService).FindById(<#list PrimaryKeys as key,value><#if value?lower_case == "long">111L<#elseif value?lower_case == "integer" || value?lower_case == "short">111<#elseif value?lower_case == "double">111D<#elseif value?lower_case == "string">"111"</#if></#list>);
        </#if>
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:111<#sep>,</#list><#else><#list PrimaryKeys as key,value>111</#list></#if>")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a [=ClassName?uncap_first] with a id=<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:111<#sep>,</#list><#else><#list PrimaryKeys as key,value>111</#list></#if>"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
	
	 [=ClassName]Entity entity =  createNewEntity();
	    <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName?cap_first]Entity();
  		<#list relationValue.fDetails as value>
		<#if value.fieldType?lower_case == "long">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](3L);
		<#elseif value.fieldType?lower_case == "integer">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](3);
		<#elseif value.fieldType?lower_case == "short">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]((short)3);
		<#elseif value.fieldType?lower_case == "double">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](3D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]("3");
		</#if> 
		</#list>
		[=relationValue.eName?uncap_first]=[=relationValue.eName?uncap_first]Repository.save([=relationValue.eName?uncap_first]);
		
		<#list relationValue.joinDetails as joinDetails>
		<#list Fields as key,value>
		<#if value.fieldName== joinDetails.joinColumn>
		entity.set[=joinDetails.joinColumn?cap_first]([=relationValue.eName?uncap_first].get[=joinDetails.referenceColumn?cap_first]());
		</#if>
		</#list>
		</#list>
		entity.set[=relationValue.eName?cap_first]([=relationValue.eName?uncap_first]);
		</#if>
		</#if>  
		</#list>
		
		entity = [=ClassName?uncap_first]_repository.save(entity);

		Find[=ClassName]ByIdOutput output= new Find[=ClassName]ByIdOutput();
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if !(AuthenticationFields?? && AuthenticationFields.Password.fieldName == key)>
		<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  		output.set[=key?cap_first](entity.get[=key?cap_first]());
		</#if> 
		</#if>
		</#if> 
		</#list>
	    <#if CompositeKeyClasses?seq_contains(ClassName)>
	    Mockito.when([=ClassName?uncap_first]AppService.FindById(new [=ClassName]Id(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if><#sep>, </#list>))).thenReturn(output);
   
        <#else>
        Mockito.when([=ClassName?uncap_first]AppService.FindById(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if></#list>)).thenReturn(output);
        
        </#if>
		mvc.perform(delete("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:"+ entity.get[=key?cap_first]()<#sep>+ ",</#list><#else><#list PrimaryKeys as key,value>" + entity.get[=key?cap_first]()</#list></#if>)
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());
	}  


	@Test
	public void Update[=ClassName]_[=ClassName]DoesNotExist_ReturnStatusNotFound() throws Exception {

		<#if CompositeKeyClasses?seq_contains(ClassName)>
        doReturn(null).when([=ClassName?uncap_first]AppService).FindById(new [=ClassName]Id(<#list PrimaryKeys as key,value><#if value?lower_case == "long">111L<#elseif value?lower_case == "integer" || value?lower_case == "short">111<#elseif value?lower_case == "double">111D<#elseif value?lower_case == "string">"111"</#if><#sep>, </#list>));
        <#else>
        doReturn(null).when([=ClassName?uncap_first]AppService).FindById(<#list PrimaryKeys as key,value><#if value?lower_case == "long">111L<#elseif value?lower_case == "integer" || value?lower_case == "short">111<#elseif value?lower_case == "double">111D<#elseif value?lower_case == "string">"111"</#if></#list>);
        </#if>

		Update[=ClassName]Input [=ClassName?uncap_first] = new Update[=ClassName]Input();
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if !(AuthenticationFields?? && AuthenticationFields.Password.fieldName == key)>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](111L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](111);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first]((short)111);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](111D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=value.fieldName?cap_first]("111");
		</#if> 
		</#if> 
		</#if>
		</#list>

		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);
		mvc.perform(put("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:111<#sep>,</#list><#else><#list PrimaryKeys as key,value>111</#list></#if>").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void Update[=ClassName]_[=ClassName]Exists_ReturnStatusOk() throws Exception {
		[=ClassName]Entity entity =  createNewEntity();
	    <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		[=relationValue.eName?cap_first]Entity [=relationValue.eName?uncap_first] = new [=relationValue.eName?cap_first]Entity();
  		<#list relationValue.fDetails as value>
		<#if value.isPrimaryKey==true && value.fieldType?lower_case == "long">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5L);
		<#elseif value.fieldType?lower_case == "integer">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5);
		<#elseif value.fieldType?lower_case == "short">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]((short)5);
		<#elseif value.fieldType?lower_case == "double">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](5D);
		<#elseif value.fieldType?lower_case == "boolean">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](true);
		<#elseif value.fieldType?lower_case == "date">
		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first](new Date());
		<#elseif value.fieldType?lower_case == "string">
  		[=relationValue.eName?uncap_first].set[=value.fieldName?cap_first]("5");
		</#if> 
		</#list>
		[=relationValue.eName?uncap_first]=[=relationValue.eName?uncap_first]Repository.save([=relationValue.eName?uncap_first]);
		<#list relationValue.joinDetails as joinDetails>
		<#list Fields as key,value>
		<#if value.isPrimaryKey==true && value.fieldName==joinDetails.joinColumn>
		entity.set[=joinDetails.joinColumn?cap_first]([=relationValue.eName?uncap_first].get[=joinDetails.referenceColumn?cap_first]());
		</#if>
		</#list>
		</#list>
		entity.set[=relationValue.eName?cap_first]([=relationValue.eName?uncap_first]);
		</#if> 
		</#if> 
		</#list>
		entity = [=ClassName?uncap_first]_repository.save(entity);
		<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
		Find[=ClassName]WithAllFieldsByIdOutput output= new Find[=ClassName]WithAllFieldsByIdOutput();
		<#else>
		Find[=ClassName]ByIdOutput output= new Find[=ClassName]ByIdOutput();
        </#if>
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  		output.set[=key?cap_first](entity.get[=value.fieldName?cap_first]());
		</#if> 
		</#if> 
		</#list>

		<#if CompositeKeyClasses?seq_contains(ClassName)>
		<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
		Mockito.when([=ClassName?uncap_first]AppService.FindWithAllFieldsById(new [=ClassName]Id(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if><#sep>, </#list>))).thenReturn(output);
		<#else>
	    Mockito.when([=ClassName?uncap_first]AppService.FindById(new [=ClassName]Id(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if><#sep>, </#list>))).thenReturn(output);
        
        </#if>
        <#else>
        <#if AuthenticationType != "none" && ClassName == AuthenticationTable>
		Mockito.when([=ClassName?uncap_first]AppService.FindWithAllFieldsById(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if></#list>)).thenReturn(output);
		<#else>
        Mockito.when([=ClassName?uncap_first]AppService.FindById(<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">entity.get[=key?cap_first]()</#if></#list>)).thenReturn(output);
        
        </#if>
        </#if>
		Update[=ClassName]Input [=ClassName?uncap_first] = new Update[=ClassName]Input();
		<#list Fields as key,value>
		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=value.fieldName?cap_first](entity.get[=key?cap_first]());
		</#if> 
		</#if> 
		</#list>
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=ClassName?uncap_first]);
	
		mvc.perform(put("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:"+ entity.get[=key?cap_first]()<#sep>+ ",</#list><#else><#list PrimaryKeys as key,value>" + entity.get[=key?cap_first]()</#list></#if>).contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

		[=ClassName]Entity de = createEntity();
		<#list PrimaryKeys as key,value>
		de.set[=key?cap_first](entity.get[=key?cap_first]());
		</#list>
		[=ClassName?uncap_first]_repository.delete(de);
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/[=ClassName?uncap_first]?search=<#list PrimaryKeys as key,value>[=key]<#break></#list>[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=ClassName?uncap_first]?search=<#list PrimaryKeys as key,value>[=ClassName?uncap_first][=key]<#break></#list>[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property <#list PrimaryKeys as key,value>[=ClassName?uncap_first][=key]<#break></#list> not found!"));

	} 
	
	<#list Relationship as relationKey, relationValue>
    <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
	<#if CompositeKeyClasses?seq_contains(ClassName)>
	@Test
	public void Get[=relationValue.eName?cap_first]_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=ClassName?uncap_first]/<#list PrimaryKeys as key,value>[=key]:111<#break></#list>/[=relationValue.eName?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=<#list PrimaryKeys as key,value>[=key]:111<#break></#list>"));
	
	}    
	</#if>
	@Test
	public void Get[=relationValue.eName?cap_first]_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:111<#sep>,</#list><#else><#list PrimaryKeys as key,value>111</#list></#if>/[=relationValue.eName?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void Get[=relationValue.eName?cap_first]_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/[=ClassName?uncap_first]/<#if CompositeKeyClasses?seq_contains(ClassName)><#list PrimaryKeys as key,value>[=key]:1<#sep>,</#list><#else><#list PrimaryKeys as key,value>1</#list></#if>/[=relationValue.eName?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
    <#elseif relationValue.relation == "OneToMany">  
	@Test
	public void Get[=relationValue.eName?cap_first]_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		<#list relationValue.joinDetails as joinDetails>
		joinCol.put("[=joinDetails.joinColumn?uncap_first]", "1");
		<#break>
		</#list>

		Mockito.when([=ClassName?uncap_first]AppService.parse[=relationValue.eName]JoinColumn("<#list relationValue.joinDetails as joinDetails>[=joinDetails.joinColumn?uncap_first]<#break></#list>")).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void Get[=relationValue.eName?cap_first]_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		<#list relationValue.joinDetails as joinDetails>
		joinCol.put("[=joinDetails.joinColumn?uncap_first]", "1");
		<#break>
		</#list>
		
        Mockito.when([=ClassName?uncap_first]AppService.parse[=relationValue.eName]JoinColumn("<#list relationValue.joinDetails as joinDetails>[=joinDetails.joinColumn?uncap_first]<#break></#list>")).thenReturn(joinCol);
		mvc.perform(get("/[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]?search=<#list relationValue.joinDetails as joinDetails>[=joinDetails.joinColumn?uncap_first]<#break></#list>[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void Get[=relationValue.eName?cap_first]_searchIsNotEmpty() throws Exception {
	
		Mockito.when([=ClassName?uncap_first]AppService.parse[=relationValue.eName]JoinColumn(anyString())).thenReturn(null);
		mvc.perform(get("/[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]?search=<#list relationValue.joinDetails as joinDetails>[=joinDetails.joinColumn?lower_case]<#break></#list>[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
    </#if>
    </#list>
    
    <#if AuthenticationType != "none" && ClassName == AuthenticationTable>
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		
		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]/2/[=AuthenticationTable?uncap_first]role?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleId", "1");

		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/[=AuthenticationTable?uncap_first]/1/[=AuthenticationTable?uncap_first]role?search=roleId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void Get[=AuthenticationTable]role_searchIsNotEmpty() throws Exception {
	
		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]roleJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/[=AuthenticationTable?uncap_first]/1/[=AuthenticationTable?uncap_first]role?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}      
	 
	@Test
	public void Get[=AuthenticationTable]permission_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("permissionid", "1");
		
		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]permissionJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]/2/[=AuthenticationTable?uncap_first]permission?search=abc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abc not found!"));
	
	}    
	
	@Test
	public void Get[=AuthenticationTable]permission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("permissionId", "1");

		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]permissionJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/[=AuthenticationTable?uncap_first]/1/[=AuthenticationTable?uncap_first]permission?search=permissionId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void Get[=AuthenticationTable]permission_searchIsNotEmpty() throws Exception {
	
		Mockito.when([=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]permissionJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/[=AuthenticationTable?uncap_first]/1/[=AuthenticationTable?uncap_first]permission?search=permissionid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}      
	</#if>

}
