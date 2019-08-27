package [=PackageName].domain.Authorization.Userpermission;

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

import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.IRepository.IUserRepository;
import [=PackageName].domain.model.UserEntity;
import [=PackageName].domain.IRepository.IPermissionRepository;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.IRepository.IUserpermissionRepository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class UserpermissionManagerTest {

	@InjectMocks
	UserpermissionManager _userpermissionManager;
	
	@Mock
	IUserpermissionRepository  _userpermissionRepository;
    
    @Mock
	IUserRepository  _userRepository;
    
    @Mock
	IPermissionRepository  _permissionRepository;
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_userpermissionManager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
//	@Test
//	public void findUserpermissionById_IdIsNotNullAndIdExists_ReturnUserpermission() {
//		UserpermissionEntity userpermission =mock(UserpermissionEntity.class);
//
//		Mockito.when(_userpermissionRepository.findById(anyLong())).thenReturn(userpermission);
//		Assertions.assertThat(_userpermissionManager.FindById(ID)).isEqualTo(userpermission);
//	}
//
//	@Test 
//	public void findUserpermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
//
//	Mockito.when(_userpermissionRepository.findById(anyLong())).thenReturn(null);
//	Assertions.assertThat(_userpermissionManager.FindById(ID)).isEqualTo(null);
//	}
	
	@Test
	public void createUserpermission_UserpermissionIsNotNullAndUserpermissionDoesNotExist_StoreUserpermission() {

		UserpermissionEntity userpermission =mock(UserpermissionEntity.class);
		Mockito.when(_userpermissionRepository.save(any(UserpermissionEntity.class))).thenReturn(userpermission);
		Assertions.assertThat(_userpermissionManager.Create(userpermission)).isEqualTo(userpermission);
	}

	@Test
	public void deleteUserpermission_UserpermissionExists_RemoveUserpermission() {

		UserpermissionEntity userpermission =mock(UserpermissionEntity.class);
		_userpermissionManager.Delete(userpermission);
		verify(_userpermissionRepository).delete(userpermission);
	}

	@Test
	public void updateUserpermission_UserpermissionIsNotNullAndUserpermissionExists_UpdateUserpermission() {
		
		UserpermissionEntity userpermission =mock(UserpermissionEntity.class);
		Mockito.when(_userpermissionRepository.save(any(UserpermissionEntity.class))).thenReturn(userpermission);
		Assertions.assertThat(_userpermissionManager.Update(userpermission)).isEqualTo(userpermission);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<UserpermissionEntity> userpermission = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_userpermissionRepository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn(userpermission);
		Assertions.assertThat(_userpermissionManager.FindAll(predicate,pageable)).isEqualTo(userpermission);
	}
	
   //User
//	@Test
//	public void getUser_if_UserpermissionIdIsNotNull_returnUser() {
//
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//		UserEntity user = mock(UserEntity.class);
//
//		Mockito.when(_userpermissionRepository.findById(anyLong())).thenReturn(userpermission);
//		Mockito.when(userpermission.getUser()).thenReturn(user);
//		Assertions.assertThat(_userpermissionManager.GetUser(ID)).isEqualTo(user);
//
//	}
	
   //Permission
//	@Test
//	public void getPermission_if_UserpermissionIdIsNotNull_returnPermission() {
//
//		UserpermissionEntity userpermission = mock(UserpermissionEntity.class);
//		PermissionEntity permission = mock(PermissionEntity.class);
//
//		Mockito.when(_userpermissionRepository.findById(anyLong())).thenReturn(userpermission);
//		Mockito.when(userpermission.getPermission()).thenReturn(permission);
//		Assertions.assertThat(_userpermissionManager.GetPermission(ID)).isEqualTo(permission);
//
//	}
	
}
