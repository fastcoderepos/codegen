package [=PackageName].domain.irepository;

import [=PackageName].domain.model.[=AuthenticationTable]roleId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import java.util.List;
import [=PackageName].domain.model.[=AuthenticationTable]roleEntity;

@RepositoryRestResource(collectionResourceRel = "[=AuthenticationTable?uncap_first]role", path = "[=AuthenticationTable?uncap_first]role")
public interface I[=AuthenticationTable]roleRepository extends JpaRepository<[=AuthenticationTable]roleEntity, [=AuthenticationTable]roleId>,QuerydslPredicateExecutor<[=AuthenticationTable]roleEntity> {
//    @Query("select e from [=AuthenticationTable]roleEntity e where e.roleId = ?1 and e.[=AuthenticationTable?uncap_first]Id = ?2")
//	[=AuthenticationTable]roleEntity findById(Long roleId,Long [=AuthenticationTable?uncap_first]Id);
}
