package [=PackageName];

import [=PackageName].application.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]AppService;
import [=PackageName].security.SecurityUtils;
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.irepository.I[=AuthenticationTable]Repository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class UserDetailsServiceImpl implements UserDetailsService {

	public UserDetailsServiceImpl(I[=AuthenticationTable]AppService userAppService) {
	}

	@Autowired
	private I[=AuthenticationTable]Repository usersRepository;
	
	@Autowired
    private SecurityUtils securityUtils;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

    <#if UserInput?? && AuthenticationFields??>
    [=AuthenticationTable]Entity applicationUser = usersRepository.findBy[=AuthenticationFields.UserName.fieldName?cap_first](username);       
    <#else>
    [=AuthenticationTable]Entity applicationUser = usersRepository.findByUserName(username);
    </#if>

	if (applicationUser == null) {
		throw new UsernameNotFoundException(username);
	}

	List<String> permissions = securityUtils.getAllPermissionsFromUserAndRole(applicationUser);
	String[] groupsArray = new String[permissions.size()];
   	List<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList(permissions.toArray(groupsArray));

    <#if UserInput?? && AuthenticationFields??>
	return new User(applicationUser.get[=AuthenticationFields.UserName.fieldName?cap_first](), applicationUser.get[=AuthenticationFields.Password.fieldName?cap_first](), authorities); // User class implements UserDetails Interface
	<#else>
    return new User(applicationUser.getUserName(), applicationUser.getPassword(), authorities); // User class implements UserDetails Interface
    </#if>
	}


}
