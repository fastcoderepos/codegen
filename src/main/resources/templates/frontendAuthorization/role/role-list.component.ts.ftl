import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { Router, ActivatedRoute } from '@angular/router';

import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';

import { IRole } from './irole';
import { RoleService } from './role.service';
<#if !ExcludeRoleNew>
export { RoleNewComponent } from './role-new.component';
</#if>
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-role-list',
  templateUrl: './role-list.component.html',
  styleUrls: ['./role-list.component.scss']
})
export class RoleListComponent extends BaseListComponent<IRole> implements OnInit {

	title:string = "Role";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: RoleService,
		public errorService: ErrorService,
		public globalPermissionService: GlobalPermissionService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = 'Role';
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "id" ];
		super.ngOnInit();
	}
  
	setAssociation(){
  	
		this.associations = [
		];
	}
  
	setColumns(){
		this.columns = [
		  {
        column: 'id',
        label: 'id',
        sort: true,
        filter: true,
        type: listColumnType.Number
      },
      {
        column: 'name',
        label: 'name',
        sort: true,
        filter: true,
        type: listColumnType.String
      },
			{
				column: 'displayName',
				label: 'displayName',
				sort: true,
				filter: true,
				type: listColumnType.String
			},
			<#if (AuthenticationType == "oidc" && UsersOnly == "false")>
			{
				column: 'scimId',
				label: 'scimId',
				sort: true,
				filter: true,
				type: listColumnType.String
			},</#if>
		  {
				column: 'actions',
				label: 'Actions',
				sort: false,
				filter: false,
				type: listColumnType.String
			}
		];
		this.selectedColumns = this.columns;
		this.displayedColumns = this.columns.map((obj) => { return obj.column });
  }
  
  <#if !ExcludeRoleNew>
	addNew() {
		super.addNew(RoleNewComponent);
	}
	</#if>
  
}
