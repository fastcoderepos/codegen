import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { UsersService } from './users.service';
import { IUsers } from './iusers';

import { RolesService } from '../roles/roles.service'

import { BaseDetailsComponent, Globals } from 'fastCodeCore';

@Component({
  selector: 'app-users-details',
  templateUrl: './users-details.component.html',
  styleUrls: ['./users-details.component.scss']
})
export class UsersDetailsComponent extends BaseDetailsComponent<IUsers> implements OnInit {
  title:string='Users';
  parentUrl:string='users';
  //roles: IRole[];  
	constructor(
		public formBuilder: FormBuilder,
		public router: Router,
		public route: ActivatedRoute,
		public dialog: MatDialog,
		public global: Globals,
		public dataService: UsersService,
		public rolesService: RolesService
	) {
		super(formBuilder, router, route, dialog, global, dataService);
  }

	ngOnInit() {
		this.setAssociations();
		super.ngOnInit();
	  
		this.itemForm = this.formBuilder.group({
			accessFailedCount: [''],
			authenticationSource: [''],
			emailAddress: ['', Validators.required],
			emailConfirmationCode: [''],
			firstName: ['', Validators.required],
			id: [],
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
			userName: ['', Validators.required],
			roleId: [''],
	        
	     });
	    if (this.idParam) {
	      const id = +this.idParam;
	      this.getItem(id).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
	    }
  }
  
	setAssociations(){
  	
		this.associations = [
			{
				column: {
					key: 'roleId',
					value: undefined
				},
				isParent: false,
				table: 'roles',
				type: 'ManyToOne',
				service: this.rolesService,
				descriptiveField: 'rolesName',
			},
			{
				column: {
					key: 'userId',
					value: undefined
				},
				isParent: true,
				table: 'permissions',
				type: 'ManyToMany',
			},
		];
		this.toMany = this.associations.filter(association => {
			return ((['ManyToMany','OneToMany'].indexOf(association.type) > - 1) && association.isParent);
		});

		this.toOne = this.associations.filter(association => {
			return ((['ManyToOne','OneToOne'].indexOf(association.type) > - 1));
		});
	}

	onItemFetched(item:IUsers) {
		this.item = item;
		this.itemForm.patchValue({
			accessFailedCount: item.accessFailedCount,
			authenticationSource: item.authenticationSource,
			emailAddress: item.emailAddress,
			emailConfirmationCode: item.emailConfirmationCode,
			firstName: item.firstName,
			id: item.id,
			isActive: item.isActive,
			isEmailConfirmed: item.isEmailConfirmed,
			isLockoutEnabled: item.isLockoutEnabled,
			isPhoneNumberConfirmed: item.isPhoneNumberConfirmed,
			lastLoginTime: item.lastLoginTime? new Date(item.lastLoginTime): null,
			lastName: item.lastName,
			lockoutEndDateUtc: item.lockoutEndDateUtc? new Date(item.lockoutEndDateUtc): null,
			password: item.password,
			passwordResetCode: item.passwordResetCode,
			phoneNumber: item.phoneNumber,
			profilePictureId: item.profilePictureId,
			twoFactorEnabled: item.twoFactorEnabled,
			userName: item.userName,
			roleId: item.roleId,
		});
	}
  
  
}