package com.fastcode.entitycodegen;

public class AuthenticationInfo {
	private String authenticationTable;
	private AuthenticationType authenticationType;
	private String logonName;
	private Boolean userOnly =false;
	
	public String getAuthenticationTable() {
		return authenticationTable;
	}
	public void setAuthenticationTable(String authenticationTable) {
		this.authenticationTable = authenticationTable;
	}
	public AuthenticationType getAuthenticationType() {
		return authenticationType;
	}
	public void setAuthenticationType(AuthenticationType authenticationType) {
		this.authenticationType = authenticationType;
	}
	public String getLogonName() {
		return logonName;
	}
	public void setLogonName(String logonName) {
		this.logonName = logonName;
	}
	public Boolean getUserOnly() {
		return userOnly;
	}
	public void setUserOnly(Boolean userOnly) {
		this.userOnly = userOnly;
	}
}
