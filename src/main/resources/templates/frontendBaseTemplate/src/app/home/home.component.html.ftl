<div class="container">
  <div class="home-container">
    <div class="left">
      <mat-card class="left-card">
        <mat-card-content>
          FastCode Online is the best place to generate FastCode applications, with no
          installation required!
        </mat-card-content>
      </mat-card>
      <mat-card class="left-card">
        <mat-card-content>
          FastCode Online is the best place to generate FastCode applications, with no
          installation required!
        </mat-card-content>
      </mat-card>
      <mat-card class="left-card">
        <mat-card-content>
          FastCode Online is the best place to generate FastCode applications, with no
          installation required!
        </mat-card-content>
      </mat-card>
    </div>
    <div class="item-form-container">

      <div class="welcome-row">
        <i class="material-icons fc-icon">
          dashboard
        </i>
        <h2>Welcome to FastCode Online</h2>
      </div>
            
   		<#if AuthenticationType != "none">
      <mat-card *ngIf="!authenticationService.token" class="item-card">
        <mat-card-content>
          <h2>Authentication</h2>
          <h4>Sign in</h4>
          <p>
            If you already have an account:
          </p>
          <button name="login" color="primary" mat-flat-button (click)="onSubmit()">
            Sign in </button>
        </mat-card-content>
      </mat-card>
      <mat-card *ngIf="authenticationService.token" class="item-card">
        <mat-card-content>
          <p>Login to Dashboard:</p>
          <button name="dashboard" color="primary" mat-flat-button (click)="goToDashboard()">Dashboard</button>
        </mat-card-content>
      </mat-card>
      <#else>
      <mat-card class="item-card">       
  			<mat-card-content>
        <button name="dashboard" color="primary" mat-flat-button (click)="goToDashboard()">Dashboard</button>
  			</mat-card-content>
      </mat-card>
      </#if>
        
      <div>
        <h4>FastCode is an Open Source, widely popular application generator </h4>
        <p>
          If you want more information on FastCode:

          FastCode homepage (with documentation, slides, tutorials, etc.)
          FastCode source code on GitHub
          FastCode on Twitter
        </p>
      </div>
    </div>
  </div>
</div>