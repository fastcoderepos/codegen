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
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.SpyBean;
<#if Cache>
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
import [=PackageName].application.authorization.rolepermission.RolepermissionAppService;
import [=PackageName].application.authorization.rolepermission.dto.CreateRolepermissionInput;
import [=PackageName].application.authorization.rolepermission.dto.FindRolepermissionByIdOutput;
import [=PackageName].application.authorization.rolepermission.dto.UpdateRolepermissionInput;
import [=PackageName].application.authorization.role.dto.FindRoleByIdOutput;
import [=PackageName].domain.irepository.IPermissionRepository;
import [=PackageName].domain.irepository.IRoleRepository;
import [=PackageName].domain.irepository.IRolepermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.RolepermissionId;

@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class RolepermissionControllerTest {

	private static final Long DEFAULT_PERMISSION_ID = 1L;
	private static final Long DEFAULT_ROLE_ID = 1L;
	
	@Autowired
    private SortHandlerMethodArgumentResolver sortArgumentResolver;
	
	@Autowired 
	private IRolepermissionRepository rolepermissionRepository;
	
	@Autowired
	private IRoleRepository roleRepository;
	
	@Autowired
	private IPermissionRepository permissionRepository;

	@SpyBean
	private RolepermissionAppService rolepermissionAppService;
	
	@SpyBean
	private LoggingHelper logHelper;
	
	@Mock
	private Logger loggerMock;
	
	private RolepermissionEntity rolepermissionEntity;
	
	private MockMvc mvc;
	
	<#if Cache>
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
		em.createNativeQuery("drop table [=SchemaName?lower_case].rolepermission CASCADE").executeUpdate();
		em.createNativeQuery("drop table [=SchemaName?lower_case].permission CASCADE").executeUpdate();
		em.createNativeQuery("drop table [=SchemaName?lower_case].role CASCADE").executeUpdate();
		em.getTransaction().commit();
	}
   
		public RolepermissionEntity createEntity() {
		RolepermissionEntity rolepermission = new RolepermissionEntity();
		rolepermission.setPermissionId(DEFAULT_PERMISSION_ID );
		rolepermission.setRoleId(DEFAULT_ROLE_ID);
		roleRepository.save(createRoleEntity());
		permissionRepository.save(createPermissionEntity());
		rolepermission.setRole(createRoleEntity());
		rolepermission.setPermission(createPermissionEntity());

		return rolepermission;
	}
	
	public static RoleEntity createRoleEntity() {
		RoleEntity role = new RoleEntity();
	    role.setDisplayName("D1");
	    role.setId(DEFAULT_ROLE_ID);
	    role.setName("R1");
		
		return role;
	}
	
	public static PermissionEntity createPermissionEntity() {
		PermissionEntity permission = new PermissionEntity();
	    permission.setDisplayName("D1");
	    permission.setId(DEFAULT_PERMISSION_ID);
	    permission.setName("P1");
	    
	    return permission;
	}
	
	public FindRoleByIdOutput createRoleByIdOuput()
	{
		FindRoleByIdOutput role = new FindRoleByIdOutput();
		role.setDisplayName("D4");
	    role.setId(DEFAULT_ROLE_ID);
	    role.setName("R4");
	  
		return role;
	}
	
	public RolepermissionEntity createNewEntityForDelete() {
		RoleEntity role = new RoleEntity ();
		role.setDisplayName("D2");
		role.setId(2L);
		role.setName("R2");
		role= roleRepository.save(role);
		
		PermissionEntity permission = createPermissionEntity();
		permission.setDisplayName("D2");
		permission.setName("P2");
		permission.setId(2L);
		permission=permissionRepository.save(permission);
		
		RolepermissionEntity rolepermission = new RolepermissionEntity();
		rolepermission.setPermissionId(permission.getId());
		rolepermission.setRoleId(role.getId());
		rolepermission.setRole(role);
		rolepermission.setPermission(permission);

		return rolepermission;
	}

	public RolepermissionEntity createNewEntityForUpdate() {
		
		RoleEntity role = new RoleEntity ();
		role.setDisplayName("D5");
		role.setId(5L);
		role.setName("R5");
		
		role= roleRepository.save(role);
		
		PermissionEntity permission = createPermissionEntity();
		permission.setName("P5");
		permission.setDisplayName("D5");
		permission.setId(5L);
		permission=permissionRepository.save(permission);
		
		RolepermissionEntity rolepermission = new RolepermissionEntity();
		rolepermission.setPermissionId(permission.getId());
		rolepermission.setRoleId(role.getId());
		rolepermission.setRole(role);
		rolepermission.setPermission(permission);

		return rolepermission;
	}

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        <#if Cache>
        evictAllCaches();
        </#if>
        final RolepermissionController rolepermissionController = new RolepermissionController(rolepermissionAppService,logHelper);
        
        when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
		
		
        this.mvc = MockMvcBuilders.standaloneSetup(rolepermissionController)
        		.setCustomArgumentResolvers(sortArgumentResolver)
        		.setControllerAdvice()
                .build();
        	
    }

	@Before
	public void initTest() {
	
		rolepermissionEntity= createEntity();
		
		List<RolepermissionEntity> list= rolepermissionRepository.findAll();
		System.out.println(list);
	    if(list.isEmpty())
	    	rolepermissionRepository.save(rolepermissionEntity);
		
	}

	@Test
	public void FindById_IdIsValid_ReturnStatusOk() throws Exception {

		 mvc.perform(get("/rolepermission/permissionId:3,roleId:3")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  

	@Test
	public void FindById_IdIsNotValid_ReturnStatusNotFound() throws Exception {

	      mvc.perform(get("/rolepermission/permissionId:32,roleId:32")
	    		  .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	@Test
	public void CreateRolepermission_RoleDoesNotExists_ThrowEntityNotFoundException() throws Exception {
       
		CreateRolepermissionInput rolepermission = new CreateRolepermissionInput();
		rolepermission.setPermissionId(35L);
		rolepermission.setRoleId(35L);
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(rolepermission);
       
        org.assertj.core.api.Assertions.assertThatThrownBy(() ->
        mvc.perform(post("/rolepermission")
        		.contentType(MediaType.APPLICATION_JSON).content(json))
         .andExpect(status().isOk())
         ).hasCause(new EntityNotFoundException("No record found"));
      
	}    
	
	@Test
	public void CreateRolepermission_RolepermissionDoesNotExist_ReturnStatusOk() throws Exception {
	
		RoleEntity role = new RoleEntity();
	    role.setDisplayName("D3");
	    role.setId(3L);
	    role.setName("R3");
	    
	    role=roleRepository.save(role);
	    
	    PermissionEntity permission = new PermissionEntity();
	    permission.setDisplayName("D3");
	    permission.setId(3L);
	    permission.setName("P3");
	    
	    permission=permissionRepository.save(permission);
	    
		CreateRolepermissionInput rolepermission = new CreateRolepermissionInput();
		rolepermission.setPermissionId(permission.getId());
		rolepermission.setRoleId(role.getId());
		
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(rolepermission);
      
		 mvc.perform(post("/rolepermission").contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk());
		 
	}  
	
	@Test
	public void DeleteRolepermission_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {
	   
		doReturn(null).when(rolepermissionAppService).FindById(new RolepermissionId(32L, 32L));
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/rolepermission/21")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));
	}  
	
	@Test
	public void DeleteRolepermission_IdIsNotValid_ThrowEntityNotFoundException() throws Exception {
	   
		doReturn(null).when(rolepermissionAppService).FindById(new RolepermissionId(32L, 32L));
     	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(delete("/rolepermission/permissionId:32,roleId:32")
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("There does not exist a rolepermission with a id=permissionId:32,roleId:32"));

	}

	@Test
	public void Delete_IdIsValid_ReturnStatusNoContent() throws Exception {
		
		RolepermissionEntity up = rolepermissionRepository.save(createNewEntityForDelete());
	
		FindRolepermissionByIdOutput output= new FindRolepermissionByIdOutput();
	    output.setRoleId(up.getRoleId());
	    output.setPermissionId(up.getPermissionId());

	     doReturn(output).when(rolepermissionAppService).FindById(new RolepermissionId(up.getPermissionId(),up.getRoleId()));
	  
	     mvc.perform(delete("/rolepermission/permissionId:"+up.getPermissionId() + ",roleId:" + up.getRoleId())
     			 .contentType(MediaType.APPLICATION_JSON))
		  .andExpect(status().isNoContent());
	}  
	
	@Test
	public void UpdateRolepermission_IdIsNotParseable_ThrowEntityNotFoundException() throws Exception {
	   
		UpdateRolepermissionInput rolepermission = new UpdateRolepermissionInput();
	    rolepermission.setRoleId(21L);
	    rolepermission.setPermissionId(21L);
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(rolepermission);
		
    	 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(put("/rolepermission/21")
    			 .contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=21"));

	}  
	
	@Test
	public void UpdateRolepermission_IdIsNotValid_ReturnNotFound() throws Exception {
		UpdateRolepermissionInput rolepermission = new UpdateRolepermissionInput();
	    rolepermission.setRoleId(99L);
	    rolepermission.setPermissionId(99L);
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(rolepermission);
		doReturn(null).when(rolepermissionAppService).FindById(new RolepermissionId(99L, 99L));
		
		mvc.perform(put("/rolepermission/permissionId:99,roleId:99")
    			 .contentType(MediaType.APPLICATION_JSON).content(json))
		  .andExpect(status().isNotFound());
	}
	
	@Test
	public void UpdateRolepermission_RolepermissionExists_ReturnStatusOk() throws Exception {
		
		RolepermissionEntity up = rolepermissionRepository.save(createNewEntityForUpdate());
		
		FindRolepermissionByIdOutput output= new FindRolepermissionByIdOutput();
	    output.setRoleId(up.getRoleId());
	    output.setPermissionId(up.getPermissionId());

        UpdateRolepermissionInput rolepermission = new UpdateRolepermissionInput();
        rolepermission.setRoleId(up.getRoleId());
		rolepermission.setPermissionId(up.getPermissionId());
	
		doReturn(output).when(rolepermissionAppService).FindById(new RolepermissionId(up.getPermissionId(),up.getRoleId()));
    	
		ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
		String json = ow.writeValueAsString(rolepermission);
     
        mvc.perform(put("/rolepermission/permissionId:"+up.getPermissionId() + ",roleId:" + up.getRoleId()).contentType(MediaType.APPLICATION_JSON).content(json))
	    .andExpect(status().isOk());

        RolepermissionEntity entity= new RolepermissionEntity();
        entity.setRoleId(up.getRoleId());
        entity.setPermissionId(up.getPermissionId());
        rolepermissionRepository.delete(entity);
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsValid_ReturnStatusOk() throws Exception {
		
		 mvc.perform(get("/rolepermission?search=permissionId[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}    
	
	@Test
	public void FindAll_SearchIsNotNullAndPropertyIsNotValid_ThrowException() throws Exception {
		 
		 org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/rolepermission?search=id[equals]=1&limit=10&offset=1")
				 .contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new Exception("Wrong URL Format: Property id not found!"));
	} 
	
	@Test
	public void GetRole_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/rolepermission/permissionId:3/role")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=permissionId:3"));
	}    
	
	@Test
	public void GetRole_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/rolepermission/permissionId:35,roleId:35/role")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	
	}    
	
	@Test
	public void GetRole_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/rolepermission/permissionId:1,roleId:1/role")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}  
	
	@Test
	public void GetPermission_IdIsNotEmptyAndIdIsNotValid_ThrowException() throws Exception {
	
		org.assertj.core.api.Assertions.assertThatThrownBy(() ->  mvc.perform(get("/rolepermission/permissionId:36/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk())).hasCause(new EntityNotFoundException("Invalid id=permissionId:36"));
	}    
	
	@Test
	public void GetPermission_IdIsNotEmptyAndIdDoesNotExist_ReturnNotFound() throws Exception {
	
	    mvc.perform(get("/rolepermission/permissionId:35,roleId:35/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isNotFound());
	}    
	
	@Test
	public void GetPermission_searchIsNotEmptyAndPropertyIsValid_ReturnList() throws Exception {
	
	   mvc.perform(get("/rolepermission/permissionId:1,roleId:1/permission")
				.contentType(MediaType.APPLICATION_JSON))
	    		  .andExpect(status().isOk());
	}   
	
}
