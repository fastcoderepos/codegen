import { Injectable } from '@angular/core';
import { environment } from 'src/environments/environment';
import { IPermission } from '../permission';
import { IGlobalPermissionService, ITokenDetail } from 'projects/fast-code-core/src/public_api';
import { AuthenticationService } from './authentication.service';

@Injectable()
export class GlobalPermissionService implements IGlobalPermissionService {

  public authUrl = environment.authUrl;
  private userPermissions: IPermission[];
  constructor(private authService: AuthenticationService) {
  }

  hasPermissionOnEntity(entity: string, crudType: string): Boolean {
    if (!entity) {
      return false;
    }
    let tokenDetails: ITokenDetail = this.authService.decodeToken();
    if (!tokenDetails) {
      return false;
    }
    crudType = crudType != "READ" ? crudType : crudType + "|" + "CREATE" + "|" + "UPDATE" + "|" + "DELETE";
    let filtered = tokenDetails.scopes.filter(perm => {
      var entityRg = new RegExp(entity, 'i');
      var crudRg = new RegExp(crudType, 'i');
      return perm.match(entityRg) && perm.match(crudRg);
    });
    return filtered ? filtered.length > 0 : false;
  }

  hasPermission(permission: string) {
    let tokenDetails: ITokenDetail = this.authService.decodeToken();
    return tokenDetails.scopes.indexOf(permission) > - 1;
  }

  checkPermission(entity: string, crudType: string): boolean {
    let filtered = this.userPermissions.filter(perm => {
      var entityRg = new RegExp(entity, 'i');
      var crudRg = new RegExp(crudType, 'i');
      return perm.name.match(entityRg) && perm.name.match(crudRg);
    });
    return filtered ? filtered.length > 0 : false;
  }

}