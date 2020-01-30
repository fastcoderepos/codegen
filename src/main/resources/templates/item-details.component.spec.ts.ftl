import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from "@angular/platform-browser";
import { of } from 'rxjs';
import { NO_ERRORS_SCHEMA } from '@angular/core';
import { Router } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { Location } from '@angular/common';

import { TestingModule, EntryComponents } from '../../testing/utils';
import { [=IEntity], [=ClassName]Service, [=ClassName]DetailsComponent, [=ClassName]ListComponent } from './index';

describe('[=ClassName]DetailsComponent', () => {
  let component: [=ClassName]DetailsComponent;
  let fixture: ComponentFixture<[=ClassName]DetailsComponent>;
  let el: HTMLElement;
    
  let data:[=IEntity] = {
    <#list Fields as key, value>           
      <#if value.fieldType == "Date">
    [=key]: new Date(),
      <#elseif value.fieldType?lower_case == "boolean">
    [=key]: true,
      <#elseif value.fieldType?lower_case == "string">              
    [=key]: '[=key]1',
      <#elseif value.fieldType?lower_case == "long" ||  value.fieldType?lower_case == "integer" ||  value.fieldType?lower_case == "double" ||  value.fieldType?lower_case == "short">              
    [=key]: 1,
      </#if> 
    </#list>
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
  };
  
  describe('Unit Tests', () => {
    beforeEach(async(() => {
      TestBed.configureTestingModule({
        declarations: [
          [=ClassName]DetailsComponent       
        ],
        imports: [TestingModule],
        providers: [
          [=ClassName]Service,
        ],
        schemas: [NO_ERRORS_SCHEMA]  
      }).compileComponents();
    }));
  
    beforeEach(() => {
      fixture = TestBed.createComponent([=ClassName]DetailsComponent);
      component = fixture.componentInstance;
      fixture.detectChanges();
    });

    it('should create', () => {
      expect(component).toBeTruthy();
    });

    it('should run #ngOnInit()', async () => {
      spyOn(component.dataService, "getById").and.returnValue(of(data));
      component.ngOnInit();

      expect(component.item).toEqual(data);
      expect(component.itemForm.getRawValue()).toEqual(data);
      component.itemForm.enable();
      expect(component.itemForm.valid).toEqual(true);
      expect(component.title.length).toBeGreaterThan(0);
      expect(component.associations).toBeDefined();
      expect(component.childAssociations).toBeDefined();
      expect(component.parentAssociations).toBeDefined();
    });

    it('should run #onSubmit()', async () => {
      component.item = data;
      component.itemForm.patchValue(data);
      component.itemForm.enable();
      fixture.detectChanges();

      spyOn(component, "onSubmit").and.returnValue();
      el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
      el.click();

      expect(component.onSubmit).toHaveBeenCalled();
    });

    it('should call the back', async () => {
      component.item = data;
      fixture.detectChanges();

      spyOn(component, "onBack").and.returnValue();
      el = fixture.debugElement.query(By.css('button[name=back]')).nativeElement;
      el.click();
      
      expect(component.onBack).toHaveBeenCalled();
    });

  });
  
  describe('Integration Tests', () => {
    beforeEach(async(() => {

      TestBed.configureTestingModule({
        declarations: [
          [=ClassName]DetailsComponent,
          [=ClassName]ListComponent
        ].concat(EntryComponents),
        imports: [
          TestingModule,
          RouterTestingModule.withRoutes([
            { path: '[=FrontendUrlPath]', component: [=ClassName]DetailsComponent },
            { path: '[=FrontendUrlPath]/:id', component: [=ClassName]ListComponent }
          ])
        ],
        providers: [
          [=ClassName]Service
        ]

      }).compileComponents();
    }));

    beforeEach(() => {
      fixture = TestBed.createComponent([=ClassName]DetailsComponent);
      component = fixture.componentInstance;
      fixture.detectChanges();
    });

    it('should create', () => {
      expect(component).toBeTruthy();
    });

    it('should run #ngOnInit()', async () => {
      spyOn(component.dataService, "getById").and.returnValue(of(data));

      component.ngOnInit();

      expect(component.item).toEqual(data);
      expect(component.itemForm.getRawValue()).toEqual(data);
      component.itemForm.enable();
      expect(component.itemForm.valid).toEqual(true);
      expect(component.title.length).toBeGreaterThan(0);
      expect(component.associations).toBeDefined();
      expect(component.childAssociations).toBeDefined();
      expect(component.parentAssociations).toBeDefined();
    });

    it('should update the record and redirect to list component', async () => {
      const router = TestBed.get(Router);
      const location = TestBed.get(Location);
      let navigationSpy = spyOn(router, 'navigate').and.callThrough();

      component.item = data;
      component.itemForm.patchValue(data);
      component.itemForm.enable();
      fixture.detectChanges();

      spyOn(component.dataService, 'update').and.returnValue(of(data));
      el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
      el.click();

      let responsePromise = navigationSpy.calls.mostRecent().returnValue;
      await responsePromise;
      expect(location.path()).toBe('/[=FrontendUrlPath]');

    });

    it('should go back to list component when back button is clicked', async () => {
      const router = TestBed.get(Router);
      const location = TestBed.get(Location);
      let navigationSpy = spyOn(router, 'navigate').and.callThrough();

      component.item = data;
      fixture.detectChanges();
      el = fixture.debugElement.query(By.css('button[name=back]')).nativeElement;
      el.click();

      let responsePromise = navigationSpy.calls.mostRecent().returnValue;
      await responsePromise;
      expect(location.path()).toBe('/[=FrontendUrlPath]');

    });

  });
  
});
