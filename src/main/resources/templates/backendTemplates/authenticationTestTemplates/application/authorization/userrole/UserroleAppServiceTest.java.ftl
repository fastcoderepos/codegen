package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role;

import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.doNothing;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;

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
import org.mockito.Spy;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.slf4j.Logger;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]role.*;
import [=CommonModulePackage].search.*;
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(AuthenticationTable)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.*;
import [=PackageName].domain.model.Q[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]Manager;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.RoleManager;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=AuthenticationTable]roleAppServiceTest {
    @Spy
	@InjectMocks
	[=AuthenticationTable]roleAppService _appService;

	@Mock
	private [=AuthenticationTable]roleManager _[=AuthenticationTable?uncap_first]roleManager;
	
    @Mock
	private [=AuthenticationTable]Manager  _[=AuthenticationTable?uncap_first]Manager;
	
    @Mock
	private RoleManager  _roleManager;
	
	@Mock
	private [=AuthenticationTable]roleMapper _mapper;

	@Mock
	private Logger loggerMock;

	@Mock
	private LoggingHelper logHelper;

	@Mock
	private [=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]RoleId;
	
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
	public void find[=AuthenticationTable]roleById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn(null);
		Assertions.assertThat(_appService.FindById([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(null);
	}
	
	@Test
	public void find[=AuthenticationTable]roleById_IdIsNotNullAndIdExists_Return[=AuthenticationTable]role() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Assertions.assertThat(_appService.FindById([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(_mapper.[=AuthenticationTable]roleEntityToFind[=AuthenticationTable]roleByIdOutput([=AuthenticationTable?uncap_first]role));
	}
	
	@Test 
    public void create[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]roleDoesNotExist_Store[=AuthenticationTable]role() { 
 
        [=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]roleEntity = new [=AuthenticationTable]roleEntity(); 
        Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = mock(Create[=AuthenticationTable]roleInput.class); 
        [=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		RoleEntity roleEntity=mock(RoleEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(roleEntity);
        Mockito.when(_mapper.Create[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(any(Create[=AuthenticationTable]roleInput.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity); 
        Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.Create(any([=AuthenticationTable]roleEntity.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity); 
        
        Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]role)).isEqualTo(_mapper.[=AuthenticationTable]roleEntityToCreate[=AuthenticationTable]roleOutput([=AuthenticationTable?uncap_first]roleEntity)); 

    } 

    @Test 
	public void create[=AuthenticationTable]role_[=AuthenticationTable]roleInputIsNotNullAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAndRoleIsAlreadyAssigned_Store[=AuthenticationTable]role() { 

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]roleEntity = new [=AuthenticationTable]roleEntity(); 
		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = mock(Create[=AuthenticationTable]roleInput.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		RoleEntity roleEntity=mock(RoleEntity.class);
		
		Mockito.doReturn(true).when(_appService).checkIfRoleAlreadyAssigned(any([=AuthenticationTable]Entity.class), any(RoleEntity.class));
		_appService.checkIfRoleAlreadyAssigned([=AuthenticationTable?uncap_first]Entity,roleEntity);  
		verify(_appService).checkIfRoleAlreadyAssigned([=AuthenticationTable?uncap_first]Entity,roleEntity);
		Mockito.when(_mapper.Create[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(any(Create[=AuthenticationTable]roleInput.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity); 
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(roleEntity);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.Create(any([=AuthenticationTable]roleEntity.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity); 
		
		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]role)).isEqualTo(_mapper.[=AuthenticationTable]roleEntityToCreate[=AuthenticationTable]roleOutput(null)); 
	} 

	@Test
	public void create[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleDoesNotExistAnd[=AuthenticationTable]IdOrPermssionIdIsNull_ReturnNull() {

		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Create[=AuthenticationTable]roleInput();
		[=AuthenticationTable?uncap_first]role.setRoleId(null);

		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]role)).isEqualTo(null);
	}

	@Test
	public void create[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleDoesNotExistAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]OrRoleDoesNotExist_ReturnNull() {

		Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = mock(Create[=AuthenticationTable]roleInput.class);

		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Create([=AuthenticationTable?uncap_first]role)).isEqualTo(null);
	}	
	
    @Test
	public void update[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleExistAnd[=AuthenticationTable]IdOrPermssionIdIsNull_ReturnNull() {

		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = new Update[=AuthenticationTable]roleInput();
		[=AuthenticationTable?uncap_first]role.setRoleId(null);

		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]RoleId,[=AuthenticationTable?uncap_first]role)).isEqualTo(null);
	}

	@Test
	public void update[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleExistAnd[=AuthenticationTable]IdOrPermssionIdIsNotNullAnd[=AuthenticationTable]OrRoleDoesNotExist_ReturnNull() {

		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = mock(Update[=AuthenticationTable]roleInput.class);

		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(null);
		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]RoleId,[=AuthenticationTable?uncap_first]role)).isEqualTo(null);
	}

	@Test
	public void update[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleDoesNotExistAndChildIsNotNullAndChildIsNotMandatory_ReturnUpdated[=AuthenticationTable]role() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]roleEntity = new [=AuthenticationTable]roleEntity();
		Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role = mock(Update[=AuthenticationTable]roleInput.class);
		RoleEntity roleEntity= mock(RoleEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
		[=AuthenticationTable?uncap_first]roleEntity.setRole(roleEntity);

		Mockito.when(_mapper.Update[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(any(Update[=AuthenticationTable]roleInput.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity);
		Mockito.when(_[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>any(Long.class)<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>any([=AuthenticationTable]Id.class)<#else><#list PrimaryKeys as key,value><#if value?lower_case == "long">anyLong()<#elseif value?lower_case == "integer">any(Integer.class)<#elseif value?lower_case == "short">any(Short.class)<#elseif value?lower_case == "double">any(Double.class)<#elseif value?lower_case == "string">anyString()</#if></#list></#if></#if>)).thenReturn([=AuthenticationTable?uncap_first]Entity);
		Mockito.when(_roleManager.FindById(anyLong())).thenReturn(roleEntity); 
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.Update(any([=AuthenticationTable]roleEntity.class))).thenReturn([=AuthenticationTable?uncap_first]roleEntity);

		Assertions.assertThat(_appService.Update([=AuthenticationTable?uncap_first]RoleId,[=AuthenticationTable?uncap_first]role)).isEqualTo(_mapper.[=AuthenticationTable]roleEntityToUpdate[=AuthenticationTable]roleOutput([=AuthenticationTable?uncap_first]roleEntity));
	}
    
    @Test 
	public void checkIfRoleAlreadyAssigned_[=AuthenticationTable]EntityAndRoleEntityIsNotNullAnd[=AuthenticationTable]RoleSetIsEmpty_ReturnFalse() {

	    RoleEntity roleEntity= mock(RoleEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
	    Assertions.assertThat(_appService.checkIfRoleAlreadyAssigned([=AuthenticationTable?uncap_first]Entity, roleEntity)).isEqualTo(false);
	}
	
	@Test 
	public void checkIfRoleAlreadyAssigned_[=AuthenticationTable]EntityAndRoleEntityIsNotNullAnd[=AuthenticationTable]RoleSetIsNotEmpty_ReturnTrue() {

    	RoleEntity roleEntity= new RoleEntity();
		roleEntity.setId(1L);
		
	    [=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role= new [=AuthenticationTable]roleEntity();
	    [=AuthenticationTable?uncap_first]role.setRoleId(1L);  
		[=AuthenticationTable?uncap_first]role.setRole(roleEntity);
		
		Set<[=AuthenticationTable]roleEntity> up= new HashSet<[=AuthenticationTable]roleEntity>();
	    up.add([=AuthenticationTable?uncap_first]role);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]Entity = mock ([=AuthenticationTable]Entity.class);
	    Mockito.when([=AuthenticationTable?uncap_first]Entity.get[=AuthenticationTable]roleSet()).thenReturn(up);
		Assertions.assertThat(_appService.checkIfRoleAlreadyAssigned([=AuthenticationTable?uncap_first]Entity, roleEntity)).isEqualTo(true);
	}
	
	@Test
	public void delete[=AuthenticationTable]role_[=AuthenticationTable]roleIsNotNullAnd[=AuthenticationTable]roleExists_[=AuthenticationTable]roleRemoved() {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role= mock([=AuthenticationTable]roleEntity.class);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		
		_appService.Delete([=AuthenticationTable?uncap_first]RoleId); 
		verify(_[=AuthenticationTable?uncap_first]roleManager).Delete([=AuthenticationTable?uncap_first]role);
	}
	

	
	@Test
	public void Find_ListIsEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]roleEntity> list = new ArrayList<>();
		Page<[=AuthenticationTable]roleEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]roleByIdOutput> output = new ArrayList<>();
		SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");

		Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void Find_ListIsNotEmpty_ReturnList() throws Exception {

		List<[=AuthenticationTable]roleEntity> list = new ArrayList<>();
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		list.add([=AuthenticationTable?uncap_first]role);
    	Page<[=AuthenticationTable]roleEntity> foundPage = new PageImpl(list);
		Pageable pageable = mock(Pageable.class);
		List<Find[=AuthenticationTable]roleByIdOutput> output = new ArrayList<>();
        SearchCriteria search= new SearchCriteria();
//		search.setType(1);
//		search.setValue("xyz");
//		search.setOperator("equals");
		output.add(_mapper.[=AuthenticationTable]roleEntityToFind[=AuthenticationTable]roleByIdOutput([=AuthenticationTable?uncap_first]role));
    	
    	Mockito.when(_appService.Search(any(SearchCriteria.class))).thenReturn(new BooleanBuilder());
    	Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindAll(any(Predicate.class),any(Pageable.class))).thenReturn(foundPage);
		Assertions.assertThat(_appService.Find(search, pageable)).isEqualTo(output);
	}
	
	@Test
	public void searchAllProperties_SearchIsNotNull_ReturnBooleanBuilder() {
		String search= "xyz";
		String operator= "equals";
		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchAllProperties([=AuthenticationTable?uncap_first]role,search,operator)).isEqualTo(builder);
	}
	
	@Test
	public void searchSpecificProperty_PropertyExists_ReturnBooleanBuilder() {
		String operator= "equals";
		List<String> list = new ArrayList<>();
		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
		BooleanBuilder builder = new BooleanBuilder();
		Assertions.assertThat(_appService.searchSpecificProperty([=AuthenticationTable?uncap_first]role, list,"xyz",operator)).isEqualTo(builder);
	}
	
    @Test
	public void searchKeyValuePair_PropertyExists_ReturnBooleanBuilder() {
		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
	    
	    SearchFields searchFields = new SearchFields();
		searchFields.setOperator("equals");
		searchFields.setSearchValue(String.valueOf(ID));
		Map<String,SearchFields> map = new HashMap<>();
		map.put("roleId",searchFields);
		
		BooleanBuilder builder = new BooleanBuilder();
		builder.and([=AuthenticationTable?uncap_first]role.role.id.eq(ID));
		
		Map<String,String> searchMap = new HashMap<String,String>();
		searchMap.put("roleId",String.valueOf(ID));
		
		Assertions.assertThat(_appService.searchKeyValuePair([=AuthenticationTable?uncap_first]role,map,searchMap)).isEqualTo(builder);
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

		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
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
		builder.or([=AuthenticationTable?uncap_first]role.role.id.eq(ID));
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
    @Test
	public void  search_SearchIsNotNullAndSearchContainsCaseThree_ReturnBooleanBuilder() throws Exception {
		
		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
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
        fields.setOperator("equals");
		fields.setSearchValue("xyz");
        fieldsList.add(fields);
        search.setFields(fieldsList);
        
		BooleanBuilder builder = new BooleanBuilder();
		builder.or([=AuthenticationTable?uncap_first]role.role.id.eq(ID));
		
		Assertions.assertThat(_appService.Search(search)).isEqualTo(builder);
	}
	
	@Test
	public void  search_StringIsNull_ReturnNull() throws Exception {

		Assertions.assertThat(_appService.Search(null)).isEqualTo(null);
	}
	
   //[=AuthenticationTable]
	@Test
	public void Get[=AuthenticationTable]_If[=AuthenticationTable]roleIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]roleExists_Return[=AuthenticationTable]() {
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		[=AuthenticationTable]Entity [=AuthenticationTable?uncap_first] = mock([=AuthenticationTable]Entity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.Get[=AuthenticationTable](any([=AuthenticationTable]roleId.class))).thenReturn([=AuthenticationTable?uncap_first]);
		Assertions.assertThat(_appService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(_mapper.[=AuthenticationTable]EntityToGet[=AuthenticationTable]Output([=AuthenticationTable?uncap_first], [=AuthenticationTable?uncap_first]role));
	}

	@Test 
	public void Get[=AuthenticationTable]_If[=AuthenticationTable]roleIdAnd[=AuthenticationTable]IdIsNotNullAnd[=AuthenticationTable]roleDoesNotExist_ReturnNull() {
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn(null);
		Assertions.assertThat(_appService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(null);
	}
 
   //Role
	@Test
	public void GetRole_If[=AuthenticationTable]roleIdAndRoleIdIsNotNullAnd[=AuthenticationTable]roleExists_ReturnRole() {
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);
		RoleEntity role = mock(RoleEntity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn([=AuthenticationTable?uncap_first]role);
		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.GetRole(any([=AuthenticationTable]roleId.class))).thenReturn(role);
		Assertions.assertThat(_appService.GetRole([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(_mapper.RoleEntityToGetRoleOutput(role, [=AuthenticationTable?uncap_first]role));
	}

	@Test 
	public void GetRole_If[=AuthenticationTable]roleIdAndRoleIdIsNotNullAnd[=AuthenticationTable]roleDoesNotExist_ReturnNull() {
		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mock([=AuthenticationTable]roleEntity.class);

		Mockito.when(_[=AuthenticationTable?uncap_first]roleManager.FindById(any([=AuthenticationTable]roleId.class))).thenReturn(null);
		Assertions.assertThat(_appService.GetRole([=AuthenticationTable?uncap_first]RoleId)).isEqualTo(null);
	}
 
    @Test
	public void Parse[=AuthenticationTable]RoleKey_KeysStringIsNotEmptyAndKeyValuePairExists_Return[=AuthenticationTable]roleId()
	{

		[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId = new [=AuthenticationTable]roleId();
		[=AuthenticationTable?uncap_first]roleId.setRoleId(Long.valueOf(ID));
        <#if (AuthenticationType!="none" && !UserInput??) >
        String keyString= "[=AuthenticationTable?uncap_first]Id:15,roleId:15";
    	[=AuthenticationTable?uncap_first]roleId.setUserId(Long.valueOf(ID));
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		String keyString= "<#list PrimaryKeys as key,value><#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">[=AuthenticationTable?uncap_first][=key?cap_first]:15,</#if></#list>roleId:15";
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable][=key?cap_first](String.valueOf(ID));
		<#elseif value?lower_case == "long" >
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable][=key?cap_first](Long.valueOf(ID));
		<#elseif value?lower_case == "integer">
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable][=key?cap_first](Integer.valueOf(ID.intValue()));
        <#elseif value?lower_case == "short">
        [=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable][=key?cap_first](Short.valueOf(ID));
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable][=key?cap_first](Double.valueOf(ID));
		</#if>
  		</#list>
  		</#if>
  		</#if>
		Assertions.assertThat(_appService.parse[=AuthenticationTable]roleKey(keyString)).isEqualToComparingFieldByField([=AuthenticationTable?uncap_first]roleId);
	}
	
	@Test
	public void Parse[=AuthenticationTable]RoleKey_KeysStringIsEmpty_ReturnNull()
	{
		
		String keyString= "";
		Assertions.assertThat(_appService.parse[=AuthenticationTable]roleKey(keyString)).isEqualTo(null);
	}
	
	@Test
	public void Parse[=AuthenticationTable]RoleKey_KeysStringIsNotEmptyAndKeyValuePairDoesNotExist_ReturnNull()
	{
		String keyString= "roleId";
		Assertions.assertThat(_appService.parse[=AuthenticationTable]roleKey(keyString)).isEqualTo(null);
	}

}

