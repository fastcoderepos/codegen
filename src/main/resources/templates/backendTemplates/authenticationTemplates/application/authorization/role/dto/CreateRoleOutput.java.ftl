package [=PackageName].application.authorization.role.dto;

public class CreateRoleOutput {
    private Long id;
    private String displayName;
    private String name;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
    public String getScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    
    </#if>
}

