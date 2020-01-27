package [=PackageName].restcontrollers;

import [=PackageName].application.authorization.permission.PermissionAppService;
import [=PackageName].application.authorization.rolepermission.RolepermissionAppService;
<#if (AuthenticationType == "database" || UsersOnly == "true")>
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]permission.dto.Find[=AuthenticationTable]permissionByIdOutput;
</#if>
import [=PackageName].application.authorization.permission.dto.*;
import [=PackageName].application.authorization.rolepermission.dto.FindRolepermissionByIdOutput;
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].logging.LoggingHelper;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.access.prepost.PreAuthorize;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/permission")
public class PermissionController {

	@Autowired
	private PermissionAppService _permissionAppService;
    
    @Autowired
	private RolepermissionAppService  _rolepermissionAppService;
	<#if (AuthenticationType == "database" || UsersOnly == "true")>
    @Autowired
	private [=AuthenticationTable]permissionAppService  _[=AuthenticationTable?uncap_first]permissionAppService;
    </#if>
	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
	
	public PermissionController(PermissionAppService appService,LoggingHelper helper,<#if (AuthenticationType == "database" || UsersOnly == "true")>[=AuthenticationTable]permissionAppService [=AuthenticationTable?uncap_first]permissionAppService,</#if>RolepermissionAppService rolepermissionAppService) {
		
		this._permissionAppService= appService;
		this.logHelper = helper;
		<#if (AuthenticationType == "database" || UsersOnly == "true")>
		this._[=AuthenticationTable?uncap_first]permissionAppService = [=AuthenticationTable?uncap_first]permissionAppService;
		</#if>
		this._rolepermissionAppService = rolepermissionAppService;
	}

	// CRUD Operations

	// ------------ Create a permission ------------
	@PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_CREATE')")
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreatePermissionOutput> Create(@RequestBody @Valid CreatePermissionInput permission) {

		FindPermissionByNameOutput existing = _permissionAppService.FindByPermissionName(permission.getName());
        
        if (existing != null) {
            logHelper.getLogger().error("There already exists a permission with name=%s", permission.getName());
            throw new EntityExistsException(
                    String.format("There already exists a permission with name=%s", permission.getName()));
        }
        
		CreatePermissionOutput output=_permissionAppService.Create(permission);
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete permission ------------
	@PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_DELETE')")
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
    FindPermissionByIdOutput output = _permissionAppService.FindById(Long.valueOf(id));
	
	if (output == null) {
		logHelper.getLogger().error("There does not exist a permission with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a permission with a id=%s", id));
	}
    _permissionAppService.Delete(Long.valueOf(id));
    }
	
	// ------------ Update permission ------------
	@PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_UPDATE')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdatePermissionOutput> Update(@PathVariable String id, @RequestBody @Valid UpdatePermissionInput permission) {
    FindPermissionByIdOutput currentPermission = _permissionAppService.FindById(Long.valueOf(id));
		
		if (currentPermission == null) {
			logHelper.getLogger().error("Unable to update. Permission with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
    return new ResponseEntity(_permissionAppService.Update(Long.valueOf(id),permission), HttpStatus.OK);
	}

    @PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindPermissionByIdOutput> FindById(@PathVariable String id) {
    FindPermissionByIdOutput output = _permissionAppService.FindById(Long.valueOf(id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}
    
    @PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_READ')")
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_permissionAppService.Find(searchCriteria,Pageable));
	}
    
    @PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{permissionid}/rolepermission", method = RequestMethod.GET)
	public ResponseEntity GetRolepermission(@PathVariable String permissionid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_permissionAppService.parseRolepermissionJoinColumn(permissionid);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindRolepermissionByIdOutput> output = _rolepermissionAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	<#if (AuthenticationType == "database" || UsersOnly == "true")>
	@PreAuthorize("hasAnyAuthority('PERMISSIONENTITY_READ')")
	@RequestMapping(value = "/{permissionid}/[=AuthenticationTable?uncap_first]permission", method = RequestMethod.GET)
	public ResponseEntity Get[=AuthenticationTable]permission(@PathVariable String permissionid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_permissionAppService.parse[=AuthenticationTable]permissionJoinColumn(permissionid);
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
	</#if>
}
