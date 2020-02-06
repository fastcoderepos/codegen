<mat-sidenav-container class="sidenav-container">
  <mat-sidenav #drawer class="sidenav" fixedInViewport="true"
    [attr.role]="(isSmallDevice$ | async) ? 'dialog' : 'navigation'" [mode]="(isSmallDevice$ | async) ? 'over' : 'side'"
    [opened]="!(isSmallDevice$ | async) && !isCurrentRootRoute <#if AuthenticationType != "none">&& authenticationService.token</#if>">

    <mat-toolbar color="primary">
      <figure class="loggo">
        <img src="../../../../assets/images/logo.png" alt="logo" />
      </figure>
  
    </mat-toolbar>
    <mat-nav-list class="nav-list">
      <a mat-list-item class="sidenav-list-item" routerLink="/"><i class="material-icons">home</i> &nbsp;{{'MainNav.Home' | translate }}</a>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          <i class="material-icons">
            g_translate
            </i> &nbsp;{{'MainNav.Language' | translate}}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">
          <mat-radio-group class="radio-group" [(ngModel)]="selectedLanguage">
            <mat-radio-button class="radio-button" *ngFor="let lang of translate.getLangs()"
              (click)="switchLanguage(lang)" [value]="lang">
             {{lang | translate}}
            </mat-radio-button>
          </mat-radio-group>

        </mat-nav-list>
      </mat-expansion-panel>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          <i class="material-icons">
            dvr
            </i> &nbsp;{{'MainNav.Entities' | translate }}
        </mat-expansion-panel-header>

        <mat-nav-list class="subnav">

          <ng-container *ngFor="let entity of entityList">
            <a <#if AuthenticationType != "none">*ngIf="entityPermissions[entity]"</#if> mat-list-item class="mat-sub-list-item" [routerLink]="[entity]">
             {{entity}}
            </a>
          </ng-container>

        </mat-nav-list>
      </mat-expansion-panel>

      <mat-expansion-panel class="expansion-panel">
        <mat-expansion-panel-header class="subnav-header">
          <i class="material-icons">
            account_box
            </i> &nbsp;{{'MainNav.Administration' | translate }}
        </mat-expansion-panel-header>

        <#if AuthenticationType != "none">
        <mat-expansion-panel class="expansion-panel">
          <mat-expansion-panel-header class="subnav-header">
            {{'MainNav.AccessMgmt' | translate }}
          </mat-expansion-panel-header>

          <mat-nav-list class="subnav">
            <#if !UserInput?? && UserOnly> 
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['user']" routerLink="user">Users </a>
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['userpermission']" routerLink="userpermission">User Permissions </a>
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['userroles']" routerLink="userrole">User Roles </a>
            <#elseif UserInput??> 
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['[=AuthenticationTable?lower_case]']" routerLink="[=AuthenticationTable?lower_case]">[=AuthenticationTable] </a> 
            <#if UserOnly>
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['[=AuthenticationTable?lower_case]permission']" routerLink="[=AuthenticationTable?lower_case]permission">[=AuthenticationTable] Permissions </a> 
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['[=AuthenticationTable?lower_case]role']" routerLink="[=AuthenticationTable?lower_case]role">[=AuthenticationTable] Roles </a> 
            </#if>
            </#if>
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['role']" routerLink="role">Roles</a> 
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['permission']" routerLink="permission">Permissions</a> 
            <a mat-list-item class="mat-sub-list-item" *ngIf="entityPermissions['rolepermission']" routerLink="rolepermission">Roles Permissions</a>
          </mat-nav-list>
        </mat-expansion-panel>
        </#if>
        <a mat-list-item class="sidenav-list-item" href="api/swagger-ui.html" target="_blank">{{'MainNav.API' | translate }}</a>
      </mat-expansion-panel>

      <a mat-list-item class="sidenav-list-item"><i class="material-icons">
        ac_unit
        </i> &nbsp;{{'MainNav.About' | translate }}</a>
    </mat-nav-list>
  </mat-sidenav>
  <mat-sidenav-content #navContent class="fc-sidenav-content">
    <mat-toolbar class="fc-tool-bar" color="primary" <#if AuthenticationType != "none">*ngIf="authenticationService.token"</#if>>
      <figure class="loggo mob-logo">
        <img src="../../../../assets/images/logo.png" alt="logo"/>
      </figure>
      <span></span>
      <span>
        <#if AuthenticationType != "none">
        
        <button mat-button [matMenuTriggerFor]="menu" *ngIf="authenticationService.token"><i class="material-icons">
            account_circle
          </i></button>
        <mat-menu #menu="matMenu">
          <button mat-menu-item><i class="material-icons" style="position: relative;top: 7px;color: skyblue;">face</i>&nbsp; <label  style="line-height: 0;    position: relative;
            top: -6px;">Admin<small style="    opacity: 0.5;
            display: block;
            line-height: 0;
            position: relative;
            top: 12px;">admin@gmail.com</small></label></button>
          <button mat-menu-item (click)="logout()"><i class="material-icons" style="position: relative;top: 7px;color: red;">power_settings_new</i>&nbsp; Logout</button>
        </mat-menu>
        </#if>
      </span>

    </mat-toolbar>
    <!-- main content container start  -->
    <router-outlet></router-outlet>
    <!-- main content container Ends -->
    <bottom-tab-nav (onNavMenuClicked)="drawer.toggle()" *ngIf="(Global.isSmallDevice$ | async)" class="fc-bottom-nav">

    </bottom-tab-nav>
  </mat-sidenav-content>
</mat-sidenav-container>