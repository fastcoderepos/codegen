package [=PackageName].domain.model;

import javax.persistence.*;
import org.hibernate.annotations.GenericGenerator;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Role", schema = "[=SchemaName]")
public class RoleEntity implements Serializable {

    private Long id;
    private String displayName;
    private String name;
    <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
    private String scimId;
    </#if>

    @Id
    @Column(name = "Id", nullable = false)
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "native")
    @GenericGenerator(name = "native", strategy = "native")
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

 	<#if (AuthenticationType == "oidc" && UsersOnly == "false")>
 	@Basic
    @Column(name = "ScimId", nullable = false, length = 36, unique = true)
    public String ScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    
    </#if>
    @Basic
    @Column(name = "DisplayName", nullable = false, length = 128)
    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Basic
    @Column(name = "Name", nullable = false, length = 128)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RoleEntity)) return false;
        RoleEntity role = (RoleEntity) o;
        return id != null && id.equals(role.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<RolepermissionEntity> getRolepermissionSet() { 
      return rolepermissionSet; 
    } 
 
    public void setRolepermissionSet(Set<RolepermissionEntity> rolepermission) { 
      this.rolepermissionSet = rolepermission; 
    } 
 
    private Set<RolepermissionEntity> rolepermissionSet = new HashSet<RolepermissionEntity>(); 
  
<#if AuthenticationType == "database" || (AuthenticationType != "database" && (UsersOnly?? && UsersOnly == "true"))>
    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<[=AuthenticationTable]roleEntity> get[=AuthenticationTable]roleSet() { 
      return [=AuthenticationTable?uncap_first]roleSet; 
    } 
 
    public void set[=AuthenticationTable]roleSet(Set<[=AuthenticationTable]roleEntity> [=AuthenticationTable?uncap_first]role) { 
      this.[=AuthenticationTable?uncap_first]roleSet = [=AuthenticationTable?uncap_first]role; 
    } 
 
    private Set<[=AuthenticationTable]roleEntity> [=AuthenticationTable?uncap_first]roleSet = new HashSet<[=AuthenticationTable]roleEntity>(); 
</#if>
    public RoleEntity() {

    }

}
