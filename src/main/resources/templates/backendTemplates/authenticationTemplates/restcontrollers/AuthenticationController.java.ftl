package [=PackageName].restcontrollers; 

<#if AuthenticationType !="None" && AuthenticationType != "oidc"> 
import [=PackageName].security.JWTAppService;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import org.springframework.security.core.context.SecurityContextHolder; 
</#if>
import org.springframework.http.ResponseEntity; 
import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.http.HttpStatus; 
import org.springframework.web.bind.annotation.RequestMapping; 
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.RestController; 
<#if AuthenticationType == "oidc">
import javax.servlet.http.HttpServletRequest;
import [=PackageName].security.SecurityConstants;
import [=PackageName].security.SecurityUtils;
import java.util.List;
import javax.persistence.EntityNotFoundException;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
<#if UserOnly>
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
<#else>
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.IRoleManager;
import java.util.ArrayList;
import java.util.stream.Collectors;
</#if>
</#if>
 
@RestController 
@RequestMapping("/auth") 
public class AuthenticationController { 
    <#if AuthenticationType !="none" && AuthenticationType != "oidc">
    
    @Autowired 
    private JWTAppService _jwtAppService; 

    @RequestMapping(value = "/logout", method = RequestMethod.POST) 
    public ResponseEntity logout() throws Exception{ 
 
         String userName = SecurityContextHolder.getContext().getAuthentication().getName(); 
        _jwtAppService.deleteAllUserTokens(userName);
        
        return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.OK); 
    } 
    
    </#if>
    <#if AuthenticationType == "oidc">
    <#if UserOnly>
    
    @Autowired
	I[=AuthenticationTable]Manager _userMgr;
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
		[=AuthenticationTable]Entity user = _userMgr.FindBy<#if AuthenticationFields?? && AuthenticationFields.UserName??>[=AuthenticationFields.UserName.fieldName?cap_first]</#if>(userName);  
		if(user !=null )
		{
			permissions = utils.getAllPermissionsFromUserAndRole(user);
		}
		else
			throw new EntityNotFoundException(
					String.format("There does not exist a user with a name=%s", userName));
		return new ResponseEntity(permissions, HttpStatus.OK);
		<#else>
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
//    @RequestMapping("/oidc") 
//    public void securedPageOIDC(Model model, OAuth2AuthenticationToken authentication) { 
// 
//        connection.getJwtToken((List<String>) authentication.getPrincipal().getAttributes().get("groups"), (String) authentication.getPrincipal().getAttributes().get("preferred_username")); 
// 
//    } 

 
} 