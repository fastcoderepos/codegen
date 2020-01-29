package [=PackageName].security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import [=PackageName].domain.irepository.IJwtRepository;

@Service
public class JWTAppService {

	@Autowired
 	private IJwtRepository _jwtRepository;
	
	
	@Transactional(propagation = Propagation.REQUIRED)
	public void deleteAllUserTokens(String userName) {
		 
        _jwtRepository.DeleteByUserName(userName);

    }
}