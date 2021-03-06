package [=PackageName].application.authorization.role.dto;

public class FindRoleByIdOutput {
    private Long id;
    private String displayName;
    private String name;
    <#if (AuthenticationType == "oidc" && !UserOnly)>
    private String scimId;
    </#if>

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
    
    <#if (AuthenticationType == "oidc" && !UserOnly)>
    public String getScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    
    </#if>

}