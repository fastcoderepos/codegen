import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from "@angular/platform-browser";
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { of } from 'rxjs';

import { TestingModule, EntryComponents, checkValues } from '../../testing/utils';
import { [=IEntity],[=ClassName]Service, [=ClassName]NewComponent } from './index';

describe('[=ClassName]NewComponent', () => {
  let component: [=ClassName]NewComponent;
  let fixture: ComponentFixture<[=ClassName]NewComponent>;
  
  let el: HTMLElement;
  
  let relationData: any = {
    <#if Relationship?has_content>
    <#list Relationship as relationKey, relationValue>
    <#if relationValue.relation == "ManyToOne" || (relationValue.relation == "OneToOne" && relationValue.isParent == false)>
    <#list relationValue.joinDetails as joinDetails>
    <#if joinDetails.joinEntityName == relationValue.eName>
    <#if joinDetails.joinColumn??>
    <#if !Fields[joinDetails.joinColumn]?? && !(DescriptiveField[relationValue.eName]?? && (joinDetails.joinColumn == relationValue.eName?uncap_first + DescriptiveField[relationValue.eName].fieldName?cap_first ))>
      <#assign jcType = joinDetails.joinColumnType?lower_case>
      <#if jcType == "date">
    [=joinDetails.joinColumn]: new Date(),
      <#elseif jcType == "boolean">
    [=joinDetails.joinColumn]: true,
      <#elseif jcType == "string">
    [=joinDetails.joinColumn]: '[=joinDetails.joinColumn]1',
      <#elseif jcType == "long" || jcType == "integer" || jcType == "double" || jcType == "short">
    [=joinDetails.joinColumn]: 1,
      </#if>
    </#if>
    </#if>
    </#if>
    </#list>
    <#assign dField=DescriptiveField[relationValue.eName]>
    <#if dField?? && dField.description??>
    <#assign dfType = dField.fieldType?lower_case>
      <#if dfType == "date">
    [=dField.description?uncap_first]: new Date(),
      <#elseif dfType == "boolean">
    [=dField.description?uncap_first]: true,
      <#elseif dfType == "string">
    [=dField.description?uncap_first]: '[=dField.fieldName]1',
      <#elseif dfType == "long" || dfType == "integer" || dfType == "double" || dfType == "short">
    [=dField.description?uncap_first]: 1,
      </#if>
    </#if>
    </#if>
    </#list>
    </#if>
  }
  let data:[=IEntity] = {
		<#list Fields as key, value>
		  <#assign fType = value.fieldType?lower_case>
			<#if fType == "date">
		[=key]: new Date(),
			<#elseif fType == "boolean">
		[=key]: true,
			<#elseif fType == "string">
		[=key]: '[=key]1',
			<#elseif fType == "long" || fType == "integer" || fType == "double" || fType == "short">
		[=key]: 1,
			</#if> 
		</#list>
		... relationData

	};
  
  let formData = {...data};
  <#list Fields as key,value>
  <#if value.isAutogenerated>
  delete formData["[=key]"];
  </#if>
  </#list>
  describe('Unit tests', () => {
    beforeEach(async(() => {
      TestBed.configureTestingModule({
        declarations: [
          [=ClassName]NewComponent
        ],
        imports: [TestingModule],
        providers: [
          [=ClassName]Service,
          { provide: MAT_DIALOG_DATA, useValue: {} }
        ]
      }).compileComponents();
    }));

    beforeEach(() => {
      fixture = TestBed.createComponent([=ClassName]NewComponent);
      component = fixture.componentInstance;
      spyOn(component, 'manageScreenResizing').and.returnValue();
      fixture.detectChanges();
    });

    it('should create', () => {
      expect(component).toBeTruthy();
    });

    it('should run #ngOnInit()', async(() => {
      component.ngOnInit();

      expect(component.title.length).toBeGreaterThan(0);
      expect(component.associations).toBeDefined();
      expect(component.parentAssociations).toBeDefined();
      expect(component.itemForm).toBeDefined();
    }));

    it('should run #onSubmit()', async () => {
      component.itemForm.patchValue(data);
      component.itemForm.enable();
      fixture.detectChanges();
      spyOn(component, "onSubmit").and.returnValue();
      el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
      el.click();
      expect(component.onSubmit).toHaveBeenCalled();
    });

    it('should call the cancel', async () => {
      spyOn(component, "onCancel").and.callThrough();
      el = fixture.debugElement.query(By.css('a[name=cancel]')).nativeElement;
      el.click();
      expect(component.onCancel).toHaveBeenCalled();
    });
  })

  describe('Integration tests', () => {

    // had to create a different suite because couldn't override MAT_DIALOG_DATA provider
    describe('', () => {
      it('should set the passed data to form', async () => {

        TestBed.configureTestingModule({
          declarations: [
            [=ClassName]NewComponent
          ].concat(EntryComponents),
          imports: [TestingModule],
          providers: [
            [=ClassName]Service,
            { provide: MAT_DIALOG_DATA, useValue: relationData }
          ]
        });
        TestBed.overrideProvider(MAT_DIALOG_DATA, {useValue : relationData})
        fixture = TestBed.createComponent([=ClassName]NewComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
  
        component.checkPassedData();
        fixture.detectChanges();
        expect(checkValues(component.itemForm.getRawValue(), relationData)).toBe(true);
      });
    })

    describe('', () => {
      beforeEach(async(() => {
        TestBed.configureTestingModule({
          declarations: [
            [=ClassName]NewComponent
          ].concat(EntryComponents),
          imports: [TestingModule],
          providers: [
            [=ClassName]Service,
            { provide: MAT_DIALOG_DATA, useValue: {} }
          ]
        });
      }));
  
      beforeEach(() => {
        fixture = TestBed.createComponent([=ClassName]NewComponent);
        component = fixture.componentInstance;
        fixture.detectChanges();
      });
  
      it('should create', () => {
        expect(component).toBeTruthy();
      });
  
      it('should run #ngOnInit()', async(() => {
        component.ngOnInit();
  
        expect(component.title.length).toBeGreaterThan(0);
        expect(component.associations).toBeDefined();
        expect(component.parentAssociations).toBeDefined();
        expect(component.itemForm).toBeDefined();
        expect(component.data).toEqual({});
      }));
  
      it('should create the record and close the dialog with created object response', async () => {
        component.itemForm.patchValue(data);
        component.itemForm.enable();
        fixture.detectChanges();
        spyOn(component.dialogRef, "close").and.returnValue();
        spyOn(component.dataService, "create").and.returnValue(of(data));
  
        el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
        el.click();
        expect(component.dialogRef.close).toHaveBeenCalledWith(data);
      });
  
      it('should close the dialog with null data when cancel button is pressed', async () => {
        spyOn(component.dialogRef, "close").and.returnValue();
        el = fixture.debugElement.query(By.css('a[name=cancel]')).nativeElement;
        el.click();
        expect(component.dialogRef.close).toHaveBeenCalledWith(null);
      });

    })

  })
  
});