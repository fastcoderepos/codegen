<div *ngIf="!noFilterableFields">
  <form [formGroup]="basicFilterForm" class="filter-form" [hidden]="showFilters">

    <div class="fb-row full-width">
      <div class="fb-col-md-6 fb-col-lg-2">
        <mat-form-field class="example-full-width full-width"  style="width:100%">
          <input type="text" placeholder="{{'LIST-FILTERS.ADD-FILTER-PLACEHOLDER' | translate}}" aria-label="Number" matInput [formControl]="filterCtrl" [matAutocomplete]="auto">
          <mat-autocomplete #auto="matAutocomplete" (optionSelected)="selected($event)">
            <mat-option *ngFor="let field of filterFields" [value]="field.label">
              {{field.label}}
            </mat-option>
          </mat-autocomplete>
        </mat-form-field>
      </div>
      <div class="fb-col-md-12 fb-col-lg-10">
        <div *ngIf="mySelector" class="div-input-container">
          <div class="field-div">
            <mat-form-field class="full-width">
              <mat-label>{{'LIST-FILTERS.ADD-FILTER-FIELD.OPERATORS.TITLE' | translate}}</mat-label>
              <mat-select formControlName="operator">
                <mat-option *ngFor="let operator of operators" [value]="operator">
                  {{operator}}
                </mat-option>
              </mat-select>
            </mat-form-field>
          </div>
          <div class="field-div" *ngIf="field.type == 'String'">
            <mat-form-field *ngIf="basicFilterForm.get('operator').value" class="full-width">
              <input formControlName="searchValue" matInput
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.VALUE' | translate}}">
            </mat-form-field>
          </div>

          <div class="field-div" *ngIf="field.type == 'Boolean'">
            <mat-form-field *ngIf="basicFilterForm.get('operator').value" class="full-width">
              <mat-label>{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.VALUE' | translate}}</mat-label>
              <mat-select formControlName="searchValue">
                <mat-option *ngFor="let option of booleanOptions" [value]="option">
                  {{option}}
                </mat-option>
              </mat-select>
            </mat-form-field>
          </div>

          <div class="field-div" *ngIf="field.type == 'Number'">
            <mat-form-field *ngIf="['equals','notEqual'].indexOf(basicFilterForm.get('operator').value) > - 1"
              class="full-width">
              <input type="number" formControlName="searchValue" matInput
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.VALUE' | translate}}" class="full-width">
            </mat-form-field>

            <mat-form-field *ngIf="basicFilterForm.get('operator').value == 'range'" class="full-width">
              <input type="number" formControlName="startingValue" matInput
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.FROM-VALUE' | translate}}">
            </mat-form-field>

            <mat-form-field *ngIf="basicFilterForm.get('operator').value == 'range'" class="full-width">
              <input type="number" formControlName="endingValue" matInput
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.TO-VALUE' | translate}}">
            </mat-form-field>
          </div>

          <div class="field-div" *ngIf="field.type == 'Date'">
            <mat-form-field *ngIf="['equals','notEqual'].indexOf(basicFilterForm.get('operator').value) > - 1"
              class="full-width">
              <input formControlName="searchValue" matInput [matDatepicker]="datePicker"
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.VALUE' | translate}}">
              <mat-datepicker-toggle matSuffix [for]="datePicker"></mat-datepicker-toggle>
              <mat-datepicker #datePicker></mat-datepicker>
            </mat-form-field>

            <mat-form-field *ngIf="basicFilterForm.get('operator').value == 'range'" class="full-width">
              <input formControlName="startingValue" matInput [matDatepicker]="startDatePicker"
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.FROM-VALUE' | translate}}">
              <mat-datepicker-toggle matSuffix [for]="startDatePicker"></mat-datepicker-toggle>
              <mat-datepicker #startDatePicker></mat-datepicker>
            </mat-form-field>

            <mat-form-field *ngIf="basicFilterForm.get('operator').value == 'range'" class="full-width">
              <input formControlName="endingValue" matInput [matDatepicker]="startDatePicker"
                placeholder="{{'LIST-FILTERS.ADD-FILTER-FIELD.PLACEHOLDERS.TO-VALUE' | translate}}">
              <mat-datepicker-toggle matSuffix [for]="startDatePicker"></mat-datepicker-toggle>
              <mat-datepicker #startDatePicker></mat-datepicker>
            </mat-form-field>
          </div>
        </div>
        <div class="button-div">
          <button mat-raised-button (click)="search()" color="primary">
            {{'LIST-FILTERS.SEARCH-BUTTON-TEXT' | translate}}
          </button>
        </div>
      </div>

      <div class="fb-col-sm-12">
        <mat-chip *ngFor="let field of selectedDisplayFilterFields; let i = index" (removed)="remove(field,i)">
          {{field}}
          <mat-icon matTooltip="remove" matChipRemove>cancel</mat-icon>
        </mat-chip>
      </div>
    </div>

  </form>
</div>