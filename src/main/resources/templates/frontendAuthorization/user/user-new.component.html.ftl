<div class="create-item">
  <mat-card>
    <mat-card-header>
      <mat-card-title>{{title}}</mat-card-title>
      <a name="cancel" href="javascript:void(0)" (click)="onCancel()" class="cancle-btn"><i class="material-icons">add_circle</i></a>
    </mat-card-header>
    <mat-card-content>
      <form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">

        <mat-form-field>
          <input formControlName="firstName" matInput placeholder="First name">
          <mat-error *ngIf="!itemForm.get('firstName').valid && itemForm.get('firstName').touched">
            {{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field>
          <input formControlName="lastName" matInput placeholder="Last name">
          <mat-error *ngIf="!itemForm.get('lastName').valid && itemForm.get('lastName').touched">
            {{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field>
          <input formControlName="userName" matInput placeholder="Username">
          <mat-error *ngIf="!itemForm.get('userName').valid && itemForm.get('userName').touched">
            {{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field>
          <input type="password" matInput placeholder="New password" formControlName="password" required>
          <mat-error *ngIf="itemForm.hasError('required', 'password')">
            {{'GENERAL.ERRORS.REQUIRED' | translate}}
          </mat-error>
        </mat-form-field>

        <mat-form-field>
          <input matInput type="password" placeholder="Confirm password" formControlName="confirmPassword"
            pattern="{{ itemForm.get('password').value }}">
          <mat-error *ngIf="!itemForm.get('confirmPassword').valid && itemForm.get('confirmPassword').touched">
            {{'GENERAL.ERRORS.PASSWORD-MISMATCH' | translate}}
          </mat-error>
        </mat-form-field>

        <mat-form-field>
          <input formControlName="emailAddress" matInput placeholder="Email">
          <mat-error *ngIf="!itemForm.get('emailAddress').valid && itemForm.get('emailAddress').touched">
            {{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>

        <mat-form-field>
          <input formControlName="phoneNumber" matInput placeholder="Phone">
        </mat-form-field>

        <div class="checkbox-container">
          <mat-checkbox formControlName="isActive">Active</mat-checkbox>
        </div>

        <mat-form-field *ngFor="let association of parentAssociations">
          <input type="text" matInput formControlName="{{association.descriptiveField}}"
            placeholder="{{association.table}}" aria-label="Number" [matAutocomplete]="auto"
            (click)="selectAssociation(association)" required>
          <mat-autocomplete (optionSelected)="onAssociationOptionSelected($event, association)" autoActiveFirstOption
            #auto="matAutocomplete" (optionsScroll)="onPickerScroll(association)">
            <mat-option *ngFor="let option of association.data" [value]="option">
              {{option[association.referencedDescriptiveField]}}
            </mat-option>
          </mat-autocomplete>
        </mat-form-field>
      </form>
    </mat-card-content>
    <mat-card-actions class="fc-text-right">
      <button name="save" mat-raised-button color="primary" (click)="itemNgForm.ngSubmit.emit()"
        [disabled]="!itemForm.valid || loading || !IsCreatePermission">{{'GENERAL.ACTIONS.SAVE' | translate}}</button>
    </mat-card-actions>
  </mat-card>
</div>