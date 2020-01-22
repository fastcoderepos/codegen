package [=PackageName].restcontrollers; 
 
import [=PackageName].security.JWTAppService;
import [=CommonModulePackage].domain.EmptyJsonResponse;
import org.springframework.beans.factory.annotation.Autowired; 
import org.springframework.http.HttpStatus; 
import org.springframework.http.ResponseEntity; 
import org.springframework.security.core.context.SecurityContextHolder; 
import org.springframework.web.bind.annotation.RequestMapping; 
import org.springframework.web.bind.annotation.RequestMethod; 
import org.springframework.web.bind.annotation.RestController; 
 
@RestController 
@RequestMapping("/auth") 
public class LoginController { 

    @Autowired 
    private JWTAppService _jwtAppService; 
 
    @RequestMapping(value = "/logout", method = RequestMethod.POST) 
    public ResponseEntity logout() throws Exception{ 
 
         String userName = SecurityContextHolder.getContext().getAuthentication().getName(); 
        _jwtAppService.deleteAllUserTokens(userName);
        
        return new ResponseEntity(new EmptyJsonResponse(), HttpStatus.OK); 
    } 
 

//    @RequestMapping("/oidc") 
//    public void securedPageOIDC(Model model, OAuth2AuthenticationToken authentication) { 
// 
//        connection.getJwtToken((List<String>) authentication.getPrincipal().getAttributes().get("groups"), (String) authentication.getPrincipal().getAttributes().get("preferred_username")); 
// 
//    } 

 
 
} 