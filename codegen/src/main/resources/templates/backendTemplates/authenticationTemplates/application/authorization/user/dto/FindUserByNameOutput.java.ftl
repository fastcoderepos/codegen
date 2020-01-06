package [=PackageName].application.authorization.[=AuthenticationTable?uncap_first].dto;

import java.util.Date;

public class Find[=AuthenticationTable]By<#if AuthenticationFields??><#list AuthenticationFields as authKey,authValue><#if authKey== "UserName">[=authValue.fieldName?cap_first]</#if></#list><#else>Name</#if>Output {

	private Long id;
	private int accessFailedCount;
	private String emailAddress;
	private Boolean isActive;
	private Boolean isEmailConfirmed;
	private Boolean isLockoutEnabled;
	private Boolean isPhoneNumberConfirmed;
	private Date lastLoginTime;
	private Date lockoutEndDateUtc;
	private String firstName;
	private String phoneNumber;
	private Long profilePictureId;
	private Boolean shouldChangePasswordOnNextLogin;
	private String lastName;
	private String userName;
    private String authenticationSource;
    
    public String getAuthenticationSource() {
        return authenticationSource;
    }

    public void setAuthenticationSource(String authenticationSource) {
        this.authenticationSource = authenticationSource;
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

	public Boolean getIsPhoneNumberEnabled() {
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

	public Boolean isShouldChangePasswordOnNextLogin() {
		return shouldChangePasswordOnNextLogin;
	}

	public void setShouldChangePasswordOnNextLogin(Boolean shouldChangePasswordOnNextLogin) {
		this.shouldChangePasswordOnNextLogin = shouldChangePasswordOnNextLogin;
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
