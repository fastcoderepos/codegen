import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
<#if AuthenticationType == "oidc">
import { OidcSecurityService } from 'angular-auth-oidc-client';
import { map } from 'rxjs/operators';
<#else>
import { AuthenticationService } from './authentication.service';
</#if>

@Injectable()
export class AuthGuard implements CanActivate {

  constructor(
    private router: Router,
    <#if AuthenticationType == "oidc">
    private oidcSecurityService: OidcSecurityService
    <#else>
    private authenticationService: AuthenticationService,
    </#if>
  ) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    <#if AuthenticationType == "oidc">
    return this.isAuthorized();
    <#else>
    if (this.authenticationService.token) {
      return true;
    }
    this.router.navigate(['/login'], { queryParams: { returnUrl: state.url } });
    return false;
    </#if>
  }
  <#if AuthenticationType == "oidc">
  
  private isAuthorized() {
    return this.oidcSecurityService.getIsAuthorized().pipe(
      map((isAuthorized: boolean) => {
        if (!isAuthorized) {
          this.router.navigate(['/']);
          return false;
        }
        return true;
      })
    );
  }
  </#if>
} 