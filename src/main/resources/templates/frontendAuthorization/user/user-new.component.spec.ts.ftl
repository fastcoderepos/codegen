import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from "@angular/platform-browser";
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { of } from 'rxjs';

import { TestingModule, EntryComponents, checkValues } from '../../testing/utils';
import { IUser, UserService, UserNewComponent } from './index';

describe('UserNewComponent', () => {
  let component: UserNewComponent;
  let fixture: ComponentFixture<UserNewComponent>;

  let el: HTMLElement;

  let relationData: any = {
  }
  let data: IUser = {
    emailAddress: 'emailAddress1',
    firstName: 'firstName1',
    id: 1,
    isActive: true,
    lastName: 'lastName1',
    password: 'password1',
    confirmPassword: 'password1',
    phoneNumber: 'phoneNumber1',
    userName: 'userName1',
    ...relationData

  };
  let formData = {...data};
  delete formData["id"];

  describe('Unit tests', () => {
    beforeEach(async(() => {
      TestBed.configureTestingModule({
        declarations: [
          UserNewComponent
        ],
        imports: [TestingModule],
        providers: [
          UserService,
          { provide: MAT_DIALOG_DATA, useValue: {} }
        ]
      }).compileComponents();
    }));

    beforeEach(() => {
      fixture = TestBed.createComponent(UserNewComponent);
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
      component.IsCreatePermission = true;
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
            UserNewComponent
          ].concat(EntryComponents),
          imports: [TestingModule],
          providers: [
            UserService,
            { provide: MAT_DIALOG_DATA, useValue: relationData }
          ]
        });
        TestBed.overrideProvider(MAT_DIALOG_DATA, { useValue: relationData })
        fixture = TestBed.createComponent(UserNewComponent);
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
            UserNewComponent
          ].concat(EntryComponents),
          imports: [TestingModule],
          providers: [
            UserService,
            { provide: MAT_DIALOG_DATA, useValue: {} }
          ]
        });
      }));

      beforeEach(() => {
        fixture = TestBed.createComponent(UserNewComponent);
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
        component.IsCreatePermission = true;
        fixture.detectChanges();
        spyOn(component.dialogRef, "close").and.returnValue();
        spyOn(component.dataService, "create").and.returnValue(of(data));

        el = fixture.debugElement.query(By.css('button[name=save]')).nativeElement;
        el.click();
        expect(component.dataService.create).toHaveBeenCalledWith(formData);
        expect(component.dialogRef.close).toHaveBeenCalledWith(data);
      });

      it('should close the dialog with null data when cancel button is pressed', async () => {
        spyOn(component.dialogRef, "close").and.returnValue();
        el = fixture.debugElement.query(By.css('a[name=cancel]')).nativeElement;
        el.click();
        expect(component.dialogRef.close).toHaveBeenCalledWith(null);
      });

    });

  });

});