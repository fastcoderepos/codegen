
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { CanDeactivateGuard } from 'projects/fast-code-core/src/public_api';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { ErrorPageComponent  } from './error-page/error-page.component';
<#if AuthenticationType == "oidc">
import { CallbackComponent } from './callback/callback.component';
import { AuthGuard } from './core/auth-guard';
<#elseif AuthenticationType == "database" || AuthenticationType == "ldap" >
import { LoginComponent } from './login/index';
import { AuthGuard } from './core/auth-guard';
</#if>

<#list EntityNames as module,entity>
<#if !(entity == AuthenticationTable && ExcludeUserNew) && !(entity == "Role" && ExcludeRoleNew)>
import { [=entity]ListComponent, [=entity]DetailsComponent, [=entity]NewComponent } from './[=module]/index';
<#else>
import { [=entity]ListComponent, [=entity]DetailsComponent } from './[=module]/index';
</#if>
</#list>

const routes: Routes = [
	
	{ path: 'dashboard',  component: DashboardComponent <#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if>  },
	<#if AuthenticationType == "oidc">
	{ path: 'callback', component: CallbackComponent },
	<#elseif AuthenticationType == "database" || AuthenticationType == "ldap" >
	{ path: 'login', component: LoginComponent },
	{ path: 'login/:returnUrl', component: LoginComponent },
	</#if>
	<#list EntityNames as module,entity>
	{ path: '[=entity?lower_case]', component: [=entity]ListComponent, canDeactivate: [CanDeactivateGuard]<#if AuthenticationType == "none">, canActivate: [ AuthGuard ]</#if>},
	<#if !(entity == AuthenticationTable && ExcludeUserNew) && !(entity == "Role" && ExcludeRoleNew)>
	{ path: '[=entity?lower_case]/new', component: [=entity]NewComponent<#if AuthenticationType == "none">, canActivate: [ AuthGuard ]</#if> },
	</#if>
	{ path: '[=entity?lower_case]/:id', component: [=entity]DetailsComponent, canDeactivate: [CanDeactivateGuard]<#if AuthenticationType == "none">, canActivate: [ AuthGuard ] </#if>},
	</#list>
  { path: '', component: HomeComponent },
  //{ path: '', redirectTo: '/', pathMatch: 'full' },
  { path: '**', component:ErrorPageComponent},
	
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes);