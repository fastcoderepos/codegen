import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import {MatDialog, MatDialogRef, MAT_DIALOG_DATA} from '@angular/material';
import { Router, ActivatedRoute } from '@angular/router';

import { BaseListComponent, Globals, IListColumn, listColumnType, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';

import { IPermission } from './ipermission';
import { PermissionService } from './permission.service';
import { PermissionNewComponent } from './permission-new.component';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-permission-list',
  templateUrl: './permission-list.component.html',
  styleUrls: ['./permission-list.component.scss']
})
export class PermissionListComponent extends BaseListComponent<IPermission> implements OnInit {

	title:string = "Permission";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: PermissionService,
		public errorService: ErrorService,
		public globalPermissionService: GlobalPermissionService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = 'Permission';
		this.setAssociation();
		this.setColumns();
		this.primaryKeys = [ "id",  ]
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
		super.addNew(PermissionNewComponent);
	}
  
}
