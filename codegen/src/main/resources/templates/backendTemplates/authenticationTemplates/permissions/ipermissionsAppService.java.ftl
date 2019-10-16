package [=PackageName].application.Authorization.Permission;

import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Permission.Dto.*;

import javax.validation.constraints.Positive;

import java.util.List;

@Service
public interface IPermissionAppService {
    // CRUD Operations
    CreatePermissionOutput Create(CreatePermissionInput input);

    void Delete(@Positive(message ="permissionId should be a positive value") Long pid);

    UpdatePermissionOutput Update(@Positive(message ="permissionId should be a positive value")Long permissionId, UpdatePermissionInput input);

    FindPermissionByIdOutput FindById(@Positive(message ="permissionId should be a positive value") Long pid);

    List<FindPermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;

}
