package [=PackageName].domain.model; 
 
import org.hibernate.validator.constraints.Length; 
<#if Cache!false>
import org.springframework.data.redis.core.RedisHash; 
import org.springframework.data.redis.core.index.Indexed; 
</#if>
import javax.persistence.*; 
import javax.validation.constraints.Email; 
import javax.validation.constraints.NotNull; 
import java.io.Serializable; 
 
<#if Cache!false>
@RedisHash("JwtEntity") 
<#else>
@Entity
@Table(indexes =  @Index(name = "idx",columnList = "token",unique = false),
		name = "JwtEntity", schema = "[=SchemaName]")
</#if>
public class JwtEntity implements Serializable { 
 
    private Long id; 
    private String userName; 
    private <#if Cache!false>@Indexed</#if>String token; 
    
    @Id 
    @Column(name = "Id", nullable = false) 
    @GeneratedValue(strategy = GenerationType.IDENTITY) 
    public Long getId() { 
        return id; 
    } 
    public void setId(Long id) { 
        this.id = id; 
    } 
 
    @Basic 
    @Column(name = "UserName", nullable = false, length = 32) 
    @NotNull 
    @Length(max = 32, message = "The field must be less than 32 characters") 
    public String getUserName() { 
        return userName; 
    } 
    public void setUserName(String userName) { 
        this.userName = userName; 
    } 
 
    @Basic 
    @Column(name = "Token", nullable = false, length=2000) 
    @NotNull 
    @Length(max = 2000, message = "The field must be less than 2147483647 characters") 
    public String getToken() { 
        return token; 
    } 
    public void setToken(String token) { 
        this.token = token; 
    } 
 
    @Override 
    public boolean equals(Object o) { 
        if (this == o) return true; 
        if (!(o instanceof JwtEntity)) return false; 
        JwtEntity jwt = (JwtEntity) o; 
        return id != null && id.equals(jwt.id); 
    } 
 
    @Override 
    public int hashCode() { 
        return 31; 
    } 
 
} 