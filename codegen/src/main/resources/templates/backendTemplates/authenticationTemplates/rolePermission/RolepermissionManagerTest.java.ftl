package [=PackageName].domain.Authorization.Rolepermission;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.IRepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.IRepository.IRoleRepository;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.IRepository.IRolepermissionRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class RolepermissionManagerTest {

	@InjectMocks
	RolepermissionManager _rolepermissionManager;
	
	@Mock
	IRolepermissionRepository  _rolepermissionRepository;
    
    @Mock
	IPermissionRepository  _permissionRepository;
    
    @Mock
	IRoleRepository  _roleRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_rolepermissionManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
//	@Test
//	public void findRolepermissionById_IdIsNotNullAndIdExists_ReturnRolepermission() {
//		RolepermissionEntity rolepermission =mock(RolepermissionEntity.class);
//
//		Mockito.when(_rolepermissionRepository.findById(anyLong())).thenReturn(rolepermission);
//		Assertions.assertThat(_rolepermissionManager.FindById(ID)).isEqualTo(rolepermission);
//	}
//
//	@Test 
//	public void findRolepermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
//
//	Mockito.when(_rolepermissionRepository.findById(anyLong())).thenReturn(null);
//	Assertions.assertThat(_rolepermissionManager.FindById(ID)).isEqualTo(null);
//	}
	
	@Test
	public void createRolepermission_RolepermissionIsNotNullAndRolepermissionDoesNotExist_StoreRolepermission() {

		RolepermissionEntity rolepermission =mock(RolepermissionEntity.class);
		Mockito.when(_rolepermissionRepository.save(any(RolepermissionEntity.class))).thenReturn(rolepermission);
		Assertions.assertThat(_rolepermissionManager.Create(rolepermission)).isEqualTo(rolepermission);
	}

	@Test
	public void deleteRolepermission_RolepermissionExists_RemoveRolepermission() {

		RolepermissionEntity rolepermission =mock(RolepermissionEntity.class);
		_rolepermissionManager.Delete(rolepermission);
		verify(_rolepermissionRepository).delete(rolepermission);
	}

	@Test
	public void updateRolepermission_RolepermissionIsNotNullAndRolepermissionExists_UpdateRolepermission() {
		
		RolepermissionEntity rolepermission =mock(RolepermissionEntity.class);
		Mockito.when(_rolepermissionRepository.save(any(RolepermissionEntity.class))).thenReturn(rolepermission);
		Assertions.assertThat(_rolepermissionManager.Update(rolepermission)).isEqualTo(rolepermission);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<RolepermissionEntity> rolepermission = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_rolepermissionRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(rolepermission);
		Assertions.assertThat(_rolepermissionManager.FindAll(predicate,pageable)).isEqualTo(rolepermission);
	}
	
   //Permission
//	@Test
//	public void getPermission_if_RolepermissionIdIsNotNull_returnPermission() {
//
//		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
//		PermissionEntity permission = mock(PermissionEntity.class);
//
//		Mockito.when(_rolepermissionRepository.findById(anyLong())).thenReturn(rolepermission);
//		Mockito.when(rolepermission.getPermission()).thenReturn(permission);
//		Assertions.assertThat(_rolepermissionManager.GetPermission(ID)).isEqualTo(permission);
//
//	}
	
   //Role
//	@Test
//	public void getRole_if_RolepermissionIdIsNotNull_returnRole() {
//
//		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
//		RoleEntity role = mock(RoleEntity.class);
//
//		Mockito.when(_rolepermissionRepository.findById(anyLong())).thenReturn(rolepermission);
//		Mockito.when(rolepermission.getRole()).thenReturn(role);
//		Assertions.assertThat(_rolepermissionManager.GetRole(ID)).isEqualTo(role);
//
//	}
	
}
