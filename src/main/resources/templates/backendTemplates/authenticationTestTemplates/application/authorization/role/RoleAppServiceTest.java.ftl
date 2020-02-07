package [=PackageName].application.authorization.role;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.assertj.core.api.Assertions;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Spy;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import [=CommonModulePackage].logging.LoggingHelper;
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchFields;
import [=PackageName].application.authorization.role.dto.*;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].application.authorization.permission.PermissionAppService;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.RoleManager;
import [=PackageName].domain.model.QRoleEntity;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class RoleAppServiceTest {

	@InjectMocks
	@Spy
	RoleAppService roleAppService;

	@Mock
	private RoleManager roleManager;

	@Mock
	private RoleMapper roleMapper;
	
	@Mock
	private PermissionAppService  permissionAppService;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(roleAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());

	}

	@After
	public void tearDown() throws Exception {
	}

	@Test 
	public void findRoleById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(null);	
		Assertions.assertThat(roleAppService.FindById(ID)).isEqualTo(null);	

	}

	@Test
	public void findRoleById_IdIsNotNullAndRoleExists_ReturnARole() {

		RoleEntity role = mock(RoleEntity.class);

		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		Assertions.assertThat(roleAppService.FindById(ID)).isEqualTo(roleMapper.RoleEntityToCreateRoleOutput(role));
	}

	@Test 
	public void findRoleByName_NameIsNotNullAndRoleDoesNotExist_ReturnNull() {

		Mockito.when(roleManager.FindByRoleName(anyString())).thenReturn(null);	
		Assertions.assertThat(roleAppService.FindByRoleName("Role1")).isEqualTo(null);	
	}

	@Test
	public void findRoleByName_NameIsNotNullAndRoleExists_ReturnARole() {

		RoleEntity role = mock(RoleEntity.class);

		Mockito.when(roleManager.FindByRoleName(anyString())).thenReturn(role);
		Assertions.assertThat(roleAppService.FindByRoleName("Role1")).isEqualTo(roleMapper.RoleEntityToCreateRoleOutput(role));
	}
 

	@Test
	public void createRole_RoleIsNotNullAndRoleDoesNotExist_StoreARole() {

		RoleEntity roleEntity = mock(RoleEntity.class);
		CreateRoleInput role=mock(CreateRoleInput.class);

		Mockito.when(roleMapper.CreateRoleInputToRoleEntity(any(CreateRoleInput.class))).thenReturn(roleEntity);
		Mockito.when(roleManager.Create(any(RoleEntity.class))).thenReturn(roleEntity);
		Assertions.assertThat(roleAppService.Create(role)).isEqualTo(roleMapper.RoleEntityToCreateRoleOutput(roleEntity));
	}

	@Test
	public void deleteRole_RoleIsNotNullAndRoleExists_RoleRemoved() {

		RoleEntity role=mock(RoleEntity.class);
	
		Mockito.when(roleManager.FindById(anyLong())).thenReturn(role);
		roleAppService.Delete(ID);
		verify(roleManager,Mockito.times(1)).FindById(anyLong());
	}

	@Test
	public void updateRole_RoleIdIsNotNullAndRoleExists_ReturnUpdatedRole() {

		RoleEntity roleEntity = mock(RoleEntity.class);
		UpdateRoleInput role=mock(UpdateRoleInput.class);
		
		Mockito.when(roleMapper.UpdateRoleInputToRoleEntity(any(UpdateRoleInput.class))).thenReturn(roleEntity);
		Mockito.when(roleManager.Update(any(RoleEntity.class))).thenReturn(roleEntity);
		Assertions.assertThat(roleAppService.Update(ID,role)).isEqualTo(roleMapper.RoleEntityToUpdateRoleOutput(roleEntity));
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<RoleEntity> list = new ArrayList<>();
		Page<RoleEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindRoleByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");

		Mockito.when(roleAppService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(roleAppService.Find(search,pageable)).isEqualTo(output);

	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<RoleEntity> list = new ArrayList<>();
		RoleEntity role=mock(RoleEntity.class);
		list.add(role);
		Page<RoleEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");

		List<FindRoleByIdOutput> output = new ArrayList<>();
		output.add(roleMapper.RoleEntityToFindRoleByIdOutput(role));
		Mockito.when(roleAppService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(roleAppService.Find(search,pageable)).isEqualTo(output);

	}

    @Test 
	public void checkPermissionProperties_SearchListIsNotNull_ReturnKeyValueMap()throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");
		list.add("name");
		permissionAppService.checkProperties(list);
	}
	@Test
	public void  searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder()
	{
		String search= "xyz";
		String operator= "equals";
		QRoleEntity role = QRoleEntity.roleEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq(search));
		builder.or(role.name.eq(search));


		Assertions.assertThat(roleAppService.searchAllProperties(role,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() throws Exception
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("name");
		list.add("displayName");
		QRoleEntity role = QRoleEntity.roleEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.name.eq("xyz"));
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.searchSpecificProperty(role,list,"xyz",operator)).isEqualTo(builder);

	}

	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QRoleEntity role = QRoleEntity.roleEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
		Map map = new HashMap();
		map.put("name", searchFields);
		
		Map joinColMap = new HashMap();
		map.put("xyz", ID);

		BooleanBuilder builder = new BooleanBuilder();
		builder.and(role.name.eq("xyz"));

		Assertions.assertThat(roleAppService.searchKeyValuePair(role, map,joinColMap)).isEqualTo(builder);
	}

	@Test(expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("xyz");

		roleAppService.checkProperties(list);
	}
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");

		roleAppService.checkProperties(list);
	}

	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QRoleEntity role = QRoleEntity.roleEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));
		builder.or(role.name.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);
	}

	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QRoleEntity role = QRoleEntity.roleEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue("xyz");
		search.setOperator("equals");
		fields.setFieldName("displayName");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);

	}
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();
		QRoleEntity role = QRoleEntity.roleEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		fields.setFieldName("displayName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(role.displayName.eq("xyz"));

		Assertions.assertThat(roleAppService.Search(search)).isEqualTo(builder);

	}

	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		Assertions.assertThat(roleAppService.Search(null)).isEqualTo(null);
	}

	@Test
    public void parseRolepermissionJoinColumn_StringIsNotNull_ReturnMap() {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("roleId", "1");
		
		Assertions.assertThat(roleAppService.parseRolepermissionJoinColumn("1")).isEqualTo(joinColumnMap);
		
	}
	
	@Test
	public void parse[=AuthenticationTable]roleJoinColumn_StringIsNotNull_ReturnMap() {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("roleId", "1");
		
		Assertions.assertThat(roleAppService.parse[=AuthenticationTable]roleJoinColumn("1")).isEqualTo(joinColumnMap);
		
	}
}
