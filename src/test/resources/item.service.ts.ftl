
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { [=IEntity] } from './[=IEntityFile]';
import { GenericApiService } from '../../../projects/fast-code-core/src/public_api';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class [=ClassName]Service extends GenericApiService<[=IEntity]> { 
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "[=ApiPath]");
  }
  
  
}
