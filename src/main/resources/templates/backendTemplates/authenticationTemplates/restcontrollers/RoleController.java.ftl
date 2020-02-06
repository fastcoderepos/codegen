package [=PackageName].restcontrollers;

import [=PackageName].application.authorization.rolepermission.RolepermissionAppService;
import [=PackageName].application.authorization.rolepermission.dto.FindRolepermissionByIdOutput;
<#if (AuthenticationType == "database" || UserOnly)>
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.dto.Find[=AuthenticationTable]roleByIdOutput;
import [=PackageName].application.authorization.[=AuthenticationTable?lower_case]role.[=AuthenticationTable]roleAppService;
</#if>
import [=PackageName].application.authorization.role.RoleAppService;
import [=PackageName].application.authorization.role.dto.*;
import [=CommonModulePackage].search.SearchCriteria;
import [=CommonModulePackage].search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import [=CommonModulePackage].logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/role")
public class RoleController {

    <#if (AuthenticationType == "database" || UserOnly)>
    @Autowired
	private [=AuthenticationTable]roleAppService  _[=AuthenticationTable?uncap_first]roleAppService;
	</#if>
	@Autowired
	private RoleAppService _roleAppService;
    
    @Autowired
	private RolepermissionAppService  _rolepermissionAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
	
	public RoleController(RoleAppService appService,LoggingHelper helper,<#if (AuthenticationType == "database" || UserOnly)>[=AuthenticationTable]roleAppService [=AuthenticationTable?uncap_first]roleAppService,</#if>RolepermissionAppService rolepermissionAppService) {
		
		this._roleAppService= appService;
		this.logHelper = helper;
		<#if (AuthenticationType == "database" || UserOnly)>
		this._[=AuthenticationTable?uncap_first]roleAppService = [=AuthenticationTable?uncap_first]roleAppService;
		</#if>
		this._rolepermissionAppService = rolepermissionAppService;
	}

   <#if AuthenticationType == "database" || UserOnly>
    // CRUD Operations
    // ------------ Create a role ------------
    @PreAuthorize("hasAnyAuthority('ROLEENTITY_CREATE')")
    @RequestMapping(method = RequestMethod.POST)
    public ResponseEntity<CreateRoleOutput> Create(@RequestBody @Valid CreateRoleInput role) {

        FindRoleByNameOutput foundRole = _roleAppService.FindByRoleName(role.getName());

        if (foundRole != null) {
            logHelper.getLogger().error("There already exists a role with name=%s", role.getName());
            throw new EntityExistsException(
                    String.format("There already exists a role with name=%s", role.getName()));
        }

        CreateRoleOutput output=_roleAppService.Create(role);
		
		return new ResponseEntity(output, HttpStatus.OK);
    }

    // ------------ Delete role ------------
    @PreAuthorize("hasAnyAuthority('ROLEENTITY_DELETE')")
	@ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
    FindRoleByIdOutput output = _roleAppService.FindById(Long.valueOf(id));
	if (output == null) {
		logHelper.getLogger().error("There does not exist a role with a id=%s", id);
		throw new EntityNotFoundException(
			String.format("There does not exist a role with a id=%s", id));
	}
    _roleAppService.Delete(Long.valueOf(id));
    }
    
    // ------------ Update role ------------
    @PreAuthorize("hasAnyAuthority('ROLEENTITY_UPDATE')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateRoleOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateRoleInput role) {
    FindRoleByIdOutput currentRole = _roleAppService.FindById(Long.valueOf(id));
		
		if (currentRole == null) {
			logHelper.getLogger().error("Unable to update. Role with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
    return new ResponseEntity(_roleAppService.Update(Long.valueOf(id),role), HttpStatus.OK);
	}
	</#if>

    @PreAuthorize("hasAnyAuthority('ROLEENTITY_READ')")
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindRoleByIdOutput> FindById(@PathVariable String id) {
    FindRoleByIdOutput output = _roleAppService.FindById(Long.valueOf(id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

    @PreAuthorize("hasAnyAuthority('ROLEENTITY_READ')")
    @RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		List<FindRoleByIdOutput> roles = _roleAppService.Find(searchCriteria, Pageable);
 		return ResponseEntity.ok(roles);
	}
	
	<#if (AuthenticationType == "database" || UserOnly)>
	@PreAuthorize("hasAnyAuthority('ROLEENTITY_READ')")
	@RequestMapping(value = "/{roleid}/[=AuthenticationTable?uncap_first]role", method = RequestMethod.GET)
	public ResponseEntity Get[=AuthenticationTable]role(@PathVariable String roleid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_roleAppService.parse[=AuthenticationTable]roleJoinColumn(roleid);
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
	
	@PreAuthorize("hasAnyAuthority('ROLEENTITY_READ')")
    @RequestMapping(value = "/{roleid}/rolepermission", method = RequestMethod.GET)
	public ResponseEntity GetRolepermission(@PathVariable String roleid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
	
		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_roleAppService.parseRolepermissionJoinColumn(roleid);
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

}