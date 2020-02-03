<section  class="spinner-container"  *ngIf="isLoadingResults">
    <mat-spinner></mat-spinner>
</section>
<div *ngIf="item" class="list-container">
  <div class="top-breadcrumb">
      <h1 class="template-title">{{title}}</h1>
      <div class="fc-row">
        <div class="fc-col-sm-12">
          <ul class="breadcrumb">
            <li><a [routerLink]="['/dashboard']"><i class="material-icons">
                  home
                </i> &nbsp;Dashboard</a></li>
            <li><a (click)="onBack()">Role</a></li>
            <li><a>{{idParam}}</a></li>
          </ul>
        </div>
        
      </div>
    </div>
  <mat-card class="card">
    <mat-card-content>
      <form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
        <mat-form-field>
          <input formControlName="displayName" matInput placeholder="Display name">
          <mat-error *ngIf="!itemForm.get('displayName').valid && itemForm.get('displayName').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>
        
        <mat-form-field>
          <input formControlName="name" matInput placeholder="Name">
          <mat-error *ngIf="!itemForm.get('name').valid && itemForm.get('name').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>
        <#if (AuthenticationType == "oidc" && UsersOnly == "false")>
        <mat-form-field>
          <input formControlName="scimId" matInput placeholder="SCIM Id">
          <mat-error *ngIf="!itemForm.get('scimId').valid && itemForm.get('scimId').touched">{{'GENERAL.ERRORS.REQUIRED' | translate}}</mat-error>
        </mat-form-field>
      	</#if>
        <mat-form-field *ngFor="let association of parentAssociations">
          <input type="text" matInput formControlName="{{association.descriptiveField}}"
            placeholder="{{association.table}}" aria-label="Number" [matAutocomplete]="auto"
            (click)="selectAssociation(association)" required>
          <mat-autocomplete (optionSelected)="onAssociationOptionSelected($event, association)" autoActiveFirstOption #auto="matAutocomplete" (optionsScroll)="onPickerScroll(association)">
            <mat-option *ngFor="let option of association.data" [value]="option">
              {{option[association.referencedDescriptiveField]}}
            </mat-option>
          </mat-autocomplete>
        </mat-form-field>
        
      </form>
      <br>
        <br>
        <div class="association-div full-width">
          <div class="fc-row">
            <div class="fc-col-sm-6">
                <button mat-button *ngFor="let association of childAssociations"
                  (click)="openChildDetails(association)" class="btn btn-link">
                  {{association.table}}&nbsp;<mat-icon>link</mat-icon>
                </button>
            </div>
            <div class="fc-col-sm-6 fc-text-right">
                <button name="back" mat-raised-button color="basic" (click)="onBack()"> {{'GENERAL.ACTIONS.CANCEL' | translate}} </button> 
                <button name="save" mat-raised-button color="primary" [disabled]="<#if !ExcludeRoleNew>!itemForm.valid || loading || !IsUpdatePermission<#else>true</#if>" (click)="itemNgForm.ngSubmit.emit()">
                  {{'GENERAL.ACTIONS.SAVE' | translate}}
                </button>
            </div>
          </div>            
        </div>
        <br>
        <br>
    </mat-card-content>
  </mat-card>
</div>