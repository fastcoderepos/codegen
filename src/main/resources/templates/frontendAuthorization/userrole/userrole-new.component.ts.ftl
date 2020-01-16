import { Component, OnInit, Inject } from '@angular/core';
import { [=AuthenticationTable]roleService } from './[=moduleName]role.service';
import { I[=AuthenticationTable]role } from './i[=moduleName]role';

import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { Globals, BaseNewComponent, PickerDialogService, ErrorService } from 'projects/fast-code-core/src/public_api';
import { MatDialogRef, MatDialog, MAT_DIALOG_DATA } from '@angular/material/dialog';

import { GlobalPermissionService } from '../core/global-permission.service';
import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { RoleService } from '../role/role.service';

@Component({
  selector: 'app-[=moduleName]role-new',
  templateUrl: './[=moduleName]role-new.component.html',
  styleUrls: ['./[=moduleName]role-new.component.scss']
})
export class [=AuthenticationTable]roleNewComponent extends BaseNewComponent<I[=AuthenticationTable]role> implements OnInit {
  
    title:string = "New [=AuthenticationTable]role";
    constructor(
      public formBuilder: FormBuilder,
      public router: Router,
      public route: ActivatedRoute,
      public dialog: MatDialog,
      public dialogRef: MatDialogRef<[=AuthenticationTable]roleNewComponent>,
      @Inject(MAT_DIALOG_DATA) public data: any,
      public global: Globals,
      public pickerDialogService: PickerDialogService,
      public dataService: [=AuthenticationTable]roleService,
      public errorService: ErrorService,
      public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
      public roleService: RoleService,
      public globalPermissionService: GlobalPermissionService,
    ) {
      super(formBuilder, router, route, dialog, dialogRef, data, global, pickerDialogService, dataService, errorService);
    }
 
  ngOnInit() {
    this.entityName = "Userrole";
    this.setAssociations();
    super.ngOnInit();
    this.setForm();
    this.checkPassedData();
    this.setPickerSearchListener();
  }
  
  setForm() {
    this.itemForm = this.formBuilder.group({
      roleId: ['', Validators.required],
      roleDescriptiveField : [''],
      <#if !UserInput??>
      [=AuthenticationTable?uncap_first]Id: ['', Validators.required],
      [=AuthenticationTable?uncap_first]DescriptiveField : [''],
      <#elseif UserInput??>
      <#if PrimaryKeys??>
      <#list PrimaryKeys as key,value>
      <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
      [=AuthenticationTable?uncap_first + key?cap_first] : ['', Validators.required],
      </#if> 
      </#list>
      </#if>
      <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
      [=DescriptiveField[AuthenticationTable].description?uncap_first] : [''],
            <#else>
      <#if AuthenticationFields??>
        <#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        <#if !PrimaryKeys[authValue.fieldName]??>
        [=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]: [''],
        </#if>
        </#if>
        </#list>
        </#if>
      </#if>
      </#if>
    });
  }
  
  setAssociations(){
    
    this.associations = [
      {
        column: [
          <#if !UserInput??>
          {
            key: '[=AuthenticationTable?uncap_first]Id',
            value: undefined,
            referencedkey: 'id'
          },
          <#elseif UserInput??>
          <#if PrimaryKeys??>
          <#list PrimaryKeys as key,value>
          <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
          {
            key: '[=AuthenticationTable?uncap_first + key?cap_first]',
            value: undefined,
            referencedkey: '[=key]'
          },
          </#if>
          </#list>
          </#if>
          </#if>
        ],
        isParent: false,
        table: '[=AuthenticationTable?uncap_first]',
        type: 'ManyToOne',
        service: this.[=AuthenticationTable?uncap_first]Service,
        <#if UserInput??>
        <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
        descriptiveField: '[=DescriptiveField[AuthenticationTable].description?uncap_first]',
        referencedDescriptiveField: '[=DescriptiveField[AuthenticationTable].fieldName]',
                <#else>
                <#if AuthenticationFields??>
          <#list AuthenticationFields as authKey,authValue>
          <#if authKey== "UserName">
          <#if !PrimaryKeys[authValue.fieldName]??>
          descriptiveField: '[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]',
        referencedDescriptiveField: '[=authValue.fieldName]',
        </#if>
          </#if>
          </#list>
          </#if>
        </#if>
        <#elseif !UserInput??>
        descriptiveField: '[=AuthenticationTable?uncap_first]DescriptiveField',
        referencedDescriptiveField: 'userName',
        </#if>
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
