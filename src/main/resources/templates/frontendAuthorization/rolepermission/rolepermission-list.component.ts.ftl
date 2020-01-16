import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';

import { IRolepermission } from './irolepermission';
import { RolepermissionService } from './rolepermission.service';
import { Router, ActivatedRoute } from '@angular/router';
import {RolepermissionNewComponent} from './rolepermission-new.component';
import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';

import { GlobalPermissionService } from '../core/global-permission.service';
import { PermissionService } from '../permission/permission.service';
import { RoleService } from '../role/role.service';

@Component({
  selector: 'app-rolepermission-list',
  templateUrl: './rolepermission-list.component.html',
  styleUrls: ['./rolepermission-list.component.scss']
})
export class RolepermissionListComponent extends BaseListComponent<IRolepermission> implements OnInit {

	title:string = "Rolepermission";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: RolepermissionService,
		public errorService: ErrorService,
		public permissionService: PermissionService,
		public roleService: RoleService,
		public globalPermissionService: GlobalPermissionService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = "Rolepermission";
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "permissionId", "roleId",  ]
		super.ngOnInit();
	}
  
	setAssociation(){
  	
		this.associations = [
			{
				column: [
                	{
						key: 'permissionId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: false,
				descriptiveField: 'permissionDescriptiveField',
				referencedDescriptiveField: 'name',
				service: this.permissionService,
				associatedObj: undefined,
				table: 'permission',
				type: 'ManyToOne'
			},
			{
				column: [
                	{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					},
					  
				],
				isParent: false,
				descriptiveField: 'roleDescriptiveField',
				referencedDescriptiveField: 'name',
				service: this.roleService,
				associatedObj: undefined,
				table: 'role',
				type: 'ManyToOne'
			},
		];
	}
  
	setColumns(){
		this.columns = [
      {
        column: 'Permission',
  			label: 'Permission',
  			sort: false,
  			filter: false,
  			type: listColumnType.Boolean
    		},
  		{
    		column: 'Role',
  			label: 'Role',
  			sort: false,
  			filter: false,
  			type: listColumnType.Boolean
    	},
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
  
	addNew() {
		super.addNew(RolepermissionNewComponent);
	}
  
}
