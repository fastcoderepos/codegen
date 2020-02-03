package [=PackageName].domain.irepository; 
 
import [=PackageName].domain.model.JwtEntity; 
import org.springframework.data.jpa.repository.JpaRepository; 
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query; 
 
import java.util.List; 
 
public interface IJwtRepository extends JpaRepository<JwtEntity, Long> { 

    JwtEntity findByToken(String token); 
    
    @Modifying
    @Query("delete from JwtEntity u where UPPER(u.userName) = UPPER(?1)") 
    void DeleteByUserName(String userName); 
} 