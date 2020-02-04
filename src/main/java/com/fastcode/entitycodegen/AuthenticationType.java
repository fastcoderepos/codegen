package com.fastcode.entitycodegen;

public enum AuthenticationType {
	DATABASE ("database"), OIDC("oidc"), LDAP("ldap"), NONE("none");

    private final String name;       

    private AuthenticationType(String s) {
        name = s;
    }
    
    public String getName() {
        return name;
    }

};
