package [=PackageName].restcontrollers;

import [=PackageName].application.authorization.userpermission.UserpermissionAppService;
import [=PackageName].application.authorization.userrole.UserroleAppService;
import [=PackageName].application.authorization.userrole.dto.FindUserroleByIdOutput;
import [=PackageName].application.authorization.userpermission.dto.FindUserpermissionByIdOutput;
import [=PackageName].application.authorization.user.UserAppService;
import [=PackageName].application.authorization.user.dto.*;
import [=PackageName].security.JWTAppService;
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
import org.springframework.security.access.prepost.PreAuthorize;
<#if AuthenticationType == "database">
import org.springframework.security.crypto.password.PasswordEncoder;
</#if>
import org.springframework.web.bind.annotation.*;
<#if AuthenticationType == "oidc">
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import [=PackageName].security.SecurityConstants;
import [=PackageName].security.SecurityUtils;

import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
<#if UserOnly>
import [=PackageName].domain.authorization.user.IUserManager;
import [=PackageName].domain.model.UserEntity;
<#else>
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.IRoleManager;
import java.util.ArrayList;
import java.util.stream.Collectors;
</#if>
</#if>
import java.util.List;
import java.util.Map;

import javax.persistence.EntityExistsException;
import javax.persistence.EntityNotFoundException;
import javax.validation.Valid;

@RestController
@RequestMapping("/user")
public class UserController {

	@Autowired
	private UserAppService _userAppService;
    
    @Autowired
	private UserpermissionAppService  _userpermissionAppService;
	
	@Autowired
	private UserroleAppService  _userroleAppService;
	
	<#if AuthenticationType == "database">
	@Autowired
    private PasswordEncoder pEncoder;
    </#if>
    
    @Autowired
 	private JWTAppService _jwtAppService;

	@Autowired
	private LoggingHelper logHelper;

	@Autowired
	private Environment env;
	<#if AuthenticationType == "oidc">
    <#if UserOnly>
    @Autowired
	IUserManager _userMgr;
    <#else>
	@Autowired
	IRoleManager _roleManager;
    </#if>
	@Autowired
	SecurityUtils utils;

	@Autowired 
	HttpServletRequest request;

	@RequestMapping(value = "/myPermissions", method = RequestMethod.GET)
	public ResponseEntity GetMeInfo() throws Exception{

		String token = request.getHeader(SecurityConstants.HEADER_STRING);
		String userName = "";
		
		SignedJWT accessToken = null;
		JWTClaimsSet claimSet = null;
		
		accessToken = SignedJWT.parse(token.replace(SecurityConstants.TOKEN_PREFIX, ""));
		claimSet = accessToken.getJWTClaimsSet();
		userName = claimSet.getSubject();
		
		<#if UserOnly>
		// Add all the roles and permissions in a list and then convert the list into all permissions, removing duplicates
		List<String> permissions=null;
		UserEntity user = _userMgr.FindByUserName(userName);  
		if(user !=null )
		{
			permissions = utils.getAllPermissionsFromUserAndRole(user);
		}
		else
			throw new EntityNotFoundException(
					String.format("There does not exist a user with a name=%s", userName));
		return new ResponseEntity(permissions, HttpStatus.OK);
		<#elseif !UserOnly>
		List<String> groups = new ArrayList<String>();
		groups = (ArrayList<String>) claimSet.getClaims().get("groups");
		List<String> permissionsList = new ArrayList<String>();
		for( String item : groups)
		{

			RoleEntity role = _roleManager.FindByRoleName(item);
			if(role != null) {
				List<String> permissions= utils.getAllPermissionsFromRole(role);

				permissionsList.addAll(permissions);
			}
		else
			throw new EntityNotFoundException(
					String.format("There does not exist a role with a name=%s", item));

		}
		permissionsList= permissionsList.stream().distinct().collect(Collectors.toList());

		return new ResponseEntity(permissionsList, HttpStatus.OK);
        </#if>
	}

    </#if>
	
	public UserController(UserAppService userAppService, UserpermissionAppService userpermissionAppService,
			UserroleAppService userroleAppService,<#if AuthenticationType == "database">PasswordEncoder pEncoder,</#if>JWTAppService jwtAppService, LoggingHelper logHelper) {
		super();
		this._userAppService = userAppService;
		this._userpermissionAppService = userpermissionAppService;
		this._userroleAppService = userroleAppService;
		this._jwtAppService = jwtAppService;
		<#if AuthenticationType == "database">
		this.pEncoder = pEncoder;
		</#if>
		this.logHelper = logHelper;
	}

 <#if AuthenticationType == "database">
	// CRUD Operations
	// ------------ Create a user ------------
	@PreAuthorize("hasAnyAuthority('USERENTITY_CREATE')")
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<CreateUserOutput> Create(@RequestBody @Valid CreateUserInput user) {
		 FindUserByNameOutput foundUser = _userAppService.FindByUserName(user.getUserName());

	     if (foundUser != null) {
	     	logHelper.getLogger().error("There already exists a user with a name=%s", user.getUserName());
	        throw new EntityExistsException(
	        	String.format("There already exists a user with a name=%s", user.getUserName()));
	    }
	    <#if AuthenticationType == "database">
	    user.setPassword(pEncoder.encode(user.getPassword()));
	    </#if>
	    CreateUserOutput output=_userAppService.Create(user);
		if(output==null)
		{
			logHelper.getLogger().error("No record found");
		throw new EntityNotFoundException(
			String.format("No record found"));
	    }
		
		return new ResponseEntity(output, HttpStatus.OK);
	}


	// ------------ Delete a user ------------
	@PreAuthorize("hasAnyAuthority('USERENTITY_DELETE')")
    @ResponseStatus(value = HttpStatus.NO_CONTENT)
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE)
	public void Delete(@PathVariable String id) {
    	FindUserByIdOutput existing = _userAppService.FindById(Long.valueOf(id));

        if (existing == null) {
        	logHelper.getLogger().error("There does not exist a user with a id=%s", id);
        	throw new EntityNotFoundException(
	        	String.format("There does not exist a user with a id=%s", id));
	     
        }
    	
		_userAppService.Delete(Long.valueOf(id));
	}
	
	// ------------ Update user ------------
	@PreAuthorize("hasAnyAuthority('USERENTITY_UPDATE')")
	@RequestMapping(value = "/{id}", method = RequestMethod.PUT)
	public ResponseEntity<UpdateUserOutput> Update(@PathVariable String id, @RequestBody @Valid UpdateUserInput user) {
    	FindUserWithAllFieldsByIdOutput currentUser = _userAppService.FindWithAllFieldsById(Long.valueOf(id));
		
		if (currentUser == null) {
			logHelper.getLogger().error("Unable to update. User with id {} not found.", id);
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		<#if AuthenticationType == "database">
		user.setPassword(currentUser.getPassword());
		</#if>
		if(currentUser.getIsActive() && !user.getIsActive()) { 
 
            _jwtAppService.deleteAllUserTokens(currentUser.getUserName()); 
        } 
    return new ResponseEntity(_userAppService.Update(Long.valueOf(id),user), HttpStatus.OK);
	}
</#if>
	// ------------ Retrieve a user ------------
	@PreAuthorize("hasAnyAuthority('USERENTITY_READ')")
    @RequestMapping(value = "/{id}", method = RequestMethod.GET)
	public ResponseEntity<FindUserByIdOutput> FindById(@PathVariable String id) {
    FindUserByIdOutput output = _userAppService.FindById(Long.valueOf(id));
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}

    @PreAuthorize("hasAnyAuthority('USERENTITY_READ')")
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity Find(@RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort) throws Exception {
		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable Pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		
		return ResponseEntity.ok(_userAppService.Find(searchCriteria,Pageable));
	}
   
    @PreAuthorize("hasAnyAuthority('USERENTITY_READ')")
	@RequestMapping(value = "/{userid}/userpermission", method = RequestMethod.GET)
	public ResponseEntity GetUserpermission(@PathVariable String userid, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }

		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit), sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_userAppService.parseUserpermissionJoinColumn(userid);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindUserpermissionByIdOutput> output = _userpermissionAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   
 
    @PreAuthorize("hasAnyAuthority('USERENTITY_READ')")
	@RequestMapping(value = "/{id}/userrole", method = RequestMethod.GET)
	public ResponseEntity GetUserrole(@PathVariable String id, @RequestParam(value="search", required=false) String search, @RequestParam(value = "offset", required=false) String offset, @RequestParam(value = "limit", required=false) String limit, Sort sort)throws Exception {
   		if (offset == null) { offset = env.getProperty("fastCode.offset.default"); }
		if (limit == null) { limit = env.getProperty("fastCode.limit.default"); }
		
		Pageable pageable = new OffsetBasedPageRequest(Integer.parseInt(offset), Integer.parseInt(limit),sort);
		
		SearchCriteria searchCriteria = SearchUtils.generateSearchCriteriaObject(search);
		Map<String,String> joinColDetails=_userAppService.parseUserroleJoinColumn(id);
		if(joinColDetails== null)
		{
			logHelper.getLogger().error("Invalid Join Column");
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		searchCriteria.setJoinColumns(joinColDetails);
		
    	List<FindUserroleByIdOutput> output = _userroleAppService.Find(searchCriteria,pageable);
		if (output == null) {
			return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity(output, HttpStatus.OK);
	}   


}