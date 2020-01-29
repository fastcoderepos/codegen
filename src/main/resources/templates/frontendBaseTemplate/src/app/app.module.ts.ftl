
import { BrowserModule } from '@angular/platform-browser';
import { NgModule<#if AuthenticationType == "oidc">, APP_INITIALIZER</#if> } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClient, HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { LayoutModule } from '@angular/cdk/layout';

import { TranslateModule, TranslateLoader } from '@ngx-translate/core';
import { TranslateHttpLoader } from '@ngx-translate/http-loader';
import { DashboardComponent } from './dashboard/dashboard.component';
import { HomeComponent } from './home/index';
import { ErrorPageComponent  } from './error-page/error-page.component';
<#if AuthenticationType != "none">
/** core components and filters for authorization and authentication **/

import { AuthenticationService } from './core/authentication.service';
import { AuthGuard } from './core/auth-guard';
import { JwtInterceptor } from './core/jwt-interceptor';
import { JwtErrorInterceptor } from './core/jwt-error-interceptor';
import { GlobalPermissionService } from './core/global-permission.service';
<#if AuthenticationType == "oidc">
import { AuthModule, OidcConfigService, OidcSecurityService } from 'angular-auth-oidc-client';
import { CallbackComponent } from './callback/callback.component';

export function loadConfig(oidcConfigService: OidcConfigService) {
  console.log('APP_INITIALIZER STARTING');
  return () => oidcConfigService.load_using_custom_stsServer(environment.wellKnownUrlsOidc);
}
<#else>
import { LoginComponent } from './login/index';
</#if>

/** end of core components and filters for authorization and authentication **/
</#if>

import {
  MatButtonModule, MatToolbarModule, MatSidenavModule,
  MatIconModule, MatListModule, MatRadioModule, MatTableModule,
  MatCardModule, MatTabsModule, MatInputModule, MatDialogModule,
  MatSelectModule, MatCheckboxModule, MatAutocompleteModule,
  MatDatepickerModule, MatNativeDateModule, MatMenuModule, MatSortModule,
  MatPaginatorModule, MatProgressSpinnerModule, MatSnackBarModule
} from '@angular/material';
import {MatChipsModule} from '@angular/material/chips';
import { MatExpansionModule } from '@angular/material/expansion';

import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';

import { routingModule } from './app.routing';
import { FastCodeCoreModule } from 'projects/fast-code-core/src/public_api';

/** common components and filters **/

import { MainNavComponent } from './common/components/main-nav/main-nav.component';
import { BottomTabNavComponent } from './common/components/bottom-tab-nav/bottom-tab-nav.component';

/** end of common components and filters **/

import { environment } from '../environments/environment';
import { Globals } from './globals';

export function HttpLoaderFactory(httpClient: HttpClient) {
  return new TranslateHttpLoader(httpClient);
}

@NgModule({
  declarations: [
    ErrorPageComponent,
  	HomeComponent,
  	DashboardComponent,
  	
		<#if AuthenticationType == "oidc">
		CallbackComponent,
		<#elseif AuthenticationType == "ldap" || AuthenticationType == "database">
		LoginComponent,
		</#if>
    AppComponent,
    MainNavComponent,
    BottomTabNavComponent,
  ],
  imports: [
    BrowserModule,
    routingModule,
    HttpClientModule,
    BrowserAnimationsModule,
    FormsModule,
    MatDialogModule,
    ReactiveFormsModule,
    MatInputModule,
    MatButtonModule,
    LayoutModule,
    MatToolbarModule,
    MatSidenavModule,
    MatTabsModule,
    MatIconModule,
    MatListModule,
    MatExpansionModule,
    MatRadioModule,
    MatTableModule,
    MatCardModule,
    MatSelectModule,
    MatCheckboxModule,
    MatAutocompleteModule,
    MatDatepickerModule,
    MatNativeDateModule,
    MatMenuModule,
    MatSortModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatSnackBarModule,
    MatChipsModule,
    NgxMaterialTimepickerModule,
    FastCodeCoreModule.forRoot({
      apiUrl: environment.apiUrl
    }),
    TranslateModule.forRoot({
      loader: {
        provide: TranslateLoader,
        useFactory: HttpLoaderFactory,
        deps: [HttpClient]
      }
    }),
    <#if AuthenticationType == "oidc">
		AuthModule.forRoot(),
		</#if>

  ],
  providers: [
		<#if AuthenticationType != "none">
		AuthenticationService,
		GlobalPermissionService,
		{ provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true },
		{ provide: HTTP_INTERCEPTORS, useClass: JwtErrorInterceptor, multi: true },
		AuthGuard,
		<#if AuthenticationType == "oidc">
		OidcSecurityService,
		OidcConfigService,
		{
			provide: APP_INITIALIZER,
			useFactory: loadConfig,
			deps: [OidcConfigService],
			multi: true
		},
		</#if>
		</#if>
		Globals
	],
  bootstrap: [AppComponent],
  entryComponents: [
  ]
})
export class AppModule {
	<#if AuthenticationType == "oidc">
	constructor(private authenticationService: AuthenticationService){
		this.authenticationService.configure();
	}
	</#if>
}
