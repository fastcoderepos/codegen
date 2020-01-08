package [=PackageName].domain.authorization.role;

import java.util.Optional;
import [=PackageName].domain.model.RoleEntity;
import [=PackageName].domain.irepository.IRolepermissionRepository;
import [=PackageName].domain.irepository.IRoleRepository;
import com.querydsl.core.types.Predicate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

@Repository
public class RoleManager implements IRoleManager {

    @Autowired
    IRoleRepository  _roleRepository;
    
    @Autowired
	IRolepermissionRepository  _rolepermissionRepository;
    
	public RoleEntity Create(RoleEntity role) {

		return _roleRepository.save(role);
	}

	public void Delete(RoleEntity role) {

		_roleRepository.delete(role);	
	}

	public RoleEntity Update(RoleEntity role) {

		return _roleRepository.save(role);
	}
	
	// Internal Operations
	public RoleEntity FindByRoleName(String roleName) {
		return _roleRepository.findByRoleName(roleName);
	}

	public RoleEntity FindById(Long  roleId)
    {
    Optional<RoleEntity> dbRole= _roleRepository.findById(roleId);
		if(dbRole.isPresent()) {
			RoleEntity existingRole = dbRole.get();
		    return existingRole;
		} else {
		    return null;
		}
	}

	public Page<RoleEntity> FindAll(Predicate predicate, Pageable pageable) {

		return _roleRepository.findAll(predicate,pageable);
	}

}
