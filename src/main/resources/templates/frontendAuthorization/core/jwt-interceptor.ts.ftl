import { Injectable } from '@angular/core';
import { HttpRequest, HttpHandler, HttpEvent, HttpInterceptor } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';
import { AuthenticationService } from './authentication.service';

@Injectable()
export class JwtInterceptor implements HttpInterceptor {

  constructor( private authService: AuthenticationService ) {}

  intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    // add authorization header with jwt token if available

    <#if AuthenticationType == "oidc">
    if (request.url != environment.tokenEndpoint) {
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