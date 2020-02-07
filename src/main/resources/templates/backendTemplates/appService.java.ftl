package [=PackageName].application<#if (AuthenticationType == "database" || UserOnly)  && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case];

import [=PackageName].application<#if (AuthenticationType == "database" || UserOnly)  && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto.*;
import [=PackageName].domain<#if (AuthenticationType == "database" || UserOnly)  && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].I[=ClassName]Manager;
import [=PackageName].domain.model.Q[=EntityClassName];
import [=PackageName].domain.model.[=EntityClassName];
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
<#list Relationship as relationKey,relationValue>
<#if relationValue.relation == "OneToOne" || relationValue.relation == "ManyToOne">
import [=PackageName].domain<#if (AuthenticationType == "database" || UserOnly) && relationValue.eName == AuthenticationTable>.authorization</#if>.[=relationValue.eName?lower_case].[=relationValue.eName]Manager;
</#if>
<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
import [=PackageName].domain.model.[=relationValue.eName]Entity;
</#if>
<#if relationValue.relation == "ManyToOne" >
<#assign i= relationValue.joinDetails?size>
<#if i!=0 && i!=1>
import [=PackageName].domain.model.[=relationValue.eName]Id;
</#if>
</#if>
</#list>
<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
import [=PackageName].domain.irepository.IJwtRepository;
import [=PackageName].domain.model.JwtEntity;
</#if>
import [=CommonModulePackage].search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.*;
<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
import java.util.Set;
import javax.servlet.ServletContext;

import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.model.RolepermissionEntity;
import [=PackageName].domain.model.[=ClassName]permissionEntity;
import org.springframework.security.core.userdetails.User;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
</#if>
<#if Cache !false>
import org.springframework.cache.annotation.*;
</#if>
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.apache.commons.lang3.StringUtils;

@Service
@Validated
public class [=ClassName]AppService implements I[=ClassName]AppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private I[=ClassName]Manager _[=ClassName?uncap_first]Manager;

    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.relation !="OneToMany">
    @Autowired
	private [=relationValue.eName]Manager _[=relationValue.eName?uncap_first]Manager;
    
    </#if>
    </#list>
	@Autowired
	private [=ClassName]Mapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public Create[=ClassName]Output Create(Create[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?uncap_first] = mapper.Create[=ClassName]InputTo[=EntityClassName](input);
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
        <#assign i=relationValue.joinDetails?size>
        <#if i==1>
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
	  	if(input.get[=joinDetails.joinColumn?cap_first]()!=null) {
			[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(input.get[=joinDetails.joinColumn?cap_first]());
			if(found[=relationValue.eName]!=null) {
				[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
			}
		<#if joinDetails.isJoinColumnOptional==false>
			else {
				return null;
			}
		</#if>
		}
		<#if joinDetails.isJoinColumnOptional==false>
		else {
			return null;
		}
		</#if>
        </#if>
        </#if>
        </#list>
        <#else>
        <#if relationValue.relation == "ManyToOne">if(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.joinColumn?cap_first]()!=null &&<#else> input.get[=joinDetails.joinColumn?cap_first]()!=null</#if></#list>) {
        [=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(new [=relationValue.eName]Id(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.joinColumn?cap_first](),<#else> input.get[=joinDetails.joinColumn?cap_first]()</#if></#list>));
        </#if>
	    <#if relationValue.relation == "OneToOne">if(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.referenceColumn?cap_first]()!=null &&<#else> input.get[=joinDetails.referenceColumn?cap_first]()!=null</#if></#list>) {
	    [=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(new [=relationValue.eName]Id(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.referenceColumn?cap_first](),<#else> input.get[=joinDetails.referenceColumn?cap_first]()</#if></#list>));
	    </#if>
			if(found[=relationValue.eName]!=null) {
				[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		</#if>
		</#if>
        </#if>
		</#list>
		[=EntityClassName] created[=ClassName] = _[=ClassName?uncap_first]Manager.Create([=ClassName?uncap_first]);
		return mapper.[=EntityClassName]ToCreate[=ClassName]Output(created[=ClassName]);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=ClassName]", key = "#p0")
	</#if>
	public Update[=ClassName]Output Update(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first] <#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if> </#if></#list> [=IdClass?uncap_first]</#if>, Update[=ClassName]Input input) {

		[=EntityClassName] [=ClassName?uncap_first] = mapper.Update[=ClassName]InputTo[=EntityClassName](input);
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
	  	<#assign i=relationValue.joinDetails?size>
        <#if i==1>
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
	  	if(input.get[=joinDetails.joinColumn?cap_first]()!=null) {
			[=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(input.get[=joinDetails.joinColumn?cap_first]());
			if(found[=relationValue.eName]!=null) {
				[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
			}
		<#if joinDetails.isJoinColumnOptional==false>
			else {
				return null;
			}
		</#if>
		}
		<#if joinDetails.isJoinColumnOptional==false>
		else {
			return null;
		}
		</#if>
		</#if>
        </#if>
        </#list>
        <#else>
        <#if relationValue.relation == "ManyToOne">if(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.joinColumn?cap_first]()!=null &&<#else> input.get[=joinDetails.joinColumn?cap_first]()!=null</#if></#list>) {
        [=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(new [=relationValue.eName]Id(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.joinColumn?cap_first](),<#else> input.get[=joinDetails.joinColumn?cap_first]()</#if></#list>));
        </#if>
	    <#if relationValue.relation == "OneToOne">if(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.referenceColumn?cap_first]()!=null &&<#else> input.get[=joinDetails.referenceColumn?cap_first]()!=null</#if></#list>) {
	    [=relationValue.eName]Entity found[=relationValue.eName] = _[=relationValue.eName?uncap_first]Manager.FindById(new [=relationValue.eName]Id(<#list relationValue.joinDetails as joinDetails><#if joinDetails_has_next>input.get[=joinDetails.referenceColumn?cap_first](),<#else> input.get[=joinDetails.referenceColumn?cap_first]()</#if></#list>));
	    </#if>
	    	if(found[=relationValue.eName]!=null){
				[=ClassName?uncap_first].set[=relationValue.eName](found[=relationValue.eName]);
			}
			else {
				return null;
			}
		}
		else {
			return null;
		}
		</#if>
        </#if>
		</#if>
		</#list>
		
		[=EntityClassName] updated[=ClassName] = _[=ClassName?uncap_first]Manager.Update([=ClassName?uncap_first]);
		return mapper.[=EntityClassName]ToUpdate[=ClassName]Output(updated[=ClassName]);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=ClassName]", key = "#p0")
	</#if>
	public void Delete(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {

		[=EntityClassName] existing = _[=ClassName?uncap_first]Manager.FindById([=IdClass?uncap_first]) ; 
		_[=ClassName?uncap_first]Manager.Delete(existing);

	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "[=ClassName]", key = "#p0")
	</#if>
	public Find[=ClassName]ByIdOutput FindById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=IdClass?uncap_first]);
		if (found[=ClassName] == null)  
			return null ; 
 	   
 	    Find[=ClassName]ByIdOutput output=mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput(found[=ClassName]); 
		return output;
	}
	<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "[=ClassName]", key = "#p0")
	</#if>
	public Find[=ClassName]WithAllFieldsByIdOutput FindWithAllFieldsById(<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=IdClass?uncap_first]);
		if (found[=ClassName] == null)  
			return null ; 
 	   
 	    Find[=ClassName]WithAllFieldsByIdOutput output=mapper.[=EntityClassName]ToFind[=ClassName]WithAllFieldsByIdOutput(found[=ClassName]); 
		return output;
	}
	
	<#if AuthenticationFields??>
	<#list AuthenticationFields as authKey,authValue>
	<#if authKey== "UserName">
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "[=ClassName]", key = "#p0")
	</#if>
	public Find[=ClassName]By[=authValue.fieldName?cap_first]Output FindBy[=authValue.fieldName?cap_first](String [=authValue.fieldName?uncap_first]) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindBy[=authValue.fieldName?cap_first]([=authValue.fieldName?uncap_first]);
		if (found[=ClassName] == null) {
			return null;
		}
		return  mapper.[=ClassName]EntityToFind[=ClassName]By[=authValue.fieldName?cap_first]Output(found[=ClassName]);

	}
	</#if>
    </#list>
    </#if>
	</#if>
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
    //[=relationValue.eName]
	// ReST API Call - GET /[=ClassName?uncap_first]/1/[=relationValue.eName?uncap_first]
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable (value = "[=ClassName]", key="#p0")
    </#if>
	public Get[=relationValue.eName]Output Get[=relationValue.eName](<#if CompositeKeyClasses?seq_contains(ClassName)>[=IdClass] [=IdClass?uncap_first]<#else><#list Fields as key,value><#if value.isPrimaryKey!false><#if value.fieldType?lower_case == "long">Long<#elseif value.fieldType?lower_case == "integer">Integer<#elseif value.fieldType?lower_case == "short">Short<#elseif value.fieldType?lower_case == "double">Double<#elseif value.fieldType?lower_case == "string">String</#if></#if></#list> [=IdClass?uncap_first]</#if>) {

		[=EntityClassName] found[=ClassName] = _[=ClassName?uncap_first]Manager.FindById([=IdClass?uncap_first]);
		if (found[=ClassName] == null) {
			logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] wth a id=%s", [=IdClass?uncap_first]);
			return null;
		}
		[=relationValue.eName]Entity re = _[=ClassName?uncap_first]Manager.Get[=relationValue.eName]([=IdClass?uncap_first]);
		return mapper.[=relationValue.eName]EntityToGet[=relationValue.eName]Output(re, found[=ClassName]);
	}
	
   </#if>
   </#list>
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
	@Cacheable(value = "[=ClassName]")
	</#if>
	public List<Find[=ClassName]ByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<[=EntityClassName]> found[=ClassName] = _[=ClassName?uncap_first]Manager.FindAll(Search(search), pageable);
		List<[=EntityClassName]> [=ClassName?uncap_first]List = found[=ClassName].getContent();
		Iterator<[=EntityClassName]> [=ClassName?uncap_first]Iterator = [=ClassName?uncap_first]List.iterator(); 
		List<Find[=ClassName]ByIdOutput> output = new ArrayList<>();

		while ([=ClassName?uncap_first]Iterator.hasNext()) {
			output.add(mapper.[=EntityClassName]ToFind[=ClassName]ByIdOutput([=ClassName?uncap_first]Iterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		Q[=EntityClassName] [=ClassName?uncap_first]= Q[=EntityClassName].[=EntityClassName?uncap_first];
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties([=ClassName?uncap_first], search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty([=ClassName?uncap_first],keysList,search.getValue(),search.getOperator());
			}
			else if(search.getType()==case3)
			{
				Map<String,SearchFields> map = new HashMap<>();
				for(SearchFields fieldDetails: search.getFields())
				{
					map.put(fieldDetails.getFieldName(),fieldDetails);
				}
				List<String> keysList = new ArrayList<String>(map.keySet());
				checkProperties(keysList);
				return searchKeyValuePair([=ClassName?uncap_first], map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(Q[=EntityClassName] [=ClassName?uncap_first],String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(value));
		</#if> 
		</#if> 
        </#list>
		}
		else if(operator.equals("equals"))
		{
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
        	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(value));
		</#if> 
		</#if> 
        </#list>
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
        <#list Fields as key,value>
        <#if value.fieldType?lower_case == "boolean">
		    	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(value)));
		</#if> 
        </#list>
       	 	}
			else if(StringUtils.isNumeric(value)){
		<#list Fields as key,value>
		<#if value.isPrimaryKey==false>
        <#if value.fieldType?lower_case == "long">
				builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(value)));
        <#elseif value.fieldType?lower_case == "integer">
                builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Integer.valueOf(value)));
        <#elseif value.fieldType?lower_case == "short">
                builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Short.valueOf(value)));
        <#elseif value.fieldType?lower_case == "double">
                builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Double.valueOf(value)));
		</#if> 
		</#if>
        </#list>
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
        <#list Fields as key,value>
        <#if value.fieldType?lower_case == "date">
	        	builder.or([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(value)));
        </#if> 
        </#list>
			}
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(
		<#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
		list.get(i).replace("%20","").trim().equals("userrole") ||
		</#if>
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
		<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        <#if !Fields[joinDetails.joinColumn]?? >
		list.get(i).replace("%20","").trim().equals("[=joinDetails.joinColumn]") ||
		</#if>
        </#if>
        </#if>
		</#list>
        </#if>
        </#if>
		</#list>
        <#list Fields?keys as key>
        <#if key_has_next>
		list.get(i).replace("%20","").trim().equals("[=Fields[key].fieldName]") ||
		<#else>
		list.get(i).replace("%20","").trim().equals("[=Fields[key].fieldName]")
        </#if> 
        </#list>
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(Q[=EntityClassName] [=ClassName?uncap_first],List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
        <#if value.isPrimaryKey==false>
            if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("contains"))
					builder.or([=ClassName?uncap_first].[=value.fieldName].likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(value));
			}
		</#if>	
		<#elseif value.fieldType?lower_case == "boolean">
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(value)));
			}
		<#elseif value.fieldType?lower_case == "long">
        <#if value.isPrimaryKey==false>
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(value)));
			}
		</#if>
        <#elseif value.fieldType?lower_case == "integer">
        <#if value.isPrimaryKey==false>
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Integer.valueOf(value)));
			}
		</#if>
        <#elseif value.fieldType?lower_case == "short">
        <#if value.isPrimaryKey==false>
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Short.valueOf(value)));
			}
		</#if>
        <#elseif value.fieldType?lower_case == "double">
        <#if value.isPrimaryKey==false>
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && StringUtils.isNumeric(value))
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(Double.valueOf(value)));
			}
		</#if>
		<#elseif value.fieldType?lower_case == "date">
			if(list.get(i).replace("%20","").trim().equals("[=value.fieldName]")) {
				if(operator.equals("equals") && SearchUtils.stringToDate(value)!=null)
					builder.or([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(value)));
			}
        </#if>
        </#list>
        <#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne">
		<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
		  if(list.get(i).replace("%20","").trim().equals("[=joinDetails.joinColumn]")) {
			builder.or([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(<#if joinDetails.joinColumnType == "Long">Long.parseLong(value)<#elseif joinDetails.joinColumnType == "Integer">Integer.parseInt(value)<#elseif joinDetails.joinColumnType == "Double">Double.parseDouble(value)<#elseif joinDetails.joinColumnType == "String">value</#if>));
			}
		</#if>
		</#if>
		</#list>
		</#if>
		</#list>
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(Q[=EntityClassName] [=ClassName?uncap_first], Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
        <#if Fields??>
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
		<#list Fields as key,value>
        <#if value.fieldType?lower_case == "string">
         <#if value.isPrimaryKey==false>
            if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(details.getValue().getSearchValue()));
			}
		  </#if>
		<#elseif value.fieldType?lower_case == "boolean">
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Boolean.parseBoolean(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && (details.getValue().getSearchValue().equalsIgnoreCase("true") || details.getValue().getSearchValue().equalsIgnoreCase("false")))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Boolean.parseBoolean(details.getValue().getSearchValue())));
			}
		<#elseif value.fieldType?lower_case == "long">
        <#if value.isPrimaryKey==false>
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Long.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].between(Long.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(Long.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(Long.valueOf(details.getValue().getEndingValue())));
				}
			}
		</#if>
        <#elseif value.fieldType?lower_case == "integer">
        <#if value.isPrimaryKey==false>
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Integer.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Integer.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].between(Integer.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(Integer.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(Integer.valueOf(details.getValue().getEndingValue())));
				}
			}
		</#if>
        <#elseif value.fieldType?lower_case == "short">
        <#if value.isPrimaryKey==false>
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Short.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Short.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].between(Short.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(Short.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(Short.valueOf(details.getValue().getEndingValue())));
				}
			}
		</#if>
        <#elseif value.fieldType?lower_case == "double">
        <#if value.isPrimaryKey==false>
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(Double.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && StringUtils.isNumeric(details.getValue().getSearchValue()))
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(Double.valueOf(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   if(StringUtils.isNumeric(details.getValue().getStartingValue()) && StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].between(Double.valueOf(details.getValue().getStartingValue()), Long.valueOf(details.getValue().getEndingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getStartingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(Double.valueOf(details.getValue().getStartingValue())));
                   else if(StringUtils.isNumeric(details.getValue().getEndingValue()))
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(Double.valueOf(details.getValue().getEndingValue())));
				}
			}
		</#if>
		<#elseif value.fieldType?lower_case == "date">
			if(details.getKey().replace("%20","").trim().equals("[=value.fieldName]")) {
				if(details.getValue().getOperator().equals("equals") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and([=ClassName?uncap_first].[=value.fieldName].eq(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("notEqual") && SearchUtils.stringToDate(details.getValue().getSearchValue()) !=null)
					builder.and([=ClassName?uncap_first].[=value.fieldName].ne(SearchUtils.stringToDate(details.getValue().getSearchValue())));
				else if(details.getValue().getOperator().equals("range"))
				{
				   Date startDate= SearchUtils.stringToDate(details.getValue().getStartingValue());
				   Date endDate= SearchUtils.stringToDate(details.getValue().getEndingValue());
				   if(startDate!=null && endDate!=null)	 
					   builder.and([=ClassName?uncap_first].[=value.fieldName].between(startDate,endDate));
				   else if(endDate!=null)
					   builder.and([=ClassName?uncap_first].[=value.fieldName].loe(endDate));
                   else if(startDate!=null)
                	   builder.and([=ClassName?uncap_first].[=value.fieldName].goe(startDate));  
                 }
                   
			}
	    </#if>
	    </#list>	
		}
		</#if>
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne" >
		<#if relationValue.isParent==false>
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
		<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
        if(joinCol != null && joinCol.getKey().equals("[=joinDetails.joinColumn]")) {
		<#if joinDetails.joinColumnType == "String">
		    builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(joinCol.getValue()));
		<#elseif joinDetails.joinColumnType == "Long">
		    builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(Long.parseLong(joinCol.getValue())));
		<#elseif joinDetails.joinColumnType == "Integer">
		    builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(Integer.parseInt(joinCol.getValue())));
		<#elseif joinDetails.joinColumnType == "Double">
		    builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(Double.parseDouble(joinCol.getValue())));
        <#elseif joinDetails.joinColumnType == "Short">
		    builder.and([=ClassName?uncap_first].[=relationValue.eName?uncap_first].[=joinDetails.referenceColumn].eq(Short.parseShort(joinCol.getValue())));
        </#if>
		}
		</#if>
        </#if>
		</#list>
        }
		</#if>
        </#if> 
		</#list>
		return builder;
	}
	
	<#if CompositeKeyClasses?seq_contains(ClassName)>
	public [=IdClass] parse[=ClassName]Key(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		[=IdClass] [=IdClass?uncap_first] = new [=IdClass]();
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					return null;
				}
			}
		}
		else {
			return null;
		}
		
		<#list PrimaryKeys as fieldName,fieldType>
		<#if fieldType?lower_case == "string" >
		[=IdClass?uncap_first].set[=fieldName?cap_first](keyMap.get("[=fieldName]"));
		<#elseif fieldType?lower_case == "long" >
		[=IdClass?uncap_first].set[=fieldName?cap_first](Long.valueOf(keyMap.get("[=fieldName]")));
		<#elseif fieldType?lower_case == "integer">
		[=IdClass?uncap_first].set[=fieldName?cap_first](Integer.valueOf(keyMap.get("[=fieldName]")));
        <#elseif fieldType?lower_case == "short">
		[=IdClass?uncap_first].set[=fieldName?cap_first](Short.valueOf(keyMap.get("[=fieldName]")));
        <#elseif fieldType?lower_case == "double">
		[=IdClass?uncap_first].set[=fieldName?cap_first](Double.valueOf(keyMap.get("[=fieldName]")));
		</#if>
		</#list>
		return [=IdClass?uncap_first];
		
	}	
	</#if>
	
	<#list Relationship as relationKey,relationValue>
	<#if relationValue.relation == "OneToMany">
	public Map<String,String> parse[=relationValue.eName]JoinColumn(String keysString) {
		<#list relationValue.joinDetails as joinDetails>
		<#assign i=relationValue.joinDetails?size>
        <#if i!=1>
		String[] keyEntries = keysString.split(",");
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					return null;
				}
			}
		}
		else {
			return null;
		}
		</#if>
		<#break>
		</#list>
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		<#list relationValue.joinDetails as joinDetails>
		<#assign i=relationValue.joinDetails?size>
        <#if i==1>
		joinColumnMap.put("[=joinDetails.joinColumn?uncap_first]", keysString);
		<#else>
		joinColumnMap.put("[=joinDetails.joinColumn?uncap_first]", keyMap.get("[=joinDetails.referenceColumn]"));
		</#if>
		</#list>
		return joinColumnMap;
	}
    </#if>
    </#list>
    
    <#if (AuthenticationType == "database" || UserOnly) && ClassName == AuthenticationTable>
    public Map<String,String> parse[=AuthenticationTable]permissionJoinColumn(String keysString) {
    	Map<String,String> joinColumnMap = new HashMap<String,String>();
    	<#assign primaryKeyLength=PrimaryKeys?size>
		<#if primaryKeyLength gt 1 >
		String[] keyEntries = keysString.split(",");
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					return null;
				}
			}
		}
		else {
			return null;
		}
		
		<#list PrimaryKeys as fieldName,fieldType>
		joinColumnMap.put("[= AuthenticationTable + fieldName?cap_first]", keyMap.get("[=fieldName?uncap_first]"));
		</#list>
		<#elseif primaryKeyLength == 1>
		<#list PrimaryKeys as fieldName,fieldType>
		joinColumnMap.put("[= AuthenticationTable + fieldName?cap_first]", keysString);
		</#list>
		</#if>
		return joinColumnMap;
	}
	
	public Map<String,String> parse[=AuthenticationTable]roleJoinColumn(String keysString) {
    	Map<String,String> joinColumnMap = new HashMap<String,String>();
    	<#assign primaryKeyLength=PrimaryKeys?size>
		<#if primaryKeyLength gt 1 >
		String[] keyEntries = keysString.split(",");
		
		Map<String,String> keyMap = new HashMap<String,String>();
		if(keyEntries.length > 1) {
			for(String keyEntry: keyEntries)
			{
				String[] keyEntryArr = keyEntry.split(":");
				if(keyEntryArr.length > 1) {
					keyMap.put(keyEntryArr[0], keyEntryArr[1]);					
				}
				else {
					return null;
				}
			}
		}
		else {
			return null;
		}
		
		<#list PrimaryKeys as fieldName,fieldType>
		joinColumnMap.put("[= AuthenticationTable + fieldName?cap_first]", keyMap.get("[=fieldName?uncap_first]"));
		</#list>
		<#elseif primaryKeyLength == 1>
		<#list PrimaryKeys as fieldName,fieldType>
		joinColumnMap.put("[= AuthenticationTable + fieldName?cap_first]", keysString);
		</#list>
		</#if>
		return joinColumnMap;
	}
	</#if>
	
}


