package [=PackageName].security;

import [=PackageName].domain.irepository.IJwtRepository;
import [=PackageName].domain.model.JwtEntity;
import [=PackageName].domain.model.RoleEntity;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.security.authentication.AuthenticationManager;
import org.apache.http.auth.InvalidCredentialsException;
<#if AuthenticationType == "database" || (AuthenticationType == "ldap" && UserOnly)>
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
</#if>
<#if AuthenticationType == "ldap" && !UserOnly>
import [=PackageName].domain.authorization.role.IRoleManager;
import java.util.stream.Collectors;
</#if>
<#if AuthenticationType != "none">
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.ldap.userdetails.LdapUserDetailsImpl;
</#if>
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;

import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.context.ApplicationContext;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;


public class JWTAuthenticationFilter extends UsernamePasswordAuthenticationFilter {

    <#if AuthenticationType == "ldap">
    private SecurityUtils securityUtils;
    <#if UserOnly>
    private I[=AuthenticationTable]Manager _userManager;
    <#else>
    private IRoleManager _roleManager;
    </#if>
    </#if>
    <#if AuthenticationType == "database">
    private I[=AuthenticationTable]Manager _userManager;
    </#if>
    private IJwtRepository jwtRepo;
	
    private AuthenticationManager authenticationManager;

    public JWTAuthenticationFilter(AuthenticationManager authenticationManager,ApplicationContext ctx) {
        this.authenticationManager = authenticationManager;
        <#if AuthenticationType == "ldap">
    	this.securityUtils = ctx.getBean(SecurityUtils.class);
    	<#if UserOnly>
    	this._userManager = ctx.getBean(I[=AuthenticationTable]Manager.class);
    	<#else>
    	this._roleManager = ctx.getBean(IRoleManager.class);
    	</#if>
    	</#if>
    	<#if AuthenticationType == "database">
    	this._userManager = ctx.getBean(I[=AuthenticationTable]Manager.class);
    	</#if>
		this.jwtRepo = ctx.getBean(IJwtRepository.class);
    }
    
    <#if AuthenticationType != "none">
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse res) throws AuthenticationException {
        try {
            System.out.println("I am here ...");
            LoginUserInput creds = new ObjectMapper()
                    .readValue(request.getInputStream(), LoginUserInput.class);
   <#if AuthenticationType == "database">
        <#if UserInput?? && AuthenticationFields??>
        [=AuthenticationTable]Entity user = _userManager.FindBy[=AuthenticationFields.UserName.fieldName?cap_first](creds.getUserName());       
        if(user != null && user.get[=AuthenticationFields.IsActive.fieldName?cap_first]())
        <#else>
        [=AuthenticationTable]Entity user = _userManager.FindByUserName(creds.getUserName());
        if(user != null && user.getIsActive())
        </#if>   
		{
			return authenticationManager.authenticate(
				new UsernamePasswordAuthenticationToken(creds.getUserName(),creds.getPassword(),new ArrayList<>()));
		}
		else
			throw new InvalidCredentialsException("Invalid Credentials");
    <#else>
    		return authenticationManager.authenticate(
				new UsernamePasswordAuthenticationToken(creds.getUserName(),creds.getPassword(),new ArrayList<>()));
    </#if>
		} catch (IOException<#if AuthenticationType == "database"> | InvalidCredentialsException</#if> e) {
            throw new RuntimeException(e);
        }
    }
    </#if>
    
    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse res,
                                            FilterChain chain,
                                            Authentication auth) throws IOException, ServletException {

        Claims claims = Jwts.claims();
        String userName = "";
        if (auth != null) {
        <#if AuthenticationType == "database">
            if (auth.getPrincipal() instanceof org.springframework.security.core.userdetails.User) {
                userName = ((User) auth.getPrincipal()).getUsername();
                claims.setSubject(userName);
            }
        </#if>    
        <#if AuthenticationType == "ldap">
            if (auth.getPrincipal() instanceof LdapUserDetailsImpl) {
                userName = ((LdapUserDetailsImpl) auth.getPrincipal()).getUsername();
                claims.setSubject(userName);
            }
        </#if>   
        }
        <#if AuthenticationType == "database">
        claims.put("scopes", (auth.getAuthorities().stream().map(s -> s.toString()).collect(Collectors.toList())));
        </#if>
        <#if AuthenticationType == "ldap">
        List<String> scopes  = (auth.getAuthorities().stream().map(s -> s.toString()).collect(Collectors.toList()));
		List<String> permissionsList = new ArrayList<String>();
		<#if UserOnly>
		<#if UserInput?? && AuthenticationFields??>
        [=AuthenticationTable]Entity user = _userManager.FindBy[=AuthenticationFields.UserName.fieldName?cap_first](userName);       
        <#else>
        [=AuthenticationTable]Entity user = _userManager.FindByUserName(userName);
        </#if>      
        if (user == null) {
		throw new UsernameNotFoundException(userName);
	    }

		List<String> permissions = securityUtils.getAllPermissionsFromUserAndRole(user);
		permissionsList.addAll(permissions);
		<#else>
		for( String item : scopes)
		{
			RoleEntity role = _roleManager.FindByRoleName(item);
			if(role != null) {
			List<String> permissions= securityUtils.getAllPermissionsFromRole(role);
			permissionsList.addAll(permissions);
			}
		}
		
		permissionsList= permissionsList.stream().distinct().collect(Collectors.toList());
		</#if>

		String[] groupsArray = new String[permissionsList.size()];
		List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList(permissionsList.toArray(groupsArray));
		claims.put("scopes", (authorities.stream().map(s -> s.toString()).collect(Collectors.toList())));
        </#if>

        claims.setExpiration(new Date(System.currentTimeMillis() + SecurityConstants.EXPIRATION_TIME));
        String token = Jwts.builder()
                .setClaims(claims)
                .signWith(SignatureAlgorithm.HS512, SecurityConstants.SECRET.getBytes())
                .compact();
                
        // Add the user and token to the JwtEntity table 
        JwtEntity jt = new JwtEntity(); 
        jt.setToken("Bearer "+ token); 
        jt.setUserName(userName); 
        
        jwtRepo.save(jt); 
        
        res.addHeader(SecurityConstants.HEADER_STRING, SecurityConstants.TOKEN_PREFIX + token);
        res.setContentType("application/json");

        PrintWriter out = res.getWriter();
        out.println("{");
        out.println("\"token\":" + "\"" + SecurityConstants.TOKEN_PREFIX + token + "\"");
        
        out.println("}");
        out.close();

    }

}
