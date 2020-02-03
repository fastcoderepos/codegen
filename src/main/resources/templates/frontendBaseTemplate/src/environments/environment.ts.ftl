// This file can be replaced during build by using the `fileReplacements` array.
// `ng build ---prod` replaces `environment.ts` with `environment.prod.ts`.
// The list of file replacements can be found in `angular.json`.
<#if AuthenticationType == "oidc">
import { OpenIdConfiguration } from 'angular-auth-oidc-client';
</#if>

export const environment = {
	production: false,
	apiUrl:  '/api', //'https://localhost:5555',
	authUrl: '/api', //'http://localhost:5555',
  <#if AuthenticationType == "oidc">
	wellKnownUrlsOidc: "https://dev-145947.okta.com/oauth2/default/.well-known/openid-configuration"
  </#if>
};
<#if AuthenticationType == "oidc">
export const AuthOidcConfig: OpenIdConfiguration = {
  stsServer: 'https://dev-145947.okta.com/oauth2/default',
  redirect_url: 'https://localhost:4200/callback',
  client_id: '0oa2ilsqcabubcWPX357',
  scope: 'openid profile email groups',
  response_type: 'code',
  silent_renew: true,
  silent_renew_url: 'https://localhost:4200/assets/silent-refresh.html',
  // silent_renew_url: 'https://localhost:4200/callback',
  log_console_debug_active: true,
  post_logout_redirect_uri: 'https://localhost:4200',
  start_checksession: false,
  post_login_route: '/dashboard',

  forbidden_route: '/',
  // HTTP 401
  unauthorized_route: '/',
  log_console_warning_active: true,
  // id_token C8: The iat Claim can be used to reject tokens that were issued too far away from the current time,
  // limiting the amount of time that nonces need to be stored to prevent attacks.The acceptable range is Client specific.
  max_id_token_iat_offset_allowed_in_seconds: 10,
  silent_renew_offset_in_seconds: 3500,
  isauthorizedrace_timeout_in_seconds: 15
};
</#if>

/*
 * In development mode, for easier debugging, you can ignore zone related error
 * stack frames such as `zone.run`/`zoneDelegate.invokeTask` by importing the
 * below file. Don't forget to comment it out in production mode
 * because it will have a performance impact when errors are thrown
 */
// import 'zone.js/dist/zone-error';  // Included with Angular CLI.
