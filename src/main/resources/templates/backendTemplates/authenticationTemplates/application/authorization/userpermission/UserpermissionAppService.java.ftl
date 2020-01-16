package [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission;

import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.*;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]permission.I[=AuthenticationTable]permissionManager;
import [=PackageName].domain.model.Q[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.permission.IPermissionManager;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.model.RolepermissionEntity;

<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=CommonModulePackage].search.*;
import [=CommonModulePackage].logging.LoggingHelper;
import com.querydsl.core.BooleanBuilder;
<#if Cache !false>
import org.springframework.cache.annotation.*;
</#if>

import java.util.Date;
import java.util.Map;
import java.util.Set;
import java.util.List;
import java.util.HashMap;
import java.util.Iterator;
import java.util.ArrayList;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.data.domain.Page; 
import org.springframework.data.domain.Pageable; 
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Validated
public class [=AuthenticationTable]permissionAppService implements I[=AuthenticationTable]permissionAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
	
	@Autowired
	private I[=AuthenticationTable]permissionManager _[=AuthenticationTable?uncap_first]permissionManager;
  
    @Autowired
	private I[=AuthenticationTable]Manager _[=AuthenticationTable?uncap_first]Manager;
    
    @Autowired
	private IPermissionManager _permissionManager;
    
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private [=AuthenticationTable]permissionMapper mapper;

    @Transactional(propagation = Propagation.REQUIRED)
	public Create[=AuthenticationTable]permissionOutput Create(Create[=AuthenticationTable]permissionInput input) {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mapper.Create[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(input);
	  	
    	if(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()!=null<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first]()!=null && <#else>input.get[=AuthenticationTable][=key?cap_first]()!=null</#if></#list></#if> || input.getPermissionId()!=null)
		{
		[=AuthenticationTable]Entity found[=AuthenticationTable] = _[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first](),<#else>input.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
		PermissionEntity foundPermission = _permissionManager.FindById(input.getPermissionId());
		
		if(found[=AuthenticationTable]!=null || foundPermission!=null)
		{			
				if(!checkIfPermissionAlreadyAssigned(found[=AuthenticationTable], foundPermission))
				{
					[=AuthenticationTable?uncap_first]permission.setPermission(foundPermission);
					[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable](found[=AuthenticationTable]);
					[=AuthenticationTable?uncap_first]permission.setRevoked(input.getRevoked());
				}
				else return null;
		}
		else return null;
		}
		else return null;
		
		[=AuthenticationTable]permissionEntity created[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.Create([=AuthenticationTable?uncap_first]permission);

		return mapper.[=AuthenticationTable]permissionEntityToCreate[=AuthenticationTable]permissionOutput(created[=AuthenticationTable]permission);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=AuthenticationTable]permission", key = "#p0")
	</#if>
	public Update[=AuthenticationTable]permissionOutput Update([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId , Update[=AuthenticationTable]permissionInput input) {

		[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission = mapper.Update[=AuthenticationTable]permissionInputTo[=AuthenticationTable]permissionEntity(input);
	  	
		if(<#if (AuthenticationType!="none" && !UserInput??) >input.get[=AuthenticationTable]Id()!=null<#elseif AuthenticationType!="none" && UserInput??><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first]()!=null && <#else>input.get[=AuthenticationTable][=key?cap_first]()!=null</#if></#list></#if> || input.getPermissionId()!=null)
		{
			[=AuthenticationTable]Entity found[=AuthenticationTable] = _[=AuthenticationTable?uncap_first]Manager.FindById(<#if (AuthenticationType!="none" && !UserInput??)>input.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>input.get[=AuthenticationTable][=key?cap_first](),<#else>input.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
			PermissionEntity foundPermission = _permissionManager.FindById(input.getPermissionId());
		
			if(found[=AuthenticationTable]!=null || foundPermission!=null)
			{			
				if(checkIfPermissionAlreadyAssigned(found[=AuthenticationTable], foundPermission))
				{
					[=AuthenticationTable?uncap_first]permission.setPermission(foundPermission);
					[=AuthenticationTable?uncap_first]permission.set[=AuthenticationTable](found[=AuthenticationTable]);
					[=AuthenticationTable?uncap_first]permission.setRevoked(input.getRevoked());
				}
				else return null;
			}
			else return null;
		}
		else return null;
		
		[=AuthenticationTable]permissionEntity updated[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.Update([=AuthenticationTable?uncap_first]permission);
		return mapper.[=AuthenticationTable]permissionEntityToUpdate[=AuthenticationTable]permissionOutput(updated[=AuthenticationTable]permission);
	}
	
	public boolean checkIfPermissionAlreadyAssigned([=AuthenticationTable]Entity found[=AuthenticationTable],PermissionEntity foundPermission)
	{
		
		Set<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]Permission = found[=AuthenticationTable].get[=AuthenticationTable]permissionSet();
		 
		Iterator pIterator = [=AuthenticationTable?uncap_first]Permission.iterator();
			while (pIterator.hasNext()) { 
				[=AuthenticationTable]permissionEntity pe = ([=AuthenticationTable]permissionEntity) pIterator.next();
				if (pe.getPermission() == foundPermission ) {
					return true;
				}
			}
			
		return false;
	}

	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="[=AuthenticationTable]permission", key = "#p0")
	</#if>
	public void Delete([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId) {

		[=AuthenticationTable]permissionEntity existing = _[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId) ; 
		_[=AuthenticationTable?uncap_first]permissionManager.Delete(existing);

	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "[=AuthenticationTable]permission", key = "#p0")
	</#if>
	public Find[=AuthenticationTable]permissionByIdOutput FindById([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId ) {

		[=AuthenticationTable]permissionEntity found[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId);
		if (found[=AuthenticationTable]permission == null)  
			return null ; 
 	   
 	   Find[=AuthenticationTable]permissionByIdOutput output=mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput(found[=AuthenticationTable]permission); 
		return output;
	}
    //[=AuthenticationTable]
	// ReST API Call - GET /[=AuthenticationTable?uncap_first]permission/1/[=AuthenticationTable?uncap_first]
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable (value = "[=AuthenticationTable]permission", key="#p0")
    </#if>
	public Get[=AuthenticationTable]Output Get[=AuthenticationTable]([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId ) {

		[=AuthenticationTable]permissionEntity found[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId);
		if (found[=AuthenticationTable]permission == null) {
			logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]permission wth a id=%s", [=AuthenticationTable?uncap_first]permissionId);
			return null;
		}
		[=AuthenticationTable]Entity re = _[=AuthenticationTable?uncap_first]permissionManager.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]permissionId);
		return mapper.[=AuthenticationTable]EntityToGet[=AuthenticationTable]Output(re, found[=AuthenticationTable]permission);
	}
    
    //Permission
	// ReST API Call - GET /[=AuthenticationTable?uncap_first]permission/1/permission
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable (value = "[=AuthenticationTable]permission", key="#p0")
	</#if>
	public GetPermissionOutput GetPermission([=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId ) {

		[=AuthenticationTable]permissionEntity found[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.FindById([=AuthenticationTable?uncap_first]permissionId);
		if (found[=AuthenticationTable]permission == null) {
			logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]permission wth a id=%s", [=AuthenticationTable?uncap_first]permissionId);
			return null;
		}
		PermissionEntity re = _[=AuthenticationTable?uncap_first]permissionManager.GetPermission([=AuthenticationTable?uncap_first]permissionId);
		return mapper.PermissionEntityToGetPermissionOutput(re, found[=AuthenticationTable]permission);
	}
    
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
	@Cacheable(value = "[=AuthenticationTable]permission")
	</#if>
	public List<Find[=AuthenticationTable]permissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<[=AuthenticationTable]permissionEntity> found[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionManager.FindAll(Search(search), pageable);
		List<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]permissionList = found[=AuthenticationTable]permission.getContent();
		Iterator<[=AuthenticationTable]permissionEntity> [=AuthenticationTable?uncap_first]permissionIterator = [=AuthenticationTable?uncap_first]permissionList.iterator(); 
		List<Find[=AuthenticationTable]permissionByIdOutput> output = new ArrayList<>();

		while ([=AuthenticationTable?uncap_first]permissionIterator.hasNext()) {
			output.add(mapper.[=AuthenticationTable]permissionEntityToFind[=AuthenticationTable]permissionByIdOutput([=AuthenticationTable?uncap_first]permissionIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission= Q[=AuthenticationTable]permissionEntity.[=AuthenticationTable?uncap_first]permissionEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties([=AuthenticationTable?uncap_first]permission, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty([=AuthenticationTable?uncap_first]permission,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair([=AuthenticationTable?uncap_first]permission, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission,String value,String operator) {
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
		if(!(
		<#if (AuthenticationType!="none" && !UserInput??)>
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
		 list.get(i).replace("%20","").trim().equals("permission") ||
		 list.get(i).replace("%20","").trim().equals("permissionId") ||
		 list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {

		<#if (AuthenticationType!="none" && !UserInput??)>
		if(list.get(i).replace("%20","").trim().equals("userId")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(value)));
		}
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
  		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(value));
		}
		<#elseif value?lower_case == "long" >
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Long.parseLong(value)));
		}
		<#elseif value?lower_case == "integer">
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Integer.parseInt(value)));
		}
        <#elseif value?lower_case == "short">
        if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Short.parseShort(value)));
		}
		<#elseif value?lower_case == "double">
		if(list.get(i).replace("%20","").trim().equals("[=key?uncap_first]")) {
			builder.or([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Double.parseDouble(value)));
		}
		</#if>
  		</#list>
  		</#if>
  		</#if>
		if(list.get(i).replace("%20","").trim().equals("permissionId")) {
			builder.or([=AuthenticationTable?uncap_first]permission.permission.id.eq(Long.parseLong(value)));
		}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(Q[=AuthenticationTable]permissionEntity [=AuthenticationTable?uncap_first]permission, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        
		<#if (AuthenticationType!="none" && !UserInput??)>
        if(joinCol != null && joinCol.getKey().equals("userId")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(joinCol.getValue())));
		}
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
  		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(joinCol.getValue()));
		}
		<#elseif value?lower_case == "long" >
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Long.parseLong(joinCol.getValue())));
		}
		<#elseif value?lower_case == "integer">
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Integer.parseInt(joinCol.getValue())));
		}
        <#elseif value?lower_case == "short">
        if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Short.parseShort(joinCol.getValue())));
		}
		<#elseif value?lower_case == "double">
		if(joinCol != null && joinCol.getKey().equals("[=key?uncap_first]")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.[=AuthenticationTable?uncap_first].[=key?uncap_first].eq(Double.parseDouble(joinCol.getValue())));
		}
		</#if>
  		</#list>
  		</#if>
  		</#if>
        }
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("permissionId")) {
		    builder.and([=AuthenticationTable?uncap_first]permission.permission.id.eq(Long.parseLong(joinCol.getValue())));
		}
        }
		return builder;
	}
	
	public [=AuthenticationTable]permissionId parse[=AuthenticationTable]permissionKey(String keysString) {
		
		String[] keyEntries = keysString.split(",");
		[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId = new [=AuthenticationTable]permissionId();
		
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
		
		[=AuthenticationTable?uncap_first]permissionId.setPermissionId(Long.valueOf(keyMap.get("permissionId")));
		<#if (AuthenticationType!="none" && !UserInput??)>
        [=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable]Id(Long.valueOf(keyMap.get("[=AuthenticationTable?uncap_first]Id")));
  		<#elseif AuthenticationType!="none" && UserInput??>
  		<#if PrimaryKeys??>
  		<#list PrimaryKeys as key,value>
  		<#if value?lower_case == "string" >
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable?cap_first][=key?cap_first](keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]"));
		<#elseif value?lower_case == "long" >
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable?cap_first][=key?cap_first](Long.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		<#elseif value?lower_case == "integer">
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable?cap_first][=key?cap_first](Integer.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
        <#elseif value?lower_case == "short">
        [=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable?cap_first][=key?cap_first](Short.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		<#elseif value?lower_case == "double">
		[=AuthenticationTable?uncap_first]permissionId.set[=AuthenticationTable?cap_first][=key?cap_first](Double.valueOf(keyMap.get("[=AuthenticationTable?uncap_first][=key?cap_first]")));
		</#if>
  		</#list>
  		</#if>
  		</#if>
		return [=AuthenticationTable?uncap_first]permissionId;
	}	
	
	
}


