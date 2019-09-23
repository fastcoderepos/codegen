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
import org.springframework.security.core.authority.SimpleGrantedAuthority;
<#if AuthenticationType == "database" || AuthenticationType == "ldap">
import java.util.stream.Collectors;
import java.util.*;
</#if>
import javax.servlet.FilterChain;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;

<#if AuthenticationType == "oidc">
import java.net.URL;
import org.springframework.security.core.authority.AuthorityUtils;
import [=PackageName].domain.model.UserpermissionEntity;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.Authorization.User.IUserManager;
import [=PackageName].domain.model.UserEntity;
import com.nimbusds.jose.*;
import com.nimbusds.jwt.*;
import com.nimbusds.jose.crypto.RSASSAVerifier;
import com.nimbusds.jose.jwk.JWKSet;
import com.nimbusds.jose.jwk.RSAKey;
</#if>

public class JWTAuthorizationFilter extends BasicAuthenticationFilter {

    //@Autowired
    private Environment environment;

 <#if AuthenticationType == "oidc">
    private IUserManager _userMgr;
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
        } catch (UnsupportedJwtException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_UNSUPPORTED);
            logHelper.getLogger().error("An Exception Occurred:", exception);
        } catch (MalformedJwtException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_MALFORMED);
            logHelper.getLogger().error("An Exception Occurred:", exception);
        } catch (SignatureException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_INCORRECT_SIGNATURE);
            logHelper.getLogger().error("An Exception Occurred:", exception);
        } catch (IllegalArgumentException exception) {
            apiError.setMessage(ExceptionMessageConstants.TOKEN_ILLEGAL_ARGUMENT);
            logHelper.getLogger().error("An Exception Occurred:", exception);
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
        Claims claims;
        if(environment==null){
            ServletContext servletContext = request.getServletContext();
            WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
            environment = webApplicationContext.getBean(Environment.class);
        }
        if (StringUtils.isNotEmpty(token) && token.startsWith(SecurityConstants.TOKEN_PREFIX)) {
            String userName = null;
            List<GrantedAuthority> authorities = null;
            <#if AuthenticationType == "database" || AuthenticationType == "ldap">
            if(!environment.getProperty("fastCode.auth.method").equals("openid")) {

                 claims = Jwts.parser()
                        .setSigningKey(SecurityConstants.SECRET.getBytes())
                        .parseClaimsJws(token.replace(SecurityConstants.TOKEN_PREFIX, ""))
                        .getBody();
                userName = claims.getSubject();
                List<String> scopes = claims.get("scopes", List.class);
                authorities = scopes.stream()
                        .map(authority -> new SimpleGrantedAuthority(authority))
                        .collect(Collectors.toList());
            }
            </#if>
            <#if AuthenticationType == "oidc">

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
                } else {
                    System.out.println("invalid signature");
                }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if(_userMgr==null){
                    ServletContext servletContext = request.getServletContext();
                    WebApplicationContext webApplicationContext = WebApplicationContextUtils.getWebApplicationContext(servletContext);
                    _userMgr = webApplicationContext.getBean(IUserManager.class);
                }

                // Add all the roles and permissions in a list and then convert the list into all permissions, removing duplicates

                UserEntity userEntity = _userMgr.FindByUserName(userName);

                Set<UserpermissionEntity> spe = userEntity.getUserpermissionSet();
                
//              Set<PermissionEntity> permissions =_userMgr.GetPermissions(userEntity); 
//              for (PermissionEntity item: permissions) { 
//              	pList.add(item.getName()); 
//              } 
                List<String> pList = new ArrayList<String>(); 
                Iterator pIterator = spe.iterator();
        		while (pIterator.hasNext()) { 
        			UserpermissionEntity pe = (UserpermissionEntity) pIterator.next();
        			pList.add(pe.getPermission().getName());
        		}
         
                RoleEntity role = _userMgr.GetRole(userEntity.getId());
                List<String> groups = new ArrayList<String>();

                groups.add(role.getName());
                groups.addAll(pList);

                ConvertToPrivilegeAuthorities con = new ConvertToPrivilegeAuthorities();
                String[] groupsArray = new String[groups.size()];

                authorities = con.convert(AuthorityUtils.createAuthorityList(groups.toArray(groupsArray)));
            </#if>

                if ((userName != null) && StringUtils.isNotEmpty(userName)) {
                	return new UsernamePasswordAuthenticationToken(userName, null, authorities);
            }
        }
        return null;

    }

}