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
import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import [=PackageName].security.JWTAppService;
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.*;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.GetRoleOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].[=AuthenticationTable]AppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].dto.*;
import [=PackageName].commonmodule.logging.LoggingHelper;

@RestController
@RequestMapping("/[=AuthenticationTable?uncap_first]role")
public class [=AuthenticationTable]roleController {

	@Autowired
	private [=AuthenticationTable]roleAppService _[=AuthenticationTable?uncap_first]roleAppService;
    
    @Autowired
	private [=AuthenticationTable]AppService  _[=AuthenticationTable?uncap_first]AppService;

	@Autowired
	private LoggingHelper logHelper;
	
	@Autowired
 	private JWTAppService _jwtAppService;

	@Autowired
	private Environment env;
	
	 public [=AuthenticationTable]roleController([=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService, [=AuthenticationTable]AppService [=AuthenticationTable?uncap_first]AppService,
			JWTAppService jwtAppService, LoggingHelper helper) {
		super();
		this._[=AuthenticationTable?uncap_first]roleAppService = [=AuthenticationTable?uncap_first]roleAppService;
		this._[=AuthenticationTable?uncap_first]AppService = [=AuthenticationTable?uncap_first]AppService;
		this._jwtAppService = jwtAppService;
		this.logHelper = helper;
	}

    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_CREATE')")
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=AuthenticationTable]roleOutput> Create(@RequestBody @Valid Create[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role) {
	Create[=AuthenticationTable]roleOutput output=_[=AuthenticationTable?uncap_first]roleAppService.Create([=AuthenticationTable?uncap_first]role);
		
	if(output==null)
	{
		logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	}
	   
	Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>output.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>output.get[=AuthenticationTable][=key?cap_first](),<#else>output.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	_jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
		
	return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete [=AuthenticationTable?uncap_first]role ------------
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_DELETE')")
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleid =_[=AuthenticationTable?uncap_first]roleAppService.parse[=AuthenticationTable]roleKey(id);
	if([=AuthenticationTable?uncap_first]roleid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=AuthenticationTable]roleByIdOutput output = _[=AuthenticationTable?uncap_first]roleAppService.FindById([=AuthenticationTable?uncap_first]roleid);
	if (output == null) {
		logHelper.getLogger().error("There does not exist a [=AuthenticationTable?uncap_first]role with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a [=AuthenticationTable?uncap_first]role with a id=%s", id));
	}
	 _[=AuthenticationTable?uncap_first]roleAppService.Delete([=AuthenticationTable?uncap_first]roleid);
	 
	  Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>output.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>output.get[=AuthenticationTable][=key?cap_first](),<#else>output.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	 _jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
		
    }
	
	// ------------ Update [=AuthenticationTable?uncap_first]role ------------
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_UPDATE')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=AuthenticationTable]roleOutput> Update(@PathVariable String id, @RequestBody @Valid Update[=AuthenticationTable]roleInput [=AuthenticationTable?uncap_first]role) {
	[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleid =_[=AuthenticationTable?uncap_first]roleAppService.parse[=AuthenticationTable]roleKey(id);
	if([=AuthenticationTable?uncap_first]roleid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
			String.format("Invalid id=%s", id));
	}
	Find[=AuthenticationTable]roleByIdOutput current[=AuthenticationTable]role = _[=AuthenticationTable?uncap_first]roleAppService.FindById([=AuthenticationTable?uncap_first]roleid);
			
	if (current[=AuthenticationTable]role == null) {
		logHelper.getLogger().error("Unable to update. [=AuthenticationTable]role with id {} not found.", id);
		return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	}
	
	Find[=AuthenticationTable]ByIdOutput found[=AuthenticationTable] =_[=AuthenticationTable?uncap_first]AppService.FindById(<#if (AuthenticationType!="none" && !UserInput??)>current[=AuthenticationTable]role.get[=AuthenticationTable]Id()<#elseif AuthenticationType!="none" && UserInput??><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>new [=AuthenticationTable]Id(</#if></#if><#list PrimaryKeys as key,value><#if key_has_next>current[=AuthenticationTable]role.get[=AuthenticationTable][=key?cap_first](),<#else>current[=AuthenticationTable]role.get[=AuthenticationTable][=key?cap_first]()</#if></#list></#if><#if CompositeKeyClasses??><#if CompositeKeyClasses?seq_contains(ClassName)>)</#if></#if>);
	_jwtAppService.deleteAllUserTokens(found[=AuthenticationTable].get<#if AuthenticationType!= "none"><#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>UserName</#if></#if>());  
		
	return new ResponseEntity(_[=AuthenticationTable?uncap_first]roleAppService.Update([=AuthenticationTable?uncap_first]roleid,[=AuthenticationTable?uncap_first]role), HttpStatus.OK);
	}

    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_READ')")
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=AuthenticationTable]roleByIdOutput> FindById(@PathVariable String id) {
	[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleid =_[=AuthenticationTable?uncap_first]roleAppService.parse[=AuthenticationTable]roleKey(id);
	if([=AuthenticationTable?uncap_first]roleid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	
	Find[=AuthenticationTable]roleByIdOutput output = _[=AuthenticationTable?uncap_first]roleAppService.FindById([=AuthenticationTable?uncap_first]roleid);
	if (output == null) {
		return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	}
		
	return new ResponseEntity(output, HttpStatus.OK);
	}
    
    @PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_READ')")
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
	if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
	if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

	Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
	SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
	return ResponseEntity.ok(_[=AuthenticationTable?uncap_first]roleAppService.Find(searchCriteria,Pageable));
	}
	
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_READ')")
	@RequestMapping(value = "/{id}/[=AuthenticationTable?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity<Get[=AuthenticationTable]Output> Get[=AuthenticationTable](@PathVariable String id) {
	[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleid =_[=AuthenticationTable?uncap_first]roleAppService.parse[=AuthenticationTable]roleKey(id);
	if([=AuthenticationTable?uncap_first]roleid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Get[=AuthenticationTable]Output output= _[=AuthenticationTable?uncap_first]roleAppService.Get[=AuthenticationTable]([=AuthenticationTable?uncap_first]roleid);
	if (output == null) {
		return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	}
		return new ResponseEntity(output, HttpStatus.OK);
	}
	
	@PreAuthorize("hasAnyAuthority('[=AuthenticationTable?upper_case]ROLEENTITY_READ')")
	@RequestMapping(value = "/{id}/role", method = RequestMethod.GET)
	public ResponseEntity<GetRoleOutput> GetRole(@PathVariable String id) {
	[=AuthenticationTable]roleId [=AuthenticationTable?uncap_first]roleid =_[=AuthenticationTable?uncap_first]roleAppService.parse[=AuthenticationTable]roleKey(id);
	if([=AuthenticationTable?uncap_first]roleid == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	
	GetRoleOutput output= _[=AuthenticationTable?uncap_first]roleAppService.GetRole([=AuthenticationTable?uncap_first]roleid);
	if (output == null) {
		return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
	}
		return new ResponseEntity(output, HttpStatus.OK);
	}

}

