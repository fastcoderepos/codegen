package [=PackageName].RestControllers;

import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

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
import [=PackageName].domain.model.[=AuthenticationTable]permissionId;
import [=CommonModulePackage].Search.SearchCriteria;
import [=CommonModulePackage].Search.SearchUtils;
import [=CommonModulePackage].application.OffsetBasedPageRequest;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import [=PackageName].application.Authorization.[=AuthenticationTable]permission.[=AuthenticationTable]permissionAppService;
import [=PackageName].application.Authorization.[=AuthenticationTable]permission.Dto.*;
import [=PackageName].application.Authorization.[=AuthenticationTable].[=AuthenticationTable]AppService;
import [=PackageName].application.Authorization.Permission.PermissionAppService;
import [=CommonModulePackage].logging.LoggingHelper;

@RestController
@RequestMapping("/[=AuthenticationTable?uncap_first]permission")
public class [=AuthenticationTable]permissionController {

	@Autowired
	private [=AuthenticationTable]permissionAppService _[=AuthenticationTable?uncap_first]permissionAppService;
    
    @Autowired
	private [=AuthenticationTable]AppService  _[=AuthenticationTable?uncap_first]AppService;
    
    @Autowired
	private PermissionAppService  _permissionAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
    
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<Create[=AuthenticationTable]permissionOutput> Create(@RequestBody @Valid Create[=AuthenticationTable]permissionInput [=AuthenticationTable?uncap_first]permission) {
		Create[=AuthenticationTable]permissionOutput output=_[=AuthenticationTable?uncap_first]permissionAppService.Create([=AuthenticationTable?uncap_first]permission);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
				String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

	// ------------ Delete [=AuthenticationTable?uncap_first]rpermission ------------
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
    }
	
	// ------------ Update [=AuthenticationTable?uncap_first]permission ------------
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
		
	return new ResponseEntity(_[=AuthenticationTable?uncap_first]permissionAppService.Update([=AuthenticationTable?uncap_first]permissionId,[=AuthenticationTable?uncap_first]permission), HttpStatus.OK);
	}

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
    
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
//		if (sort.isUnsorted()) { sort = new Sort(Sort.Direction.fromString(env.getProperty("fastCode.sort.direction.default")), new String[]{env.getProperty("fastCode.sort.property.default")}); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_[=AuthenticationTable?uncap_first]permissionAppService.Find(searchCriteria,Pageable));
	}

	@RequestMapping(value = "/{[=AuthenticationTable?uncap_first]permissionid}/[=AuthenticationTable?uncap_first]", method = RequestMethod.GET)
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
  
	@RequestMapping(value = "/{[=AuthenticationTable?uncap_first]permissionid}/permission", method = RequestMethod.GET)
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

