package [=PackageName].domain.irepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import [=PackageName].domain.model.UserEntity;

@RepositoryRestResource(collectionResourceRel = "user", path = "user")
public interface IUserRepository extends JpaRepository<UserEntity, Long>,QuerydslPredicateExecutor<UserEntity> {

    @Query("select u from UserEntity u where u.userName = ?1")
    UserEntity findByUserName(String value);

}
