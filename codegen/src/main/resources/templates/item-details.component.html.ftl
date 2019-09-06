<div *ngIf="item" class="container">
	<mat-toolbar class="action-tool-bar" color="primary">
		<button mat-flat-button (click)="onBack()">
	    {{'GENERAL.ACTIONS.CANCEL' | translate}} </button>
		<span class="middle">{{title}}</span>
	
		<button mat-flat-button (click)="itemNgForm.ngSubmit.emit()">
	    {{'GENERAL.ACTIONS.SAVE' | translate}} </button>
	</mat-toolbar>
	<mat-card class="card">
		<mat-card-content>
			<form [formGroup]="itemForm" #itemNgForm="ngForm" (ngSubmit)="onSubmit()" class="item-form">
			<#list Fields as key,value>
			<#-- to exclude the duplicate fields(join columns) -->
			<#assign isJoinColumn = false>
			<#if Relationship?has_content>
			<#list Relationship as relationKey, relationValue>
			<#list relationValue.joinDetails as joinDetails>
            <#if joinDetails.joinEntityName == relationValue.eName>
            <#if joinDetails.joinColumn??>
            <#if joinDetails.joinColumn == key>
            <#assign isJoinColumn = true>
            </#if>
            </#if>
			</#if>
			</#list>
			</#list>
			</#if>
            <#if AuthenticationType== "database" && ClassName == AuthenticationTable>  
    		<#if AuthenticationFields??>
  			<#list AuthenticationFields as authKey,authValue>
  			<#if authKey== "Password">
  			<#if value.fieldName != authValue.fieldName>
    		<#if isJoinColumn == false>
			<#if value.fieldType?lower_case == "boolean">
				<mat-checkbox formControlName="[=value.fieldName]">[=value.fieldName]</mat-checkbox>            
			<#elseif value.fieldType?lower_case == "date">
				<mat-form-field>
					<input formControlName="[=value.fieldName]" matInput [matDatepicker]="[=value.fieldName]Picker" placeholder="Enter [=value.fieldName]">
					<mat-datepicker-toggle matSuffix [for]="[=value.fieldName]Picker"></mat-datepicker-toggle>
					<mat-datepicker #[=value.fieldName]Picker></mat-datepicker>
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
					</#if>
				</mat-form-field>
			<#elseif value.fieldType?lower_case == "string">
				<mat-form-field>
					<input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
				    </#if>
				</mat-form-field>
			<#elseif !value.isAutogenerated && (value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double")>
				<mat-form-field>
					<input type="number" formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
				    </#if>
				</mat-form-field>
			</#if>
			</#if>
    		</#if>
    		</#if>
    		</#list>
    		</#if>
    		<#else>
    		<#if isJoinColumn == false>
			<#if value.fieldType?lower_case == "boolean">
				<mat-checkbox formControlName="[=value.fieldName]">[=value.fieldName]</mat-checkbox>            
			<#elseif value.fieldType?lower_case == "date">
				<mat-form-field>
					<input formControlName="[=value.fieldName]" matInput [matDatepicker]="[=value.fieldName]Picker" placeholder="Enter [=value.fieldName]">
					<mat-datepicker-toggle matSuffix [for]="[=value.fieldName]Picker"></mat-datepicker-toggle>
					<mat-datepicker #[=value.fieldName]Picker></mat-datepicker>
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
					</#if>
				</mat-form-field>
			<#elseif value.fieldType?lower_case == "string">
				<mat-form-field>
					<input formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
				    </#if>
				</mat-form-field>
			<#elseif !value.isAutogenerated && (value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "short" ||  value.fieldType?lower_case == "double")>
				<mat-form-field>
					<input type="number" formControlName="[=value.fieldName]" matInput placeholder="Enter [=value.fieldName]">
					<#if value.isNullable == false>
					<mat-error *ngIf="!itemForm.get('[=value.fieldName]').valid && itemForm.get('[=value.fieldName]').touched">[=value.fieldName] is required</mat-error>
				    </#if>
				</mat-form-field>
			</#if>
			</#if>
   			</#if>
			</#list>
			
				<mat-form-field *ngFor="let association of parentAssociations">
					<input matInput disabled placeholder="{{association.table}}" formControlName="{{association.descriptiveField}}">
					<mat-icon matSuffix (click)="$event.preventDefault();selectAssociation(association)">list</mat-icon>
				</mat-form-field>
				
			</form>
			<div *ngFor="let association of childAssociations" class="association-div">
				<button mat-stroked-button color="primary" (click)="openChildDetails(association)" class="btn btn-link">
					{{association.table}}
				</button>
			</div>
		</mat-card-content>
	</mat-card>
</div>