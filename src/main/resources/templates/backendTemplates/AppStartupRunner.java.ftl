package [=PackageName];

import [=PackageName].domain.model.*;
import [=PackageName].domain.authorization.permission.IPermissionManager;
import [=PackageName].domain.authorization.rolepermission.IRolepermissionManager;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]role.I[=AuthenticationTable]roleManager;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
import [=PackageName].domain.authorization.role.IRoleManager;
import [=PackageName].commonmodule.logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@Profile("bootstrap")
public class AppStartupRunner implements ApplicationRunner {

    @Autowired
    private IPermissionManager permissionManager;

    @Autowired
    private IRoleManager roleManager;
    
    @Autowired
    private I[=AuthenticationTable]Manager userManager;
    
	@Autowired
    private IRolepermissionManager rolepermissionManager;
    
    @Autowired
    private I[=AuthenticationTable]roleManager userroleManager;
    
    @Autowired
    private LoggingHelper loggingHelper;

    @Autowired
    private PasswordEncoder pEncoder;
    
    @Override
    public void run(ApplicationArguments args) {

     System.out.println("*****************Creating Default Users/Roles/Permissions *************************");

        // Create permissions for default entities

        loggingHelper.getLogger().info("Creating the data in the database");

        // Create roles

        RoleEntity role = new RoleEntity();
        role.setName("ROLE_Admin");
        role = roleManager.Create(role);
        addDefaultUser(role);
        
		List<String> entityList = new ArrayList<String>();
        entityList.add("role");
        entityList.add("permission");
        entityList.add("rolepermission");

        <#if !UserInput??>
		entityList.add("user");
		entityList.add("userpermission");
		entityList.add("userrole");
		<#else>
		entityList.add("[=AuthenticationTable?lower_case]permission");
		entityList.add("[=AuthenticationTable?lower_case]role");
        </#if>

        <#list entitiesMap as entityKey, entityMap>
		entityList.add("[=entityKey?lower_case]");
		</#list>
		
		for(String entity: entityList) {
        	addEntityPermissions(entity, role.getId());
        }
      
        loggingHelper.getLogger().info("Completed creating the data in the database");

    }
    
    private void addEntityPermissions(String entity, long roleId) {
		PermissionEntity pe1 = new PermissionEntity(entity.toUpperCase() + "ENTITY_CREATE", "create " + entity);
        PermissionEntity pe2 = new PermissionEntity(entity.toUpperCase() + "ENTITY_READ", "read " + entity);
        PermissionEntity pe3 = new PermissionEntity(entity.toUpperCase() + "ENTITY_DELETE", "delete " + entity);
        PermissionEntity pe4 = new PermissionEntity(entity.toUpperCase() + "ENTITY_UPDATE", "update " + entity);

        pe1 = permissionManager.Create(pe1);
        pe2 = permissionManager.Create(pe2);
        pe3 = permissionManager.Create(pe3);
        pe4 = permissionManager.Create(pe4);
        
        RolepermissionEntity pe1RP = new RolepermissionEntity(pe1.getId(), roleId);
        RolepermissionEntity pe2RP = new RolepermissionEntity(pe2.getId(), roleId);
        RolepermissionEntity pe3RP = new RolepermissionEntity(pe3.getId(), roleId);
        RolepermissionEntity pe4RP = new RolepermissionEntity(pe4.getId(), roleId);
        
        rolepermissionManager.Create(pe1RP);
        rolepermissionManager.Create(pe2RP);
        rolepermissionManager.Create(pe3RP);
        rolepermissionManager.Create(pe4RP);
    }
    
    private void addDefaultUser(RoleEntity role) {
    	[=AuthenticationTable]Entity admin = new [=AuthenticationTable]Entity();
        <#if AuthenticationType != "none" && ClassName?? && ClassName == AuthenticationTable>  
        <#if AuthenticationFields??>
  	    <#list AuthenticationFields as authKey,authValue>
  	    <#list Fields as key,value>
        <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  	    <#if value.fieldName == authValue.fieldName>
  	    <#if authKey== "Password">
        admin.set[=value.fieldName?cap_first](pEncoder.encode("secret"));
        <#elseif authKey== "UserName">
        admin.set[=value.fieldName?cap_first]("admin");
        <#elseif authKey== "FirstName">
        admin.set[=value.fieldName?cap_first]("test");
        <#elseif authKey== "LastName">
        admin.set[=value.fieldName?cap_first]("admin");
        <#elseif authKey== "EmailAddress">
        admin.set[=value.fieldName?cap_first]("admin@demo.com");
        </#if>
        </#if>
        </#if>
	    </#list>
        </#list>
        </#if>
        <#else>
        admin.setFirstName("test");
    	admin.setLastName("admin");
    	admin.setUserName("admin");
    	admin.setEmailAddress("admin@demo.com");
    	admin.setPassword(pEncoder.encode("secret"));
    	admin.setIsActive(true);
        </#if> 
    	admin = userManager.Create(admin);
    	[=AuthenticationTable]roleEntity urole = new [=AuthenticationTable]roleEntity();
    	urole.setRoleId(role.getId());
    	<#if (AuthenticationType!="none" && !UserInput??)>
    	urole.set[=AuthenticationTable]Id(admin.getId());
        <#elseif AuthenticationType!="none" && UserInput??>
        <#if PrimaryKeys??>
        <#list PrimaryKeys as key,value>
        <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
        urole.set[=AuthenticationTable][=key?cap_first](admin.get[=key?cap_first]());
        </#if> 
        </#list>
        </#if>
        </#if>
		urole=userroleManager.Create(urole);
    }
}
