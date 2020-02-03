import { Component, OnInit, Inject } from '@angular/core';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';

import { RoleService } from './role.service';
import { IRole } from './irole';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-role-new',
  templateUrl: './role-new.component.html',
  styleUrls: ['./role-new.component.scss']
})
export class RoleNewComponent extends BaseNewComponent<IRole> implements OnInit {
  
    title:string = "New Role";
		constructor(
			public formBuilder: FormBuilder,
			public router: Router,
			public route: ActivatedRoute,
			public dialog: MatDialog,
			public dialogRef: MatDialogRef<RoleNewComponent>,
			@Inject(MAT_DIALOG_DATA) public data: any,
			public global: Globals,
			public pickerDialogService: PickerDialogService,
			public dataService: RoleService,
			public errorService: ErrorService,
			public globalPermissionService: GlobalPermissionService,
		) {
			super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
	  }
 
	ngOnInit() {
		this.entityName = 'Role';
		this.setAssociations();
		super.ngOnInit();
		this.setForm();
		this.checkPassedData();
    this.setPickerSearchListener();
  }
    
  setForm(){
    this.itemForm = this.formBuilder.group({
      displayName: ['', Validators.required],
      name: ['', Validators.required],
    });
  }
	
	setAssociations(){
  	
		this.associations = [
		];
		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});

	}
    
}
