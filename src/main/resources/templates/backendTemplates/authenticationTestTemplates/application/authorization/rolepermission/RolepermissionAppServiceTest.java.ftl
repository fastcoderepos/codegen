package [=PackageName].application.authorization.rolepermission;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import [=PackageName].domain.authorization.rolepermission.*;
import [=CommonModulePackage].search.*;
import [=PackageName].application.authorization.rolepermission.dto.*;
import [=PackageName].domain.model.RolepermissionId;
import [=PackageName].domain.model.QRolepermissionEntity;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.authorization.permission.PermissionManager;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.RoleManager;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class RolepermissionAppServiceTest {

	@InjectMocks
	@Spy
	RolepermissionAppService _appService;

	@Mock
	private RolepermissionManager _rolepermissionManager;

	@Mock
	private PermissionManager  _permissionManager;

	@Mock
	private RoleManager  _roleManager;

	@Mock
	private RolepermissionMapper _mapper;

	@Mock
	private RolepermissionId rolePermissionId;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;
    
	private static long ID=15;
	@Before
	public void setUp() throws Exception {

		MockitoAnnotations.initMocks(_appService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void findRolepermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById(rolePermissionId)).isEqualTo(null);
	}

	@Test
	public void findRolepermissionById_IdIsNotNullAndIdExists_ReturnRolepermission() {

		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(rolepermission);
		Assertions.assertThat(_appService.FindById(rolePermissionId)).isEqualTo(_mapper.RolepermissionEntityToFindRolepermissionByIdOutput(rolepermission));
	}

	@Test 
	public void createRolepermission_RolepermissionInputIsNotNullAndRoleIdOrPermssionIdIsNotNullAndRolepermissionDoesNotExist_StoreRolepermission() { 

		RolepermissionEntity rolepermissionEntity = new RolepermissionEntity(); 
		CreateRolepermissionInput rolepermission = mock(CreateRolepermissionInput.class);
		RoleEntity roleEntity = mock (RoleEntity.class);
		PermissionEntity permissionEntity=mock(PermissionEntity.class);

		Mockito.when(_mapper.CreateRolepermissionInputToRolepermissionEntity(any(CreateRolepermissionInput.class))).thenReturn(rolepermissionEntity); 
		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(roleEntity);
		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(permissionEntity);
		Mockito.when(_rolepermissionManager.Create(any(RolepermissionEntity.class))).thenReturn(rolepermissionEntity); 
		
		Assertions.assertThat(_appService.Create(rolepermission)).isEqualTo(_mapper.RolepermissionEntityToCreateRolepermissionOutput(rolepermissionEntity)); 
	} 

	@Test
	public void createRolepermission_RolepermissionIsNotNullAndRolepermissionDoesNotExistAndRoleIdOrPermssionIdIsNull_ReturnNull() {

		CreateRolepermissionInput rolepermission = new CreateRolepermissionInput();
		rolepermission.setPermissionId(null);

		Assertions.assertThat(_appService.Create(rolepermission)).isEqualTo(null);
	}

	@Test
	public void createRolepermission_RolepermissionIsNotNullAndRolepermissionDoesNotExistAndRoleIdOrPermssionIdIsNotNullAndRoleOrPermissionDoesNotExist_ReturnNull() {

		CreateRolepermissionInput rolepermission = mock(CreateRolepermissionInput.class);

		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Create(rolepermission)).isEqualTo(null);
	}


	@Test
	public void updateRolepermission_RolepermissionIsNotNullAndRolepermissionExistAndRoleIdOrPermssionIdIsNull_ReturnNull() {

		UpdateRolepermissionInput rolepermission = new UpdateRolepermissionInput();
		rolepermission.setPermissionId(null);

		Assertions.assertThat(_appService.Update(rolePermissionId,rolepermission)).isEqualTo(null);
	}

	@Test
	public void updateRolepermission_RolepermissionIsNotNullAndRolepermissionExistAndRoleIdOrPermssionIdIsNotNullAndRoleOrPermissionDoesNotExist_ReturnNull() {

		UpdateRolepermissionInput rolepermission = mock(UpdateRolepermissionInput.class);

		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Update(rolePermissionId,rolepermission)).isEqualTo(null);
	}


	@Test
	public void updateRolepermission_RolepermissionIsNotNullAndRolepermissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdatedRolepermission() {

		RolepermissionEntity rolepermissionEntity = new RolepermissionEntity();
		UpdateRolepermissionInput rolepermission = mock(UpdateRolepermissionInput.class);
		PermissionEntity permissionEntity= mock(PermissionEntity.class);
		RoleEntity roleEntity = mock (RoleEntity.class);
		rolepermissionEntity.setPermission(permissionEntity);

		Mockito.when(_mapper.UpdateRolepermissionInputToRolepermissionEntity(any(UpdateRolepermissionInput.class))).thenReturn(rolepermissionEntity);
		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(roleEntity);
		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(permissionEntity); 
		
		Mockito.when(_rolepermissionManager.Update(any(RolepermissionEntity.class))).thenReturn(rolepermissionEntity);

		Assertions.assertThat(_appService.Update(rolePermissionId,rolepermission)).isEqualTo(_mapper.RolepermissionEntityToUpdateRolepermissionOutput(rolepermissionEntity));

	}

	@Test
	public void deleteRolepermission_RolepermissionIsNotNullAndRolepermissionExists_RolepermissionRemoved() {

		RolepermissionEntity rolepermission= mock(RolepermissionEntity.class);
		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(rolepermission);
		
		_appService.Delete(rolePermissionId); 
		verify(_rolepermissionManager).Delete(rolepermission);
	}

	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<RolepermissionEntity> list = new ArrayList<>();
		Page<RolepermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindRolepermissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");

		Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(_rolepermissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<RolepermissionEntity> list = new ArrayList<>();
		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
		list.add(rolepermission);
		Page<RolepermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<FindRolepermissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");
		output.add(_mapper.RolepermissionEntityToFindRolepermissionByIdOutput(rolepermission));
		
		Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(_rolepermissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}

	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		QRolepermissionEntity rolepermission = QRolepermissionEntity.rolepermissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchAllProperties(rolepermission,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		QRolepermissionEntity rolepermission = QRolepermissionEntity.rolepermissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchSpecificProperty(rolepermission, list,"xyz",operator)).isEqualTo(builder);
	}

	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		QRolepermissionEntity rolepermission = QRolepermissionEntity.rolepermissionEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue(String.valueOf(ID));
		Map<String,SearchFields> map = new HashMap<>();
		map.put("roleId",searchFields);
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(rolepermission.role.id.eq(ID));
		Map<String,String> searchMap = new HashMap<String,String>();
		searchMap.put("roleId",String.valueOf(ID));


		Assertions.assertThat(_appService.searchKeyValuePair(rolepermission,map,searchMap)).isEqualTo(builder);
	}

	@Test (expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception {
		List<String> list = new ArrayList<>();
		list.add("xyz");
		_appService.checkProperties(list);
	}

	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception {
		List<String> list = new ArrayList<>();
		_appService.checkProperties(list);
	}

	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception {

		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue(String.valueOf(ID));
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}

	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		QRolepermissionEntity rolepermission = QRolepermissionEntity.rolepermissionEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue(String.valueOf(ID));
		search.setOperator("equals");

		fields.setFieldName("roleId");
		fieldsList.add(fields);
		search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(rolepermission.role.id.eq(ID));

		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}

	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {

		Map<String,SearchFields> map = new HashMap<>();
		QRolepermissionEntity rolepermission = QRolepermissionEntity.rolepermissionEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue(String.valueOf(ID));
		search.setOperator("equals");

		Map<String,String> searchMap = new HashMap<String,String>();
		searchMap.put("roleId",String.valueOf(ID));
		search.setJoinColumns(searchMap);

		fields.setOperator("equals");
		fields.setSearchValue(String.valueOf(ID));
		fields.setFieldName("roleId");
		fieldsList.add(fields);
		search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(rolepermission.role.id.eq(ID));

		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}

	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}

	//Permission
	@Test
	public void GetPermission_IfRolepermissionIdAndPermissionIdIsNotNullAndRolepermissionExists_ReturnPermission() {
		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
		PermissionEntity permission = mock(PermissionEntity.class);

		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(rolepermission);
		Mockito.when(_rolepermissionManager.GetPermission(any(RolepermissionId.class))).thenReturn(permission);
		Assertions.assertThat(_appService.GetPermission(rolePermissionId)).isEqualTo(_mapper.PermissionEntityToGetPermissionOutput(permission, rolepermission));
	}

	@Test 
	public void GetPermission_IfRolepermissionIdAndPermissionIdIsNotNullAndRolepermissionDoesNotExist_ReturnNull() {

		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetPermission(rolePermissionId)).isEqualTo(null);
	}

	//Role
	@Test
	public void GetRole_IfRolepermissionIdAndRoleIdIsNotNullAndRolepermissionExists_ReturnRole() {
		RolepermissionEntity rolepermission = mock(RolepermissionEntity.class);
		RoleEntity role = mock(RoleEntity.class);

		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(rolepermission);
		Mockito.when(_rolepermissionManager.GetRole(any(RolepermissionId.class))).thenReturn(role);
		Assertions.assertThat(_appService.GetRole(rolePermissionId)).isEqualTo(_mapper.RoleEntityToGetRoleOutput(role, rolepermission));
	}

	@Test 
	public void GetRole_IfRolepermissionIdAndRoleIdIsNotNullAndRolepermissionDoesNotExist_ReturnNull() {

		Mockito.when(_rolepermissionManager.FindById(any(RolepermissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetRole(rolePermissionId)).isEqualTo(null);
	}
	
	@Test
	public void ParseRolePermissionKey_KeysStringIsNotEmptyAndKeyValuePairExists_ReturnRolepermissionId()
	{
		String keyString= "roleId:15,permissionId:15";
	
		RolepermissionId rolepermissionId = new RolepermissionId();
		rolepermissionId.setPermissionId(Long.valueOf(ID));
		rolepermissionId.setRoleId(Long.valueOf(ID));
		Assertions.assertThat(_appService.parseRolepermissionKey(keyString)).isEqualToComparingFieldByField(rolepermissionId);
	}
	
	@Test
	public void ParseRolePermissionKey_KeysStringIsEmpty_ReturnNull()
	{
		
		String keyString= "";
		Assertions.assertThat(_appService.parseRolepermissionKey(keyString)).isEqualTo(null);
	}
	
	@Test
	public void ParseRolePermissionKey_KeysStringIsNotEmptyAndKeyValuePairDoesNotExist_ReturnNull()
	{
		String keyString= "permissionId";
		Assertions.assertThat(_appService.parseRolepermissionKey(keyString)).isEqualTo(null);
	}
}

