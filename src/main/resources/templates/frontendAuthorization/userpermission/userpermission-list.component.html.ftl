<div class="list-container" (onScroll)="onTableScroll()" appVirtualScroll>
  <div class="top-breadcrumb">
    <h1 class="template-title">{{title}}</h1>
    <div class="fc-row">
      <div class="fc-col-md-8">
        <ul class="breadcrumb">
          <li><a [routerLink]="['/dashboard']"><i class="material-icons">
                home
              </i> &nbsp;Dashboard</a></li>
          <li><a>{{title}}</a></li>
          <li *ngIf="selectedAssociation" (click)="back()">
            <span *ngIf="selectedAssociation.associatedObj">
              {{selectedAssociation.table}}: {{selectedAssociation.associatedObj[selectedAssociation.referencedDescriptiveField]}}
            </span>
          </li>
        </ul>
      </div>
      <div class="fc-col-md-4 fc-text-right">
        <button name="add" mat-raised-button color="primary" [disabled]="!IsCreatePermission" (click)="addNew()"><i class="material-icons">
            add_circle_outline
          </i> &nbsp;{{'GENERAL.ACTIONS.ADD' | translate}}</button>
      </div>
    </div>
  </div>
  <mat-card>
	  <app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
    <div class="table-container">
      <mat-table matSort [dataSource]="items" class="mat-elevation-z8">
        <ng-container matColumnDef="User">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('User')">
            {{getFieldLabel("User")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.userDescriptiveField }}
          </mat-cell>
        </ng-container>

        <ng-container matColumnDef="Permission">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Permission')">
            {{getFieldLabel("Permission")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.permissionDescriptiveField }}
          </mat-cell>
        </ng-container>

        <ng-container matColumnDef="revoked">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('revoked')">
            {{getFieldLabel("Revoked")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.revoked }}
          </mat-cell>
        </ng-container>

        <ng-container matColumnDef="actions">
          <mat-header-cell *matHeaderCellDef> {{getFieldLabel("Actions")}}</mat-header-cell>
          <mat-cell *matCellDef="let item" (click)="$event.stopPropagation()">
            <button mat-icon-button aria-label="Example icon-button with a heart icon text-dangger"
              matTooltip="('GENERAL.ACTIONS.EDIT' | translate)" (click)="openDetails(item)">
              <mat-icon>open_in_new</mat-icon>
            </button>
            <button mat-icon-button color="warn"
              aria-label="Example icon-button with a heart icon text-dangger"
              matTooltip="('GENERAL.ACTIONS.DELETE' | translate)" (click)="delete(item)">
              <mat-icon color="warn">delete</mat-icon>
            </button>
          </mat-cell>
        </ng-container>
        <mat-header-row *matHeaderRowDef="displayedColumns"></mat-header-row>
        <mat-row *matRowDef="let row; columns: displayedColumns;"></mat-row>
      </mat-table>
    </div>
    <section  class="small-spinner-container" *ngIf="isLoadingResults">
      <mat-spinner></mat-spinner>
    </section>
  </mat-card>
</div>