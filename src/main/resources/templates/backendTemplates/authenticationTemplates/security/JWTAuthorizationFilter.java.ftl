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
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
<#if AuthenticationType !="oidc">
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import java.util.stream.Collectors;
</#if>
import java.net.URL;
import org.springframework.security.core.authority.AuthorityUtils;
import [=PackageName].domain.irepository.IJwtRepository;
import [=PackageName].domain.model.JwtEntity;
<#if AuthenticationType =="oidc">
import com.nimbusds.jose.*;
import com.nimbusds.jwt.*;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
<#if UsersOnly == "true">
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
<#else>
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.authorization.role.IRoleManager;
</#if>
</#if>
import java.util.*;
import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

public class JWTAuthorizationFilter extends BasicAuthenticationFilter {

    private Environment environment;
    private IJwtRepository jwtRepo;
    <#if AuthenticationType == "oidc">
    private SecurityUtils securityUtils;
    <#if UsersOnly == "true">
    private I[=AuthenticationTable]Manager _userMgr;
    <#else>
    private IRoleManager _roleManager;
    </#if>
    </#if>
    public JWTAuthorizationFilter(AuthenticationManager authManager) {
        super(authManager);
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
        
        if(jwtRepo==null){
             ServletContext servletContext = request.getServletContext();
             WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
             jwtRepo = webApplicationContext.getBean(IJwtRepository.class);
         }
 
         // Check that the token is inactive in the JwtEntity table
 
         JwtEntity jwt = jwtRepo.findByToken(token);
         ApiError apiError = new ApiError(HttpStatus.UNAUTHORIZED);
 
         if(jwt == null) {
             throw new JwtException("Token Does Not Exist");
         }
 
         if(!jwt.getIsActive()) {
             throw new JwtException("Token Inactive");
	     }
        
        Claims claims;
        if(environment==null){
            ServletContext servletContext = request.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            environment = webApplicationContext.getBean(Environment.class);
        }
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
            if(securityUtils==null){
            ServletContext servletContext = request.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            securityUtils = webApplicationContext.getBean(SecurityUtils.class);
            }
    		<#if UsersOnly == "true">
    		if(_userMgr==null){
            	ServletContext servletContext = request.getServletContext();
                WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
                _userMgr = webApplicationContext.getBean(I[=AuthenticationTable]Manager.class);
             }
    		<#else>
    		if(_roleManager==null){
            	ServletContext servletContext = request.getServletContext();
                WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
                _roleManager = webApplicationContext.getBean(IRoleManager.class);
             }
             
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
	                    <#if UsersOnly != "true">
	                     groups = (ArrayList<String>) claimSet.getClaims().get("groups");
	                     </#if>
	                } else {
	                    System.out.println("invalid signature");
	                }
	                } catch (Exception e) {
	                    e.printStackTrace();
	            }
               
                <#if UsersOnly == "true">
                // Add all the roles and permissions in a list and then convert the list into all permissions, removing duplicates
            	<#if UserInput?? && AuthenticationFields??>
                [=AuthenticationTable]Entity user = _userMgr.FindBy[=AuthenticationFields.UserName.fieldName?cap_first](userName);       
            	<#else>
                [=AuthenticationTable]Entity user = _userMgr.FindByUserName(userName);
            	</#if>    
                if (applicationUser == null) {
					throw new UsernameNotFoundException(username);
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