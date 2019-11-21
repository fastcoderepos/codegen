package [=PackageName].application.Authorization.[=AuthenticationTable]role;

import [=PackageName].application.Authorization.[=AuthenticationTable]role.Dto.*;
import [=PackageName].domain.Authorization.[=AuthenticationTable]role.I[=AuthenticationTable]roleManager;
import [=PackageName].domain.model.Q[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].domain.Authorization.[=AuthenticationTable].[=AuthenticationTable]Manager;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.Authorization.Role.RoleManager;
import [=PackageName].domain.model.RoleEntity;
import [=CommonModulePackage].Search.*;
import [=CommonModulePackage].logging.LoggingHelper;
<#if Flowable!false>
import [=PackageName].application.Flowable.FlowableIdentityService;
</#if>
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
	
<#if Flowable!false>
	@Autowired
	private FlowableIdentityService idmIdentityService;
</#if>

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
		<#if Flowable!false>
		<#if AuthenticationType!="none" && UserInput??>
		idmIdentityService.addUserGroupMapping(created[=AuthenticationTable]role.get[=AuthenticationTable?cap_first]().get[=AuthenticationFields.UserName.fieldName?cap_first](), created[=AuthenticationTable]role.getRole().getName());
		<#else>
		idmIdentityService.addUserGroupMapping(created[=AuthenticationTable]role.get[=AuthenticationTable]().getUserName(), created[=AuthenticationTable]role.getRole().getName());
		</#if>
		</#if>
		
		return mapper.[=AuthenticationTable]roleEntityToCreate[=AuthenticationTable]roleOutput(created[=AuthenticationTable]role);
	
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="[=AuthenticationTable]role", key = "#[=AuthenticationTable?uncap_first]roleId")
	public Update[=AuthenticationTable]roleOutput Update([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId , Update[=AuthenticationTable]roleInput input) {

		[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role = mapper.Update[=AuthenticationTable]roleInputTo[=AuthenticationTable]roleEntity(input);
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
		
		[=AuthenticationTable]roleEntity updated[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleManager.Create([=AuthenticationTable?uncap_first]role);
		<#if Flowable!false>
		<#if AuthenticationType!="none" && UserInput??>
		idmIdentityService.updateUserGroupMapping(updated[=AuthenticationTable]role.get[=AuthenticationTable?cap_first]().get[=AuthenticationFields.UserName.fieldName?cap_first](), updated[=AuthenticationTable]role.getRole().getName());
		<#else>
		idmIdentityService.updateUserGroupMapping(updated[=AuthenticationTable]role.get[=AuthenticationTable]().getUserName(), updated[=AuthenticationTable]role.getRole().getName());
		</#if>
		</#if>
		return mapper.[=AuthenticationTable]roleEntityToUpdate[=AuthenticationTable]roleOutput(updated[=AuthenticationTable]role);
	}
	
	public boolean checkIfRoleAlreadyAssigned(UserEntity foundUser,RoleEntity foundRole)
	{
	
		Set<UserroleEntity> userRole = foundUser.getUserroleSet();
		 
		Iterator rIterator = userRole.iterator();
			while (rIterator.hasNext()) { 
				UserroleEntity ur = (UserroleEntity) rIterator.next();
				if (ur.getRole() == foundRole) {
					return true;
				}
			}
			
		return false;
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	@CacheEvict(value="[=AuthenticationTable]role", key = "#[=AuthenticationTable?uncap_first]roleId")
	public void Delete([=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleId) {

		[=AuthenticationTable]roleEntity existing = _[=AuthenticationTable?uncap_first]roleManager.FindById([=AuthenticationTable?uncap_first]roleId) ; 
		_[=AuthenticationTable?uncap_first]roleManager.Delete(existing);
	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	@Cacheable(value = "[=AuthenticationTable]role", key = "#[=AuthenticationTable?uncap_first]roleId")
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
    @Cacheable (value = "[=AuthenticationTable]role", key="#[=AuthenticationTable?uncap_first]roleId")
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
    @Cacheable (value = "[=AuthenticationTable]role", key="#[=AuthenticationTable?uncap_first]roleId")
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
	@Cacheable(value = "[=AuthenticationTable]role")
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
		if(!(
		list.get(i).replace("%20","").trim().equals("role") ||
		list.get(i).replace("%20","").trim().equals("roleId") ||
		list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]") ||
		list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]Id")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
		  if(list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]Id")) {
			builder.or([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(value)));
			}
		  if(list.get(i).replace("%20","").trim().equals("roleId")) {
			builder.or([=AuthenticationTable?uncap_first]role.role.id.eq(Long.parseLong(value)));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(Q[=AuthenticationTable]roleEntity [=AuthenticationTable?uncap_first]role, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();
        
		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
		}
		for (Map.Entry<String, String> joinCol : joinColumns.entrySet()) {
        if(joinCol != null && joinCol.getKey().equals("[=AuthenticationTable?uncap_first]Id")) {
		    builder.and([=AuthenticationTable?uncap_first]role.[=AuthenticationTable?uncap_first].id.eq(Long.parseLong(joinCol.getValue())));
		}
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
		[=AuthenticationTable?uncap_first]roleId.set[=AuthenticationTable]Id(Long.valueOf(keyMap.get("[=AuthenticationTable?uncap_first]Id")));
		return [=AuthenticationTable?uncap_first]roleId;
		
	}	
	
    
	
}


