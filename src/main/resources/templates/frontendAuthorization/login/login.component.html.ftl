<div class="login-container">
  <mat-card class="item-card">
    <mat-card-title class="text-center">
      <figure class="logo">
        <img src="../../assets/images/logo.png" alt="logo" style="    border-radius: 46px;" />
      </figure>   
      <figcaption class="text-center">
        <h2 class="sub-title">Log In</h2>
      </figcaption>         
    </mat-card-title>
    <mat-card-content>
      <form [formGroup]="itemForm" #loginNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
        <mat-form-field>
          <span matPrefix><i class="material-icons">
            account_circle
            </i> &nbsp;</span>
          <input formControlName="userName" matInput placeholder="Enter User Name" required>
          <mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">User Name
          is required</mat-error>
        </mat-form-field>
        <mat-form-field>
          <span matPrefix><i class="material-icons">
            https
            </i> &nbsp;
          </span>
          <input type="password" formControlName="password" matInput placeholder="Enter Password" required>
          <mat-error *ngIf="!itemForm.get('password').valid && itemForm.get('password').touched">Password
          is required</mat-error>
        </mat-form-field>
        <mat-error *ngIf="itemForm.errors?.passwordUserNameError && (itemForm.touched || itemForm.dirty)">
          Wrong username or password.
        </mat-error>
        <mat-card-actions class="item-action text-center">
          <button name="login" mat-flat-button color="primary" class="btn-submit">
            Login &nbsp; <i class="material-icons" style="color:#fff; bottom:0;">
            near_me
            </i>
          </button>
        </mat-card-actions>
      </form>
    </mat-card-content>
  </mat-card>
</div>

