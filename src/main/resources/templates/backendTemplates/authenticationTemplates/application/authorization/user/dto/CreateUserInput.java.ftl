package [=PackageName].application.authorization.user.dto;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;
import java.util.Date;
import org.hibernate.validator.constraints.Length;

public class CreateUserInput {

  private Integer accessFailedCount;
  
  @Length(max = 64, message = "authenticationSource must be less than 64 characters")
  private String authenticationSource;
  
  @NotNull(message = "emailAddress Should not be null")
  @Length(max = 256, message = "emailAddress must be less than 256 characters")
  @Email(message = "Email Address should be valid ")
  private String emailAddress;
  
  @Length(max = 328, message = "emailConfirmationCode must be less than 328 characters")
  private String emailConfirmationCode;
  
  @NotNull(message = "firstName Should not be null")
  @Length(max = 32, message = "firstName must be less than 32 characters")
  private String firstName;
  
  <#if AuthenticationType =="oidc">
  @NotNull(message = "ScimId Should not be null")
  @Length(max = 36, message = "scimId must be less than 36 characters")
  private String scimId;
  
  </#if>
  @NotNull(message = "isActive Should not be null")
  private Boolean isActive;
  
  private Boolean isEmailConfirmed;
  
  private Boolean isLockoutEnabled;
  
  @Length(max = 255, message = "isPhoneNumberConfirmed must be less than 255 characters")
  private String isPhoneNumberConfirmed;
  
  private Date lastLoginTime;
  
  @NotNull(message = "lastName Should not be null")
  @Length(max = 32, message = "lastName must be less than 32 characters")
  private String lastName;
  
  private Date lockoutEndDateUtc;
  
  <#if AuthenticationType =="database">
  @NotNull(message = "password Should not be null")
  @Length(max = 128, message = "password must be less than 128 characters")
  private String password;
  
  @Length(max = 328, message = "passwordResetCode must be less than 328 characters")
  private String passwordResetCode;
  </#if>
  
  @Length(max = 32, message = "phoneNumber must be less than 32 characters")
  private String phoneNumber;
  
  private Long profilePictureId;
  
  private Boolean twoFactorEnabled;
  
  @NotNull(message = "userName Should not be null")
  @Length(max = 32, message = "userName must be less than 32 characters")
  private String userName;
  
  public Integer getAccessFailedCount() {
  return accessFailedCount;
  }

  public void setAccessFailedCount(Integer accessFailedCount){
  this.accessFailedCount = accessFailedCount;
  }
  
  public String getAuthenticationSource() {
  return authenticationSource;
  }

  public void setAuthenticationSource(String authenticationSource){
  this.authenticationSource = authenticationSource;
  }
  
  public String getEmailAddress() {
  return emailAddress;
  }

  public void setEmailAddress(String emailAddress){
  this.emailAddress = emailAddress;
  }
  
  public String getEmailConfirmationCode() {
  return emailConfirmationCode;
  }

  public void setEmailConfirmationCode(String emailConfirmationCode){
  this.emailConfirmationCode = emailConfirmationCode;
  }
  
  public String getFirstName() {
  return firstName;
  }

  public void setFirstName(String firstName){
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
  
  public Boolean getIsActive() {
  return isActive;
  }

  public void setIsActive(Boolean isActive){
  this.isActive = isActive;
  }
  
  public Boolean getIsEmailConfirmed() {
  return isEmailConfirmed;
  }

  public void setIsEmailConfirmed(Boolean isEmailConfirmed){
  this.isEmailConfirmed = isEmailConfirmed;
  }
  
  public Boolean getIsLockoutEnabled() {
  return isLockoutEnabled;
  }

  public void setIsLockoutEnabled(Boolean isLockoutEnabled){
  this.isLockoutEnabled = isLockoutEnabled;
  }
  
  public String getIsPhoneNumberConfirmed() {
  return isPhoneNumberConfirmed;
  }

  public void setIsPhoneNumberConfirmed(String isPhoneNumberConfirmed){
  this.isPhoneNumberConfirmed = isPhoneNumberConfirmed;
  }
  
  public Date getLastLoginTime() {
  return lastLoginTime;
  }

  public void setLastLoginTime(Date lastLoginTime){
  this.lastLoginTime = lastLoginTime;
  }
  
  public String getLastName() {
  return lastName;
  }

  public void setLastName(String lastName){
  this.lastName = lastName;
  }
  
  public Date getLockoutEndDateUtc() {
  return lockoutEndDateUtc;
  }

  public void setLockoutEndDateUtc(Date lockoutEndDateUtc){
  this.lockoutEndDateUtc = lockoutEndDateUtc;
  }
  <#if AuthenticationType =="database">
  public String getPassword() {
  return password;
  }

  public void setPassword(String password){
  this.password = password;
  }
  
  public String getPasswordResetCode() {
  return passwordResetCode;
  }

  public void setPasswordResetCode(String passwordResetCode){
  this.passwordResetCode = passwordResetCode;
  }
  </#if>
  
  public String getPhoneNumber() {
  return phoneNumber;
  }

  public void setPhoneNumber(String phoneNumber){
  this.phoneNumber = phoneNumber;
  }
  
  public Long getProfilePictureId() {
  return profilePictureId;
  }

  public void setProfilePictureId(Long profilePictureId){
  this.profilePictureId = profilePictureId;
  }
  
  public Boolean getTwoFactorEnabled() {
  return twoFactorEnabled;
  }

  public void setTwoFactorEnabled(Boolean twoFactorEnabled){
  this.twoFactorEnabled = twoFactorEnabled;
  }
  
  public String getUserName() {
  return userName;
  }

  public void setUserName(String userName){
  this.userName = userName;
  }
}
