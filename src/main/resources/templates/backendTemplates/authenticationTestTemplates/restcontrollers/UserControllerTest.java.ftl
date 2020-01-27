package [=PackageName].restcontrollers;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityExistsException;
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
import org.springframework.data.web.SortHandlerMethodArgumentResolver;

import org.springframework.http.MediaType;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
<#if Cache !false>
import org.springframework.cache.CacheManager;
</#if>

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import [=CommonModulePackage].logging.LoggingHelper;
import [=PackageName].security.JWTAppService;
import [=PackageName].application.authorization.user.UserAppService;
import [=PackageName].application.authorization.user.dto.CreateUserInput;
import [=PackageName].application.authorization.user.dto.FindUserByIdOutput;
import [=PackageName].application.authorization.user.dto.FindUserByNameOutput;
import [=PackageName].application.authorization.user.dto.FindUserWithAllFieldsByIdOutput;
import [=PackageName].application.authorization.user.dto.UpdateUserInput;
import [=PackageName].application.authorization.userpermission.UserpermissionAppService;
import [=PackageName].application.authorization.userrole.UserroleAppService;

import [=PackageName].domain.irepository.IUserRepository;
import [=PackageName].domain.model.UserEntity;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserControllerTest {

	private static final String DEFAULT_USER_NAME = "U1";
	
	@Autowired
    private SortHandlerMethodArgumentResolver sortArgumentResolver;
	
	@Autowired 
	private IUserRepository user_repository;

	@SpyBean
	private UserAppService userAppService;
	
	@SpyBean
	private UserpermissionAppService userpermissionAppService;
	
	@SpyBean
	private UserroleAppService userroleAppService;
	
	@SpyBean
	private LoggingHelper logHelper;
	
	<#if AuthenticationType == "database">
	@SpyBean
	private PasswordEncoder pEncoder;
	</#if>
	
	@SpyBean
	private JWTAppService jwtAppService;
	
	@Mock
	private Logger loggerMock;
	
	private UserEntity user;
	
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
		em.createNativeQuery("drop table [=SchemaName?lower_case].user CASCADE").executeUpdate();
		em.getTransaction().commit();
	}
	
	public static UserEntity createEntity() {
		UserEntity user = new UserEntity();
		user.setUserName(DEFAULT_USER_NAME);
		user.setId(1L);
		<#if AuthenticationType == "database">
		user.setPassword("secret");
		</#if>
		user.setFirstName("U1");
		user.setLastName("11");
		user.setEmailAddress("u11@g.com");
		user.setIsActive(true);
		return user;
	}

	public static CreateUserInput createUserInput() {
		CreateUserInput user = new CreateUserInput();
		
		user.setUserName("newUser");
		<#if AuthenticationType == "database">
		user.setPassword("secret");
		</#if>
		user.setFirstName("U22");
		user.setLastName("122");
		user.setEmailAddress("u122@g.com");
		user.setIsActive(true);

		return user;
	}
	
	public static UserEntity createNewEntity() {
		UserEntity user = new UserEntity();
		user.setId(2L);
		<#if AuthenticationType == "database">
		user.setPassword("secret");
		</#if>
		user.setUserName("U25");
		user.setFirstName("U25");
		user.setLastName("125");
		user.setEmailAddress("u125@g.com");
		user.setIsActive(true);

		return user;
	}

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        <#if Cache !false>
        evictAllCaches();
        </#if>
        final UserController userController = new UserController(userAppService,userpermissionAppService,userroleAppService,<#if AuthenticationType == "database">pEncoder,</#if>jwtAppService,logHelper);
        
        when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		
		
        this.mvc = MockMvcBuilders.standaloneSetup(userController)
        		.setCustomArgumentResolvers(sortArgumentResolver)
        		.setControllerAdvice()
                .build();
        	
    }

	@Before
	public void initTest() {
	
		user= createEntity();
	
		List<UserEntity> list= user_repository.findAll();
	    if(list.isEmpty()) {
		   user_repository.save(user);
	    }
	
	}
	
	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {
		 mvc.perform(get("/user/1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

	      mvc.perform(get("/user/21")
	    		  .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    

	@Test
	public void CreateUser_UserDoesNotExist_ReturnStatusOk() throws Exception {
	
	    Mockito.doReturn(null).when(userAppService).FindByUserName(anyString());
        
		CreateUserInput user = createUserInput();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
      
		 mvc.perform(post("/user").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
		 
		 user_repository.delete(createNewEntity());
	}  

	@Test
	public void CreateUser_UserAlreadyExists_ThrowEntityExistsException() throws Exception {

		FindUserByNameOutput output= new FindUserByNameOutput();
	    output.setId(3L);
	    output.setUserName("U23");
	    output.setFirstName("U23");
	    output.setLastName("123");
	    output.setEmailAddress("u123@g.com");
	    output.setIsActive(true);

	    Mockito.when(userAppService.FindByUserName(anyString())).thenReturn(output);
        
	    CreateUserInput user = createUserInput();
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
       
        org.assertj.core.api.Assertions.assertThatThrownBy(() -> mvc.perform(post("/user")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())).hasCause(new EntityExistsException("There already exists a user with a name=" + user.getUserName()));
      
	}    
	
	@Test
	public void DeleteUser_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {
	   
	    Mockito.doReturn(null).when(userAppService).FindById(anyLong());
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/user/21")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a user with a id=21"));

	}  

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		
		Long id = user_repository.save(createNewEntity()).getId();
		
		FindUserByIdOutput output= new FindUserByIdOutput();
	    output.setId(id.longValue());
	    output.setUserName("U33");
	    output.setFirstName("U33");
	    output.setLastName("133");
	    output.setEmailAddress("u133@g.com");
	    output.setIsActive(true);
	    
	    Mockito.when(userAppService.FindById(anyLong())).thenReturn(output);
		
     	 mvc.perform(delete("/user/"+id.toString())
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isNoContent());
	}  
	
	
	@Test
	public void UpdateUser_UserDoesNotExist_ReturnStatusNotFound() throws Exception {
		
        Mockito.doReturn(null).when(userAppService).FindWithAllFieldsById(anyLong());
        UpdateUserInput user = new UpdateUserInput();
        user.setId(1L);
        user.setUserName("U116");
		user.setFirstName("U116");
		user.setLastName("116");
		user.setEmailAddress("u116@g.com");
		user.setIsActive(true);
		
 		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
      
        mvc.perform(put("/user/1").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isNotFound());
     
	}    
	
	@Test
	public void UpdateUser_UserExists_ReturnStatusOk() throws Exception {
		UserEntity ue=user_repository.save(createNewEntity());
		Long id = ue.getId();
		FindUserWithAllFieldsByIdOutput output= new FindUserWithAllFieldsByIdOutput();
	    output.setId(id.longValue());
	    output.setUserName(ue.getUserName());
	    output.setFirstName(ue.getFirstName());
	    output.setLastName(ue.getLastName());
	    output.setEmailAddress(ue.getEmailAddress());
	    output.setIsActive(ue.getIsActive());
	    <#if AuthenticationType == "database">
	    output.setPassword(ue.getPassword());
	    </#if>
	    
		Mockito.doReturn(output).when(userAppService).FindWithAllFieldsById(anyLong());
	    
	    doNothing().when(jwtAppService).deleteAllUserTokens(anyString());  
	    
        UpdateUserInput user = new UpdateUserInput();
        user.setId(id.longValue());
		user.setUserName(ue.getUserName());
		user.setFirstName("U1");
		user.setLastName("16");
		user.setEmailAddress("u16@g.com");
		user.setIsActive(true);
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(user);
      
        mvc.perform(put("/user/"+id).contentType(MediaType.APPLICATION_JSON).content(json))
	    .andExpect(status().isOk());

        UserEntity e= createEntity();
        e.setId(id);
        user_repository.delete(e);
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {
		
		 mvc.perform(get("/user?search=id[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {
		 
		 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user?search=roleid[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property roleid not found!"));
	
	}   
	
	@Test
	public void GetUserrole_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("roleid", "1");
		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/2/userrole?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property roleid not found!"));
	
	}    
	
	@Test
	public void GetUserrole_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("userId", "1");
		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/user/2/userrole?search=userId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetUserrole_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseUserroleJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/user/2/userrole?search=roleid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	@Test
	public void GetUserpermission_searchIsNotEmptyAndPropertyIsNotValid_ThrowException() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("userid", "1");
		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(joinCol);
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/user/2/userpermission?search=userid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property userid not found!"));
	
	}    
	
	@Test
	public void GetUserpermission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
		Map<String,String> joinCol = new HashMap<String,String>();
		joinCol.put("userId", "1");
		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(joinCol);

		mvc.perform(get("/user/2/userpermission?search=userId[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetUserpermission_searchIsNotEmpty() throws Exception {
	
		Mockito.when(userAppService.parseUserpermissionJoinColumn(any(String.class))).thenReturn(null);
		mvc.perform(get("/user/2/userpermission?search=userid[equals]=1&limit=10&offset=1")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	
}
