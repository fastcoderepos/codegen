package [=PackageName].restcontrollers;

<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
import javax.persistence.EntityExistsException;
</#if>
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

<#if AuthenticationType != "none">
import org.springframework.security.access.prepost.PreAuthorize;
</#if>
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
<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
<#if AuthenticationType == "database">
import org.springframework.security.crypto.password.PasswordEncoder;
</#if>
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Find[=AuthenticationTable]roleByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Find[=AuthenticationTable]permissionByIdOutput;
</#if>
<#if CompositeKeyClasses?seq_contains(ClassName)>
import [=PackageName].domain.model.[=IdClass];
</#if>
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].[=ClassName]AppService;
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>.authorization</#if>.[=ClassName?lower_case].dto.*;
<#list Relationship as relationKey,relationValue>
<#if ClassName != relationValue.eName>
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && relationValue.eName == AuthenticationTable>.authorization</#if>.[=relationValue.eName?lower_case].[=relationValue.eName]AppService;
</#if>
<#if relationValue.relation == "OneToMany">
import [=PackageName].application<#if (AuthenticationType == "database" || UsersOnly == "true") && relationValue.eName == AuthenticationTable>.authorization</#if>.[=relationValue.eName?lower_case].dto.Find[=relationValue.eName]ByIdOutput;
</#if>
</#list>
<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].security.JWTAppService;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import java.util.ArrayList;
import java.util.Set;
import java.util.Iterator;
</#if>
import java.util.List;
import java.util.Map;
import [=CommonModulePackage].logging.LoggingHelper;

@RestController
@RequestMapping("/[=ApiPath]")
public class [=ClassName]Controller {

	@Autowired
	private [=ClassName]AppService _[=ClassName?uncap_first]AppService;
    <#list Relationship as relationKey,relationValue>
    <#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    
    @Autowired
	private [=relationValue.eName]AppService  _[=relationValue.eName?uncap_first]AppService;
    </#if>
    </#list>

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
	
	<#if AuthenticationType == "database" && ClassName == AuthenticationTable>
	@Autowired
    private PasswordEncoder pEncoder;
	</#if>
	
	<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
	@Autowired
    private [=AuthenticationTable]permissionAppService _[=AuthenticationTable?uncap_first]permissionAppService;
    
    @Autowired
    private [=AuthenticationTable]roleAppService _[=AuthenticationTable?uncap_first]roleAppService;
    
    @Autowired
 	private JWTAppService _jwtAppService;
    </#if>  
    
    public [=ClassName]Controller([=ClassName]AppService [=ClassName?uncap_first]AppService,<#list Relationship as relationKey,relationValue><#if ClassName != relationValue.eName && relationValue.eName !="OneToMany"> [=relationValue.eName]AppService [=relationValue.eName?uncap_first]AppService,</#if></#list>
	<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable><#if AuthenticationType == "database">PasswordEncoder pEncoder,</#if> [=AuthenticationTable]permissionAppService [=AuthenticationTable?uncap_first]permissionAppService, [=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService,JWTAppService jwtAppService,</#if> LoggingHelper helper) {
		super();
		this._[=ClassName?uncap_first]AppService = [=ClassName?uncap_first]AppService;
		<#list Relationship as relationKey,relationValue>
    	<#if ClassName != relationValue.eName && relationValue.eName !="OneToMany">
    	this._[=relationValue.eName?uncap_first]AppService = [=relationValue.eName?uncap_first]AppService;
    	</#if>
    	</#list>
		<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
		<#if AuthenticationType == "database">
	    this.pEncoder = pEncoder;
	    </#if>
	    this._jwtAppService = jwtAppService;
 		this._[=AuthenticationTable?uncap_first]permissionAppService = [=AuthenticationTable?uncap_first]permissionAppService;
    	this._[=AuthenticationTable?uncap_first]roleAppService = [=AuthenticationTable?uncap_first]roleAppService;
    	</#if>
		this.logHelper = helper;
	}

    <#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_CREATE')")
    </#if>
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=ClassName]Output> Create(@RequestBody @Valid Create[=ClassName]Input [=ClassName?uncap_first]) {
		<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
		Find[=ClassName]By[=authValue.fieldName?cap_first]Output found[=ClassName] = _[=ClassName?uncap_first]AppService.FindBy[=authValue.fieldName?cap_first]([=ClassName?uncap_first].get[=authValue.fieldName?cap_first]());

	        if (found[=ClassName] != null) {
	            logHelper.getLogger().error("There already exists a [=ClassName?uncap_first] with a [=authValue.fieldName?cap_first]=%s", [=ClassName?uncap_first].get[=authValue.fieldName?cap_first]());
	            throw new EntityExistsException(
	                    String.format("There already exists a [=ClassName?uncap_first] with [=authValue.fieldName?cap_first] =%s", [=ClassName?uncap_first].get[=authValue.fieldName?cap_first]()));
	        }
	    </#if> 
        <#if AuthenticationType == "database" && authKey == "Password">
	    [=ClassName?uncap_first].set[=authValue.fieldName?cap_first](pEncoder.encode([=ClassName?uncap_first].get[=authValue.fieldName?cap_first]()));
	    </#if>
	    </#list>
        </#if>
		</#if>
		Create[=ClassName]Output output=_[=ClassName?uncap_first]AppService.Create([=ClassName?uncap_first]);
		<#list Relationship as relationKey,relationValue>
		<#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
		<#if relationValue.isParent==false>
        <#assign i=relationValue.joinDetails?size>
        <#if i==1>
	  	<#list relationValue.joinDetails as joinDetails>
        <#if joinDetails.joinEntityName == relationValue.eName>
        <#if joinDetails.joinColumn??>
		<#if joinDetails.isJoinColumnOptional==false>
		if(output==null) {
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
	    
		</#if>
        </#if>
        </#if>
        </#list>
        <#else>
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
	    
		</#if>
		</#if>
        </#if>
		</#list>
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete [=ClassName?uncap_first] ------------
	<#if AuthenticationType != "none">
	@PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_DELETE')")
	</#if>
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
	<#if CompositeKeyClasses?seq_contains(ClassName)>
	[=IdClass] [=IdClass?lower_case] =_[=ClassName?uncap_first]AppService.parse[=ClassName]Key(id);
	if([=IdClass?lower_case] == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById([=IdClass?lower_case]);
	<#else>
    <#list Fields as key,value>
    <#if value.isPrimaryKey!false>
    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById([=value.fieldType?cap_first].valueOf(id));
    <#elseif value.fieldType?lower_case == "string">
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(id);
    </#if>
    </#if>  
    </#list>
    </#if>
	if (output == null) {
		logHelper.getLogger().error("There does not exist a [=ClassName?uncap_first] with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a [=ClassName?uncap_first] with a id=%s", id));
	}
    <#if CompositeKeyClasses?seq_contains(ClassName)>
	 _[=ClassName?uncap_first]AppService.Delete([=IdClass?lower_case]);
    <#else>
    <#list Fields as key,value>
    <#if value.isPrimaryKey!false>
    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
    _[=ClassName?uncap_first]AppService.Delete([=value.fieldType?cap_first].valueOf(id));
    <#elseif value.fieldType?lower_case == "string">
  	 _[=ClassName?uncap_first]AppService.Delete(id);
    </#if>
    </#if>  
    </#list>
    </#if>
    }
	
	// ------------ Update [=ClassName?uncap_first] ------------
	<#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_UPDATE')")
    </#if>
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<Update[=ClassName]Output> Update(@PathVariable String id, @RequestBody @Valid Update[=ClassName]Input [=ClassName?uncap_first]) {
	    <#if CompositeKeyClasses?seq_contains(ClassName)>
		[=IdClass] [=IdClass?lower_case] =_[=ClassName?uncap_first]AppService.parse[=ClassName]Key(id);
		if([=IdClass?lower_case] == null)
		{
			logHelper.getLogger().error("Invalid id=%s", id);
			throw new EntityNotFoundException(
					String.format("Invalid id=%s", id));
		}
		<#if AuthenticationType == "database" && ClassName == AuthenticationTable>
		Find[=ClassName]WithAllFieldsByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindWithAllFieldsById([=IdClass?lower_case]);
		<#else>
		Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById([=IdClass?lower_case]);
		</#if>
		<#else>
	    <#list Fields as key,value>
	    <#if value.isPrimaryKey!false>
	    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
	    <#if AuthenticationType == "database" && ClassName == AuthenticationTable>
	    Find[=ClassName]WithAllFieldsByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindWithAllFieldsById([=value.fieldType?cap_first].valueOf(id));
		<#else>
	    Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById([=value.fieldType?cap_first].valueOf(id));
		</#if>
	    <#elseif value.fieldType?lower_case == "string">
	    <#if AuthenticationType == "database" && ClassName == AuthenticationTable>
	    Find[=ClassName]WithAllFieldsByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindWithAllFieldsById(id);
		<#else>
	    Find[=ClassName]ByIdOutput current[=ClassName] = _[=ClassName?uncap_first]AppService.FindById(id);
		</#if>
	    </#if>
	    </#if>  
	    </#list>
	    </#if>
			
		if (current[=ClassName] == null) {
			logHelper.getLogger().error("Unable to update. [=ClassName] with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
		<#if AuthenticationFields??>
		<#list AuthenticationFields as authKey,authValue>
        <#if AuthenticationType == "database" && authKey== "Password">
	    [=ClassName?uncap_first].set[=authValue.fieldName?cap_first](pEncoder.encode(current[=ClassName].get[=authValue.fieldName?cap_first]()));
	    </#if>
	    <#if authKey== "UserName">
 		_jwtAppService.deleteAllUserTokens(current[=ClassName].get[=authValue.fieldName?cap_first]());
	    </#if>
	    </#list>
        </#if>
		</#if>
		<#if CompositeKeyClasses?seq_contains(ClassName)>
		return new ResponseEntity(_[=ClassName?uncap_first]AppService.Update([=IdClass?lower_case],[=ClassName?uncap_first]), HttpStatus.OK);
	    <#else>
	    <#list Fields as key,value>
	    <#if value.isPrimaryKey!false>
	    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
	    return new ResponseEntity(_[=ClassName?uncap_first]AppService.Update([=value.fieldType?cap_first].valueOf(id),[=ClassName?uncap_first]), HttpStatus.OK);
	    <#elseif value.fieldType?lower_case == "string">
	  	return new ResponseEntity(_[=ClassName?uncap_first]AppService.Update(id,[=ClassName?uncap_first]), HttpStatus.OK);
	    </#if>
	    </#if>  
	    </#list>
	    </#if>
	}

    <#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<Find[=ClassName]ByIdOutput> FindById(@PathVariable String id) {
    <#if CompositeKeyClasses?seq_contains(ClassName)>
	[=IdClass] [=IdClass?lower_case] =_[=ClassName?uncap_first]AppService.parse[=ClassName]Key(id);
	if([=IdClass?lower_case] == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById([=IdClass?lower_case]);
	<#else>
    <#list Fields as key,value>
    <#if value.isPrimaryKey!false>
    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
    Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById([=value.fieldType?cap_first].valueOf(id));
    <#elseif value.fieldType?lower_case == "string">
  	Find[=ClassName]ByIdOutput output = _[=ClassName?uncap_first]AppService.FindById(id);
    </#if>
    </#if>  
    </#list>
    </#if>
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
    <#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_[=ClassName?uncap_first]AppService.Find(searchCriteria,Pageable));
	}
    <#list Relationship as relationKey, relationValue>
    <#if relationValue.relation == "ManyToOne" || relationValue.relation == "OneToOne">
    <#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity<Get[=relationValue.eName]Output> Get[=relationValue.eName](@PathVariable String id) {
	<#if CompositeKeyClasses?seq_contains(ClassName)>
	[=IdClass] [=IdClass?lower_case] =_[=ClassName?uncap_first]AppService.parse[=ClassName]Key(id);
	if([=IdClass?lower_case] == null)
	{
		logHelper.getLogger().error("Invalid id=%s", id);
		throw new EntityNotFoundException(
				String.format("Invalid id=%s", id));
	}
	Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName]([=IdClass?lower_case]);
	<#else>
	<#list Fields as key,value>
    <#if value.isPrimaryKey!false>
    <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
    Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName]([=value.fieldType?cap_first].valueOf(id));
    <#elseif value.fieldType?lower_case == "string">
    Get[=relationValue.eName]Output output= _[=ClassName?uncap_first]AppService.Get[=relationValue.eName](id);
    </#if>
    </#if>  
    </#list>
    </#if>
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity(output, HttpStatus.OK);
	}
    <#elseif relationValue.relation == "OneToMany">
    
    <#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
	@RequestMapping(value = "/{id}/[=relationValue.eName?uncap_first]", method = RequestMethod.GET)
	public ResponseEntity Get[=relationValue.eName](@PathVariable String id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_[=ClassName?uncap_first]AppService.parse[=relationValue.eName]JoinColumn(id);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<Find[=relationValue.eName]ByIdOutput> output = _[=relationValue.eName?uncap_first]AppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
 
    </#if>
    </#list>
	<#if (AuthenticationType == "database" || UsersOnly == "true") && ClassName == AuthenticationTable>
	<#if AuthenticationType != "none">
    @PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
    </#if>
   	@RequestMapping(value = "/{id}/[=AuthenticationTable?uncap_first]permission", method = RequestMethod.GET)
	public ResponseEntity Get[=AuthenticationTable]permission(@PathVariable String id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_[=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]permissionJoinColumn(id);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<Find[=AuthenticationTable]permissionByIdOutput> output = _[=AuthenticationTable?uncap_first]permissionAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}  
	
	@PreAuthorize("hasAnyAuthority('[=ClassName?upper_case]ENTITY_READ')")
	@RequestMapping(value = "/{id}/[=AuthenticationTable?uncap_first]role", method = RequestMethod.GET)
	public ResponseEntity Get[=AuthenticationTable]role(@PathVariable String id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_[=AuthenticationTable?uncap_first]AppService.parse[=AuthenticationTable]roleJoinColumn(id);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<Find[=AuthenticationTable]roleByIdOutput> output = _[=AuthenticationTable?uncap_first]roleAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
	</#if>


}

