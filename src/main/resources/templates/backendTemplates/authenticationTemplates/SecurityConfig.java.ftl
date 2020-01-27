package [=PackageName];

<#if AuthenticationType !="oidc">
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment; 
</#if>
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
<#if AuthenticationType !="oidc">
import [=PackageName].security.JWTAuthenticationFilter;
</#if>
import [=PackageName].security.JWTAuthorizationFilter;

import static [=PackageName].security.SecurityConstants.CONFIRM;
import static [=PackageName].security.SecurityConstants.REGISTER;
import javax.naming.AuthenticationNotSupportedException;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig extends WebSecurityConfigurerAdapter {

<#if AuthenticationType =="database">
    @Autowired
    private UserDetailsServiceImpl userDetailsService;
</#if>
<#if AuthenticationType !="oidc">
    @Autowired
	private Environment env;
</#if>

    @Override
    protected void configure(HttpSecurity http) throws Exception {

      /*   if (env.getProperty("fastCode.auth.method").equalsIgnoreCase("oidc") ) {
            // The following configuration is for SSO
           http
                    .cors()
                    .and()
                    .csrf().disable()
                    .authorizeRequests()
                    .antMatchers("/v2/api-docs", "/actuator/**","/configuration/ui", "/swagger-resources", "/configuration/security", "/swagger-ui.html", "/webjars/**", "/swagger-resources/configuration/ui", "/swagger-resources/configuration/security", "/browser/index.html#", "/browser/**").permitAll()
                    .antMatchers(HttpMethod.POST, REGISTER).permitAll()
                    .antMatchers(HttpMethod.POST, CONFIRM).permitAll()
                    .anyRequest().authenticated()
                    .and()
                    .oauth2Login();

        }

        // The following authorization configuration is for database/LDAP

        else {*/

            http
                    .cors()
                    .and()
                    .csrf().disable()
                    .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
                    .authorizeRequests()
                    .antMatchers("/v2/api-docs", "/actuator/**", "/configuration/ui", "/swagger-resources", "/configuration/security", "/swagger-ui.html", "/webjars/**", "/swagger-resources/configuration/ui", "/swagger-resources/configuration/security", "/browser/index.html#", "/browser/**").permitAll()
                    .antMatchers(HttpMethod.POST, REGISTER).permitAll()
                    .antMatchers(HttpMethod.POST, CONFIRM).permitAll()
                    .anyRequest().authenticated()
                    .and()
                    <#if AuthenticationType !="oidc">
                    .addFilter(new JWTAuthenticationFilter(authenticationManager()))
                    </#if>
                    .addFilter(new JWTAuthorizationFilter(authenticationManager()));
      //  }
    }

<#if AuthenticationType !="oidc">
    @Autowired
    public void configure(AuthenticationManagerBuilder auth) throws Exception {

      <#if AuthenticationType =="database">
        if(env.getProperty("fastCode.auth.method").equalsIgnoreCase("database")) {
            auth
                    .userDetailsService(userDetailsService)
                    .passwordEncoder(new BCryptPasswordEncoder());
        }
        </#if>
        <#if AuthenticationType =="ldap">
        if (env.getProperty("fastCode.auth.method").equalsIgnoreCase("ldap") ) {
            auth
                .ldapAuthentication()
                .contextSource()
                .url(env.getProperty("fastCode.ldap.contextsourceurl"))
                .managerDn(env.getProperty("fastCode.ldap.manager.dn"))
                .managerPassword(env.getProperty("fastCode.ldap.manager.password"))
                .and()
                .userSearchBase(env.getProperty("fastCode.ldap.usersearchbase"))
                .userSearchFilter(env.getProperty("fastCode.ldap.usersearchfilter"))
                .groupSearchBase(env.getProperty("fastCode.ldap.groupsearchbase"))
                .groupSearchFilter(env.getProperty("fastCode.ldap.groupsearchfilter"))
                .rolePrefix(env.getProperty("fastCode.ldap.roleprefix"));
        }
        </#if>
        else {
            throw new AuthenticationNotSupportedException();
        }
    }
</#if>
}
