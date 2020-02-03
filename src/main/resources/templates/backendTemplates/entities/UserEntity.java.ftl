package [=PackageName].domain.model;

import [=PackageName].domain.model.RoleEntity;
import org.hibernate.validator.constraints.Length;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "User", schema = "[=SchemaName]")
public class  UserEntity implements Serializable {

    private Long id;
    private String firstName;
    private String lastName;
    private String emailAddress;
    private String userName;
    <#if AuthenticationType == "database">
    private String password;
    private String passwordResetCode;
    private Boolean shouldChangePasswordOnNextLogin;
    </#if>
    <#if AuthenticationType == "oidc">
    private String scimId;
    </#if>
    private String phoneNumber;
    private Long profilePictureId;
    private Date lastLoginTime;
    private Integer accessFailedCount;
    private String authenticationSource;
    private Boolean isEmailConfirmed;
    private String emailConfirmationCode;
    private Boolean isActive;
    private Boolean isLockoutEnabled;
    private Date lockoutEndDateUtc;
    private String isPhoneNumberConfirmed;
    private Boolean isTwoFactorEnabled;

    @Id
    @Column(name = "Id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public Long getId() {
        return id;
    }
F
    public void setId(Long id) {
        this.id = id;
    }

    @Basic
    @Column(name = "AccessFailedCount", nullable = true)
    public Integer getAccessFailedCount() {
        return accessFailedCount;
    }

    public void setAccessFailedCount(Integer accessFailedCount) {
        this.accessFailedCount = accessFailedCount;
    }

    @Basic
    @Column(name = "AuthenticationSource", nullable = true, length = 64)
    public String getAuthenticationSource() {
        return authenticationSource;
    }

    public void setAuthenticationSource(String authenticationSource) {
        this.authenticationSource = authenticationSource;
    }

    @Basic
    @Column(name = "EmailAddress", nullable = false, length = 256)
    @Email
    @NotNull
    @Length(max = 256, message = "The field must be less than 256 characters")
    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    @Basic
    @Column(name = "EmailConfirmationCode", nullable = true, length = 328)
    public String getEmailConfirmationCode() {
        return emailConfirmationCode;
    }

    public void setEmailConfirmationCode(String emailConfirmationCode) {
        this.emailConfirmationCode = emailConfirmationCode;
    }

    @Basic
    @Column(name = "IsActive", nullable = false)
    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    @Basic
    @Column(name = "IsEmailConfirmed", nullable = true)
    public Boolean getIsEmailConfirmed() {
        return isEmailConfirmed;
    }

    public void setIsEmailConfirmed(Boolean emailConfirmed) {
        isEmailConfirmed = emailConfirmed;
    }

    @Basic
    @Column(name = "IsLockoutEnabled", nullable = true)
    public Boolean getIsLockoutEnabled() {
        return isLockoutEnabled;
    }

    public void setIsLockoutEnabled(Boolean lockoutEnabled) {
        isLockoutEnabled = lockoutEnabled;
    }

    @Basic
    @Column(name = "LastLoginTime", nullable = true)
    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    @Basic
    @Column(name = "LockoutEndDateUtc", nullable = true)
    public Date getLockoutEndDateUtc() {
        return lockoutEndDateUtc;
    }

    public void setLockoutEndDateUtc(Date lockoutEndDateUtc) {
        this.lockoutEndDateUtc = lockoutEndDateUtc;
    }

    @Basic
    @Column(name = "FirstName", nullable = false, length = 32)
    @NotNull
    @Length(max = 32, message = "The field must be less than 32 characters")
    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    <#if AuthenticationType == "oidc">
   
    @Basic
    @Column(name = "ScimId", nullable = false, length = 36, unique = true)
    public String getScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    </#if>
    <#if AuthenticationType == "database">

    @Basic
    @Column(name = "Password", nullable = true, length = 128)
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    @Basic
    @Column(name = "PasswordResetCode", nullable = true, length = 328)
    public String getPasswordResetCode() {
        return passwordResetCode;
    }

    public void setPasswordResetCode(String passwordResetCode) {
        this.passwordResetCode = passwordResetCode;
    }
    
    @Basic
    @Column(name = "ShouldChangePasswordOnNextLogin", nullable = true)
    public Boolean ShouldChangePasswordOnNextLogin() {
        return shouldChangePasswordOnNextLogin;
    }

    public void setShouldChangePasswordOnNextLogin(Boolean shouldChangePasswordOnNextLogin) {
        this.shouldChangePasswordOnNextLogin = shouldChangePasswordOnNextLogin;
    }
    
</#if>
    @Basic
    @Column(name = "PhoneNumber", nullable = true, length = 32)
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Basic
    @Column(name = "ProfilePictureId", nullable = true)
    public Long getProfilePictureId() {
        return profilePictureId;
    }

    public void setProfilePictureId(Long profilePictureId) {
        this.profilePictureId = profilePictureId;
    }

    @Basic
    @Column(name = "LastName", nullable = false, length = 32)
    @NotNull
    @Length(max = 32, message = "The field must be less than 32 characters")
    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Basic
    @Column(name = "UserName", nullable = false, length = 32, unique = true)
    @NotNull
    @Length(max = 32, message = "The field must be less than 32 characters")
    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    @Basic
    @Column(name = "IsPhoneNumberConfirmed", nullable = true)
    public String getIsPhoneNumberConfirmed() {
        return isPhoneNumberConfirmed;
    }

    public void setIsPhoneNumberConfirmed(String isPhoneNumberConfirmed) {
        this.isPhoneNumberConfirmed = isPhoneNumberConfirmed;
    }

    @Basic
    @Column(name = "TwoFactorEnabled", nullable = true)
    public Boolean getIsTwoFactorEnabled() {
        return isTwoFactorEnabled;
    }

    public void setIsTwoFactorEnabled(Boolean isTwoFactorEnabled) {
        this.isTwoFactorEnabled = isTwoFactorEnabled;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof UserEntity)) return false;
        UserEntity user = (UserEntity) o;
        return id != null && id.equals(user.id);
    }

    @Override
    public int hashCode() {
        return 31;
    }

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<UserpermissionEntity> getUserpermissionSet() { 
       return userpermissionSet; 
    } 
 
    public void setUserpermissionSet(Set<UserpermissionEntity> userpermission) { 
      this.userpermissionSet = userpermission; 
    } 
 
    private Set<UserpermissionEntity> userpermissionSet = new HashSet<UserpermissionEntity>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true) 
    public Set<UserroleEntity> getUserroleSet() { 
      return userroleSet; 
    } 
 
    public void setUserroleSet(Set<UserroleEntity> userrole) { 
      this.userroleSet = userrole; 
    } 
 
    private Set<UserroleEntity> userroleSet = new HashSet<UserroleEntity>(); 
    
}
