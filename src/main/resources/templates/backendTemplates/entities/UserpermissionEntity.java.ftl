package [=PackageName].domain.model;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;

@Entity
@Table(name = "[=AuthenticationTable]permission", schema = "[=SchemaName]")
@IdClass([=AuthenticationTable]permissionId.class)
public class [=AuthenticationTable]permissionEntity implements Serializable {

	private Boolean revoked;
    private Long permissionId;
  	<#if (AuthenticationType!="none" && !UserInput??)>
  	private Long userId;
 	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  	private [=value] [=AuthenticationTable?uncap_first][=key?cap_first];
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
  	public [=AuthenticationTable]permissionEntity() {
  	}
  
  	@Basic
  	@Column(name = "revoked", nullable = true)
  	public Boolean getRevoked() {
    	return revoked;
  	}

  	public void setRevoked(Boolean revoked) {
    	this.revoked = revoked;
  	}

  	@ManyToOne
  	@JoinColumn(name = "permissionId", insertable=false, updatable=false)
  	public PermissionEntity getPermission() {
    	return permission;
  	}
  	public void setPermission(PermissionEntity permission) {
    	this.permission = permission;
  	}
  
  	private PermissionEntity permission;
 
  	@Id
  	@Column(name = "permissionId", nullable = false)
  	public Long getPermissionId() {
  		return permissionId;
  	}

  	public void setPermissionId(Long permissionId){
  		this.permissionId = permissionId;
  	}

  	<#if (AuthenticationType!="none" && !UserInput??)>
  	@Id
  	@Column(name = "userId", nullable = false)
  	public Long getUserId() {
  		return userId;
  	}

  	public void setUserId(Long userId){
  		this.userId = userId;
  	}
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#list PrimaryKeys as key,value>
  	<#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
  	@Id
  	@Column(name = "[=AuthenticationTable?uncap_first][=key?cap_first]", nullable = false)
  	public [=value] get[=AuthenticationTable][=key?cap_first]() {
  		return [=AuthenticationTable?uncap_first][=key?cap_first];
  	}

  	public void set[=AuthenticationTable][=key?cap_first]([=value] [=AuthenticationTable?uncap_first][=key?cap_first]){
  		this.[=AuthenticationTable?uncap_first][=key?cap_first] = [=AuthenticationTable?uncap_first][=key?cap_first];
  	}
  	</#if> 
  	</#list>
  	</#if>
  	</#if>
  
  	@ManyToOne
  	<#if (AuthenticationType!="none" && !UserInput??)>
  	@JoinColumn(name = "[=AuthenticationTable?uncap_first]Id", insertable=false, updatable=false)
  	<#elseif AuthenticationType!="none" && UserInput??>
  	<#if PrimaryKeys??>
  	<#assign i=PrimaryKeys?size>
  	<#if i==1>
  	<#list PrimaryKeys as key,value>
  	@JoinColumn(name = "[=AuthenticationTable?uncap_first][=key?cap_first]", insertable=false, updatable=false)
  	<#break>
  	</#list>
 	<#else>
  	@JoinColumns({<#list PrimaryKeys as key,value><#if key_has_next>@JoinColumn(name="[=AuthenticationTable?uncap_first][=key?cap_first]"<#if value?lower_case !="string">,columnDefinition="[=value?cap_first]"</#if>, referencedColumnName="[=key?uncap_first]", nullable=false, insertable=false, updatable=false),<#else>@JoinColumn(name="[=AuthenticationTable?uncap_first][=key?cap_first]"<#if value?lower_case !="string">, columnDefinition="[=value?cap_first]"</#if>, referencedColumnName="[=key?uncap_first]", nullable=false,insertable=false, updatable=false)</#if></#list>})
  	</#if>
  	</#if>
  	</#if> 
  	public [=AuthenticationTable]Entity get[=AuthenticationTable]() {
    	return [=AuthenticationTable?uncap_first];
  	}
  	public void set[=AuthenticationTable]([=AuthenticationTable]Entity [=AuthenticationTable?uncap_first]) {
    	this.[=AuthenticationTable?uncap_first] = [=AuthenticationTable?uncap_first];
  	}
  
  	private [=AuthenticationTable]Entity [=AuthenticationTable?uncap_first];
 
  
//  @Override
//  public boolean equals(Object o) {
//    if (this == o) return true;
//      if (!(o instanceof UserpermissionEntity)) return false;
//        UserpermissionEntity userpermission = (UserpermissionEntity) o;
//        return id != null && id.equals(userpermission.id);
//  }

}
