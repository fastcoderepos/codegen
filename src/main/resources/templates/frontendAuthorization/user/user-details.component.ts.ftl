import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, Validators} from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';

import { PickerDialogService, ErrorService, BaseDetailsComponent, Globals } from 'projects/fast-code-core/src/public_api';

import { UserService } from './user.service';
import { IUser } from './iuser';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-user-details',
  templateUrl: './user-details.component.html',
  styleUrls: ['./user-details.component.scss']
})
export class UserDetailsComponent extends BaseDetailsComponent<IUser> implements OnInit {
  title:string='User';
  parentUrl:string='user';
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: UserService,
		public pickerDialogService: PickerDialogService,
		public errorService: ErrorService,
		public globalPermissionService: GlobalPermissionService,
	) {
		super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

	ngOnInit() {
		this.entityName = "User";
		this.setAssociations();
		super.ngOnInit();
		this.setForm();
		this.getItem();
    this.setPickerSearchListener();
	}
	
  setForm(){
    this.itemForm = this.formBuilder.group({
      accessFailedCount: [''],
      authenticationSource: [''],
      emailAddress: ['', Validators.required],
      emailConfirmationCode: [''],
      firstName: ['', Validators.required],
      id: [{value: '', disabled: true}, Validators.required],
      isActive: [false],
      isEmailConfirmed: [false],
      isLockoutEnabled: [false],
      isPhoneNumberConfirmed: [''],
      lastLoginTime: [''],
      lastName: ['', Validators.required],
      lockoutEndDateUtc: [''],
      password: [''],
      passwordResetCode: [''],
      phoneNumber: [''],
      profilePictureId: [''],
      twoFactorEnabled: [false],
      userName: ['', Validators.required]
    });
	}
  
	setAssociations(){
  	
		this.associations = [
			{
				column: [
					{
						key: 'userId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: true,
				table: 'userpermission',
				type: 'OneToMany',
			},
			{
				column: [
					{
						key: 'userId',
						value: undefined,
						referencedkey: 'id'
					},
				],
				isParent: true,
				table: 'userrole',
				type: 'OneToMany',
			}
		];
		this.childAssociations = this.associations.filter(association => {
			return (association.isParent);
		});

		this.parentAssociations = this.associations.filter(association => {
			return (!association.isParent);
		});
	}
}
