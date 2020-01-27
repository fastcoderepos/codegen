package [=PackageName].domain.irepository; 
 
import [=PackageName].domain.model.JwtEntity; 
import org.springframework.data.jpa.repository.JpaRepository; 
import org.springframework.data.jpa.repository.Query; 
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query; 
 
import java.util.List; 
 
public interface IJwtRepository extends JpaRepository<JwtEntity, Long> { 
    @Query("select j from JwtEntity j where j.id = ?1") 
    JwtEntity findById(long id); 
 
    @Query("select j from JwtEntity j where UPPER(j.userName) = UPPER(?1)") 
    List<JwtEntity> findByUserName(String value); 
 
    JwtEntity findByToken(String token); 
    
    @Modifying
    @Query("delete from JwtEntity u where UPPER(u.userName) = UPPER(?1)") 
    void DeleteByUserName(String userName); 
} 