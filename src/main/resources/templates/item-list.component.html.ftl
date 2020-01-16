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
        <button mat-raised-button color="primary" <#if AuthenticationType!="none"> [disabled]="!IsCreatePermission"</#if> (click)="addNew()"><i
            class="material-icons">
            add_circle_outline
          </i> &nbsp;{{'GENERAL.ACTIONS.ADD' | translate}}</button>
      </div>
    </div>
  </div>
	<app-list-filters [columnsList]="selectedColumns" (onSearch)="applyFilter($event)"></app-list-filters>
	<mat-card>
  	<div class="table-container">
  		<mat-table matSort [dataSource]="items" class="mat-elevation-z8">
  			<#list Fields as key,value>
  			<#-- to exclude the duplicate fields(join columns) -->
  			<#assign isJoinColumn = false>
  			<#if Relationship?has_content>
  			<#list Relationship as relationKey, relationValue>
  			<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
  			<#list relationValue.joinDetails as joinDetails>
  	        <#if joinDetails.joinEntityName == relationValue.eName>
  	        <#if joinDetails.joinColumn??>
  	        <#if joinDetails.joinColumn == key>
  	        <#assign isJoinColumn = true>
  	        </#if>
  	        </#if>
  			</#if>
  			</#list>
  			</#if>
  			</#list>
  			</#if>
  			<#-- to exclude the password field in case of user provided "User" table -->
  			<#assign isPasswordField = false>
  			<#if AuthenticationType != "none" && ClassName == AuthenticationTable>  
      		<#if AuthenticationFields?? && AuthenticationFields.Password.fieldName == value.fieldName>
  			<#assign isPasswordField = true>
  			</#if>
  			</#if>
  			<#if isJoinColumn == false && isPasswordField == false>
  			<#if value.fieldType == "Date">
  			<ng-container matColumnDef="[=value.fieldName]">
  				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> {{getFieldLabel("[=value.fieldName?cap_first]")}}</mat-header-cell>
  				<mat-cell *matCellDef="let item">
  					{{item.[=value.fieldName] | date: defaultDateFormat}}
  				</mat-cell>
  			</ng-container>
  			<#elseif value.fieldType?lower_case == "string" || value.fieldType?lower_case == "boolean" || value.fieldType?lower_case == "long" || value.fieldType?lower_case == "integer" || value.fieldType?lower_case == "short" || value.fieldType?lower_case == "double">
  			<ng-container matColumnDef="[=value.fieldName]">
  				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=value.fieldName]')"> {{getFieldLabel("[=value.fieldName?cap_first]")}}</mat-header-cell>
  				<mat-cell *matCellDef="let item">
  					{{ item.[=value.fieldName] }}
  				</mat-cell>
  			</ng-container>
  			</#if>
      		</#if>
  			</#list>
  			<#list Relationship as relationKey, relationValue>
  			<#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
  			<#if DescriptiveField[relationValue.eName]?? && DescriptiveField[relationValue.eName].description??>
  			<ng-container matColumnDef="[=relationValue.eName]">
  				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('[=relationValue.eName]')"> {{getFieldLabel("[=relationValue.eName?cap_first]")}}</mat-header-cell>
  				<mat-cell *matCellDef="let item">
  					<span class="mobile-label">{{getFieldLabel("[=relationValue.eName?cap_first]")}}:</span>
  					{{ item.[=DescriptiveField[relationValue.eName].description?uncap_first] }}
  				</mat-cell>
  			</ng-container>
  			</#if>
  			</#if>
  			</#list>
  			<#if AuthenticationType != "none" && ClassName == AuthenticationTable>
  			<ng-container matColumnDef="Role">
  				<mat-header-cell mat-sort-header *matHeaderCellDef [disabled]="!isColumnSortable('Role')"> {{getFieldLabel("Role")}}</mat-header-cell>
  				<mat-cell *matCellDef="let item">
  					{{ item.roleDescriptiveField }}
  				</mat-cell>
  			</ng-container>
  			</#if>
  			<ng-container matColumnDef="actions">
  				<mat-header-cell *matHeaderCellDef> {{getFieldLabel("Actions")}}</mat-header-cell>
  				<mat-cell *matCellDef="let item" (click)="$event.stopPropagation()">
            <button mat-icon-button aria-label="Example icon-button with a heart icon text-dangger"
              matTooltip="('GENERAL.ACTIONS.EDIT' | translate)" (click)="openDetails(item)">
              <mat-icon>open_in_new</mat-icon>
            </button>
            <button mat-icon-button color="warn" aria-label="Example icon-button with a heart icon text-dangger" matTooltip="('GENERAL.ACTIONS.DELETE' | translate)"  <#if AuthenticationType!="none"> [disabled]="!IsDeletePermission"</#if>
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
