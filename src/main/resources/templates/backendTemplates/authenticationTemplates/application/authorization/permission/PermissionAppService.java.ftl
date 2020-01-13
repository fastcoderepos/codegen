package [=PackageName].application.authorization.permission;

import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchFields;
import [=CommonModulePackage].search.SearchUtils;
import [=PackageName].application.authorization.permission.dto.*;
import [=PackageName].domain.model.PermissionEntity;
import [=PackageName].domain.authorization.permission.IPermissionManager;
import [=PackageName].domain.model.QPermissionEntity;
import com.querydsl.core.BooleanBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
<#if Cache !false>
import org.springframework.cache.annotation.*;
</#if>
import org.springframework.validation.annotation.Validated;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.apache.commons.lang3.StringUtils;

import java.util.*;

@Service
@Validated
public class PermissionAppService implements IPermissionAppService {

    static final int case1=1;
	static final int case2=2;
	static final int case3=3;
    
    @Autowired
	private IPermissionManager _permissionManager;

	@Autowired
	private PermissionMapper mapper;

    @Transactional(propagation = Propagation.REQUIRED)
	public CreatePermissionOutput Create(CreatePermissionInput input) {

		PermissionEntity permission = mapper.CreatePermissionInputToPermissionEntity(input);
		PermissionEntity createdPermission = _permissionManager.Create(permission);
		
		return mapper.PermissionEntityToCreatePermissionOutput(createdPermission);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="Permission", key = "#p0")
	</#if>
	public UpdatePermissionOutput Update(Long permissionId, UpdatePermissionInput input) {
	
		PermissionEntity permission = mapper.UpdatePermissionInputToPermissionEntity(input);
		PermissionEntity updatedPermission = _permissionManager.Update(permission);

		return mapper.PermissionEntityToUpdatePermissionOutput(updatedPermission);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	<#if Cache !false>
	@CacheEvict(value="Permission", key = "#p0")
	</#if>
	public void Delete(Long permissionId) {

		PermissionEntity existing = _permissionManager.FindById(permissionId) ; 
		_permissionManager.Delete(existing);

	}
	
	@Transactional(propagation = Propagation.NOT_SUPPORTED)
	<#if Cache !false>
	@Cacheable(value = "Permission", key = "#p0")
	</#if>
	public FindPermissionByIdOutput FindById(Long permissionId) {

		PermissionEntity foundPermission = _permissionManager.FindById(permissionId);
		if (foundPermission == null)  
			return null ; 
 	   
 	   FindPermissionByIdOutput output=mapper.PermissionEntityToFindPermissionByIdOutput(foundPermission); 
		return output;
	}

    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
    @Cacheable(value = "Permission", key = "#p0")
    </#if>
	public FindPermissionByNameOutput FindByPermissionName(String permissionName) {

		PermissionEntity foundPermission = _permissionManager.FindByPermissionName(permissionName);
		if (foundPermission == null) {
			return null;
		}
		return mapper.PermissionEntityToFindPermissionByNameOutput(foundPermission);

	}
	
    @Transactional(propagation = Propagation.NOT_SUPPORTED)
    <#if Cache !false>
	@Cacheable(value = "Permission")
	</#if>
	public List<FindPermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception  {

		Page<PermissionEntity> foundPermission = _permissionManager.FindAll(Search(search), pageable);
		List<PermissionEntity> permissionList = foundPermission.getContent();
		Iterator<PermissionEntity> permissionIterator = permissionList.iterator(); 
		List<FindPermissionByIdOutput> output = new ArrayList<>();

		while (permissionIterator.hasNext()) {
			output.add(mapper.PermissionEntityToFindPermissionByIdOutput(permissionIterator.next()));
		}
		return output;
	}
	
	BooleanBuilder Search(SearchCriteria search) throws Exception {

		QPermissionEntity permission= QPermissionEntity.permissionEntity;
		if(search != null) {
			if(search.getType()==case1)
			{
				return searchAllProperties(permission, search.getValue(),search.getOperator());
			}
			else if(search.getType()==case2)
			{
				List<String> keysList = new ArrayList<String>();
				for(SearchFields f: search.getFields())
				{
					keysList.add(f.getFieldName());
				}
				checkProperties(keysList);
				return searchSpecificProperty(permission,keysList,search.getValue(),search.getOperator());
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
				return searchKeyValuePair(permission, map,search.getJoinColumns());
			}

		}
		return null;
	}
	
	BooleanBuilder searchAllProperties(QPermissionEntity permission,String value,String operator) {
		BooleanBuilder builder = new BooleanBuilder();

		if(operator.equals("contains")) {
			builder.or(permission.displayName.likeIgnoreCase("%"+ value + "%"));
			builder.or(permission.name.likeIgnoreCase("%"+ value + "%"));
		}
		else if(operator.equals("equals"))
		{
        	builder.or(permission.displayName.eq(value));
        	builder.or(permission.name.eq(value));
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
		
		 list.get(i).replace("%20","").trim().equals("displayName") ||
		 list.get(i).replace("%20","").trim().equals("id") ||
		 list.get(i).replace("%20","").trim().equals("name") ||
		 list.get(i).replace("%20","").trim().equals("rolepermission") ||
		 list.get(i).replace("%20","").trim().equals("[=AuthenticationTable?uncap_first]permission")
		)) 
		{
		 throw new Exception("Wrong URL Format: Property " + list.get(i) + " not found!" );
		}
		}
	}
	
	BooleanBuilder searchSpecificProperty(QPermissionEntity permission,List<String> list,String value,String operator)  {
		BooleanBuilder builder = new BooleanBuilder();
		
		for (int i = 0; i < list.size(); i++) {
		
            if(list.get(i).replace("%20","").trim().equals("displayName")) {
				if(operator.equals("contains"))
					builder.or(permission.displayName.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(permission.displayName.eq(value));
			}
            if(list.get(i).replace("%20","").trim().equals("name")) {
				if(operator.equals("contains"))
					builder.or(permission.name.likeIgnoreCase("%"+ value + "%"));
				else if(operator.equals("equals"))
					builder.or(permission.name.eq(value));
			}
		}
		return builder;
	}
	
	BooleanBuilder searchKeyValuePair(QPermissionEntity permission, Map<String,SearchFields> map,Map<String,String> joinColumns) {
		BooleanBuilder builder = new BooleanBuilder();

		for (Map.Entry<String, SearchFields> details : map.entrySet()) {
            if(details.getKey().replace("%20","").trim().equals("displayName")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(permission.displayName.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(permission.displayName.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(permission.displayName.ne(details.getValue().getSearchValue()));
			}
            if(details.getKey().replace("%20","").trim().equals("name")) {
				if(details.getValue().getOperator().equals("contains"))
					builder.and(permission.name.likeIgnoreCase("%"+ details.getValue().getSearchValue() + "%"));
				else if(details.getValue().getOperator().equals("equals"))
					builder.and(permission.name.eq(details.getValue().getSearchValue()));
				else if(details.getValue().getOperator().equals("notEqual"))
					builder.and(permission.name.ne(details.getValue().getSearchValue()));
			}
		}
		return builder;
	}
	
	public Map<String,String> parseRolepermissionJoinColumn(String keysString) {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("permissionId", keysString);
		return joinColumnMap;
		
	}
	
	
	public Map<String,String> parse[=AuthenticationTable]permissionJoinColumn(String keysString) {
		
		Map<String,String> joinColumnMap = new HashMap<String,String>();
		joinColumnMap.put("permissionId", keysString);
		return joinColumnMap;
		
	}
}
