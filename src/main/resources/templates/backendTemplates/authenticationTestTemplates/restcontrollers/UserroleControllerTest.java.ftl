package [=PackageName].restcontrollers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.doReturn;

import java.util.List;

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
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import org.springframework.data.web.SortHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import [=CommonModulePackage].logging.LoggingHelper;
import [=PackageName].security.JWTAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Create[=AuthenticationTable]roleInput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Find[=AuthenticationTable]roleByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Update[=AuthenticationTable]roleInput;

import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]AppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].dto.Find[=AuthenticationTable]ByIdOutput;
import [=PackageName].domain.irepository.IRoleRepository;
import [=PackageName].domain.irepository.I[=AuthenticationTable]Repository;
import [=PackageName].domain.irepository.I[=AuthenticationTable]roleRepository;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class [=AuthenticationTable]roleControllerTest {

	private static final Long DEFAULT_ROLE_ID = 1L;
	private static final Long DEFAULT_USER_ID = 1L;

	@Autowired
	private SortHandlerMethodArgumentResolver sortArgumentResolver;

	@Autowired 
	private I[=AuthenticationTable]roleRepository [=AuthenticationTable?uncap_first]roleRepository;

	@Autowired
	private I[=AuthenticationTable]Repository [=AuthenticationTable?uncap_first]Repository;

	@Autowired
	private IRoleRepository roleRepository;

	@SpyBean
	private [=AuthenticationTable]AppService [=AuthenticationTable?uncap_first]AppService;

	@SpyBean
	private [=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService;

	@SpyBean
	private LoggingHelper logHelper;

	@Mock
	private Logger loggerMock;
	
	@SpyBean
	private JWTAppService jwtAppService;

	private [=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role;

	private MockMvc mvc;
	
	@Autowired
	EntityManagerFactory emf;
	
	static EntityManagerFactory emfs;
<#if Cache !false>

	@Autowired 
	private CacheManager cacheManager; 

	public void evictAllCaches(){ 
		for(String name : cacheManager.getCacheNames()){
			cacheManager.getCache(name).clear(); 
		} 
	}
</#if>

    @PostConstruct
	public void init() {
	this.emfs = emf;
	}

	@AfterClass
	public static void cleanup() {
	EntityManager em = emfs.createEntityManager();
	try {
		  em.getTransaction().begin(); 
		  em.createNativeQuery("drop table [=SchemaName?lower_case].[=AuthenticationTable?uncap_first]role CASCADE").executeUpdate();
		  em.createNativeQuery("drop table [=SchemaName?lower_case].role CASCADE").executeUpdate();
		  em.createNativeQuery("drop table [=SchemaName?lower_case].[=AuthenticationTable?uncap_first] CASCADE").executeUpdate();
		  em.getTransaction().commit();
		} catch(Exception ex) {
		  em.getTransaction().rollback();
		  throw ex;
		}
	}
	
	public [=AuthenticationTable]roleEntity createEntity() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]=create[=AuthenticationTable]Entity();
		RoleEntity role =createRoleEntity();
		
		if([=AuthenticationTable?uncap_first]Repository.findAll().isEmpty())
		{
		<#if Flowable!false>
			ActIdUserEntity actIdUser = actIdUserMapper.createUsersEntityToActIdUserEntity([=AuthenticationTable?uncap_first]);
			idmIdentityService.createUser([=AuthenticationTable?uncap_first], actIdUser);
		</#if>
			[=AuthenticationTable?uncap_first]=[=AuthenticationTable?uncap_first]Repository.save([=AuthenticationTable?uncap_first]);
		}

		if(roleRepository.findAll().isEmpty())
		{
			role=roleRepository.save(role);
			<#if Flowable!false>
			idmIdentityService.createGroup(role.getName());
			</#if>
		}
		
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = new [=AuthenticationTable]roleEntity();
		[=AuthenticationTable?uncap_first]role.setRoleId(role.getId());
		<#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]role.setRole(role);
		

		return [=AuthenticationTable?uncap_first]role;
	}

	public static Create[=AuthenticationTable]roleInput create[=AuthenticationTable]roleInput() {
		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Create[=AuthenticationTable]roleInput();
		[=AuthenticationTable?uncap_first]role.setRoleId(3L);
		<#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(3L);
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](3L);
		<#elseif value?lower_case == "integer">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](3);
		<#elseif value?lower_case == "short">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]((short)3);
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](3D);
		<#elseif value?lower_case == "string">
  		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]("3");
		</#if> 
		</#list>
		</#if> 
		</#if>
		
		return [=AuthenticationTable?uncap_first]role;
	}

	public static [=AuthenticationTable]Entity create[=AuthenticationTable]Entity() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = new [=AuthenticationTable]Entity();
		<#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
	    [=AuthenticationTable?uncap_first].setId(DEFAULT_USER_ID);
		[=AuthenticationTable?uncap_first].setIsActive(true);
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u1");
		[=AuthenticationTable?uncap_first].setEmailAddress("u1@g.com");
		[=AuthenticationTable?uncap_first].setFirstName("U1");
		[=AuthenticationTable?uncap_first].setLastName("1");
		<#if AuthenticationType =="database">
		[=AuthenticationTable?uncap_first].setPassword("secret");
		</#if>
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=key?cap_first](1);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first]((short)1);
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
		<#elseif authValue.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](1);
		<#elseif authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]((short)1);
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

	public static RoleEntity createRoleEntity() {
		RoleEntity role = new RoleEntity();
		role.setDisplayName("D1");
		role.setId(DEFAULT_ROLE_ID);
		role.setName("P1");

		return role;

	}

	public Find[=AuthenticationTable]ByIdOutput create[=AuthenticationTable]ByIdOuput()
	{
		Find[=AuthenticationTable]ByIdOutput [=AuthenticationTable?uncap_first] = new Find[=AuthenticationTable]ByIdOutput();
		<#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
		[=AuthenticationTable?uncap_first].setId(4L);
		[=AuthenticationTable?uncap_first].setIsActive(true);
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u4");
		[=AuthenticationTable?uncap_first].setEmailAddress("u4@gh.com");
		[=AuthenticationTable?uncap_first].setFirstName("U4");
		[=AuthenticationTable?uncap_first].setLastName("4");
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false && (AuthenticationType =="database" && AuthenticationFields?? && AuthenticationFields.Password.fieldName != value.fieldName)>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](4L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=key?cap_first](4);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first]((short)4);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](4D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("4");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]?? && ( AuthenticationType =="database" && authKey != "Password")>
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](4L);
		<#elseif authValue.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](4);
		<#elseif authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]((short)4);
		<#elseif authValue.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](4D);
		<#elseif authValue.fieldType?lower_case == "boolean">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](true);
		<#elseif authValue.fieldType?lower_case == "date">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](new Date());
		<#elseif authValue.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]("4");
		</#if> 
		</#if>
		</#list>
		</#if>
		</#if>

		return [=AuthenticationTable?uncap_first];
	}

	public [=AuthenticationTable]roleEntity createNewEntityForDelete() {
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] =create[=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u2");
		<#if AuthenticationType =="database" >
		[=AuthenticationTable?uncap_first].setPassword("secret");
		</#if>
		[=AuthenticationTable?uncap_first].setIsActive(true);
		[=AuthenticationTable?uncap_first].setFirstName("U2");
		[=AuthenticationTable?uncap_first].setEmailAddress("u2@gil.com");
		[=AuthenticationTable?uncap_first].setId(2L);
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](2L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=key?cap_first](2);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first]((short)2);
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
		<#elseif authValue.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](2);
		<#elseif authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]((short)2);
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
		
		RoleEntity role = createRoleEntity();
		role.setName("P2");
		role.setId(2L);
		role.setDisplayName("D2");
		role=roleRepository.save(role);
		
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = new [=AuthenticationTable]roleEntity();
		[=AuthenticationTable?uncap_first]role.setRoleId(role.getId());
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list> 
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]role.setRole(role);

		return [=AuthenticationTable?uncap_first]role;
	}

	public [=AuthenticationTable]roleEntity createNewEntityForUpdate() {
		
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] =create[=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u5");
		[=AuthenticationTable?uncap_first].setFirstName("U5");
		[=AuthenticationTable?uncap_first].setEmailAddress("u5@gma.com");
		[=AuthenticationTable?uncap_first].setId(5L);
		<#if AuthenticationType =="database">
		[=AuthenticationTable?uncap_first].setPassword("secret");
		</#if>
		[=AuthenticationTable?uncap_first].setIsActive(true);
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](5L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=key?cap_first](5);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first]((short)5);
		<#elseif value.fieldType?lower_case == "double">
		[=ClassName?uncap_first].set[=key?cap_first](5D);
		<#elseif value.fieldType?lower_case == "string">
  		[=ClassName?uncap_first].set[=key?cap_first]("5");
		</#if> 
		</#if>
		</#list>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
		<#if !Fields[authValue.fieldName]?? && (AuthenticationType =="database" && authKey != "Password")>
		<#if authValue.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](5L);
		<#elseif authValue.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](5);
		<#elseif authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]((short)5);
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
		
		RoleEntity role = createRoleEntity();
		role.setName("P5");
		role.setId(5L);
		role.setDisplayName("D5");
		role=roleRepository.save(role);
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = new [=AuthenticationTable]roleEntity();
		[=AuthenticationTable?uncap_first]role.setRoleId(role.getId());
		<#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]([=AuthenticationTable?uncap_first]);
		[=AuthenticationTable?uncap_first]role.setRole(role);

		return [=AuthenticationTable?uncap_first]role;
	}
	
	@Before
	public void setup() {
		MockitoAnnotations.initMocks(this);
        <#if Cache !false>
		evictAllCaches();
		</#if>
		final [=AuthenticationTable]roleController [=AuthenticationTable?uncap_first]roleController = new [=AuthenticationTable]roleController([=AuthenticationTable?uncap_first]roleAppService, [=AuthenticationTable?uncap_first]AppService,jwtAppService,logHelper);

		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());


		this.mvc = MockMvcBuilders.standaloneSetup([=AuthenticationTable?uncap_first]roleController)
				.setCustomArgumentResolvers(sortArgumentResolver)
				.setControllerAdvice()
				.build();

	}

	@Before
	public void initTest() {

		[=AuthenticationTable?uncap_first]role= createEntity();

		List<[=AuthenticationTable]roleEntity> list= [=AuthenticationTable?uncap_first]roleRepository.findAll();
		System.out.println(list);
		if(list.isEmpty())
		{
			[=AuthenticationTable?uncap_first]roleRepository.save([=AuthenticationTable?uncap_first]role);
			<#if Flowable!false>
			idmIdentityService.addUserGroupMapping([=AuthenticationTable?uncap_first]role.get[=AuthenticationTable]().get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>(), [=AuthenticationTable?uncap_first]role.getRole().getName());
            </#if>
		}

	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void Create[=AuthenticationTable]role_[=AuthenticationTable]DoesNotExists_ThrowEntityNotFoundException() throws Exception {

		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = create[=AuthenticationTable]roleInput();
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]role);
      
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->
		mvc.perform(post("/[=AuthenticationTable?uncap_first]role")
				.contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk())
				).hasCause(new EntityNotFoundException("No record found"));

	}    

	@Test
	public void Create[=AuthenticationTable]role_[=AuthenticationTable]roleDoesNotExist_ReturnStatusOk() throws Exception {

		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = new [=AuthenticationTable]Entity();
		<#if (AuthenticationType!="none" && !UserInput??)>
        [=AuthenticationTable?uncap_first].setId(3L);
	    [=AuthenticationTable?uncap_first].setIsActive(true);
	    [=AuthenticationTable?uncap_first].set[=AuthenticationTable]Name("u3");
	    [=AuthenticationTable?uncap_first].setEmailAddress("u3@g.com");
	    [=AuthenticationTable?uncap_first].setFirstName("U");
	    [=AuthenticationTable?uncap_first].setLastName("3");
	    <#if AuthenticationType =="database">
	    [=AuthenticationTable?uncap_first].setPassword("secret");
	    </#if>
		<#else>
  		<#list Fields as key,value>
  		<#if value.isNullable==false>
		<#if value.fieldType?lower_case == "long">
		[=ClassName?uncap_first].set[=key?cap_first](3L);
		<#elseif value.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=key?cap_first](3);
		<#elseif value.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=key?cap_first]((short)3);
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
		<#elseif authValue.fieldType?lower_case == "integer">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first](3);
		<#elseif authValue.fieldType?lower_case == "short">
		[=ClassName?uncap_first].set[=authValue.fieldName?cap_first]((short)3);
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

		RoleEntity role = new RoleEntity();
		role.setDisplayName("D1");
		role.setId(3L);
		role.setName("R3");

		role=roleRepository.save(role);
        <#if Flowable!false>
		ActIdUserEntity actIdUser = actIdUserMapper.createUsersEntityToActIdUserEntity([=AuthenticationTable?uncap_first]);
		idmIdentityService.createUser([=AuthenticationTable?uncap_first], actIdUser);
		idmIdentityService.createGroup(role.getName());
        </#if>
		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = create[=AuthenticationTable]roleInput();
		[=AuthenticationTable?uncap_first]role.setRoleId(role.getId());
	    <#if (AuthenticationType!="none" && !UserInput??)>
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(user.getId());
		<#else>
		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]([=AuthenticationTable?uncap_first].get[=key?cap_first]());
		</#if> 
		</#list>
		</#if> 
		</#if>
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]role);

		mvc.perform(post("/[=AuthenticationTable?uncap_first]role").contentType(MediaType.APPLICATION_JSON).content(json))
		.andExpect(status().isOk());

	}  

	@Test
	public void Delete[=AuthenticationTable]role_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {

		doReturn(null).when([=AuthenticationTable?uncap_first]roleAppService).FindById(new [=AuthenticationTable]roleId(32L,<#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/[=AuthenticationTable?uncap_first]role/21")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));

	}  

	@Test
	public void Delete[=AuthenticationTable]role_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {

		doReturn(null).when([=AuthenticationTable?uncap_first]roleAppService).FindById(new [=AuthenticationTable]roleId(32L,<#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/[=AuthenticationTable?uncap_first]role/roleId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a [=AuthenticationTable?uncap_first]role with a id=roleId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>"));

	}

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {

		[=AuthenticationTable]roleEntity up = [=AuthenticationTable?uncap_first]roleRepository.save(createNewEntityForDelete());
		Find[=AuthenticationTable]roleByIdOutput output= new Find[=AuthenticationTable]roleByIdOutput();
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
		output.setRoleId(up.getRoleId());

		doReturn(output).when([=AuthenticationTable?uncap_first]roleAppService).FindById(new [=AuthenticationTable]roleId(up.getRoleId(),<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if>));
	
		Mockito.when([=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>
		)).thenReturn(create[=AuthenticationTable]ByIdOuput());
		doNothing().when(jwtAppService).deleteAllUserTokens(anyString());

		mvc.perform(delete("/[=AuthenticationTable?uncap_first]role/roleId:"+up.getRoleId() +",<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:" + up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:" + up.get[=AuthenticationTable][=key?cap_first]()<#sep>+ ",</#list></#if></#if>)
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNoContent());

	}  

//	@Test
//	public void Update[=AuthenticationTable]role_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {
//
//		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Update[=AuthenticationTable]roleInput();
//		<#if (AuthenticationType!="none" && !UserInput??)>
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(21L);
//		<#else>
//		<#if PrimaryKeys??>
//  	<#list PrimaryKeys as key,value>
//		<#if value?lower_case == "long">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](21L);
//		<#elseif value?lower_case == "integer" || value?lower_case == "short">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](21);
//		<#elseif value?lower_case == "double">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](21D);
//		<#elseif value?lower_case == "string">
//  		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]("21");
//		</#if> 
//		</#list>
//		</#if> 
//		</#if>
//		[=AuthenticationTable?uncap_first]role.setRoleId(21L);
//		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
//		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]role);
//
//		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(put("/[=AuthenticationTable?uncap_first]role/21")
//				.contentType(MediaType.APPLICATION_JSON).content(json))
//				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));
//
//	}  
//
//	@Test
//	public void Update[=AuthenticationTable]role_IdIsNotValid_ReturnNotFound() throws Exception {
//		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Update[=AuthenticationTable]roleInput();
//		<#if (AuthenticationType!="none" && !UserInput??)>
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(32L);
//		<#else>
//		<#if PrimaryKeys??>
//  	<#list PrimaryKeys as key,value>
//		<#if value?lower_case == "long">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](32L);
//		<#elseif value?lower_case == "integer" || value?lower_case == "short">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](32);
//		<#elseif value?lower_case == "double">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](32D);
//		<#elseif value?lower_case == "string">
//  		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first]("32");
//		</#if> 
//		</#list>
//		</#if> 
//		</#if>
//		[=AuthenticationTable?uncap_first]role.setRoleId(32L);
//		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
//		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]role);
//      
//		doReturn(null).when([=AuthenticationTable?uncap_first]roleAppService).FindById(new [=AuthenticationTable]roleId(32L,<#if (AuthenticationType!="none" && !UserInput??)>32L<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if value?lower_case == "long">32L<#elseif value?lower_case == "integer" || value?lower_case == "short">32<#elseif value?lower_case == "double">32D<#elseif value?lower_case == "boolean">true<#elseif value?lower_case == "date">new Date()<#elseif value?lower_case == "string">"32"</#if><#sep>,</#list></#if>));
//		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(put("/[=AuthenticationTable?uncap_first]role/roleId:32,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:32<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:32<#sep>,</#list></#if></#if>")
//				.contentType(MediaType.APPLICATION_JSON).content(json))
//				.andExpect(status().isNotFound()));
//
//	}
//
//	@Test
//	public void Update[=AuthenticationTable]role_[=AuthenticationTable]roleExists_ReturnStatusOk() throws Exception {
//
//		[=AuthenticationTable]roleEntity up = [=AuthenticationTable?uncap_first]roleRepository.save(createNewEntityForUpdate());
//		Find[=AuthenticationTable]roleByIdOutput output= new Find[=AuthenticationTable]roleByIdOutput();
//		<#if (AuthenticationType!="none" && !UserInput??)>
//		output.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
//		<#else>
//		<#if PrimaryKeys??>
//  		<#list PrimaryKeys as key,value>
//		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
//		output.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
//		</#if> 
//		</#list>
//		</#if> 
//		</#if>
//		output.setRoleId(up.getRoleId());
//
//		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Update[=AuthenticationTable]roleInput();
//		<#if (AuthenticationType!="none" && !UserInput??)>
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
//		<#else>
//		<#if PrimaryKeys??>
// 		<#list PrimaryKeys as key,value>
//		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
//		[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
//		</#if> 
//		</#list>
//		</#if> 
//		</#if>
//		[=AuthenticationTable?uncap_first]role.setRoleId(up.getRoleId());
//
//		doReturn(output).when([=AuthenticationTable?uncap_first]roleAppService).FindById(new [=AuthenticationTable]roleId(up.getRoleId(),<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if>));
//		Mockito.when([=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>up.get[=AuthenticationTable][=key?cap_first]()<#sep>,</#list></#if></#if>)).thenReturn(create[=AuthenticationTable]ByIdOuput());
//		doNothing().when(jwtAppService).deleteAllUserTokens(anyString());
//
//      ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
//		String json = ow.writeValueAsString([=AuthenticationTable?uncap_first]role);
//      
//
//		mvc.perform(put("/[=AuthenticationTable?uncap_first]role/roleId:"+up.getRoleId() + ",<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:" + up.get[=AuthenticationTable]Id()<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:" + up.get[=AuthenticationTable][=key?cap_first]()<#sep>+ ",</#list></#if></#if>)
//		.contentType(MediaType.APPLICATION_JSON).content(json))
//		.andExpect(status().isOk());
//
//		[=AuthenticationTable]roleEntity entity= createNewEntityForUpdate();
//		<#if (AuthenticationType!="none" && !UserInput??)>
//		entity.set[=AuthenticationTable]Id(up.get[=AuthenticationTable]Id());
//		<#else>
//		<#if PrimaryKeys??>
//  		<#list PrimaryKeys as key,value>
//		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "string">
//		entity.set[=AuthenticationTable][=key?cap_first](up.get[=AuthenticationTable][=key?cap_first]());
//		</#if> 
//		</#list>
//		</#if> 
//		</#if>
//		entity.setRoleId(up.getRoleId());
//		[=AuthenticationTable?uncap_first]roleRepository.delete(entity);
//		[=AuthenticationTable?uncap_first]Repository.delete(up.get[=AuthenticationTable]());
//		roleRepository.delete(up.getRole());
//		<#if Flowable!false>
//		idmIdentityService.deleteUserGroupMapping(up.get[=AuthenticationTable]().get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>(), up.getRole().getName());
//	    </#if>
//	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role?search=roleId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}    

	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]role?search=abcc[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property abcc not found!"));

	} 

	@Test
	public void Get[=AuthenticationTable]_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:33/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=roleId:33"));

	}    

	@Test
	public void Get[=AuthenticationTable]_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:99,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:99<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:99<#sep>,</#list></#if></#if>/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void Get[=AuthenticationTable]_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>/[=AuthenticationTable?uncap_first]")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

	@Test
	public void GetRole_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {

		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:33/role")
				.contentType(MediaType.APPLICATION_JSON))
				.andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=roleId:33"));

	}    

	@Test
	public void GetRole_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:99,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:99<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:99<#sep>,</#list></#if></#if>/role")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isNotFound());

	}    

	@Test
	public void GetRole_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {

		mvc.perform(get("/[=AuthenticationTable?uncap_first]role/roleId:1,<#if (AuthenticationType!="none" && !UserInput??)>[=AuthenticationTable?uncap_first]Id:1<#else><#if PrimaryKeys??><#list PrimaryKeys as key,value>[=AuthenticationTable?uncap_first][=key?cap_first]:1<#sep>,</#list></#if></#if>/role")
				.contentType(MediaType.APPLICATION_JSON))
		.andExpect(status().isOk());
	}  

}
