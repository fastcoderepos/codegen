import { Injectable, Inject } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';

import { IForRootConf } from '../../IForRootConf';
import { IP_CONFIG } from '../../tokens';

@Injectable({
  providedIn: 'root'
})

export class UserService {

  url = "";
  resp: any
  constructor(private httpclient: HttpClient, @Inject(IP_CONFIG) private _config: IForRootConf) {
    this.url = _config.apiPath;
  }

  // Get logged in user info
  getAccount() {
    return this.httpclient.get(this.url + '/app/rest/account');
  };
  
  // Get user info by id
  getUserInfo(userId) {
    return this.httpclient.get(this.url + '/app/rest/users/' + userId);
  };

  //Filter users based on a filter text, in the context of workflow: for tasks, processes, etc.
  getFilteredUsers(filterText, taskId, processInstanceId, tenantId, group): Observable<any> {
    console.log(taskId);
    var params: any = {};
    if (typeof filterText === 'string') {
      params.filter = filterText;
    }
    else {
      // Could be i.e. { email: 'user@domain.com' } or { externalId: 'externalUserId' }
      params = filterText;
    }
    if (taskId) {
      params.excludeTaskId = taskId;
    }
    if (processInstanceId) {
      params.excludeProcessId = processInstanceId;
    }

    if (group && group.id) {
      params.groupId = group.id;
    }

    var httpOptions = {
      params: params
    };
    return this.httpclient.get(this.url + '/app/rest/workflow-users', httpOptions);

  };

  protected handleError(err: HttpErrorResponse) {

    let errorMessage = '';
    if (err.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      errorMessage = `An error occurred: ${err.error.message}`;
    } else {

      errorMessage = `Server returned code: ${err.status}, error message is: ${err.message}`;
    }
    console.error(errorMessage);
    return throwError(errorMessage);
  }
}