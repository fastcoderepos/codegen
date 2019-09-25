package [=PackageName].domain.Flowable.Users;

import java.io.Serializable;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;
import java.util.Date;

import [=PackageName].domain.Flowable.Groups.ActIdGroupEntity;

@Entity
@Table(name = "act_id_user", schema = "dbo")
public class ActIdUserEntity  implements Serializable {

private String displayName;
private String email;
private String first;
private String id;
private String last;
private String pictureId;
private String pwd;
private Long rev;
private String tenantId;

@ManyToMany(cascade = {CascadeType.ALL})
@JoinTable(name = "act_id_membership", schema = "dbo",
joinColumns = {@JoinColumn(name = "user_id_", referencedColumnName = "id_")},
inverseJoinColumns = {@JoinColumn(name = "group_id_", referencedColumnName = "id_")})
public Set<ActIdGroupEntity> getActIdGroup() {
    return actIdGroup;
    }
    public void setActIdGroup(Set<ActIdGroupEntity> actIdGroup) {
        this.actIdGroup = actIdGroup;
        }
        private Set<ActIdGroupEntity> actIdGroup = new HashSet<>();

            @Basic
            @Column(name = "display_name_", nullable = true, length =255)
            public String getDisplayName() {
            return displayName;
            }

            public void setDisplayName(String displayName){
            this.displayName = displayName;
            }


            @Basic
            @Column(name = "email_", nullable = true, length =255)
            public String getEmail() {
            return email;
            }

            public void setEmail(String email){
            this.email = email;
            }


            @Basic
            @Column(name = "first_", nullable = true, length =255)
            public String getFirst() {
            return first;
            }

            public void setFirst(String first){
            this.first = first;
            }


            @Id
            @Column(name = "id_", nullable = false, length =64)
            public String getId() {
            return id;
            }

            public void setId(String id){
            this.id = id;
            }


            @Basic
            @Column(name = "last_", nullable = true, length =255)
            public String getLast() {
            return last;
            }

            public void setLast(String last){
            this.last = last;
            }


            @Basic
            @Column(name = "picture_id_", nullable = true, length =64)
            public String getPictureId() {
            return pictureId;
            }

            public void setPictureId(String pictureId){
            this.pictureId = pictureId;
            }


            @Basic
            @Column(name = "pwd_", nullable = true, length =255)
            public String getPwd() {
            return pwd;
            }

            public void setPwd(String pwd){
            this.pwd = pwd;
            }

            @Basic
            @Column(name = "rev_", nullable = true)
            public Long getRev() {
            return rev;
            }

            public void setRev(Long rev){
            this.rev = rev;
            }


            @Basic
            @Column(name = "tenant_id_", nullable = true, length =255)
            public String getTenantId() {
            return tenantId;
            }

            public void setTenantId(String tenantId){
            this.tenantId = tenantId;
            }

            @Override
            public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof ActIdUserEntity)) return false;
            ActIdUserEntity actiduser = (ActIdUserEntity) o;
            return id != null && id.equals(actiduser.id);
            }
            }





