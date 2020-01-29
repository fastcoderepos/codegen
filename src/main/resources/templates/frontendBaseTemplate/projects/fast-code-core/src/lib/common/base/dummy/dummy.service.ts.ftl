
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { IDummy } from './idummy';
import { GenericApiService } from 'projects/fast-code-core/src/public_api';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class DummyService extends GenericApiService<IDummy> { 
  
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "dummy");
  }
  
}

@Injectable({
  providedIn: 'root'
})
export class ParentService extends GenericApiService<IDummy> { 
  
  constructor(private httpclient: HttpClient) { 
    super(httpclient, { apiUrl: environment.apiUrl }, "parent");
  }
  
}
