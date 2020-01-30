package [=PackageName].security;

import [=PackageName].domain.irepository.IJwtRepository;
import [=PackageName].domain.model.JwtEntity;
import [=PackageName].domain.model.RoleEntity;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.security.authentication.AuthenticationManager;
<#if AuthenticationType == "ldap">
<#if UsersOnly== "true">
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.authorization.user.I[=AuthenticationTable]Manager;
<#else>
import [=PackageName].domain.authorization.role.IRoleManager;
import java.util.stream.Collectors;
</#if>
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
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
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
    <#if UsersOnly== "true">
    private I[=AuthenticationTable]Manager _userManager;
    <#else>
    private IRoleManager _roleManager;
    </#if>
    </#if>
    private IJwtRepository jwtRepo;
	
    private AuthenticationManager authenticationManager;

    public JWTAuthenticationFilter(AuthenticationManager authenticationManager) {
        this.authenticationManager = authenticationManager;
    }
    <#if AuthenticationType != "none">
    @Override
    public Authentication attemptAuthentication(HttpServletRequest request,
                                                HttpServletResponse res) throws AuthenticationException {
        try {
            System.out.println("I am here ...");
            LoginUserInput creds = new ObjectMapper()
                    .readValue(request.getInputStream(), LoginUserInput.class);

            return authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            creds.getUserName(),
                            creds.getPassword(),
                            new ArrayList<>())
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    </#if>
    @Override
    protected void successfulAuthentication(HttpServletRequest request,
                                            HttpServletResponse res,
                                            FilterChain chain,
                                            Authentication auth) throws IOException, ServletException {

        <#if AuthenticationType == "ldap">
        if(securityUtils==null){
			ServletContext servletContext = request.getServletContext();
			WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
			securityUtils = webApplicationContext.getBean(SecurityUtils.class);
		}
		
        <#if UsersOnly == "true">
        if(_userManager==null){
            ServletContext servletContext = request.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            _userManager = webApplicationContext.getBean(I[=AuthenticationTable?cap_first]Manager.class);
        }
        
        <#else>
         // We cannot autowire RolesManager, but need to use the code below to set it
          if(_roleManager==null){
            ServletContext servletContext = request.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            _roleManager = webApplicationContext.getBean(IRoleManager.class);
        }
        
        </#if>
        </#if>
        Claims claims = Jwts.claims();
        String userName = "";
        if (auth != null) {
            if (auth.getPrincipal() instanceof org.springframework.security.core.userdetails.User) {
                userName = ((User) auth.getPrincipal()).getUsername();
                claims.setSubject(userName);
            }
            else if (auth.getPrincipal() instanceof LdapUserDetailsImpl) {
                userName = ((LdapUserDetailsImpl) auth.getPrincipal()).getUsername();
                claims.setSubject(userName);
            }
            
        }
        <#if AuthenticationType == "database">
        claims.put("scopes", (auth.getAuthorities().stream().map(s -> s.toString()).collect(Collectors.toList())));
        </#if>
        <#if AuthenticationType == "ldap">
        List<String> scopes  = (auth.getAuthorities().stream().map(s -> s.toString()).collect(Collectors.toList()));
		List<String> permissionsList = new ArrayList<String>();
		<#if UsersOnly== "true">
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
        jt.setIsActive(true); 
 
        if(jwtRepo==null){ 
            ServletContext servletContext = request.getServletContext(); 
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext); 
            jwtRepo = webApplicationContext.getBean(IJwtRepository.class); 
        } 
 
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
