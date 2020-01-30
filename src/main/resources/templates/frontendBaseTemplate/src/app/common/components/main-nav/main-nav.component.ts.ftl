import { Component, ViewChild } from '@angular/core';
import { Observable } from 'rxjs';
import { TranslateService } from '@ngx-translate/core';
import { Router, Event } from '@angular/router';
import { MatSidenav, MatSidenavContent } from '@angular/material';
<#if AuthenticationType != "none">
import { AuthenticationService } from 'src/app/core/authentication.service';
import { GlobalPermissionService } from 'src/app/core/global-permission.service';
</#if>

import entities from './entities.json';
import { FastCodeCoreTranslateUiService, Globals } from 'projects/fast-code-core/src/public_api';

@Component({
	selector: 'app-main-nav',
	templateUrl: './main-nav.component.html',
	styleUrls: ['./main-nav.component.scss']
})
export class MainNavComponent {	
	@ViewChild("drawer", { static: false }) drawer: MatSidenav;
	@ViewChild("navContent", { static: false }) navContent: MatSidenavContent;
	
	appName: string = '[=AppName]';
	selectedLanguage: string;
	entityList = entities;

	hasTaskAppPermission: boolean = false;
	hasAdminAppPermission: boolean = false;

	isSmallDevice$: Observable<boolean>;
	isMediumDevice$: Observable<boolean>;
	isCurrentRootRoute: boolean = true;
	constructor(
		private router: Router,
		public translate: TranslateService,
		public Global: Globals,
    private fastCodeCoreTranslateUiService: FastCodeCoreTranslateUiService,
		<#if AuthenticationType != "none">
		public authenticationService: AuthenticationService,
		public globalPermissionService: GlobalPermissionService,
		</#if>
	) {

		this.isSmallDevice$ = Global.isSmallDevice$;
		this.isMediumDevice$ = Global.isMediumDevice$;

		this.router.events.subscribe((event: Event) => {
			this.isCurrentRootRoute = (this.router.url == '/') ? true : false;
		});
		
		this.selectedLanguage = localStorage.getItem('selectedLanguage');
	}

	switchLanguage(language: string) {
	  if(this.translate.translations[language]){
      this.translate.use(language);
    }else{
      this.translate.use(language).subscribe(() => {
        this.fastCodeCoreTranslateUiService.init(language);
      });
    }
    localStorage.setItem('selectedLanguage', language);
    this.selectedLanguage = language;
	}
	
	<#if AuthenticationType != "none">
	isMenuVisible(entityName:string){
		return this.authenticationService.token? this.globalPermissionService.hasPermissionOnEntity(entityName,"READ"): false;
	}
	<#if AuthenticationType == "oidc">
	login() {
		this.authenticationService.login();
	}
	
	logout() {
		this.authenticationService.logout();
	}
	<#else>
	login() {
		this.router.navigate(['/login'], { queryParams: { returnUrl: 'dashboard' } });
  }
  
  logout() {
		this.authenticationService.logout();
		this.router.navigate(['/']);
	}
	</#if>
	</#if>
	
}