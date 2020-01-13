package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role;

import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.*;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]role.I[=AuthenticationTable]roleManager;
import [=PackageName].domain.model.Q[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]Manager;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.role.RoleManager;
import [=PackageName].domain.model.RoleEntity;
import [=CommonModulePackage].search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;

import java.util.*;
import org.springframework.cache.annotation.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.apache.commons.lang3.StringUtils;
<#if Cache !false>
import org.springframework.cache.annotation.*;
</#if>

@Service
@Validated
public class [=AuthenticationTable]roleAppService implements I[=AuthenticationTable]roleAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private I[=AuthenticationTable]roleManager _[=AuthenticationTable?uncap_first]roleManager;
	
    @Autowired
	private [=AuthenticationTable]Manager _[=AuthenticationTable?uncap_first]Manager;
    
    @Autowired
	private RoleManager _roleManager;
    
	@Autowired
	private [=AuthenticationTable]roleMapper mapper;
	
	@Autowired
	private LoggingHelper logHelper;

    @Transactional(propagation = Propagation.REQUIRED)
	public Create[=AuthenticationTable]roleOutput Create(Create[=AuthenticationTable]roleInput input) {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mapper.Create[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(input);
	  	if(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()!=null<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first]()!=null && <#else>input.get[=AuthenticationTable][=key?cap_first]()!=null</#if></#list></#if> || input.getRoleId()!=null)
	  	{
			[=AuthenticationTable]Entity found[=AuthenticationTable] = _[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first](),<#else>input.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	        RoleEntity foundRole = _roleManager.FindById(input.getRoleId());
		
		    if(found[=AuthenticationTable]!=null || foundRole!=null)
		    {			
				if(!checkIfRoleAlreadyAssigned(found[=AuthenticationTable], foundRole))
				{
					[=AuthenticationTable?uncap_first]role.setRole(foundRole);
					[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable](found[=AuthenticationTable]);
				}
				else return null;
		     }
		     else return null;
		}
		else return null;
		
		[=AuthenticationTable]roleEntity created[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.Create([=AuthenticationTable?uncap_first]role);
		
		return mapper.[=AuthenticationTable]roleEntityToCreate[=AuthenticationTable]roleOutput(created[=AuthenticationTable]role);
	
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=AuthenticationTable]role", key = "#p0")
	</#if>
	public Update[=AuthenticationTable]roleOutput Update([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId , Update[=AuthenticationTable]roleInput input) {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mapper.Update[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(input);
	  	if(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()!=null<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first]()!=null && <#else>input.get[=AuthenticationTable][=key?cap_first]()!=null</#if></#list></#if> || input.getRoleId()!=null)
	  	{
			[=AuthenticationTable]Entity found[=AuthenticationTable] = _[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first](),<#else>input.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	        RoleEntity foundRole = _roleManager.FindById(input.getRoleId());
		
		    if(found[=AuthenticationTable]!=null || foundRole!=null)
		    {			
				if(checkIfRoleAlreadyAssigned(found[=AuthenticationTable], foundRole))
				{
					[=AuthenticationTable?uncap_first]role.setRole(foundRole);
					[=AuthenticationTable?uncap_first]role.set[=AuthenticationTable](found[=AuthenticationTable]);
				}
				else return null;
		     }
		     else return null;
		}
		else return null;
		
		[=AuthenticationTable]roleEntity updated[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.Create([=AuthenticationTable?uncap_first]role);
		return mapper.[=AuthenticationTable]roleEntityToUpdate[=AuthenticationTable]roleOutput(updated[=AuthenticationTable]role);
	}
	
	public boolean checkIfRoleAlreadyAssigned([=AuthenticationTable]Entity foundUser,RoleEntity foundRole)
	{
	
		Set<[=AuthenticationTable]roleEntity> userRole = foundUser.get[=AuthenticationTable]roleSet();
		 
		Iterator rIterator = userRole.iterator();
			while (rIterator.hasNext()) { 
				[=AuthenticationTable]roleEntity ur = ([=AuthenticationTable]roleEntity) rIterator.next();
				if (ur.getRole() == foundRole) {
					return true;
				}
			}
			
		return false;
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=AuthenticationTable]role", key = "#p0")
	</#if>
	public void Delete([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {

		[=AuthenticationTable]roleEntity existing = _[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId) ; 
		_[=AuthenticationTable?uncap_first]roleManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "[=AuthenticationTable]role", key = "#p0")
	</#if>
	public Find[=AuthenticationTable]roleByIdOutput FindById([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {

		[=AuthenticationTable]roleEntity found[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId);
		if (found[=AuthenticationTable]role == null)  
			return null ; 
 	   
 	    Find[=AuthenticationTable]roleByIdOutput output=mapper.[=AuthenticationTable]roleEntityToFind[=AuthenticationTable]roleByIdOutput(found[=AuthenticationTable]role); 
		return output;
	}
    //[=AuthenticationTable]
	// ReST API Call - GET /[=AuthenticationTable?uncap_first]role/1/[=AuthenticationTable?uncap_first]
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable (value = "[=AuthenticationTable]role", key="#p0")
    </#if>
	public Get[=AuthenticationTable]Output Get[=AuthenticationTable]([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {

		[=AuthenticationTable]roleEntity found[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId);
		if (found[=AuthenticationTable]role == null) {
			logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]role wth a id=%s", [=AuthenticationTable?uncap_first]roleId);
			return null;
		}
		[=AuthenticationTable]Entity re = _[=AuthenticationTable?uncap_first]roleManager.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]roleId);
		return mapper.[=AuthenticationTable]EntityToGet[=AuthenticationTable]Output(re, found[=AuthenticationTable]role);
	}
	
    //Role
	// ReST API Call - GET /[=AuthenticationTable?uncap_first]role/1/role
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable (value = "[=AuthenticationTable]role", key="#p0")
    </#if>
	public GetRoleOutput GetRole([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {

		[=AuthenticationTable]roleEntity found[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId);
		if (found[=AuthenticationTable]role == null) {
			logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]role wth a id=%s", [=AuthenticationTable?uncap_first]roleId);
			return null;
		}
		RoleEntity re = _[=AuthenticationTable?uncap_first]roleManager.GetRole([=AuthenticationTable?uncap_first]roleId);
		return mapper.RoleEntityToGetRoleOutput(re, found[=AuthenticationTable]role);
	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
	@Cacheable(value = "[=AuthenticationTable]role")
	</#if>
	public List<Find[=AuthenticationTable]roleByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<[=AuthenticationTable]roleEntity> found[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.FindAll(Search(search), pageable);
		List<[=AuthenticationTable]roleEntity> [=AuthenticationTable?uncap_first]roleList = found[=AuthenticationTable]role.getContent();
		Iterator<[=AuthenticationTable]roleEntity> [=AuthenticationTable?uncap_first]roleIterator = [=AuthenticationTable?uncap_first]roleList.iterator(); 
		List<Find[=AuthenticationTable]roleByIdOutput> output = new ArrayList<>();

		while ([=AuthenticationTable?uncap_first]roleIterator.hasNext()) {
			output.add(mapper.[=AuthenticationTable]roleEntityToFind[=AuthenticationTable]roleByIdOutput([=AuthenticationTable?uncap_first]roleIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role= Q[=AuthenticationTable]roleEntity.[=AuthenticationTable?uncap_first]roleEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties([=AuthenticationTable?uncap_first]role, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty([=AuthenticationTable?uncap_first]role,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair([=AuthenticationTable?uncap_first]role, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
		}
		else if(operator.equals("equals"))
		{
        	if(value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
       	 	}
			else if(StringUtils.isNumeric(value)){
        	}
        	else if(SearchUtils.stringToDate(value)!=null) {
			}
		}

		return builder;
	}

	public void checkProperties(List<String> list) throws Exception  {
		for (int i = 0; i < list.size(); i++) {
		if(!(<#if (AuthenticationType!="none" && !UserInput??)>
    	list.get(i).replace("%20","").trim().equals("userId")||
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
   		<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
   	 	list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")||
  		</#if> 
  		</#list>
  		</#if>
  		</#if>
		list.get(i).replace("%20","").trim().equals("role") ||
		list.get(i).replace("%20","").trim().equals("roleId") ||
		list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]"))) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		<#if (AuthenticationType!="none" && !UserInput??)>
		if(list.get(i).replace("%20","").trim().equals("userId")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(value)));
		}
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
  		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(value));
		}
		<#elseif value?lower_case == "long" >
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Long.parseLong(value)));
		}
		<#elseif value?lower_case == "integer">
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Integer.parseInt(value)));
		}
        <#elseif value?lower_case == "short">
        if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Short.parseShort(value)));
		}
		<#elseif value?lower_case == "double">
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Double.parseDouble(value)));
		}
		</#if>
  		</#list>
  		</#if>
  		</#if>
		if(list.get(i).replace("%20","").trim().equals("roleId")) {
			builder.or([=AuthenticationTable?uncap_first]role.role.id.eq(Long.parseLong(value)));
		}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
		<#if (AuthenticationType!="none" && !UserInput??)>
        if(joinCol != null && joinCol.getKey().equals("userId")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(joinCol.getValue())));
		}
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
  		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(joinCol.getValue()));
		}
		<#elseif value?lower_case == "long" >
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Long.parseLong(joinCol.getValue())));
		}
		<#elseif value?lower_case == "integer">
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Integer.parseInt(joinCol.getValue())));
		}
        <#elseif value?lower_case == "short">
        if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Short.parseShort(joinCol.getValue())));
		}
		<#elseif value?lower_case == "double">
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Double.parseDouble(joinCol.getValue())));
		}
		</#if>
  		</#list>
  		</#if>
  		</#if>
        }
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("roleId")) {
		    builder.and([=AuthenticationTable?uncap_first]role.role.id.eq(Long.parseLong(joinCol.getValue())));
		}
        }
		return builder;
	}
	
	public [=AuthenticationTable]roleId parse[=AuthenticationTable]roleKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId = new [=AuthenticationTable]roleId();
		
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
		
		[=AuthenticationTable?uncap_first]roleId.setRoleId(Long.valueOf(keyMap.get("roleId")));
		<#if (AuthenticationType!="none" && !UserInput??)>
        [=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable]Id(Long.valueOf(keyMap.get("[=AuthenticationTable?uncap_first]Id")));
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable?cap_first][=key?cap_first](keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]"));
		<#elseif value?lower_case == "long" >
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable?cap_first][=key?cap_first](Long.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		<#elseif value?lower_case == "integer">
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable?cap_first][=key?cap_first](Integer.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
        <#elseif value?lower_case == "short">
        [=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable?cap_first][=key?cap_first](Short.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable?cap_first][=key?cap_first](Double.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		</#if>
  		</#list>
  		</#if>
  		</#if>
		return [=AuthenticationTable?uncap_first]roleId;
		
	}	
	
}


