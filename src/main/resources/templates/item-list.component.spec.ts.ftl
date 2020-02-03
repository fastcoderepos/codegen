import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { of } from 'rxjs';
import { ChangeDetectorRef, NO_ERRORS_SCHEMA, DebugElement } from '@angular/core';
import { Location } from '@angular/common';
import { Router } from '@angular/router';
import { RouterTestingModule } from '@angular/router/testing';
import { ListFiltersComponent, ServiceUtils } from 'projects/fast-code-core/src/public_api';

import { EntryComponents, TestingModule } from 'src/testing/utils';
import { [=IEntity], [=ClassName]Service, [=ClassName]DetailsComponent, [=ClassName]ListComponent<#if !ExcludeUserNew>, [=ClassName]NewComponent</#if> } from './index';

describe('[=ClassName]ListComponent', () => {
  let fixture:ComponentFixture<[=ClassName]ListComponent>;
  let component:[=ClassName]ListComponent;
  let el: HTMLElement;
  let constData:[=IEntity][] = [
    <#list [1,2] as index>     
    {   
      <#list Fields as key, value>
      <#assign fType = value.fieldType?lower_case>         
        <#if fType == "date">
      [=key]: new Date(),
        <#elseif fType == "boolean">
      [=key]: true,
        <#elseif fType == "string">              
      [=key]: '[=key][=index]',
        <#elseif fType == "long" || fType == "integer" || fType == "double" || fType == "short">              
      [=key]: [=index],
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
      [=joinDetails.joinColumn]: '[=joinDetails.joinColumn][=index]',
        <#elseif jcType == "long" || jcType == "integer" || jcType == "double" || jcType == "short">              
      [=joinDetails.joinColumn]: [=index],
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
      [=dField.description?uncap_first]: [=index],
        </#if>
      </#if>
      </#if>
      </#list>
      </#if>
    },
    </#list> 
  ];
  let data: [=IEntity][] = [... constData];

  describe('Unit tests', () => {
  
    beforeEach(async(() => {
      
      TestBed.configureTestingModule({
        declarations: [
          [=ClassName]ListComponent       
        ],
        imports: [TestingModule],
        providers: [
          [=ClassName]Service,      
          ChangeDetectorRef,
        ],
        schemas: [NO_ERRORS_SCHEMA]   
      }).compileComponents();

    }));
    
    beforeEach(() => {
      fixture = TestBed.createComponent([=ClassName]ListComponent);
      component = fixture.componentInstance;
      data = [... constData];
      fixture.detectChanges();
    });

    it('should create a component', async () => {
      expect(component).toBeTruthy();
    });

    it('should run #ngOnInit()', async () => {

      spyOn(component.dataService, "getAll").and.returnValue(of(data));
      component.ngOnInit();

      expect(component.items.length).toEqual(data.length);
      fixture.detectChanges();
      let tableRows = fixture.nativeElement.querySelectorAll('mat-row');
      expect(tableRows.length).toBe(data.length);

      expect(component.associations).toBeDefined();
      expect(component.entityName.length).toBeGreaterThan(0);
      expect(component.primaryKeys.length).toBeGreaterThan(0);
      expect(component.columns.length).toBeGreaterThan(0);
      expect(component.selectedColumns.length).toBeGreaterThan(0);
      expect(component.displayedColumns.length).toBeGreaterThan(0);

    });

		<#if !ExcludeUserNew>
    it('should run #addNew()', async () => {
      spyOn(component, "addNew").and.returnValue();
      el = fixture.debugElement.query(By.css('button[name=add]')).nativeElement;
      el.click();
      expect(component.addNew).toHaveBeenCalled();
    });
    
    </#if>
    it('should run #delete()', async () => {

      component.items = data;
      fixture.detectChanges();

      let tableRows = fixture.nativeElement.querySelectorAll('mat-row')
      let firstRowCells = tableRows[0].querySelectorAll('mat-cell');
      let editButtonCell = firstRowCells[firstRowCells.length - 1];
      let editButton = editButtonCell.querySelectorAll('button')[1];

      spyOn(component, "delete").and.returnValue();
      editButton.click();
      expect(component.delete).toHaveBeenCalledWith(data[0]);

    });

    it('should call openDetails function when edit button is clicked', async () => {
      component.items = data;
      fixture.detectChanges();

      let tableRows = fixture.nativeElement.querySelectorAll('mat-row')
      let firstRowCells = tableRows[0].querySelectorAll('mat-cell');
      let editButtonCell = firstRowCells[firstRowCells.length - 1];
      let editButton = editButtonCell.querySelectorAll('button')[0];

      spyOn(component, 'openDetails').and.returnValue();
      editButton.click();

      expect(component.openDetails).toHaveBeenCalled();
    });

    it('should call applyFilter function in case of onSearch event of list-filter-component', async () => {
      fixture.detectChanges();
      
      spyOn(component, 'applyFilter');
      fixture.debugElement.query(By.css("app-list-filters")).triggerEventHandler('onSearch', null);
      
      expect(component.applyFilter).toHaveBeenCalled();
    });

    it('should pass the selected columns list as input to app list filters', async () => {
      fixture.detectChanges();
      
      let listFilterElement: DebugElement = fixture.debugElement.query(By.css("app-list-filters"));
      
      expect(listFilterElement.properties.columnsList).toBe(component.selectedColumns);
    });
  
  });
  
  describe('Integration tests', () => {

    beforeEach(async(() => {

      TestBed.configureTestingModule({
        declarations: [
          [=ClassName]ListComponent,
          <#if !ExcludeUserNew>
          [=ClassName]NewComponent,
          </#if>
          [=ClassName]DetailsComponent
        ].concat(EntryComponents),
        imports: [
          TestingModule,
          RouterTestingModule.withRoutes([
            { path: '[=FrontendUrlPath]', component: [=ClassName]ListComponent },
            { path: '[=FrontendUrlPath]/:id', component: [=ClassName]DetailsComponent }
          ])
        ],
        providers: [
          [=ClassName]Service,
          ChangeDetectorRef,
        ]

      }).compileComponents();

    }));

    beforeEach(() => {
      fixture = TestBed.createComponent([=ClassName]ListComponent);
      component = fixture.componentInstance;
      data = [... constData];
      fixture.detectChanges();
    });

    it('should create a component', async () => {
      expect(component).toBeTruthy();
    });

    it('should run #ngOnInit()', async () => {
      spyOn(component.dataService, "getAll").and.returnValue(of(data));
      component.ngOnInit();

      expect(component.items.length).toEqual(data.length);
      fixture.detectChanges();
      let tableRows = fixture.nativeElement.querySelectorAll('mat-row');
      expect(tableRows.length).toBe(data.length);

      expect(component.associations).toBeDefined();
      expect(component.entityName.length).toBeGreaterThan(0);
      expect(component.primaryKeys.length).toBeGreaterThan(0);
      expect(component.columns.length).toBeGreaterThan(0);
      expect(component.selectedColumns.length).toBeGreaterThan(0);
      expect(component.displayedColumns.length).toBeGreaterThan(0);
    });

		<#if !ExcludeUserNew>
    it('should open new dialog for new entry', async () => {
      component.IsCreatePermission = true;
      fixture.detectChanges();
      spyOn(component.dialog, 'open').and.callThrough();
      el = fixture.debugElement.query(By.css('button[name=add]')).nativeElement;
      el.click();

      expect(component.dialog.open).toHaveBeenCalled();
    });
    
		</#if>
    it('should delete the item from list', async () => {
      component.items = data;
      fixture.detectChanges();

      let tableRows = fixture.nativeElement.querySelectorAll('mat-row')
      let firstRowCells = tableRows[0].querySelectorAll('mat-cell');
      let deleteButtonCell = firstRowCells[firstRowCells.length - 1];
      let deleteButton = deleteButtonCell.querySelectorAll('button')[1];

      spyOn(component.dataService, "delete").and.returnValue(of(null));
      let itemsLength = component.items.length;
      deleteButton.click();
      expect(component.items.length).toBe(itemsLength - 1);
    });

    it('should set the columns list in app list filters component', async () => {
      let listFilters: ListFiltersComponent = fixture.debugElement.query(By.css("app-list-filters")).componentInstance;
      
      expect(listFilters.columnsList).toEqual(component.selectedColumns);
    });

    it('should verify that redirected to details page when edit button is clicked', async () => {
      const router = TestBed.get(Router);
      const location = TestBed.get(Location);
      component.items = data;
      fixture.detectChanges();

      let tableRows = fixture.nativeElement.querySelectorAll('mat-row')
      let firstRowCells = tableRows[0].querySelectorAll('mat-cell');
      let editButtonCell = firstRowCells[firstRowCells.length - 1];
      let editButton = editButtonCell.querySelectorAll('button')[0];

      spyOn(component.dataService, 'getById').and.returnValue(of(data[0]));
      let navigationSpy = spyOn(router, 'navigate').and.callThrough();
      editButton.click();

      let responsePromise = navigationSpy.calls.mostRecent().returnValue;
      await responsePromise;
      
      expect(location.path()).toBe(`/[=FrontendUrlPath]/${ServiceUtils.encodeIdByObject(data[0], component.primaryKeys)}`);
    });

    it('should emit onSearch event of list-filter-component and call applyFilter function', async () => {
      let filteredArray = [data[0]];
      spyOn(component.dataService, 'getAssociations').and.returnValue(of(filteredArray));
      spyOn(component.dataService, 'getAll').and.returnValue(of(filteredArray));

      let filterableColumns = component.columns.filter(x => x.filter)
      if (filterableColumns.length > 0) {
        let searchButton = fixture.debugElement.query(By.css("app-list-filters")).query(By.css("button")).nativeElement;
        searchButton.click();

        expect(component.items).toEqual(filteredArray);
      }
    });

  });
        
});
