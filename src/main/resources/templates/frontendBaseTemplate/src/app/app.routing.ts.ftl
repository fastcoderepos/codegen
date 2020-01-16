
import { RouterModule, Routes } from '@angular/router';
import { ModuleWithProviders } from "@angular/core";
import { CanDeactivateGuard } from 'projects/fast-code-core/src/public_api';
import { HomeComponent } from './home/home.component';
import { DashboardComponent } from './dashboard/dashboard.component';
import { ErrorPageComponent  } from './error-page/error-page.component';
<#if AuthenticationType != "none">
import { LoginComponent } from './login/index';
import { AuthGuard } from './core/auth-guard';
import { CallbackComponent } from './oauth/callback.component';
</#if>
<#if FlowableModule!false>
import { TaskAppRoutes } from 'projects/task-app/src/public_api';
</#if>
<#if SchedulerModule!false>
import { SchedulerRoutes } from 'scheduler';
</#if>
<#if EmailModule!false>
import { EmailRoutes } from 'projects/ip-email-builder/src/public_api';
</#if>

const routes: Routes = [

	
	{ path: 'dashboard',  component: DashboardComponent <#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if>  },
	<#if AuthenticationType != "none">	
	{ path: 'login', component: LoginComponent },
	{ path: 'login/:returnUrl', component: LoginComponent },
	{ path: 'callback', component: CallbackComponent },
	</#if>
  <#if FlowableModule!false>
  { path: 'task-app', children: TaskAppRoutes <#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if>},
  </#if>
  <#if SchedulerModule!false>
  {path: 'scheduler', children: SchedulerRoutes},
  </#if>
  <#if EmailModule!false>
  {path: 'email', children: EmailRoutes<#if AuthenticationType != "none">,canActivate: [ AuthGuard ]</#if> },
  </#if>
  { path: '', component: HomeComponent },
  //{ path: '', redirectTo: '/', pathMatch: 'full' },
  { path: '**', component:ErrorPageComponent},
	
];

export const routingModule: ModuleWithProviders = RouterModule.forRoot(routes<#if FlowableModule!false>, { useHash: true, enableTracing: true }</#if>);
