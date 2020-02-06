import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
import { Observable } from 'rxjs';
<#if AuthenticationType == "oidc">
import { AuthOidcConfig } from 'src/environments/environment';
</#if>
import { AuthenticationService } from './authentication.service';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {

  constructor( private authService: AuthenticationService ) {}

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // add authorization header with jwt token if available

    <#if AuthenticationType == "oidc">
    if (request.url.search(AuthOidcConfig.stsServer) == -1) {
      let token = this.authService.token;
			token = token ? ("Bearer " + token) : token;

      if (token) {
        request = request.clone({
          setHeaders: {
            Authorization: token,
            Accept: 'application/json'
          }
        });
      }
    }
    <#else>
    let token = this.authService.token;

    if (token) {
      request = request.clone({
        setHeaders: {
          Authorization: token,
          Accept: 'application/json'
        }
      });
    }
    </#if>

    return next.handle(request);
  }
}