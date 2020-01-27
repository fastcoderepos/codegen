package [=PackageName].security;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.stereotype.Component;
import [=PackageName].domain.model.RolepermissionEntity;
<#if AuthenticationType != "database" && UsersOnly == "false">
import [=PackageName].domain.model.RoleEntity;
<#else>
import [=PackageName].domain.model.[=AuthenticationTable]Entity;
import [=PackageName].domain.model.[=AuthenticationTable]permissionEntity;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;
</#if>
@Component
public class SecurityUtils {

   <#if AuthenticationType != "database" && UsersOnly == "false">
	public List<String> getAllPermissionsFromRole(RoleEntity role)
    {
    	List<String> permissions = new ArrayList<>();
    	
    	Set<RolepermissionEntity> srp= role.getRolepermissionSet();
    	for (RolepermissionEntity item : srp) {
			permissions.add(item.getPermission().getName());
        }
    	
    	return permissions;
    	
    }
   <#else>
    public List<String> getAllPermissionsFromUserAndRole([=AuthenticationTable]Entity user) {

		List<String> permissions = new ArrayList<>();
        Set<[=AuthenticationTable]roleEntity> ure = user.get[=AuthenticationTable]roleSet();
        Iterator rIterator = ure.iterator();
		while (rIterator.hasNext()) {
            [=AuthenticationTable]roleEntity re = ([=AuthenticationTable]roleEntity) rIterator.next();
            Set<RolepermissionEntity> srp= re.getRole().getRolepermissionSet();
            for (RolepermissionEntity item : srp) {
				permissions.add(item.getPermission().getName());
            }
		}
		
		Set<[=AuthenticationTable]permissionEntity> spe = user.get[=AuthenticationTable]permissionSet();
        Iterator pIterator = spe.iterator();
		while (pIterator.hasNext()) {
            [=AuthenticationTable]permissionEntity pe = ([=AuthenticationTable]permissionEntity) pIterator.next();
            
            if(permissions.contains(pe.getPermission().getName()) && (pe.getRevoked() != null && pe.getRevoked()))
            {
            	permissions.remove(pe.getPermission().getName());
            }
            if(!permissions.contains(pe.getPermission().getName()) && (pe.getRevoked()==null || !pe.getRevoked()))
            {
            	permissions.add(pe.getPermission().getName());
			
            }
         
		}
		
		return permissions
				.stream()
				.distinct()
				.collect(Collectors.toList());
	}
	</#if>

}
