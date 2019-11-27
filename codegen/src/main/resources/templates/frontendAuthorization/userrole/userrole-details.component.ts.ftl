import { Component, OnInit } from '@angular/core';
import { ActivatedRoute,Router} from "@angular/router";
import { FormBuilder, FormGroup, Validators} from '@angular/forms';
import { first } from 'rxjs/operators';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';

import { [=AuthenticationTable]roleService } from './[=moduleName]role.service';
import { I[=AuthenticationTable]role } from './i[=moduleName]role';
import { PickerDialogService, ErrorService, BaseDetailsComponent, Globals } from 'fastCodeCore';

import { [=AuthenticationTable]Service } from '../[=moduleName]/[=moduleName].service';
import { RoleService } from '../role/role.service';
import { GlobalPermissionService } from '../core/global-permission.service';

@Component({
  selector: 'app-[=moduleName]role-details',
  templateUrl: './[=moduleName]role-details.component.html',
  styleUrls: ['./[=moduleName]role-details.component.scss']
})
export class [=AuthenticationTable]roleDetailsComponent extends BaseDetailsComponent<I[=AuthenticationTable]role> implements OnInit {
  title:string='[=AuthenticationTable]role';
  parentUrl:string='[=AuthenticationTable?lower_case]role';
  
  constructor(
    public formBuilder: FormBuilder,
    public router: Router,
    public route: ActivatedRoute,
    public dialog: MatDialog,
    public global: Globals,
    public dataService: [=AuthenticationTable]roleService,
    public pickerDialogService: PickerDialogService,
    public errorService: ErrorService,
    public [=AuthenticationTable?uncap_first]Service: [=AuthenticationTable]Service,
    public roleService: RoleService,
    public globalPermissionService: GlobalPermissionService,
  ) {
    super(formBuilder, router, route, dialog, global, pickerDialogService, dataService, errorService);
  }

  ngOnInit() {
    this.entityName = "Userrole";
    this.setAssociations();
    super.ngOnInit();
    this.itemForm = this.formBuilder.group({
      roleId: ['', Validators.required],
      roleDescriptiveField : [{ value: '', disabled: true }],
      <#if !UserInput??>
      [=AuthenticationTable?uncap_first]Id: ['', Validators.required],
      [=AuthenticationTable?uncap_first]DescriptiveField : [{ value: '', disabled: true }],
      <#elseif UserInput??>
      <#if PrimaryKeys??>
      <#list PrimaryKeys as key,value>
      <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
      [=AuthenticationTable?uncap_first + key?cap_first] : ['', Validators.required],
      </#if> 
      </#list>
      </#if>
      <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]?? && DescriptiveField[AuthenticationTable].description??>
      [=DescriptiveField[AuthenticationTable].description?uncap_first] : [{ value: '', disabled: true }],
      <#else>
      <#if AuthenticationFields??>
        <#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        <#if !PrimaryKeys[authValue.fieldName]??>
        [=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]: [{ value: '', disabled: true }],
        </#if>
        </#if>
        </#list>
        </#if>
      </#if>
      </#if>
      });
      if (this.idParam) {
      this.getItem(this.idParam).subscribe(x=>this.onItemFetched(x),error => this.errorMessage = <any>error);
      }
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
        <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??  && DescriptiveField[AuthenticationTable].description??>
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
    this.childAssociations = this.associations.filter(association => {
      return (association.isParent);
    });

    this.parentAssociations = this.associations.filter(association => {
      return (!association.isParent);
    });
  }

  onItemFetched(item:I[=AuthenticationTable]role) {
    this.item = item;
    this.itemForm.patchValue({
      roleId: item.roleId,
      roleDescriptiveField: item.roleDescriptiveField,
      <#if !UserInput??>
      [=AuthenticationTable?uncap_first]Id: item.[=AuthenticationTable?uncap_first]Id,
      [=AuthenticationTable?uncap_first]DescriptiveField: item.[=AuthenticationTable?uncap_first]DescriptiveField,
      <#elseif UserInput??>
      <#if PrimaryKeys??>
      <#list PrimaryKeys as key,value>
      <#if value?lower_case == "long" || value?lower_case == "integer" || value?lower_case == "short" || value?lower_case == "double" || value?lower_case == "boolean" || value?lower_case == "date" || value?lower_case == "string">
      [=AuthenticationTable?uncap_first + key?cap_first] : item.[=AuthenticationTable?uncap_first + key?cap_first],
      </#if> 
      </#list>
      </#if>
      <#if DescriptiveField?? && DescriptiveField[AuthenticationTable]??>
      [=DescriptiveField[AuthenticationTable].description?uncap_first] : item.[=DescriptiveField[AuthenticationTable].description?uncap_first],
      <#else>
      <#if AuthenticationFields??>
        <#list AuthenticationFields as authKey,authValue>
        <#if authKey== "UserName">
        <#if !PrimaryKeys[authValue.fieldName]??>
        [=AuthenticationTable?uncap_first + authValue.fieldName?cap_first]: item.[=AuthenticationTable?uncap_first + authValue.fieldName?cap_first],
      </#if>
        </#if>
        </#list>
        </#if>
      </#if>
      </#if>
    });
  }
}
