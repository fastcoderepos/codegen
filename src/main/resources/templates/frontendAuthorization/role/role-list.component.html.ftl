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
        <button name="add" mat-raised-button color="primary" [disabled]=<#if ExcludeRoleNew>"true"<#else>"!IsCreatePermission"</#if> (click)="addNew()"><i class="material-icons">
            add_circle_outline
          </i> &nbsp;{{'GENERAL.ACTIONS.ADD' | translate}}</button>
      </div>
    </div>
  </div>
  <mat-card>
	  <app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
    <div class="table-container">
      <mat-table matSort [dataSource]="items" class="mat-elevation-z8">
        <ng-container matColumnDef="id">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('id')">
            {{getFieldLabel("Id")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.id }}
          </mat-cell>
        </ng-container>

        <ng-container matColumnDef="displayName">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('displayName')">
            {{getFieldLabel("DisplayName")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.displayName }}
          </mat-cell>
        </ng-container>

	    <#if (AuthenticationType == "oidc" && !UserOnly)>
        <ng-container matColumnDef="scimId">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('scimId')">
            {{getFieldLabel("ScimId")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.scimId }}
          </mat-cell>
        </ng-container>
			
			</#if>
        <ng-container matColumnDef="name">
          <mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('name')">
            {{getFieldLabel("Name")}}</mat-header-cell>
          <mat-cell *matCellDef="let item">
            {{ item.name }}
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