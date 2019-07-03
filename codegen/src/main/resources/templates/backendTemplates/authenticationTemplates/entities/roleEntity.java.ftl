package [=PackageName].domain.model;

<#if Audit!false>
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import [=PackageName].Audit.AuditedEntity;
</#if>

import javax.persistence.*;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "Roles")
<#if Audit!false>
@EntityListeners(AuditingEntityListener.class)
</#if>

public class RolesEntity <#if Audit!false>extends AuditedEntity<String></#if> implements Serializable {

    private Long id;
    private String displayName;
    private String name;

    @Id
    @Column(name = "Id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "DisplayName", nullable = true, length = 64)
    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    @Basic
    @Column(name = "Name", nullable = false, length = 32)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof RolesEntity)) return false;
        RolesEntity role = (RolesEntity) o;
        return id != null && id.equals(role.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @ManyToMany(cascade = {CascadeType.ALL})
    @JoinTable(name = "RolesPermissions", schema = "[=Schema]",
            joinColumns = {@JoinColumn(name = "RoleId", referencedColumnName = "Id")},
            inverseJoinColumns = {@JoinColumn(name = "PermissionId", referencedColumnName = "Id")})
    public Set<PermissionsEntity> getPermissions() {
        return permissions;
    }

    public void setPermissions(Set<PermissionsEntity> permissions) {
        this.permissions = permissions;
    }

    private Set<PermissionsEntity> permissions = new HashSet<>();
    
<#if AuthenticationType == "database">
    @OneToMany(mappedBy = "role", cascade = CascadeType.ALL, orphanRemoval = true)
    public Set<UsersEntity> getUsers() {
        return users;
    }

    public void setUsers(Set<UsersEntity> users) {
        this.users = users;
    }

    private Set<UsersEntity> users = new HashSet<UsersEntity>();
</#if>
    public RolesEntity() {

    }

}