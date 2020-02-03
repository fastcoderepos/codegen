package [=PackageName].application.authorization.user.dto;

import java.sql.Date;

public class CreateUserOutput {

    private Long id;
    private int accessFailedCount;
    private String emailAddress;
    private String emailConfirmationCode;
    private Boolean isActive;
    private Boolean isEmailConfirmed;
    private Boolean isLockoutEnabled;
    private Boolean isPhoneNumberConfirmed;
    private Date lastLoginTime;
    private Date lockoutEndDateUtc;
    private String firstName;
    <#if AuthenticationType =="oidc">
    private String scimId;
    </#if>
    <#if AuthenticationType =="database">
    private String passwordResetCode;
    private Boolean shouldChangePasswordOnNextLogin;
    </#if>
    private String phoneNumber;
    private Long profilePictureId;
    private String signInToken;
    private Date signInTokenExpireTimeUtc;
    private String lastName;
    private String userName;
    
    public CreateUserOutput() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public int getAccessFailedCount() {
        return accessFailedCount;
    }

    public void setAccessFailedCount(int accessFailedCount) {
        this.accessFailedCount = accessFailedCount;
    }

    public String getEmailAddress() {
        return emailAddress;
    }

    public void setEmailAddress(String emailAddress) {
        this.emailAddress = emailAddress;
    }

    public String getEmailConfirmationCode() {
        return emailConfirmationCode;
    }

    public void setEmailConfirmationCode(String emailConfirmationCode) {
        this.emailConfirmationCode = emailConfirmationCode;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean active) {
        isActive = active;
    }

    public Boolean getIsEmailConfirmed() {
        return isEmailConfirmed;
    }

    public void setIsEmailConfirmed(Boolean emailConfirmed) {
        isEmailConfirmed = emailConfirmed;
    }

    public Boolean getIsLockoutEnabled() {
        return isLockoutEnabled;
    }

    public void setIsLockoutEnabled(Boolean lockoutEnabled) {
        isLockoutEnabled = lockoutEnabled;
    }

    public Boolean getIsPhoneNumberConfirmed() {
        return isPhoneNumberConfirmed;
    }

    public void setIsPhoneNumberConfirmed(Boolean phoneNumberConfirmed) {
        isPhoneNumberConfirmed = phoneNumberConfirmed;
    }

    public Date getLastLoginTime() {
        return lastLoginTime;
    }

    public void setLastLoginTime(Date lastLoginTime) {
        this.lastLoginTime = lastLoginTime;
    }

    public Date getLockoutEndDateUtc() {
        return lockoutEndDateUtc;
    }

    public void setLockoutEndDateUtc(Date lockoutEndDateUtc) {
        this.lockoutEndDateUtc = lockoutEndDateUtc;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    <#if AuthenticationType =="oidc">
  
  	public String getScimId() {
  		return scimId;
  	}

  	public void setScimId(String scimId){
  		this.scimId = scimId;
  	}
  	</#if>
	<#if AuthenticationType =="database">
    public String getPasswordResetCode() {
        return passwordResetCode;
    }

    public void setPasswordResetCode(String passwordResetCode) {
        this.passwordResetCode = passwordResetCode;
    }
    
    public Boolean isShouldChangePasswordOnNextLogin() {
        return shouldChangePasswordOnNextLogin;
    }

    public void setShouldChangePasswordOnNextLogin(Boolean shouldChangePasswordOnNextLogin) {
        this.shouldChangePasswordOnNextLogin = shouldChangePasswordOnNextLogin;
    }
	</#if>
    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Long getProfilePictureId() {
        return profilePictureId;
    }

    public void setProfilePictureId(Long profilePictureId) {
        this.profilePictureId = profilePictureId;
    }

    public String getSignInToken() {
        return signInToken;
    }

    public void setSignInToken(String signInToken) {
        this.signInToken = signInToken;
    }

    public Date getSignInTokenExpireTimeUtc() {
        return signInTokenExpireTimeUtc;
    }

    public void setSignInTokenExpireTimeUtc(Date signInTokenExpireTimeUtc) {
        this.signInTokenExpireTimeUtc = signInTokenExpireTimeUtc;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }
    <#if Audit!false>
    
    public java.util.Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(java.util.Date creationTime) {
      	this.creationTime = creationTime;
    }

    public String getLastModifierUserId() {
      	return lastModifierUserId;
    }

    public void setLastModifierUserId(String lastModifierUserId) {
      	this.lastModifierUserId = lastModifierUserId;
    }

    public java.util.Date getLastModificationTime() {
      	return lastModificationTime;
    }

    public void setLastModificationTime(java.util.Date lastModificationTime) {
      	this.lastModificationTime = lastModificationTime;
    }

    public String getCreatorUserId() {
      	return creatorUserId;
    }

    public void setCreatorUserId(String creatorUserId) {
      	this.creatorUserId = creatorUserId;
    }
    </#if>
}
