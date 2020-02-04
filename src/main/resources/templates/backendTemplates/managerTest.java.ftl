package [=PackageName].domain<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case];

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

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

import [=PackageName].domain.model.[=EntityClassName];
<#list Relationship as relationKey, relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].domain.irepository.I[=relationValue.eName]Repository;
</#if>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>   
</#list>
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
import [=PackageName].domain.irepository.I[=ClassName]Repository;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.types.Predicate;

@RunWith(SpringJUnit4ClassRunner.class)
public class [=ClassName]ManagerTest {

	@InjectMocks
	[=ClassName]Manager _[=ClassName?uncap_first]Manager;
	
	@Mock
	I[=ClassName]Repository  _[=ClassName?uncap_first]Repository;
	<#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName>
    
    @Mock
	I[=relationValue.eName]Repository  _[=relationValue.eName?uncap_first]Repository;
    </#if>
    </#list>
	@Mock
    private Logger loggerMock;
   
	@Mock
	private LoggingHelper logHelper;
	
	<#if CompositeKeyClasses?seq_contains(ClassName)>
	@Mock
	private [=IdClass] [=IdClass?uncap_first];
	<#else>
	<#list Fields as key,value>
	<#if value.isPrimaryKey!false>
	<#if value.fieldType?lower_case == "long">
	private static [=value.fieldType?cap_first] ID=15L;
	<#elseif value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short">
	private static [=value.fieldType?cap_first] ID=15;
	<#elseif value.fieldType?lower_case == "double">
	private static [value.fieldType?cap_first] ID=15D;
	<#elseif value.fieldType?lower_case == "string">
	private static String ID="15";
	</#if></#if></#list></#if>
	
	@Before
	public void setUp() throws Exception {
		MockitoAnnotations.initMocks(_[=ClassName?uncap_first]Manager);
		when(logHelper.getLogger()).thenReturn(loggerMock);
		doNothing().when(loggerMock).error(anyString());
	}

	@After
	public void tearDown() throws Exception {
	}
	
	@Test
	public void find[=ClassName]ById_IdIsNotNullAndIdExists_Return[=ClassName]() {
		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);

        Optional<[=ClassName]Entity> db[=ClassName] = Optional.of(([=ClassName]Entity) [=ClassName?uncap_first]);
		Mockito.<Optional<[=ClassName]Entity>>when(_[=ClassName?uncap_first]Repository.findById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=IdClass].class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn(db[=ClassName]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo([=ClassName?uncap_first]);
	}

	@Test 
	public void find[=ClassName]ById_IdIsNotNullAndIdDoesNotExist_ReturnNull() {

	    Mockito.<Optional<[=ClassName]Entity>>when(_[=ClassName?uncap_first]Repository.findById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=IdClass].class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn(Optional.empty());
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo(null);
	}
	<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
	<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
	
    @Test
	public void find[=ClassName]ByName_NameIsNotNullAndNameExists_ReturnA[=ClassName]() {
		[=EntityClassName] [=ClassName?uncap_first]Entity = mock([=EntityClassName].class);

		Mockito.when(_[=ClassName?uncap_first]Repository.findBy[=authValue.fieldName?cap_first](anyString())).thenReturn([=ClassName?uncap_first]Entity);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindBy[=authValue.fieldName?cap_first]("User1")).isEqualTo([=ClassName?uncap_first]Entity);
	}

	@Test 
	public void find[=ClassName]ByName_NameIsNotNullAndNameDoesNotExist_ReturnNull() {

		Mockito.when(_[=ClassName?uncap_first]Repository.findBy[=authValue.fieldName?cap_first](anyString())).thenReturn(null);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindBy[=authValue.fieldName?cap_first]("User1")).isEqualTo(null);
	
	}
	</#if>
    </#list>
    </#if>
    </#if>
	
	@Test
	public void create[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]DoesNotExist_Store[=ClassName]() {

		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?uncap_first]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Create([=ClassName?uncap_first])).isEqualTo([=ClassName?uncap_first]);
	}

	@Test
	public void delete[=ClassName]_[=ClassName]Exists_Remove[=ClassName]() {

		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		_[=ClassName?uncap_first]Manager.Delete([=ClassName?uncap_first]);
		verify(_[=ClassName?uncap_first]Repository).delete([=ClassName?uncap_first]);
	}

	@Test
	public void update[=ClassName]_[=ClassName]IsNotNullAnd[=ClassName]Exists_Update[=ClassName]() {
		
		[=ClassName]Entity [=ClassName?uncap_first] =mock([=ClassName]Entity.class);
		Mockito.when(_[=ClassName?uncap_first]Repository.save(any([=ClassName]Entity.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Update([=ClassName?uncap_first])).isEqualTo([=ClassName?uncap_first]);
		
	}

	@Test
	public void findAll_PageableIsNotNull_ReturnPage() {
		Page<[=ClassName]Entity> [=ClassName?uncap_first] = mock(Page.class);
		Pageable pageable = mock(Pageable.class);
		Predicate predicate = mock(Predicate.class);

		Mockito.when(_[=ClassName?uncap_first]Repository.findAll(any(Predicate.class),any(Pageable.class))).thenReturn([=ClassName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.FindAll(predicate,pageable)).isEqualTo([=ClassName?uncap_first]);
	}
	
  <#list Relationship as relationKey,relationValue>
  <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
    //[=relationValue.eName]
	@Test
	public void get[=relationValue.eName]_if_[=ClassName]IdIsNotNull_return[=relationValue.eName]() {

		[=EntityClassName] [=ClassName?uncap_first] = mock([=EntityClassName].class);
		[=relationValue.eName]Entity [=relationValue.eName?uncap_first] = mock([=relationValue.eName]Entity.class);
		
        Optional<[=EntityClassName]> db[=ClassName] = Optional.of(([=EntityClassName]) [=ClassName?uncap_first]);
		Mockito.<Optional<[=EntityClassName]>>when(_[=ClassName?uncap_first]Repository.findById(<#if CompositeKeyClasses?seq_contains(ClassName)>any([=IdClass].class)<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">anyLong()<#elseif value.fieldType?lower_case == "integer">any(Integer.class)<#elseif value.fieldType?lower_case == "short">any(Short.class)<#elseif value.fieldType?lower_case == "double">any(Double.class)<#elseif value.fieldType?lower_case == "string">anyString()</#if></#if></#list></#if>)).thenReturn(db[=ClassName]);
		Mockito.when([=ClassName?uncap_first].get[=relationValue.eName]()).thenReturn([=relationValue.eName?uncap_first]);
		Assertions.assertThat(_[=ClassName?uncap_first]Manager.Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "string">ID</#if></#if></#list></#if>)).isEqualTo([=relationValue.eName?uncap_first]);

	}
	
   </#if>
  </#list>
}
