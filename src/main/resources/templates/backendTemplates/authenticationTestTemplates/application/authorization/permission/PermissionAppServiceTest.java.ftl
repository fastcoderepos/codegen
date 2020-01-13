package [=PackageName].application.authorization.permission;

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
import [=PackageName].application.authorization.permission.dto.CreatePermissionInput;
import [=PackageName].application.authorization.permission.dto.FindPermissionByIdOutput;
import [=PackageName].application.authorization.permission.dto.UpdatePermissionInput;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.authorization.permission.PermissionManager;
import [=PackageName].domain.model.QPermissionEntity;

import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class PermissionAppServiceTest {

	@InjectMocks
	PermissionAppService permissionAppService;
	
	@Mock
	private PermissionManager permissionManager;
	
	@Mock
	private PermissionMapper permissionMapper;
	
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	private static long ID=15;

	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(permissionAppService);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test 
	public void findPermissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {
		
		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(null);	
		Assertions.assertThat(permissionAppService.FindById(ID)).isEqualTo(null);	
	}

	@Test
	public void findPermissionById_IdIsNotNullAndPermissionExists_ReturnAPermission() {

		PermissionEntity permission = mock(PermissionEntity.class);

		Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permission);
		Assertions.assertThat(permissionAppService.FindById(ID)).isEqualTo(permissionMapper.PermissionEntityToCreatePermissionOutput(permission));
	}

	@Test 
	public void findPermissionByName_NameIsNotNullAndPermissionDoesNotExist_ReturnNull() {
		
		Mockito.when(permissionManager.FindByPermissionName(anyString())).thenReturn(null);	
		Assertions.assertThat(permissionAppService.FindByPermissionName("Permission1")).isEqualTo(null);	
	}

	@Test
	public void findPermissionByName_NameIsNotNullAndPermissionExists_ReturnAPermission() {

		PermissionEntity permission = mock(PermissionEntity.class);

		Mockito.when(permissionManager.FindByPermissionName(anyString())).thenReturn(permission);
		Assertions.assertThat(permissionAppService.FindByPermissionName("Permission1")).isEqualTo(permissionMapper.PermissionEntityToCreatePermissionOutput(permission));
	}


	@Test
	public void createPermission_PermissionIsNotNullAndPermissionDoesNotExist_StoreAPermission() {

		PermissionEntity permissionEntity = mock(PermissionEntity.class);
		CreatePermissionInput permission=mock(CreatePermissionInput.class);
		
		Mockito.when(permissionMapper.CreatePermissionInputToPermissionEntity(any(CreatePermissionInput.class))).thenReturn(permissionEntity);
		Mockito.when(permissionManager.Create(any(PermissionEntity.class))).thenReturn(permissionEntity);
		Assertions.assertThat(permissionAppService.Create(permission)).isEqualTo(permissionMapper.PermissionEntityToCreatePermissionOutput(permissionEntity));
	}

	@Test
	public void deletePermission_PermissionIsNotNullAndPermissionExists_PermissionRemoved() {

		PermissionEntity permission = mock(PermissionEntity.class);
        Mockito.when(permissionManager.FindById(anyLong())).thenReturn(permission);
		permissionAppService.Delete(ID);
		verify(permissionManager,Mockito.times(1)).FindById(any(Long.class));
	}


	@Test
	public void updatePermission_PermissionIdIsNotNullAndPermissionExists_ReturnUpdatedPermission() {

		PermissionEntity permissionEntity = mock(PermissionEntity.class);
		UpdatePermissionInput permission=mock(UpdatePermissionInput.class);
		
		Mockito.when(permissionMapper.UpdatePermissionInputToPermissionEntity(any(UpdatePermissionInput.class))).thenReturn(permissionEntity);
		Mockito.when(permissionManager.Update(any(PermissionEntity.class))).thenReturn(permissionEntity);
		Assertions.assertThat(permissionAppService.Update(ID,permission)).isEqualTo(permissionMapper.PermissionEntityToUpdatePermissionOutput(permissionEntity));
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception
	{
		List<PermissionEntity> list = new ArrayList<>();
		Page<PermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);

		List<FindPermissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		Mockito.when(permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(permissionAppService.Find(search,pageable)).isEqualTo(output);
	}

	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception
	{
		List<PermissionEntity> list = new ArrayList<>();
		PermissionEntity permission=mock(PermissionEntity.class);
		list.add(permission);
		Page<PermissionEntity> foundPage = new PageImpl(list);
		Pageable pageable =mock(Pageable.class);
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");

		List<FindPermissionByIdOutput> output = new ArrayList<>();
		output.add(permissionMapper.PermissionEntityToFindPermissionByIdOutput(permission));
		Mockito.when(permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(permissionAppService.Find(search,pageable)).isEqualTo(output);
	}
	
	@Test
	public void  searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder()
	{
		String search= "xyz";
		String operator= "equals";
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(permission.displayName.eq(search));
		builder.or(permission.name.eq(search));

		Assertions.assertThat(permissionAppService.searchAllProperties(permission,search,operator)).isEqualTo(builder);
	}

	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() throws Exception
	{
		String operator= "equals";
		List<String> list = new ArrayList<>();
		list.add("name");
		list.add("displayName");
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		builder.or(permission.name.eq("xyz"));
		builder.or(permission.displayName.eq("xyz"));

		Assertions.assertThat(permissionAppService.searchSpecificProperty(permission,list,"xyz",operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder()
	{
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
		SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue("xyz");
		Map map = new HashMap();
		map.put("name", searchFields);
		
        BooleanBuilder builder = new BooleanBuilder();
        builder.and(permission.name.eq("xyz"));
        
        Assertions.assertThat(permissionAppService.searchKeyValuePair(permission, map,new HashMap())).isEqualTo(builder);
	}

	@Test(expected = Exception.class)
	public void checkProperties_PropertyDoesNotExist_ThrowException() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("xyz");

		permissionAppService.checkProperties(list);
	}
	@Test
	public void checkProperties_PropertyExists_ReturnNothing() throws Exception
	{
		List<String> list = new ArrayList<>();
		list.add("displayName");

		permissionAppService.checkProperties(list);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseOne_ReturnBooleanBuilder() throws Exception
	{
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
		SearchCriteria search= new SearchCriteria();
		search.setType(1);
		search.setValue("xyz");
		search.setOperator("equals");
        BooleanBuilder builder = new BooleanBuilder();
        builder.or(permission.displayName.eq("xyz"));
		builder.or(permission.name.eq("xyz"));

        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception
	{
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
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
    	builder.or(permission.displayName.eq("xyz"));
    	
        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception
	{
		Map<String,SearchFields> map = new HashMap<>();List<SearchFields> fieldsList= new ArrayList<>();
		QPermissionEntity permission = QPermissionEntity.permissionEntity;
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		fields.setFieldName("displayName");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
	
    	BooleanBuilder builder = new BooleanBuilder();
    	builder.or(permission.displayName.eq("xyz"));
    	
        Assertions.assertThat(permissionAppService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void search_StringIsNull_ReturnNull() throws Exception
	{
		 Assertions.assertThat(permissionAppService.Search(null)).isEqualTo(null);
	}
	
	@Test
    public void parseRolepermissionJoinColumn_StringIsNotNull_ReturnMap() {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("permissionId", "1");
		
		Assertions.assertThat(permissionAppService.parseRolepermissionJoinColumn("1")).isEqualTo(joinColumnMap);
		
	}
	
	@Test
	public void parse[=AuthenticationTable]permissionJoinColumn_StringIsNotNull_ReturnMap() {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("permissionId", "1");
		Assertions.assertThat(permissionAppService.parse[=AuthenticationTable]permissionJoinColumn("1")).isEqualTo(joinColumnMap);
		
	}
	
	
}
