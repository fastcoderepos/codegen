package [=PackageName].application.authorization.role.dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class CreateRoleInput {
  
	@NotNull(message = "Display Name Should not be null")
    @Length(max = 128, message = "Display Name must be less than 128 characters")
    private String displayName;
    
    <#if (AuthenticationType == "oidc" && !UserOnly)>
    @NotNull(message = "ScimId Should not be null")
    @Length(max = 36, message = "ScimId must be less than 36 characters")
    private String scimId;
    
    </#if>
	@NotNull(message = "Name Should not be null")
	@Length(max = 128, message = "Name must be less than 128 characters")
    private String name;

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
    
    <#if (AuthenticationType == "oidc" && !UserOnly)>
    public String getScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    
    </#if>
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}
