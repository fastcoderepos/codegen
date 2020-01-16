import { Component, OnInit, Inject } from '@angular/core';
import { RolepermissionService } from './rolepermission.service';
import { IRolepermission } from './irolepermission';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { PermissionService } from '../permission/permission.service';
import { RoleService } from '../role/role.service';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-rolepermission-new',
  templateUrl: './rolepermission-new.component.html',
  styleUrls: ['./rolepermission-new.component.scss']
})
export class RolepermissionNewComponent extends BaseNewComponent<IRolepermission> implements OnInit {
  
    title:string = "New Rolepermission";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<RolepermissionNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: RolepermissionService,
			public errorService: ErrorService,
			public permissionService: PermissionService,
			public roleService: RoleService,
			public globalPermissionService: GlobalPermissionService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
	ngOnInit() {
		this.entityName = "Rolepermission";
		this.setAssociations();
		super.ngOnInit();
		this.setForm();
		this.checkPassedData();
    this.setPickerSearchListener();
  }
  
  setForm(){
    this.itemForm = this.formBuilder.group({
      permissionId: ['', Validators.required],
      roleId: ['', Validators.required],
      permissionDescriptiveField : [''],
      roleDescriptiveField : [''],
    });
  }
  
  setAssociations(){
  	
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
				table: 'permission',
				type: 'ManyToOne',
				service: this.permissionService,
				descriptiveField: 'permissionDescriptiveField',
				referencedDescriptiveField: 'name',
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
				table: 'role',
				type: 'ManyToOne',
				service: this.roleService,
				descriptiveField: 'roleDescriptiveField',
				referencedDescriptiveField: 'name',
			},
		];
		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}
}
