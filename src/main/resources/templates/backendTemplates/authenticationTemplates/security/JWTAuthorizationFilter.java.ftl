package [=PackageName].security;

import com.fasterxml.jackson.databind.ObjectMapper;

import [=CommonModulePackage].error.ApiError;
import [=CommonModulePackage].error.ExceptionMessageConstants;
import [=CommonModulePackage].logging.LoggingHelper;
import io.jsonwebtoken.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.context.ApplicationContext;
<#if AuthenticationType !="oidc">
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.util.stream.Collectors;
import [=PackageName].domain.model.JwtEntity;
import [=PackageName].domain.irepository.IJwtRepository;
</#if>
import java.net.URL;
import org.springframework.security.core.authority.AuthorityUtils;
<#if AuthenticationType == "oidc">
import com.nimbusds.jose.*;
import com.nimbusds.jwt.*;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
<#if UserOnly>
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
<#else>
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.IRoleManager;
import java.util.stream.Collectors;
</#if>
</#if>
import java.util.*;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

public class JWTAuthorizationFilter extends BasicAuthenticationFilter {
    
    <#if AuthenticationType != "oidc">
    private IJwtRepository jwtRepo;
    </#if>
    <#if AuthenticationType == "oidc">
    private Environment environment;
    private SecurityUtils securityUtils;
    <#if UserOnly>
    private I[=AuthenticationTable]Manager _userMgr;
    <#else>
    private IRoleManager _roleManager;
    </#if>
    </#if>
    public JWTAuthorizationFilter(AuthenticationManager authManager,ApplicationContext ctx) {
        super(authManager);
        <#if AuthenticationType == "oidc">
        this.environment = ctx.getBean(Environment.class);
    	this.securityUtils = ctx.getBean(SecurityUtils.class);
    	<#if UserOnly>
    	this._userMgr = ctx.getBean(IUserManager.class);
    	<#else>
    	this._roleManager = ctx.getBean(IRoleManager.class);
    	</#if>
    	</#if>
    	<#if AuthenticationType != "oidc">
		this.jwtRepo = ctx.getBean(IJwtRepository.class);
		</#if>
    }

    @Override
    protected void doFilterInternal(HttpServletRequest req,
                                    HttpServletResponse res,
                                    FilterChain chain) throws IOException, ServletException {
        String header = req.getHeader(SecurityConstants.HEADER_STRING);

        if (header == null || !header.startsWith(SecurityConstants.TOKEN_PREFIX)) {
            chain.doFilter(req, res);
            return;
        }

        UsernamePasswordAuthenticationToken authentication = null;
        ApiError apiError = new ApiError(HttpStatus.UNAUTHORIZED);
        LoggingHelper logHelper = new LoggingHelper();
        try {
            authentication = getAuthentication(req);
            SecurityContextHolder.getContext().setAuthentication(authentication);
            chain.doFilter(req, res);
            return;

        } catch (ExpiredJwtException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_EXPIRED);
            logHelper.getLogger().error("An Exception Occurred:", exception);
            res.setStatus(401);
        } catch (UnsupportedJwtException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_UNSUPPORTED);
            logHelper.getLogger().error("An Exception Occurred:", exception);
            res.setStatus(401);
        } catch (MalformedJwtException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_MALFORMED);
            logHelper.getLogger().error("An Exception Occurred:", exception);
            res.setStatus(401);
        } catch (SignatureException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_INCORRECT_SIGNATURE);
            logHelper.getLogger().error("An Exception Occurred:", exception);
            res.setStatus(401);
        } catch (IllegalArgumentException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_ILLEGAL_ARGUMENT);
            logHelper.getLogger().error("An Exception Occurred:", exception);
            res.setStatus(401);
        } catch (JwtException exception) {
             apiError.setMessage(ExceptionMessageConstants.TOKEN_UNAUTHORIZED);
             logHelper.getLogger().error("An Exception Occurred:", exception);
             res.setStatus(401);
	    }


        OutputStream out = res.getOutputStream();
        com.fasterxml.jackson.databind.ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(out, apiError);
        out.flush();
    }

    private ResponseEntity<Object> buildResponseEntity(ApiError apiError) {
        return new ResponseEntity<>(apiError, apiError.getStatus());
    }


    private UsernamePasswordAuthenticationToken getAuthentication(HttpServletRequest request) throws JwtException {

        String token = request.getHeader(SecurityConstants.HEADER_STRING);
 
         // Check that the token is inactive in the JwtEntity table
        <#if AuthenticationType != "oidc">
         JwtEntity jwt = jwtRepo.findByToken(token);
         ApiError apiError = new ApiError(HttpStatus.UNAUTHORIZED);
 
         if(jwt == null) {
             throw new JwtException("Token Does Not Exist");
         }
        </#if>
        Claims claims;
       
		if (StringUtils.isNotEmpty(token) && token.startsWith(SecurityConstants.TOKEN_PREFIX)) {
        	String userName = null;
            List<GrantedAuthority> authorities = null;
            <#if AuthenticationType !="none" && AuthenticationType !="oidc">
            claims = Jwts.parser()
                        .setSigningKey(SecurityConstants.SECRET.getBytes())
                        .parseClaimsJws(token.replace(SecurityConstants.TOKEN_PREFIX, ""))
                        .getBody();
            userName = claims.getSubject();
            List<String> scopes = claims.get("scopes", List.class);
            authorities = scopes.stream()
                        .map(authority -> new SimpleGrantedAuthority(authority))
                        .collect(Collectors.toList());
                        
            <#elseif AuthenticationType =="oidc">

    		<#if !UserOnly>
            List<String> groups = new ArrayList<String>();
    		</#if>
            
	        SignedJWT accessToken = null;
	        JWTClaimsSet claimSet = null;
	
	        try {
	              
	        	accessToken = SignedJWT.parse(token.replace(SecurityConstants.TOKEN_PREFIX, ""));
	            String kid = accessToken.getHeader().getKeyID();
	            JWKSet jwks = null;
				jwks = JWKSet.load(new URL(environment.getProperty("spring.security.oauth2.client.provider.oidc.issuer-uri") + "/v1/keys"));
	
	            RSAKey jwk = (RSAKey) jwks.getKeyByKeyId(kid);
	            JWSVerifier verifier = new RSASSAVerifier(jwk);
	
	            if (accessToken.verify(verifier)) {
	            	System.out.println("valid signature");
	                claimSet = accessToken.getJWTClaimsSet();
	                userName = claimSet.getSubject();
	                List<String> aud = null;
	                aud = (ArrayList) claimSet.getClaims().get("aud");
	                if(!aud.get(0).equals("localhost:5555")) {
	                	throw new JwtException("Invalid token");
	                }
	                <#if !UserOnly>
	                groups = (ArrayList<String>) claimSet.getClaims().get("groups");
	                </#if>
	           } else {
	                System.out.println("invalid signature");
	           }
	      } catch (Exception e) {
	                    e.printStackTrace();
	      }
               
        <#if UserOnly>
        // Add all the roles and permissions in a list and then convert the list into all permissions, removing duplicates
        <#if UserInput?? && AuthenticationFields??>
        [=AuthenticationTable]Entity user = _userMgr.FindBy[=AuthenticationFields.UserName.fieldName?cap_first](userName);       
        <#else>
        [=AuthenticationTable]Entity user = _userMgr.FindByUserName(userName);
        </#if>    
        if (user == null) {
	    	throw new UsernameNotFoundException(userName);
	    }

        List<String> permissions = securityUtils.getAllPermissionsFromUserAndRole(user);
        String[] groupsArray = new String[permissions.size()];
        authorities = AuthorityUtils.createAuthorityList(permissions.toArray(groupsArray));
                
        <#else>
        List<String> permissionsList = new ArrayList<String>();
        for( String item : groups)
   	    {
			RoleEntity role = _roleManager.FindByRoleName(item);
   			if(role != null) {
   				List<String> permissions= securityUtils.getAllPermissionsFromRole(role);
   				permissionsList.addAll(permissions);
   			}
   		}
   		permissionsList= permissionsList.stream().distinct().collect(Collectors.toList());
        String[] groupsArray = new String[permissionsList.size()];
        authorities = AuthorityUtils.createAuthorityList(permissionsList.toArray(groupsArray));
        </#if>
        </#if>

        if ((userName != null) && StringUtils.isNotEmpty(userName)) {
        	return new UsernamePasswordAuthenticationToken(userName, null, authorities);
        }
        }
        return null;

    }

}