<section class="spinner-container" *ngIf="isLoadingResults">
  <mat-spinner></mat-spinner>
</section>

<div class="list-container" (onScroll)="onTableScroll()" appVirtualScroll>
  <div class="top-breadcum">
    <h1 class="template-title">{{title}}</h1>
    <div class="fb-row">
      <div class="fb-col-md-8">
        <ul class="breadcum">
          <li><a [routerLink]="['/dashboard']"><i class="material-icons">
                home
              </i> &nbsp;Dashboard</a></li>
          <li><a>{{title}}</a></li>
        </ul>
      </div>
      <div class="fb-col-md-4 fb-text-right">
        <button name="add" mat-raised-button color="primary"  (click)="addNew()"><i
            class="material-icons">
            add_circle_outline
          </i> &nbsp;{{'GENERAL.ACTIONS.ADD' | translate}}</button>
      </div>
    </div>
  </div>
  <mat-card>
	  <app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
    <div class="table-container">
      <mat-table matSort [dataSource]="items" class="mat-elevation-z8">
        
        <ng-container matColumnDef="emailAddress">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('emailAddress')"> {{getFieldLabel("EmailAddress")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.emailAddress }}
          </mat-cell>
        </ng-container>
        
        <ng-container matColumnDef="firstName">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('firstName')"> {{getFieldLabel("FirstName")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.firstName }}
          </mat-cell>
        </ng-container>
        <ng-container matColumnDef="id">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('id')"> {{getFieldLabel("Id")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.id }}
          </mat-cell>
        </ng-container>
        <ng-container matColumnDef="isActive">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('isActive')"> {{getFieldLabel("IsActive")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.isActive }}
          </mat-cell>
        </ng-container>
        
        <ng-container matColumnDef="lastName">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('lastName')"> {{getFieldLabel("LastName")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.lastName }}
          </mat-cell>
        </ng-container>
        
        <ng-container matColumnDef="phoneNumber">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('phoneNumber')"> {{getFieldLabel("PhoneNumber")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.phoneNumber }}
          </mat-cell>
        </ng-container>
        
        <ng-container matColumnDef="userName">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('userName')"> {{getFieldLabel("UserName")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.userName }}
          </mat-cell>
        </ng-container>
        <ng-container matColumnDef="actions">
          <mat-header-cell *matHeaderCellDef> {{getFieldLabel("Actions")}}</mat-header-cell>
          <mat-cell *matCellDef="let item" (click)="$event.stopPropagation()">
            <button mat-icon-button aria-label="Example icon-button with a heart icon text-dangger"
              matTooltip="('GENERAL.ACTIONS.EDIT' | translate)" (click)="openDetails(item)">
              <mat-icon>open_in_new</mat-icon>
            </button>
            <button mat-icon-button color="warn" aria-label="Example icon-button with a heart icon text-dangger" matTooltip="('GENERAL.ACTIONS.DELETE' | translate)"  
              (click)="delete(item)">
              <mat-icon color="warn">delete</mat-icon>
            </button>
          </mat-cell>
        </ng-container>
        <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
        <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
      </mat-table>
    </div>
  </mat-card>
</div>
