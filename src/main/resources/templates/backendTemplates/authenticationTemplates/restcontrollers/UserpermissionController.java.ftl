package [=PackageName].restcontrollers;

import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
<#if CompositeKeyClasses?? && CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=AuthenticationTable]Id;
</#if>
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
<#if AuthenticationType != "oidc">
import [=PackageName].security.JWTAppService;
</#if>
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]AppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.*;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].dto.*;
import [=CommonModulePackage].logging.LoggingHelper;

@RestController
@RequestMapping("/[=AuthenticationTable?uncap_first]permission")
public class [=AuthenticationTable]permissionController {

	@Autowired
	private [=AuthenticationTable]permissionAppService _[=AuthenticationTable?uncap_first]permissionAppService;
	
	@Autowired
	private [=AuthenticationTable]AppService _[=AuthenticationTable?uncap_first]AppService;

	@Autowired
	private LoggingHelper logHelper;
	
	<#if AuthenticationType != "oidc">
	@Autowired
 	private JWTAppService _jwtAppService;
    
    </#if>
	@Autowired
	private Environment env;
	
	public [=AuthenticationTable]permissionController([=AuthenticationTable]permissionAppService [=AuthenticationTable?uncap_first]permissionAppService, [=AuthenticationTable]AppService [=AuthenticationTable?uncap_first]AppService,
			<#if AuthenticationType != "oidc">JWTAppService jwtAppService,</#if> LoggingHelper helper) {
	
		this._[=AuthenticationTable?uncap_first]permissionAppService = [=AuthenticationTable?uncap_first]permissionAppService;
		this._[=AuthenticationTable?uncap_first]AppService = [=AuthenticationTable?uncap_first]AppService;
		<#if AuthenticationType != "oidc">
		this._jwtAppService = jwtAppService;
		</#if>
		this.logHelper = helper;
	}
    
    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_CREATE')")
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=AuthenticationTable]permissionOutput> Create(@RequestBody @Valid Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission) {
		Create[=AuthenticationTable]permissionOutput output=_[=AuthenticationTable?uncap_first]permissionAppService.Create([=AuthenticationTable?uncap_first]permission);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
	    <#if AuthenticationType != "oidc">
	    
		Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>output.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>output.get[=AuthenticationTable][=key?cap_first](),<#else>output.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	   _jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
		
		</#if>
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete [=AuthenticationTable?uncap_first]rpermission ------------
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_DELETE')")
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId =_[=AuthenticationTable?uncap_first]permissionAppService.parse[=AuthenticationTable]permissionKey(id);
	if([=AuthenticationTable?uncap_first]permissionId == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=AuthenticationTable]permissionByIdOutput output = _[=AuthenticationTable?uncap_first]permissionAppService.FindById([=AuthenticationTable?uncap_first]permissionId);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]permission with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a [=AuthenticationTable?uncap_first]permission with a id=%s", id));
	}
	 _[=AuthenticationTable?uncap_first]permissionAppService.Delete([=AuthenticationTable?uncap_first]permissionId);
	 
	 <#if AuthenticationType != "oidc">
	 Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>output.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>output.get[=AuthenticationTable][=key?cap_first](),<#else>output.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	 _jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
     </#if>		
    }
	
	// ------------ Update [=AuthenticationTable?uncap_first]permission ------------
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_UPDATE')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=AuthenticationTable]permissionOutput> Update(@PathVariable String id, @RequestBody @Valid Update[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission) {
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId =_[=AuthenticationTable?uncap_first]permissionAppService.parse[=AuthenticationTable]permissionKey(id);
	if([=AuthenticationTable?uncap_first]permissionId == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=AuthenticationTable]permissionByIdOutput current[=AuthenticationTable]permission = _[=AuthenticationTable?uncap_first]permissionAppService.FindById([=AuthenticationTable?uncap_first]permissionId);
		
    if (current[=AuthenticationTable]permission == null) {
	   logHelper.getLogger().error("Unable to update. [=AuthenticationTable]permission with id {} not found.", id);
	   return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	}
	<#if AuthenticationType != "oidc">	
		
    Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>current[=AuthenticationTable]permission.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>current[=AuthenticationTable]permission.get[=AuthenticationTable][=key?cap_first](),<#else>current[=AuthenticationTable]permission.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	_jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
    </#if>	
    	
	return new ResponseEntity(_[=AuthenticationTable?uncap_first]permissionAppService.Update([=AuthenticationTable?uncap_first]permissionId,[=AuthenticationTable?uncap_first]permission), HttpStatus.OK);
	}

    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=AuthenticationTable]permissionByIdOutput> FindById(@PathVariable String id) {
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId =_[=AuthenticationTable?uncap_first]permissionAppService.parse[=AuthenticationTable]permissionKey(id);
	if([=AuthenticationTable?uncap_first]permissionId == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=AuthenticationTable]permissionByIdOutput output = _[=AuthenticationTable?uncap_first]permissionAppService.FindById([=AuthenticationTable?uncap_first]permissionId);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_READ')")
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_[=AuthenticationTable?uncap_first]permissionAppService.Find(searchCriteria,Pageable));
	}

    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{id}/[=AuthenticationTable?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity<Get[=AuthenticationTable]Output> Get[=AuthenticationTable](@PathVariable String id) {
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId =_[=AuthenticationTable?uncap_first]permissionAppService.parse[=AuthenticationTable]permissionKey(id);
	if([=AuthenticationTable?uncap_first]permissionId == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Get[=AuthenticationTable]Output output= _[=AuthenticationTable?uncap_first]permissionAppService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]permissionId);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
  
    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{id}/permission", method = RequestMethod.GET)
	public ResponseEntity<GetPermissionOutput> GetPermission(@PathVariable String id) {
	[=AuthenticationTable]permissionId [=AuthenticationTable?uncap_first]permissionId =_[=AuthenticationTable?uncap_first]permissionAppService.parse[=AuthenticationTable]permissionKey(id);
	if([=AuthenticationTable?uncap_first]permissionId == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	GetPermissionOutput output= _[=AuthenticationTable?uncap_first]permissionAppService.GetPermission([=AuthenticationTable?uncap_first]permissionId);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
  

}

