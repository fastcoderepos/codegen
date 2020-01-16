import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { MatDialog } from '@angular/material';

import { Router, ActivatedRoute } from '@angular/router';
import { UserNewComponent } from './user-new.component';
import { BaseListComponent, Globals, listColumnType, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';

import { IUser } from './iuser';
import { UserService } from './user.service';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-user-list',
  templateUrl: './user-list.component.html',
  styleUrls: ['./user-list.component.scss']
})
export class UserListComponent extends BaseListComponent<IUser> implements OnInit {

	title:string = "User";
	
	constructor(
		public router: Router,
		public route: ActivatedRoute,
		public global: Globals,
		public dialog: MatDialog,
		public changeDetectorRefs: ChangeDetectorRef,
		public pickerDialogService: PickerDialogService,
		public dataService: UserService,
		public errorService: ErrorService,
		public globalPermissionService: GlobalPermissionService,
	) { 
		super(router, route, dialog, global, changeDetectorRefs, pickerDialogService, dataService, errorService)
  }

	ngOnInit() {
		this.entityName = "User";
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
  			column: 'firstName',
  			label: 'firstName',
  			sort: true,
  			filter: true,
  			type: listColumnType.String
  		},
  		{
  			column: 'lastName',
  			label: 'lastName',
  			sort: true,
  			filter: true,
  			type: listColumnType.String
  		},
  		{
  			column: 'userName',
  			label: 'userName',
  			sort: true,
  			filter: true,
  			type: listColumnType.String
  		},
  		{
  			column: 'emailAddress',
  			label: 'emailAddress',
  			sort: true,
  			filter: true,
  			type: listColumnType.String
  		},
  		{
  			column: 'isActive',
  			label: 'isActive',
  			sort: true,
  			filter: true,
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
		super.addNew(UserNewComponent);
	}
  
}
