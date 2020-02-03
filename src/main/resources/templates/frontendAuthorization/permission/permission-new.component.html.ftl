<div class="create-item">
  <mat-card>
    <mat-card-header>
      <mat-card-title>{{title}}</mat-card-title>
      <a name="cancel" href="javascript:void(0)" (click)="onCancel()" class="cancle-btn"><i
          class="material-icons">add_circle</i></a>
    </mat-card-header>
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
    </mat-card-content>
    <mat-card-actions class="fc-text-right">
      <button name="save" mat-raised-button color="primary" (click)="itemNgForm.ngSubmit.emit()"
        [disabled]="!itemForm.valid || loading || !IsCreatePermission">{{'GENERAL.ACTIONS.SAVE' | translate}}</button>
    </mat-card-actions>
  </mat-card>
</div>
