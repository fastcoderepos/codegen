import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { PickerDialogService, ErrorService, BaseDetailsComponent, Globals } from 'projects/fast-code-core/src/public_api';

import { RoleService } from './role.service';
import { IRole } from './irole';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-role-details',
  templateUrl: './role-details.component.html',
  styleUrls: ['./role-details.component.scss']
})
export class RoleDetailsComponent extends BaseDetailsComponent<IRole> implements OnInit {
  title:string='Role';
  parentUrl:string='role';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: RoleService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public globalPermissionService: GlobalPermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = 'Role';
		this.setAssociations();
		super.ngOnInit();
		this.setForm();
    this.getItem();
    this.setPickerSearchListener();
  }
  
  setForm(){
    this.itemForm = this.formBuilder.group({
      displayName: [''],
      id: [{value: '', disabled: true}, Validators.required],
      name: ['', Validators.required],
    });
  }
  
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: true,
				table: 'rolepermission',
				type: 'OneToMany',
			},
			{
				column: [
					{
						key: 'roleId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: true,
				table: 'userrole',
				type: 'OneToMany',
			},
		];
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}

}
