import { Component } from '@angular/core';
import { Router} from "@angular/router";
import { first } from 'rxjs/operators';
<#if AuthenticationType != "none">
import { AuthenticationService } from '../core/authentication.service';
</#if>
 
@Component({ 
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent {

	constructor(
		public router: Router,
		<#if AuthenticationType != "none">
		public authenticationService: AuthenticationService,
		</#if>
  ) { }
 
  <#if AuthenticationType != "none">
	<#if AuthenticationType == "oidc"> 
  onSubmit() {
    this.authenticationService.login();
  }
  <#else>
  onSubmit() {
    this.router.navigate(['/login'], { queryParams: { returnUrl: 'dashboard' } });
  }
	</#if>
	</#if>
	goToDashboard(){
    this.router.navigate(['dashboard']);
  }
}
