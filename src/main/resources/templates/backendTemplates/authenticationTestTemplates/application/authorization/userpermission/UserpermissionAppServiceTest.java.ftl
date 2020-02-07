package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doNothing;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import org.mockito.Spy;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;
import java.util.HashMap;

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

<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(AuthenticationTable)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]permission.*;
import [=CommonModulePackage].search.*;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.*;
import [=PackageName].domain.model.Q[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]Manager;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.authorization.permission.PermissionManager;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;


@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]permissionAppServiceTest {
    @Spy
	@InjectMocks
	[=AuthenticationTable]permissionAppService _appService;

	@Mock
	private [=AuthenticationTable]permissionManager _[=AuthenticationTable?uncap_first]permissionManager;
	
    @Mock
	private [=AuthenticationTable]Manager  _[=AuthenticationTable?uncap_first]Manager;
	
    @Mock
	private PermissionManager  _permissionManager;
	
	@Mock
	private [=AuthenticationTable]permissionMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	@Mock
	private [=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]PermissionId;
	
	private static Long ID=15L;
	
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
	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

    	Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(null);
	}
	
	@Test
	public void find[=AuthenticationTable]permissionById_IdIsNotNullAndIdExists_Return[=AuthenticationTable]permission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Assertions.assertThat(_appService.FindById([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable?uncap_first]permission));
	}
	
	@Test 
    public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_Store[=AuthenticationTable]permission() { 
 
        [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = new [=AuthenticationTable]permissionEntity(); 
        Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class); 
        [=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		PermissionEntity permissionEntity=mock(PermissionEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(permissionEntity);
        Mockito.when(_mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Create[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
       
        Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Create(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
        
        Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity)); 
    } 

    @Test 
	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionInputIsNotNullAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAndPermissionIsAlreadyAssigned_Store[=AuthenticationTable]permission() { 

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = new [=AuthenticationTable]permissionEntity(); 
		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		PermissionEntity permissionEntity=mock(PermissionEntity.class);
		
		Mockito.doReturn(true).when(_appService).checkIfPermissionAlreadyAssigned(any([=AuthenticationTable]Entity.class), any(PermissionEntity.class));
		_appService.checkIfPermissionAlreadyAssigned([=AuthenticationTable?uncap_first]Entity,permissionEntity);  
		verify(_appService).checkIfPermissionAlreadyAssigned([=AuthenticationTable?uncap_first]Entity,permissionEntity);
		Mockito.when(_mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Create[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(permissionEntity);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Create(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity); 
		
		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput(null)); 
	} 


	@Test
	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAnd[=AuthenticationTable]IdOrPermssionIdIsNull_ReturnNull() {

		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Create[=AuthenticationTable]permissionInput();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(null);

		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
	}

	@Test
	public void create[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]OrPermissionDoesNotExist_ReturnNull() {

		Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Create[=AuthenticationTable]permissionInput.class);

		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
	}	
	

    @Test
	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionExistAnd[=AuthenticationTable]IdOrPermssionIdIsNull_ReturnNull() {

		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = new Update[=AuthenticationTable]permissionInput();
		[=AuthenticationTable?uncap_first]permission.setPermissionId(null);

		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]PermissionId,[=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
	}

	@Test
	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionExistAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]OrPermissionDoesNotExist_ReturnNull() {

		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);

		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]PermissionId,[=AuthenticationTable?uncap_first]permission)).isEqualTo(null);
	}


	@Test
	public void update[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdated[=AuthenticationTable]permission() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permissionEntity = new [=AuthenticationTable]permissionEntity();
		Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission = mock(Update[=AuthenticationTable]permissionInput.class);
		PermissionEntity permissionEntity= mock(PermissionEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		[=AuthenticationTable?uncap_first]permissionEntity.setPermission(permissionEntity);

		Mockito.when(_mapper.Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(any(Update[=AuthenticationTable]permissionInput.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_permissionManager.FindById(anyLong())).thenReturn(permissionEntity); 
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Update(any([=AuthenticationTable]permissionEntity.class))).thenReturn([=AuthenticationTable?uncap_first]permissionEntity);

		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]PermissionId,[=AuthenticationTable?uncap_first]permission)).isEqualTo(_mapper.[=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput([=AuthenticationTable?uncap_first]permissionEntity));
	}
    
    @Test 
	public void checkIfPermissionAlreadyAssigned_[=AuthenticationTable]EntityAndPermissionEntityIsNotNullAnd[=AuthenticationTable]PermissionSetIsEmpty_ReturnFalse() {

	    PermissionEntity permissionEntity= mock(PermissionEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
	    Assertions.assertThat(_appService.checkIfPermissionAlreadyAssigned([=AuthenticationTable?uncap_first]Entity, permissionEntity)).isEqualTo(false);

	}
	
	@Test 
	public void checkIfPermissionAlreadyAssigned_[=AuthenticationTable]EntityAndPermissionEntityIsNotNullAnd[=AuthenticationTable]PermissionSetIsNotEmpty_ReturnTrue() {

    	PermissionEntity permissionEntity= new PermissionEntity();
		permissionEntity.setId(1L);
		
	    [=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission= new [=AuthenticationTable]permissionEntity();
	    [=AuthenticationTable?uncap_first]permission.setPermissionId(1L);  
		[=AuthenticationTable?uncap_first]permission.setPermission(permissionEntity);
		
		Set<[=AuthenticationTable]permissionEntity> up= new HashSet<[=AuthenticationTable]permissionEntity>();
	    up.add([=AuthenticationTable?uncap_first]permission);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
	    Mockito.when([=AuthenticationTable?uncap_first]Entity.get[=AuthenticationTable]permissionSet()).thenReturn(up);
		Assertions.assertThat(_appService.checkIfPermissionAlreadyAssigned([=AuthenticationTable?uncap_first]Entity, permissionEntity)).isEqualTo(true);
	}
	
	@Test
	public void delete[=AuthenticationTable]permission_[=AuthenticationTable]permissionIsNotNullAnd[=AuthenticationTable]permissionExists_[=AuthenticationTable]permissionRemoved() {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission= mock([=AuthenticationTable]permissionEntity.class);
		 Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn([=AuthenticationTable?uncap_first]permission);

		_appService.Delete([=AuthenticationTable?uncap_first]PermissionId); 
		verify(_[=AuthenticationTable?uncap_first]permissionManager).Delete([=AuthenticationTable?uncap_first]permission);
	}
	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]permissionEntity> list = new ArrayList<>();
		Page<[=AuthenticationTable]permissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]permissionByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");

		Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]permissionEntity> list = new ArrayList<>();
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		list.add([=AuthenticationTable?uncap_first]permission);
    	Page<[=AuthenticationTable]permissionEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]permissionByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");
		output.add(_mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable?uncap_first]permission));
    	
    	Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
    	Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchAllProperties([=AuthenticationTable?uncap_first]permission,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchSpecificProperty([=AuthenticationTable?uncap_first]permission, list,"xyz",operator)).isEqualTo(builder);
	}
	
    @Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
	    
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue(String.valueOf(ID));
		Map<String,SearchFields> map = new HashMap<>();
		map.put("permissionId",searchFields);
		
		BooleanBuilder builder = new BooleanBuilder();
		builder.and([=AuthenticationTable?uncap_first]permission.permission.id.eq(ID));
		
		Map<String,String> searchMap = new HashMap<String,String>();
		searchMap.put("permissionId",String.valueOf(ID));
		
		Assertions.assertThat(_appService.searchKeyValuePair([=AuthenticationTable?uncap_first]permission,map,searchMap)).isEqualTo(builder);
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
		search.setValue("xyz");
		search.setOperator("equals");
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_SearchIsNotNullAndSearchContainsCaseTwo_ReturnBooleanBuilder() throws Exception {

		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(2);
		search.setValue(String.valueOf(ID));
		search.setOperator("equals");
		
		fields.setFieldName("permissionId");
        fieldsList.add(fields);
        search.setFields(fieldsList);
		BooleanBuilder builder = new BooleanBuilder();
		builder.or([=AuthenticationTable?uncap_first]permission.permission.id.eq(ID));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
		
	}
	
    @Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
		
		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		List<SearchFields> fieldsList= new ArrayList<>();
		SearchFields fields=new SearchFields();
		SearchCriteria search= new SearchCriteria();
		search.setType(3);
		search.setValue(String.valueOf(ID));
		search.setOperator("equals");
		
		Map<String,String> searchMap = new HashMap<String,String>();
		searchMap.put("permissionId",String.valueOf(ID));
		search.setJoinColumns(searchMap);

		fields.setOperator("equals");
		fields.setSearchValue(String.valueOf(ID));
		fields.setFieldName("permissionId");
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
        
		BooleanBuilder builder = new BooleanBuilder();
		builder.or([=AuthenticationTable?uncap_first]permission.permission.id.eq(ID));
		
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
		
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
    //[=AuthenticationTable]
	@Test
	public void Get[=AuthenticationTable]_If[=AuthenticationTable]permissionIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]permissionExists_Return[=AuthenticationTable]() {
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = mock([=AuthenticationTable]Entity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.Get[=AuthenticationTable](any([=AuthenticationTable]permissionId.class))).thenReturn([=AuthenticationTable?uncap_first]);
		Assertions.assertThat(_appService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(_mapper.[=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable?uncap_first], [=AuthenticationTable?uncap_first]permission));
	}

	@Test 
	public void Get[=AuthenticationTable]_If[=AuthenticationTable]permissionIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_ReturnNull() {
		
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(null);
	}
 
   //Permission
	@Test
	public void GetPermission_If[=AuthenticationTable]permissionIdAndPermissionIdIsNotNullAnd[=AuthenticationTable]permissionExists_ReturnPermission() {
		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mock([=AuthenticationTable]permissionEntity.class);
		PermissionEntity permission = mock(PermissionEntity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn([=AuthenticationTable?uncap_first]permission);
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.GetPermission(any([=AuthenticationTable]permissionId.class))).thenReturn(permission);
		Assertions.assertThat(_appService.GetPermission([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(_mapper.PermissionEntityToGetPermissionOutput(permission, [=AuthenticationTable?uncap_first]permission));
	}

	@Test 
	public void GetPermission_If[=AuthenticationTable]permissionIdAndPermissionIdIsNotNullAnd[=AuthenticationTable]permissionDoesNotExist_ReturnNull() {
		
		Mockito.when(_[=AuthenticationTable?uncap_first]permissionManager.FindById(any([=AuthenticationTable]permissionId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetPermission([=AuthenticationTable?uncap_first]PermissionId)).isEqualTo(null);
	}
	
	@Test
	public void Parse[=AuthenticationTable]PermissionKey_KeysStringIsNotEmptyAndKeyValuePairExists_Return[=AuthenticationTable]permissionId()
	{

		[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId = new [=AuthenticationTable]permissionId();
		[=AuthenticationTable?uncap_first]permissionId.setPermissionId(Long.valueOf(ID));
        <#if (AuthenticationType!="none" && !UserInput??) >
        String keyString= "[=AuthenticationTable?uncap_first]Id:15,permissionId:15";
    	[=AuthenticationTable?uncap_first]permissionId.setUserId(Long.valueOf(ID));
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		String keyString= "<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">[=AuthenticationTable?uncap_first][=key?cap_first]:15,</#if></#list>permissionId:15";
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable][=key?cap_first](String.valueOf(ID));
		<#elseif value?lower_case == "long" >
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable][=key?cap_first](Long.valueOf(ID));
		<#elseif value?lower_case == "integer">
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable][=key?cap_first](Integer.valueOf(ID.intValue()));
        <#elseif value?lower_case == "short">
        [=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable][=key?cap_first](Short.valueOf(ID));
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable][=key?cap_first](Double.valueOf(ID));
		</#if>
  		</#list>
  		</#if>
  		</#if>
		Assertions.assertThat(_appService.parse[=AuthenticationTable]permissionKey(keyString)).isEqualToComparingFieldByField([=AuthenticationTable?uncap_first]permissionId);
	}
	
	@Test
	public void Parse[=AuthenticationTable]PermissionKey_KeysStringIsEmpty_ReturnNull()
	{
		
		String keyString= "";
		Assertions.assertThat(_appService.parse[=AuthenticationTable]permissionKey(keyString)).isEqualTo(null);
	}
	
	@Test
	public void Parse[=AuthenticationTable]PermissionKey_KeysStringIsNotEmptyAndKeyValuePairDoesNotExist_ReturnNull()
	{
		String keyString= "permissionId";
		Assertions.assertThat(_appService.parse[=AuthenticationTable]permissionKey(keyString)).isEqualTo(null);
	}
 
}

