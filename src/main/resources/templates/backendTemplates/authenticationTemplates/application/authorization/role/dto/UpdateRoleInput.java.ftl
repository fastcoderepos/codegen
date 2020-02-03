package [=PackageName].application.authorization.role.dto;

import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;

public class UpdateRoleInput {
	
	@NotNull(message = "Id Should not be null")
	private Long id;
    
    @NotNull(message = "Display Name Should not be null")
    @Length(max = 128, message = "Display Name must be less than 128 characters")
    private String displayName;
    
    @NotNull(message = "Name Should not be null")
    @Length(max = 128, message = "Name must be less than 128 characters")
    private String name;

    <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
    @NotNull(message = "ScimId Should not be null")
    @Length(max = 36, message = "ScimId must be less than 36 characters")
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
    
    <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
    public String getScimId() {
        return scimId;
    }

    public void setScimId(String scimId) {
        this.scimId = scimId;
    }
    
    </#if>
}
