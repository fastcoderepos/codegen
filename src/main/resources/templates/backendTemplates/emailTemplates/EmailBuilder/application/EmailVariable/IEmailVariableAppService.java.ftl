package [=PackageName].application.EmailVariable;

import java.util.List;

import javax.validation.constraints.Positive;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.EmailVariable.Dto.*;


@Service
public interface IEmailVariableAppService {

	CreateEmailVariableOutput Create(CreateEmailVariableInput email);

    void Delete(@Positive(message ="EmailId should be a positive value")Long eid);

    UpdateEmailVariableOutput Update(@Positive(message ="EmailId should be a positive value") Long eid,UpdateEmailVariableInput email);

    FindEmailVariableByIdOutput FindById(@Positive(message ="EmailId should be a positive value")Long eid);

    FindEmailVariableByNameOutput FindByName(String name);
    
    List<FindEmailVariableByIdOutput> Find(SearchCriteria search,Pageable pageable) throws Exception;
	
}
