package [=PackageName].application.Authorization.Rolepermission;

import java.util.List;

import [=PackageName].domain.model.RolepermissionId;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import [=CommonModulePackage].Search.SearchCriteria;
import [=PackageName].application.Authorization.Rolepermission.Dto.*;

@Service
public interface IRolepermissionAppService {

	CreateRolepermissionOutput Create(CreateRolepermissionInput rolepermission);

    void Delete(RolepermissionId rolepermissionId );

    UpdateRolepermissionOutput Update(RolepermissionId rolepermissionId , UpdateRolepermissionInput input);

    FindRolepermissionByIdOutput FindById(RolepermissionId rolepermissionId );

    List<FindRolepermissionByIdOutput> Find(SearchCriteria search, Pageable pageable) throws Exception;
	
	public RolepermissionId parseRolepermissionKey(String keysString);
    //Permission
    GetPermissionOutput GetPermission(RolepermissionId rolepermissionId );
    //Role
    GetRoleOutput GetRole(RolepermissionId rolepermissionId );
}
