import { Component } from '@angular/core';
import { OidcSecurityService } from 'angular-auth-oidc-client';

@Component({
	template: ''
})
export class CallbackComponent {
	constructor(
		private oidcSecurityService: OidcSecurityService
	) {
		this.oidcSecurityService.authorizedCallbackWithCode(window.location.toString());
	}
}
