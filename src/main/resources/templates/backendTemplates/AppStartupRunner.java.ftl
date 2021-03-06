package [=PackageName];

import [=PackageName].domain.model.*;
import [=PackageName].domain.authorization.permission.IPermissionManager;
import [=PackageName].domain.authorization.rolepermission.IRolepermissionManager;
<#if (AuthenticationType == "database" || UserOnly)>
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case]role.I[=AuthenticationTable]roleManager;
import [=PackageName].domain.authorization.[=AuthenticationTable?lower_case].I[=AuthenticationTable]Manager;
</#if>
import [=PackageName].domain.authorization.role.IRoleManager;
import [=PackageName].commonmodule.logging.LoggingHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
<#if AuthenticationType == "database">
import org.springframework.security.crypto.password.PasswordEncoder;
</#if>
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
@Profile("bootstrap")
public class AppStartupRunner implements ApplicationRunner {

	@Autowired
	private Environment environment;
	 
    @Autowired
    private IPermissionManager permissionManager;
    
    @Autowired
    private IRoleManager roleManager;

<#if (AuthenticationType == "database" || UserOnly)> 
    @Autowired
    private I[=AuthenticationTable]Manager userManager;
    
    @Autowired
    private I[=AuthenticationTable]roleManager userroleManager;
    
</#if>    
	@Autowired
    private IRolepermissionManager rolepermissionManager;
    
    @Autowired
    private LoggingHelper loggingHelper;
 <#if AuthenticationType == "database">
 
    @Autowired
    private PasswordEncoder pEncoder;
</#if>    

    @Override
    public void run(ApplicationArguments args) {

     System.out.println("*****************Creating Default Users/Roles/Permissions *************************");

        // Create permissions for default entities

        loggingHelper.getLogger().info("Creating the data in the database");

        // Create roles

        RoleEntity role = new RoleEntity();
        role.setName("ROLE_Admin");
        role.setDisplayName("Role1");
        role = roleManager.Create(role);
        <#if (AuthenticationType == "database" || UserOnly)>
        addDefaultUser(role);
        </#if>
        
		List<String> entityList = new ArrayList<String>();
        entityList.add("role");
        entityList.add("permission");
        entityList.add("rolepermission");

        <#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
		entityList.add("user");
		entityList.add("userpermission");
		entityList.add("userrole");
		<#elseif (AuthenticationType == "database" || UserOnly) && UserInput??>
		entityList.add("[=AuthenticationTable?lower_case]permission");
		entityList.add("[=AuthenticationTable?lower_case]role");
        </#if>

        <#list entitiesMap as entityKey, entityMap>
		entityList.add("[=entityKey?lower_case]");
		</#list>
		
		for(String entity: entityList) {
			<#if (AuthenticationType == "database" || UserOnly) && !UserInput??>
			if(!environment.getProperty("fastCode.auth.method").equals("database") && entity.equals("user"))
        	<#elseif (AuthenticationType == "database" || UserOnly) && UserInput??>
        	if(!environment.getProperty("fastCode.auth.method").equals("database") && entity.equals("[=AuthenticationTable?lower_case]"))
        	<#elseif (AuthenticationType != "database" && !UserOnly) && UserInput??>
        	if(!environment.getProperty("fastCode.auth.method").equals("database") && (entity.equals("role") || entity.equals("[=AuthenticationTable?lower_case]")))
        	<#else>
        	if(!environment.getProperty("fastCode.auth.method").equals("database") && entity.equals("role"))
        	</#if>
        		addEntityPermissions(entity, role.getId(), true);
			else
				addEntityPermissions(entity, role.getId(), false);
        }
      
        loggingHelper.getLogger().info("Completed creating the data in the database");

    }
    
    private void addEntityPermissions(String entity, long roleId,boolean readOnly) {
    	if(readOnly)
    	{
    		PermissionEntity pe2 = new PermissionEntity(entity.toUpperCase() + "ENTITY_READ", "read " + entity);
    		pe2 = permissionManager.Create(pe2);
    		RolepermissionEntity pe2RP = new RolepermissionEntity(pe2.getId(), roleId);
    		rolepermissionManager.Create(pe2RP);
    	}
    	else
    	{
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
    }
    
    <#if (AuthenticationType == "database" || UserOnly)>
    private void addDefaultUser(RoleEntity role) {
    	[=AuthenticationTable]Entity admin = new [=AuthenticationTable]Entity();
        <#if (AuthenticationType == "database" || UserOnly) && ClassName?? && ClassName == AuthenticationTable>  
        <#list Fields as key,value>
		<#if value.isAutogenerated== false && value.isPrimaryKey == true>
		<#if value.fieldType?lower_case == "long">
		admin.set[=value.fieldName?cap_first](1L);
		<#elseif value.fieldType?lower_case == "integer">
		admin.set[=value.fieldName?cap_first](1);
		<#elseif value.fieldType?lower_case == "short">
		admin.set[=value.fieldName?cap_first]((short)1);
		<#elseif value.fieldType?lower_case == "double">
		admin.set[=value.fieldName?cap_first](1D);
		<#elseif value.fieldType?lower_case == "string">
  		admin.set[=value.fieldName?cap_first]("1");
		</#if> 
		</#if> 
		</#list>
        <#if AuthenticationFields??>
  	    <#list AuthenticationFields as authKey,authValue>
  	    <#list Fields as key,value>
        <#if value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "date" || value.fieldType?lower_case == "string">
  	    <#if value.fieldName == authValue.fieldName>
  	    <#if authKey== "Password">
        admin.set[=value.fieldName?cap_first](pEncoder.encode("secret"));
        <#elseif authKey== "UserName">
        admin.set[=value.fieldName?cap_first]("admin");
        <#elseif authKey== "IsActive">
        admin.set[=value.fieldName?cap_first](true);
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
    	<#if AuthenticationType == "oidc">
    	admin.setScimId("scimId");
    	</#if>
    	<#if AuthenticationType == "database">
    	admin.setPassword(pEncoder.encode("secret"));
    	admin.setIsActive(true);
    	</#if>
        </#if> 
    	admin = userManager.Create(admin);
    	[=AuthenticationTable]roleEntity urole = new [=AuthenticationTable]roleEntity();
    	urole.setRoleId(role.getId());
    	<#if !UserInput??>
    	urole.set[=AuthenticationTable]Id(admin.getId());
        <#elseif UserInput??>
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
    </#if>
}
