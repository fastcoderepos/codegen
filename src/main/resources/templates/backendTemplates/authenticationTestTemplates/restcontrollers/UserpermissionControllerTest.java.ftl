package [=PackageName].restcontrollers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;

import java.util.List;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityNotFoundException;
import javax.annotation.PostConstruct;

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
<#if Cache !false>
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
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Create[=AuthenticationTable]permissionInput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Find[=AuthenticationTable]permissionByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Update[=AuthenticationTable]permissionInput;
import [=PackageName].application.authorization.rolepermission.RolepermissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]AppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].dto.Find[=AuthenticationTable]ByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
import [=PackageName].domain.irepository.IPermissionRepository;
import [=PackageName].domain.irepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.irepository.I[=AuthenticationTable]permissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class [=AuthenticationTable]permissionControllerTest {

	private static final Long DEFAULT_PERMISSION_ID = 1L;
	private static final Long DEFAULT_USER_ID = 1L;
	private static final Boolean DEFAULT_REVOKED=true;
	
	@Autowired
    private SortHandlerMethodArgumentResolver sortArgumentResolver;
	
	@Autowired 
	private I[=AuthenticationTable]permissionRepository [=AuthenticationTable?uncap_first]permissionRepository;
	
	@Autowired
	private I[=AuthenticationTable]Repository [=AuthenticationTable?uncap_first]Repository;
	
	@Autowired
	private IPermissionRepository permissionRepository;

	@SpyBean
	private [=AuthenticationTable]AppService [=AuthenticationTable?uncap_first]AppService;
	
	@SpyBean
	private [=AuthenticationTable]permissionAppService [=AuthenticationTable?uncap_first]permissionAppService;
	
	@SpyBean
	private [=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService;
	
	@SpyBean
	private RolepermissionAppService rolepermissionAppService;
	
	@SpyBean
	private LoggingHelper logHelper;
	
	@Mock
	private Logger loggerMock;
	
	private [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission;
	
	private MockMvc mvc;
	
	<#if Cache !false>
	@Autowired 
	private CacheManager cacheManager; 
	
	public void evictAllCaches(){ 
	    for(String name : cacheManager.getCacheNames()){
	        cacheManager.getCache(name).clear(); 
	    } 
	}
    </#if>
    
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
		em.createNativeQuery("drop table [=SchemaName?lower_case].[=AuthenticationTable?uncap_first]permission CASCADE").executeUpdate();
		em.createNativeQuery("drop table [=SchemaName?lower_case].permission CASCADE").executeUpdate();
		em.createNativeQuery("drop table [=SchemaName?lower_case].[=AuthenticationTable?uncap_first] CASCADE").executeUpdate();
		em.getTransaction().commit();
	}
    
	public [=AuthenticationTable]permissionEntity createEntity() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]=create[=AuthenticationTable]Entity();
		PermissionEntity permission =createPermissionEntity();
		
		if([=AuthenticationTable?uncap_first]Repository.findAll().isEmpty())
		{
			[=AuthenticationTable?uncap_first]=[=AuthenticationTable?uncap_first]Repository.save([=AuthenticationTable?uncap_first]);
		}

		if(permissionRepository.findAll().isEmpty())
		{
			permission=permissionRepository.save(permission);
		}
		
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = new [=AuthenticationTable]permissionEntity();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(permission.getId());
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id([=AuthenticationTable?uncap_first].getId());
		<#elseif AuthenticationType!="none" && UserInput??>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>

		[=AuthenticationTable?uncap_first]permission.setRevoked(DEFAULT_REVOKED);
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]permission.setPermission(permission);
		return [=AuthenticationTable?uncap_first]permission;
	}

	public static Create[=AuthenticationTable]permissionInput create[=AuthenticationTable]permissionInput() {
		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Create[=AuthenticationTable]permissionInput();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(3L);
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(3L);
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](3L);
		<#elseif value?lower_case == "integer" || value?lower_case == "short">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](3);
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](3D);
		<#elseif value?lower_case == "string">
  		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]("3");
		</#if> 
		</#list>
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]permission.setRevoked(DEFAULT_REVOKED);
		
		return [=AuthenticationTable?uncap_first]permission;
	}
	
	public static [=AuthenticationTable]Entity create[=AuthenticationTable]Entity() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = new [=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first].setId(DEFAULT_USER_ID);
	    [=AuthenticationTable?uncap_first].setIsActive(true);
	    [=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u1");
	    [=AuthenticationTable?uncap_first].setEmailAddress("u1@g.com");
	    [=AuthenticationTable?uncap_first].setFirstName("U");
	    [=AuthenticationTable?uncap_first].setLastName("1");
	    [=AuthenticationTable?uncap_first].setPassword("secret");
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first](1);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](1D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("1");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]??>
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1L);
		<#elseif authValue.fieldType?lower_case == "integer" || authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("1");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>
		
		return [=AuthenticationTable?uncap_first];
	}
	
	public static PermissionEntity createPermissionEntity() {
		PermissionEntity permission = new PermissionEntity();
	    permission.setDisplayName("D1");
	    permission.setId(DEFAULT_PERMISSION_ID);
	    permission.setName("P1");
	    
	    return permission;
	}
	
	public Find[=AuthenticationTable]ByIdOutput create[=AuthenticationTable]ByIdOuput()
	{
		Find[=AuthenticationTable]ByIdOutput [=AuthenticationTable?uncap_first] = new Find[=AuthenticationTable]ByIdOutput();
	
	    <#if (AuthenticationType!="none" && !UserInput??)>
	    [=AuthenticationTable?uncap_first].setId(1L);
	    [=AuthenticationTable?uncap_first].setIsActive(true);
	    [=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u1");
	    [=AuthenticationTable?uncap_first].setEmailAddress("u1@g.com");
	    [=AuthenticationTable?uncap_first].setFirstName("U");
	    [=AuthenticationTable?uncap_first].setLastName("1");
		<#else>
  		<#list Fields as key,value>
  		<#if value.isAutogenerated == false && value.isNullable==false && (AuthenticationFields?? && AuthenticationFields.Password.fieldName != value.fieldName)>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first](1);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](1D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("1");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]?? && authKey != "Password">
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1L);
		<#elseif authValue.fieldType?lower_case == "integer" || authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("1");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>
	  
		return [=AuthenticationTable?uncap_first];
	}
	
	public [=AuthenticationTable]permissionEntity createNewEntityForDelete() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] =create[=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u2");
		[=AuthenticationTable?uncap_first].setPassword("secret");
		[=AuthenticationTable?uncap_first].setIsActive(true);
		[=AuthenticationTable?uncap_first].setFirstName("U2");
		[=AuthenticationTable?uncap_first].setEmailAddress("u2@gil.com");
		[=AuthenticationTable?uncap_first].setId(2L);
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](2L);
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first](2);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](2D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("2");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]??>
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](2L);
		<#elseif authValue.fieldType?lower_case == "integer" || authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](2);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](2D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("2");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>
		[=AuthenticationTable?uncap_first]=[=AuthenticationTable?uncap_first]Repository.save([=AuthenticationTable?uncap_first]);
		
		PermissionEntity permission = createPermissionEntity();
		permission.setName("P2");
		permission.setId(2L);
		permission=permissionRepository.save(permission);
		
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = new [=AuthenticationTable]permissionEntity();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(permission.getId());
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list> 
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]permission.setPermission(permission);

		return [=AuthenticationTable?uncap_first]permission;
	}

	public [=AuthenticationTable]permissionEntity createNewEntityForUpdate() {
		
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] =create[=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u5");
		[=AuthenticationTable?uncap_first].setFirstName("U5");
		[=AuthenticationTable?uncap_first].setEmailAddress("u5@gma.com");
		[=AuthenticationTable?uncap_first].setId(5L);
		[=AuthenticationTable?uncap_first].setPassword("secret");
		[=AuthenticationTable?uncap_first].setIsActive(true);
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](5L);
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first](5);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](5D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("5");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]?? && authKey != "Password">
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](5L);
		<#elseif authValue.fieldType?lower_case == "integer" || authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](5);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](5D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("5");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>
		[=AuthenticationTable?uncap_first]=[=AuthenticationTable?uncap_first]Repository.save([=AuthenticationTable?uncap_first]);
		
		PermissionEntity permission = createPermissionEntity();
		permission.setName("P5");
		permission.setId(5L);
		permission=permissionRepository.save(permission);
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = new [=AuthenticationTable]permissionEntity();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(permission.getId());
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]permission.setPermission(permission);

		return [=AuthenticationTable?uncap_first]permission;
	}
	

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        <#if Cache !false>
        evictAllCaches();
        </#if>
        final [=AuthenticationTable]permissionController [=AuthenticationTable?uncap_first]permissionController = new [=AuthenticationTable]permissionController([=AuthenticationTable?uncap_first]permissionAppService,[=AuthenticationTable?uncap_first]AppService,logHelper);
        
        when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		
		
        this.mvc = MockMvcBuilders.standaloneSetup([=AuthenticationTable?uncap_first]permissionController)
        		.setCustomArgumentResolvers(sortArgumentResolver)
        		.setControllerAdvice()
                .build();
        	
    }

	@Before
	public void initTest() {
	
		[=AuthenticationTable?uncap_first]permission= createEntity();
		
		List<[=AuthenticationTable]permissionEntity> list= [=AuthenticationTable?uncap_first]permissionRepository.findAll();
		System.out.println(list);
	    if(list.isEmpty()){
	    	[=AuthenticationTable?uncap_first]permissionRepository.save([=AuthenticationTable?uncap_first]permission);
		}
	}
	
	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {

		 mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

	      mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
	    		  .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	@Test
	public void Create[=AuthenticationTable]permission_[=AuthenticationTable]DoesNotExists_ThrowEntityNotFoundException() throws Exception {
       
		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = create[=AuthenticationTable]permissionInput();

        ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]permission);
      
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->
        mvc.perform(post("/[=AuthenticationTable?uncap_first]permission")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())
         ).hasCause(new EntityNotFoundException("No record found"));
      
	}    
	
	@Test
	public void Create[=AuthenticationTable]permission_[=AuthenticationTable]permissionDoesNotExist_ReturnStatusOk() throws Exception {
	
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = new [=AuthenticationTable]Entity();
	    <#if (AuthenticationType!="none" && !UserInput??)>
        [=AuthenticationTable?uncap_first].setId(3L);
	    [=AuthenticationTable?uncap_first].setIsActive(true);
	    [=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u3");
	    [=AuthenticationTable?uncap_first].setEmailAddress("u3@g.com");
	    [=AuthenticationTable?uncap_first].setFirstName("U");
	    [=AuthenticationTable?uncap_first].setLastName("3");
	    [=AuthenticationTable?uncap_first].setPassword("secret");
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](3L);
		<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first](3);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](3D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("3");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]??>
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](3L);
		<#elseif authValue.fieldType?lower_case == "integer" || authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](3);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](3D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("3");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>
	    [=AuthenticationTable?uncap_first]=[=AuthenticationTable?uncap_first]Repository.save([=AuthenticationTable?uncap_first]);
	    
	    PermissionEntity permission = new PermissionEntity();
	    permission.setDisplayName("D1");
	    permission.setId(3L);
	    permission.setName("P3");
	    
	    permission=permissionRepository.save(permission);

		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = create[=AuthenticationTable]permissionInput();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(permission.getId());
		[=AuthenticationTable?uncap_first]permission.setRevoked(false);
	    <#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]permission);
      
		 mvc.perform(post("/[=AuthenticationTable?uncap_first]permission").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
	
	}  
	
	@Test
	public void Delete[=AuthenticationTable]permission_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {
	   
	   doReturn(null).when([=AuthenticationTable?uncap_first]permissionAppService).FindById(new [=AuthenticationTable]permissionId(32L, <#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/[=AuthenticationTable?uncap_first]permission/21")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));

	}  
	
	@Test
	public void Delete[=AuthenticationTable]permission_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {
	   
		doReturn(null).when([=AuthenticationTable?uncap_first]permissionAppService).FindById(new [=AuthenticationTable]permissionId(32L, <#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
		
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/[=AuthenticationTable?uncap_first]permission/permissionId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a [=AuthenticationTable?uncap_first]permission with a id=permissionId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>"));

	}

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		
		[=AuthenticationTable]permissionEntity up = [=AuthenticationTable?uncap_first]permissionRepository.save(createNewEntityForDelete());
	
		Find[=AuthenticationTable]permissionByIdOutput output= new Find[=AuthenticationTable]permissionByIdOutput();
	    output.setPermissionId(up.getPermissionId());
	    <#if (AuthenticationType!="none" && !UserInput??)>
	    output.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		output.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
	   
	     doReturn(output).when([=AuthenticationTable?uncap_first]permissionAppService).FindById(new [=AuthenticationTable]permissionId(up.getPermissionId(),<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if>));
	     Mockito.when([=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>)).thenReturn(create[=AuthenticationTable]ByIdOuput());
	     doNothing().when([=AuthenticationTable?uncap_first]AppService).deleteAllUserTokens(anyString());
	     
	     mvc.perform(delete("/[=AuthenticationTable?uncap_first]permission/permissionId:"+up.getPermissionId() + ",<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:" + up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:" + up.get[=AuthenticationTable][=key?cap_first]()<#sep>+ ",</#list></#if></#if>)
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isNoContent());
     	 
	}  
	
	@Test
	public void Update[=AuthenticationTable]permission_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {
	   
		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Update[=AuthenticationTable]permissionInput();
	    <#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(21L);
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](21L);
		<#elseif value?lower_case == "integer" || value?lower_case == "short">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](21);
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](21D);
		<#elseif value?lower_case == "string">
  		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]("21");
		</#if> 
		</#list>
		</#if> 
		</#if>
	    [=AuthenticationTable?uncap_first]permission.setPermissionId(21L);
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]permission);
		
    	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(put("/[=AuthenticationTable?uncap_first]permission/21")
    			 .contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));

	}  
	
	@Test
	public void Update[=AuthenticationTable]permission_IdIsNotValid_ReturnNotFound() throws Exception {
		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Update[=AuthenticationTable]permissionInput();
	    <#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(32L);
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](32L);
		<#elseif value?lower_case == "integer" || value?lower_case == "short">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](32);
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](32D);
		<#elseif value?lower_case == "string">
  		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first]("32");
		</#if> 
		</#list>
		</#if> 
		</#if>
	    [=AuthenticationTable?uncap_first]permission.setPermissionId(32L);
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]permission);
		doReturn(null).when([=AuthenticationTable?uncap_first]permissionAppService).FindById(new [=AuthenticationTable]permissionId(32L,<#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
		 
     	mvc.perform(put("/[=AuthenticationTable?uncap_first]permission/permissionId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
     			 .contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isNotFound());

	}
	
	@Test
	public void Update[=AuthenticationTable]permission_[=AuthenticationTable]permissionExists_ReturnStatusOk() throws Exception {
		
		[=AuthenticationTable]permissionEntity up = [=AuthenticationTable?uncap_first]permissionRepository.save(createNewEntityForUpdate());
		
		Find[=AuthenticationTable]permissionByIdOutput output= new Find[=AuthenticationTable]permissionByIdOutput();
	    <#if (AuthenticationType!="none" && !UserInput??)>
		output.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		output.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
	    output.setPermissionId(up.getPermissionId());

        Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Update[=AuthenticationTable]permissionInput();
        <#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]permission.setPermissionId(up.getPermissionId());
	
		doReturn(output).when([=AuthenticationTable?uncap_first]permissionAppService).FindById(new [=AuthenticationTable]permissionId(up.getPermissionId(),<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if>));
    	Mockito.when([=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>)).thenReturn(create[=AuthenticationTable]ByIdOuput());
     	doNothing().when([=AuthenticationTable?uncap_first]AppService).deleteAllUserTokens(anyString());
    	
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]permission);
     
        mvc.perform(put("/[=AuthenticationTable?uncap_first]permission/permissionId:"+up.getPermissionId() + ",<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:" + up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:" + up.get[=AuthenticationTable][=key?cap_first]()<#sep>+ ",</#list></#if></#if>)
        .contentType(MediaType.APPLICATION_JSON).content(json))
	    .andExpect(status().isOk());

        [=AuthenticationTable]permissionEntity entity= createNewEntityForUpdate();
        <#if (AuthenticationType!="none" && !UserInput??)>
		entity.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		entity.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
        entity.setPermissionId(up.getPermissionId());
        [=AuthenticationTable?uncap_first]permissionRepository.delete(entity);
       
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {
		
		 mvc.perform(get("/[=AuthenticationTable?uncap_first]permission?search=permissionId[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {
		 
		 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]permission?search=abcc[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abcc not found!"));
	
	} 
	
	@Test
	public void Get[=AuthenticationTable]_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:33/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=permissionId:33"));
	
	}    
	
	@Test
	public void Get[=AuthenticationTable]_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:99,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:99<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:99<#sep>,</#list></#if></#if>/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void Get[=AuthenticationTable]_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetPermission_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:33/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=permissionId:33"));
	
	}    
	
	@Test
	public void GetPermission_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:99,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:99<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:99<#sep>,</#list></#if></#if>/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetPermission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/[=AuthenticationTable?uncap_first]permission/permissionId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
}

